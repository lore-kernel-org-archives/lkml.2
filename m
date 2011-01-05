Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1AEVQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:16:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429Ab1AEVQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:16:52 -0500
Date: Wed, 5 Jan 2011 13:16:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric B Munson <emunson@mgebm.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mel@csn.ul.ie,
        caiqian@redhat.com, mhocko@suse.cz, stable@kernel.org
Subject: Re: [PATCH V2] Fix handling of parse errors in sysfs
Message-Id: <20110105131613.92e2c274.akpm@linux-foundation.org>
In-Reply-To: <1294258593-15009-1-git-send-email-emunson@mgebm.net>
References: <1294258593-15009-1-git-send-email-emunson@mgebm.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Jan 2011 13:16:33 -0700
Eric B Munson <emunson@mgebm.net> wrote:

> When parsing changes to the huge page pool sizes made from userspace
> via the sysfs interface, bogus input values are being covered up
> by nr_hugepages_store_common and nr_overcommit_hugepages_store
> returning 0 when strict_strtoul returns an error.  This can cause an
> infinite loop in the nr_hugepages_store code.  This patch changes
> the return value for these functions to -EINVAL when strict_strtoul
> returns an error.
> 

ah, OK, there we are.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8585524..5cb71a9 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1440,7 +1440,7 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
>  
>  	err = strict_strtoul(buf, 10, &count);
>  	if (err)
> -		return 0;
> +		return -EINVAL;
>  
>  	h = kobj_to_hstate(kobj, &nid);
>  	if (nid == NUMA_NO_NODE) {
> @@ -1519,7 +1519,7 @@ static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
>  
>  	err = strict_strtoul(buf, 10, &input);
>  	if (err)
> -		return 0;
> +		return -EINVAL;
>  
>  	spin_lock(&hugetlb_lock);
>  	h->nr_overcommit_huge_pages = input;

strict_strtoul() returns an errno - thise code should propagate it, not
overwrite it.

Here's what I ended up with:


diff -puN mm/hugetlb.c~fix-handling-of-parse-errors-in-sysfs mm/hugetlb.c
--- a/mm/hugetlb.c~fix-handling-of-parse-errors-in-sysfs
+++ a/mm/hugetlb.c
@@ -1375,10 +1375,8 @@ static ssize_t nr_hugepages_store_common
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
 	err = strict_strtoul(buf, 10, &count);
-	if (err) {
-		err = 0;		/* This seems wrong */
+	if (err)
 		goto out;
-	}
 
 	h = kobj_to_hstate(kobj, &nid);
 	if (h->order >= MAX_ORDER) {
@@ -1468,7 +1466,7 @@ static ssize_t nr_overcommit_hugepages_s
 
 	err = strict_strtoul(buf, 10, &input);
 	if (err)
-		return 0;
+		return err;
 
 	spin_lock(&hugetlb_lock);
 	h->nr_overcommit_huge_pages = input;
_


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab2DRGRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:17:42 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:41711 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2DRGRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:17:41 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V6 10/14] hugetlbfs: Add memcg control files for hugetlbfs
In-Reply-To: <20120416161354.b967790c.akpm@linux-foundation.org>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120416161354.b967790c.akpm@linux-foundation.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 18 Apr 2012 11:46:37 +0530
Message-ID: <87d375womy.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12041806-8878-0000-0000-000002120A43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 16 Apr 2012 16:14:47 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>
>> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
>> +static char *mem_fmt(char *buf, unsigned long n)
>> +{
>> +	if (n >= (1UL << 30))
>> +		sprintf(buf, "%luGB", n >> 30);
>> +	else if (n >= (1UL << 20))
>> +		sprintf(buf, "%luMB", n >> 20);
>> +	else
>> +		sprintf(buf, "%luKB", n >> 10);
>> +	return buf;
>> +}
>> +
>> +int __init mem_cgroup_hugetlb_file_init(int idx)
>> +{
>> +	char buf[32];
>> +	struct cftype *cft;
>> +	struct hstate *h = &hstates[idx];
>> +
>> +	/* format the size */
>> +	mem_fmt(buf, huge_page_size(h));
>
> The sprintf() into a fixed-sized buffer is a bit ugly.  I didn't check
> it for possible overflows because 32 looks like "enough".  Actually too
> much.
>
> Oh well, it's hard to avoid.  But using scnprintf() would prevent nasty
> accidents.
>
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 519d370..0ccf934 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5269,14 +5269,14 @@ static void mem_cgroup_destroy(struct cgroup *cont)
 }
 
 #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
-static char *mem_fmt(char *buf, unsigned long n)
+static char *mem_fmt(char *buf, int size, unsigned long hsize)
 {
-	if (n >= (1UL << 30))
-		sprintf(buf, "%luGB", n >> 30);
-	else if (n >= (1UL << 20))
-		sprintf(buf, "%luMB", n >> 20);
+	if (hsize >= (1UL << 30))
+		scnprintf(buf, size, "%luGB", hsize >> 30);
+	else if (hsize >= (1UL << 20))
+		scnprintf(buf, size, "%luMB", hsize >> 20);
 	else
-		sprintf(buf, "%luKB", n >> 10);
+		scnprintf(buf, size, "%luKB", hsize >> 10);
 	return buf;
 }
 
@@ -5287,7 +5287,7 @@ int __init mem_cgroup_hugetlb_file_init(int idx)
 	struct hstate *h = &hstates[idx];
 
 	/* format the size */
-	mem_fmt(buf, huge_page_size(h));
+	mem_fmt(buf, 32, huge_page_size(h));
 
 	/* Add the limit file */
 	cft = &h->mem_cgroup_files[0];


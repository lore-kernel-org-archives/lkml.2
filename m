Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1FEUtI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 16:49:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10136 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1FEUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 16:49:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=AwiEgtY7aWGQti5iDizRvGecZ1/m8kAiWsOTQeFNKkukAdKhkE0rXMQ1Dyj9kDJ213
         iweiTVcf5InC8JlTQnjA==
Date: Sun, 5 Jun 2011 13:48:55 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org
Subject: Re: ENOSPC returned by handle_mm_fault()
In-Reply-To: <20110605195025.GH11521@ZenIV.linux.org.uk>
Message-ID: <alpine.LSU.2.00.1106051339001.8317@sister.anvils>
References: <20110605134317.GF11521@ZenIV.linux.org.uk> <alpine.LSU.2.00.1106051141570.5792@sister.anvils> <20110605195025.GH11521@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jun 2011, Al Viro wrote:
> On Sun, Jun 05, 2011 at 12:16:08PM -0700, Hugh Dickins wrote:
> 
> > Good find, news to me.  Interesting uses of -PTR_ERR()!
> 
> You mean, something like the diff below?

Second hunk yes, but first hunk no: there's at least one other place
(hugetlb_reserve_pages) which calls region_chg(), and expects a
conventional -errno return from it; and even if there weren't,
I'd rather not spread these unconventional return values any deeper.

Something more like the one at the bottom I think: okay, it's slightly
tacky to assume the nature of the failure from vma_needs_reservation(),
but we already have two places which do make that assumption.

> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f33bb31..3de23f0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -125,7 +125,7 @@ static long region_chg(struct list_head *head, long f, long t)
>  	if (&rg->link == head || t < rg->from) {
>  		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
>  		if (!nrg)
> -			return -ENOMEM;
> +			return -VM_FAULT_OOM;
>  		nrg->from = f;
>  		nrg->to   = f;
>  		INIT_LIST_HEAD(&nrg->link);
> @@ -1036,7 +1036,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  		return ERR_PTR(chg);
>  	if (chg)
>  		if (hugetlb_get_quota(inode->i_mapping, chg))
> -			return ERR_PTR(-ENOSPC);
> +			return ERR_PTR(-VM_FAULT_SIGBUS);
>  
>  	spin_lock(&hugetlb_lock);
>  	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);

Signed-off-by: Hugh Dickins <hughd@google.com
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.0-rc1/mm/hugetlb.c	2011-05-29 18:42:37.425882575 -0700
+++ linux/mm/hugetlb.c	2011-06-05 13:33:22.795341004 -0700
@@ -1033,10 +1033,10 @@ static struct page *alloc_huge_page(stru
 	 */
 	chg = vma_needs_reservation(h, vma, addr);
 	if (chg < 0)
-		return ERR_PTR(chg);
+		return ERR_PTR(-VM_FAULT_OOM);
 	if (chg)
 		if (hugetlb_get_quota(inode->i_mapping, chg))
-			return ERR_PTR(-ENOSPC);
+			return ERR_PTR(-VM_FAULT_SIGBUS);
 
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);

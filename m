Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1FETua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:50:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45018 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1FETu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:50:29 -0400
Date: Sun, 5 Jun 2011 20:50:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org
Subject: Re: ENOSPC returned by handle_mm_fault()
Message-ID: <20110605195025.GH11521@ZenIV.linux.org.uk>
References: <20110605134317.GF11521@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1106051141570.5792@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1106051141570.5792@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 12:16:08PM -0700, Hugh Dickins wrote:

> Good find, news to me.  Interesting uses of -PTR_ERR()!

*snerk*

I've run into a bug where ->open() returned -PTR_ERR(...) on one of the failure
exits and went grepping.  Caught so far:
	* l2tp_debugfs - originally found bug
	* xfs mknod() returning the error with wrong sign if xfs_get_acl()
fails
	* jfs lmLogOpen() - positive error value returned (and propagated
all way be to userland if we'd been doing remount) if block device can't be
opened
	* sunrpc - two bugs of the same kind
	* this one, where the *sign* is right, but mixing E.. with VM_FAULT_..
is not.

Bugs are like mushrooms - found one, look around for more...

> Looks like we'd better not have more than 12 VM_FAULT_ flags.

> > Am I right assuming that we want VM_FAULT_OOM in both cases?
> 
> No, where hugetlb_get_quota() fails it should be VM_FAULT_SIGBUS:
> there's no excuse to go on an OOM-killing spree just because hugetlb
> quota is exhausted.

Good point...

> VM_FAULT_OOM is appropriate where vma_needs_reservation() fails,
> because region_chg() couldn't kmalloc a structure, as you point out.
> 
> (Though that doesn't matter much, since the only way the kmalloc can
> fail is when this task is already selected for OOM-kill - I think.)

You mean, something like the diff below?

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f33bb31..3de23f0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -125,7 +125,7 @@ static long region_chg(struct list_head *head, long f, long t)
 	if (&rg->link == head || t < rg->from) {
 		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
 		if (!nrg)
-			return -ENOMEM;
+			return -VM_FAULT_OOM;
 		nrg->from = f;
 		nrg->to   = f;
 		INIT_LIST_HEAD(&nrg->link);
@@ -1036,7 +1036,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 		return ERR_PTR(chg);
 	if (chg)
 		if (hugetlb_get_quota(inode->i_mapping, chg))
-			return ERR_PTR(-ENOSPC);
+			return ERR_PTR(-VM_FAULT_SIGBUS);
 
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);

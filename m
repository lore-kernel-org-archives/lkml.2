Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0JCAqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 20:46:15 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37993 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab0JCAqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 20:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=CNv06aRfIc4IC/xvRabXFghSG1gmfiWgaPVxl5bXrtS+lmYM+tpFzTBkSLc4/q/3oU
         ObOCYC9ep3wn1Db18iSg==
Date: Sat, 2 Oct 2010 17:46:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ksm: fix page_address_in_vma anon_vma oops
Message-ID: <alpine.LSU.2.00.1010021742070.27679@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-rc1 commit 21d0d443cdc1658a8c1484fdcece4803f0f96d0e "rmap:
resurrect page_address_in_vma anon_vma check" was right to resurrect
that check; but now that it's comparing anon_vma->roots instead of
just anon_vmas, there's a danger of oopsing on a NULL anon_vma.

In most cases no NULL anon_vma ever gets here; but it turns out that
occasionally KSM, when enabled on a forked or forking process, will
itself call page_address_in_vma() on a "half-KSM" page left over from
an earlier failed attempt to merge - whose page_anon_vma() is NULL.

It's my bug that those should be getting here at all: I thought they
were already dealt with, this oops proves me wrong, I'll fix it in
the next release - such pages are effectively pinned until their
process exits, since rmap cannot find their ptes (though swapoff can).

For now just work around it by making page_address_in_vma() safe (and
add a comment on why that check is wanted anyway).  A similar check
in __page_check_anon_rmap() is safe because do_page_add_anon_rmap()
already excluded KSM pages.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/rmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- 2.6.36-rc6/mm/rmap.c	2010-09-28 22:42:43.000000000 -0700
+++ linux/mm/rmap.c	2010-09-28 23:27:05.000000000 -0700
@@ -381,7 +381,13 @@ vma_address(struct page *page, struct vm
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	if (PageAnon(page)) {
-		if (vma->anon_vma->root != page_anon_vma(page)->root)
+		struct anon_vma *page__anon_vma = page_anon_vma(page);
+		/*
+		 * Note: swapoff's unuse_vma() is more efficient with this
+		 * check, and needs it to match anon_vma when KSM is active.
+		 */
+		if (!vma->anon_vma || !page__anon_vma ||
+		    vma->anon_vma->root != page__anon_vma->root)
 			return -EFAULT;
 	} else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
 		if (!vma->vm_file ||

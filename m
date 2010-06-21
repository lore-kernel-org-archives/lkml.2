Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab0FUUkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:40:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758405Ab0FUUjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:39:54 -0400
Date: Mon, 21 Jun 2010 16:38:00 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
       Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH -mm 5/6] resurrect page_address_in_vma anon_vma check
Message-ID: <20100621163800.0ea44021@annuminas.surriel.com>
In-Reply-To: <20100621163146.4e4e30cb@annuminas.surriel.com>
References: <20100621163146.4e4e30cb@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: resurrect page_address_in_vma anon_vma check

With root anon-vma it's trivial to keep doing the usual check as in
old-anon-vma code.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---

diff --git a/mm/rmap.c b/mm/rmap.c
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -362,9 +362,10 @@ vma_address(struct page *page, struct vm
  */
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
-	if (PageAnon(page))
-		;
-	else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
+	if (PageAnon(page)) {
+		if (vma->anon_vma->root != page_anon_vma(page)->root)
+			return -EFAULT;
+	} else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
 		if (!vma->vm_file ||
 		    vma->vm_file->f_mapping != page->mapping)
 			return -EFAULT;


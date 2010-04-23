Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0DWCKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:10:22 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61033 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0DWCKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:10:19 -0400
Date: Fri, 23 Apr 2010 11:08:27 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [BUGFIX] rmap: remove anon_vma check in
 page_address_in_vma()
Message-ID: <20100423020827.GB7383@spritzerA.linux.bs1.fc.nec.co.jp>
References: <20100422054241.GB10957@spritzerA.linux.bs1.fc.nec.co.jp>
 <4BD0688A.7050806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <4BD0688A.7050806@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently page_address_in_vma() compares vma->anon_vma and page_anon_vma(page)
for parameter check, but in 2.6.34 a vma can have multiple anon_vmas with
anon_vma_chain, so current check does not work. (For anonymous page shared by
multiple processes, some verified (page,vma) pairs return -EFAULT wrongly.)

We can go to checking all anon_vmas in the "same_vma" chain, but it needs
to meet lock requirement. Instead, we can remove anon_vma check safely
because page_address_in_vma() assumes that page and vma are already checked
to belong to the identical process.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
 mm/rmap.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git v2.6.34-rc5:mm/rmap.c v2.6.34-rc5:mm/rmap.c
index 526704e..486fd0a 100644
--- v2.6.34-rc5:mm/rmap.c
+++ v2.6.34-rc5:mm/rmap.c
@@ -335,14 +335,13 @@ vma_address(struct page *page, struct vm_area_struct *vma)
 
 /*
  * At what user virtual address is page expected in vma?
- * checking that the page matches the vma.
+ * Caller should check the page is actually part of the vma.
  */
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
-	if (PageAnon(page)) {
-		if (vma->anon_vma != page_anon_vma(page))
-			return -EFAULT;
-	} else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
+	if (PageAnon(page))
+		;
+	else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
 		if (!vma->vm_file ||
 		    vma->vm_file->f_mapping != page->mapping)
 			return -EFAULT;
-- 
1.7.0

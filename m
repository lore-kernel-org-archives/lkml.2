Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1C1N5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:57:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60471 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1C1N5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:57:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=plbqeh/otlg/TSaimpTLx8JtMOT1ySpVuMJPH2v+vd3GTVoLto8CEfj5RH4H2k6MPn
         UUVyzNOfs3fCIkGhrEohBtl1shVahTZxYxFtgZ3vTWYhxIGPfIXpgV3VXZvYaSdXPXcW
         AesS7lFNbfZwimS6iwxix9h9FrxkBg1zwjQ/w=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@snapgear.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] nommu: find vma using the sorted vma list
Date: Mon, 28 Mar 2011 22:56:44 +0900
Message-Id: <1301320607-7259-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
References: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have the sorted vma list, use it in the find_vma[_exact]()
rather than doing linear search on the rb-tree.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/nommu.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index a6a073f0745a..6c5a13b507b4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -828,17 +828,15 @@ static void delete_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
 	struct vm_area_struct *vma;
-	struct rb_node *n = mm->mm_rb.rb_node;
 
 	/* check the cache first */
 	vma = mm->mmap_cache;
 	if (vma && vma->vm_start <= addr && vma->vm_end > addr)
 		return vma;
 
-	/* trawl the tree (there may be multiple mappings in which addr
+	/* trawl the list (there may be multiple mappings in which addr
 	 * resides) */
-	for (n = rb_first(&mm->mm_rb); n; n = rb_next(n)) {
-		vma = rb_entry(n, struct vm_area_struct, vm_rb);
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->vm_start > addr)
 			return NULL;
 		if (vma->vm_end > addr) {
@@ -878,7 +876,6 @@ static struct vm_area_struct *find_vma_exact(struct mm_struct *mm,
 					     unsigned long len)
 {
 	struct vm_area_struct *vma;
-	struct rb_node *n = mm->mm_rb.rb_node;
 	unsigned long end = addr + len;
 
 	/* check the cache first */
@@ -886,10 +883,9 @@ static struct vm_area_struct *find_vma_exact(struct mm_struct *mm,
 	if (vma && vma->vm_start == addr && vma->vm_end == end)
 		return vma;
 
-	/* trawl the tree (there may be multiple mappings in which addr
+	/* trawl the list (there may be multiple mappings in which addr
 	 * resides) */
-	for (n = rb_first(&mm->mm_rb); n; n = rb_next(n)) {
-		vma = rb_entry(n, struct vm_area_struct, vm_rb);
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->vm_start < addr)
 			continue;
 		if (vma->vm_start > addr)
-- 
1.7.4


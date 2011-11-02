Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1KBGeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:34:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48582 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1KBGeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:34:44 -0400
From: Guanjun He <heguanbo@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Guanjun He <heguanbo@gmail.com>
Subject: [PATCH][mm] adjust the logic of checking THP
Date: Wed,  2 Nov 2011 14:34:30 +0800
Message-Id: <1320215670-10157-1-git-send-email-heguanbo@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <pebolle@tiscali.nl;linux-kernel@vger.kernel.org;linux-mm@kvack.org;gjhe@suse.com>
References: <pebolle@tiscali.nl;linux-kernel@vger.kernel.org;linux-mm@kvack.org;gjhe@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acturally, pmd_trans_huge(orig_pmd) only checks the _PAGE_PSE bits,
it's a pmd entry bits, only mark a size, not a flag;As one can easily 
create the same pmd entry bits for some special use,then the check 
will get confused.And this patch is to adjust the logic to use the flag, 
it can perfectly avoid this potential issuse,and basically no impact 
to the current code.


Signed-off-by: Guanjun He <heguanbo@gmail.com>
---
 mm/memory.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index a56e3ba..a76b17f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3465,20 +3465,22 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	pmd = pmd_alloc(mm, pud, address);
 	if (!pmd)
 		return VM_FAULT_OOM;
-	if (pmd_none(*pmd) && transparent_hugepage_enabled(vma)) {
-		if (!vma->vm_ops)
-			return do_huge_pmd_anonymous_page(mm, vma, address,
-							  pmd, flags);
-	} else {
-		pmd_t orig_pmd = *pmd;
-		barrier();
-		if (pmd_trans_huge(orig_pmd)) {
-			if (flags & FAULT_FLAG_WRITE &&
-			    !pmd_write(orig_pmd) &&
-			    !pmd_trans_splitting(orig_pmd))
-				return do_huge_pmd_wp_page(mm, vma, address,
-							   pmd, orig_pmd);
+	if (transparent_hugepage_enabled(vma)) {
+		if (pmd_none(*pmd)) {
+			if (!vma->vm_ops)
+				return do_huge_pmd_anonymous_page(mm, vma, address,
+								  pmd, flags);
+		} else {
+			pmd_t orig_pmd = *pmd;
+			barrier();
+			if (pmd_trans_huge(orig_pmd)) {
+				if (flags & FAULT_FLAG_WRITE &&
+				    !pmd_write(orig_pmd) &&
+				    !pmd_trans_splitting(orig_pmd))
+					return do_huge_pmd_wp_page(mm, vma, address,
+								   pmd, orig_pmd);
 			return 0;
+			}
 		}
 	}
 
-- 
1.7.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1KALmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 07:42:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48485 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab1KALmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 07:42:00 -0400
From: Guanjun He <heguanbo@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Guanjun He <heguanbo@gmail.com>
Subject: [PATCH][mm:] adjust the logic of checking THP
Date: Tue,  1 Nov 2011 19:41:45 +0800
Message-Id: <1320147705-15117-1-git-send-email-heguanbo@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <shaohua.li@intel.com;linux-mm@kvack.org;linux-kernel@vger.kernel.org>
References: <shaohua.li@intel.com;linux-mm@kvack.org;linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Guanjun He <heguanbo@gmail.com>
---
 mm/memory.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index a56e3ba..d6dd6b3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3465,20 +3465,24 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
-			return 0;
+	if (transparent_hugepage_enabled(vma)) {
+		if(pmd_none(*pmd)){
+			if (!vma->vm_ops)
+				return do_huge_pmd_anonymous_page(mm, vma, address,
+						pmd, flags);
+		}
+		else
+		{
+			pmd_t orig_pmd = *pmd;
+			barrier();
+			if (pmd_trans_huge(orig_pmd)) {
+				if (flags & FAULT_FLAG_WRITE &&
+						!pmd_write(orig_pmd) &&
+						!pmd_trans_splitting(orig_pmd))
+					return do_huge_pmd_wp_page(mm, vma, address,
+							pmd, orig_pmd);
+				return 0;
+			}
 		}
 	}
 
-- 
1.7.7


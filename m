Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab0HTR4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:56:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:5563 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab0HTR4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:56:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,240,1280732400"; 
   d="scan'208";a="649710727"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org,
        "Kyle McMartin" <kyle@mcmartin.ca>, "Helge Deller" <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Matthew Wilcox" <willy@linux.intel.com>
Subject: [RFC - PATCH] leave guard page for upwardly growing stacks too
Date: Fri, 20 Aug 2010 10:56:47 -0700
Message-Id: <4c6ec1df290705bb68@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 320b2b8de12698082609ebbc1a17165727f4c893
   mm: keep a guard page below a grow-down stack segment

we prevented stacks from growing downwards into other vma areas.
But some arhictectures (ia64 and pa-risc) have stacks that
grow upwards. Provide the same protection for them.

Signed-off-by: Tony Luc <tony.luck@intel.com>

---

Pointed out to me by Matthew Wilcox.

DANGER, DANGER - NOT TESTED on pa-risc yet DO NOT APPLY WITHOUT AN ACK FROM PA-RISC LAND!

Are there any other architectures with upward growing stacks?

diff --git a/mm/memory.c b/mm/memory.c
index b6e5fd2..9dcef72 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2760,21 +2760,35 @@ out_release:
 }
 
 /*
- * This is like a special single-page "expand_downwards()",
- * except we must first make sure that 'address-PAGE_SIZE'
+ * This is like a special single-page "expand_{down|up}wards()",
+ * except we must first make sure that 'address{-|+}PAGE_SIZE'
  * doesn't hit another vma.
  *
  * The "find_vma()" will do the right thing even if we wrap
  */
 static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned long address)
 {
-	address &= PAGE_MASK;
-	if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
-		address -= PAGE_SIZE;
-		if (find_vma(vma->vm_mm, address) != vma)
-			return -ENOMEM;
+	struct vm_area_struct *v;
+
+	if (vma->vm_flags & VM_GROWSDOWN) {
+		address &= PAGE_MASK;
+		if (address == vma->vm_start) {
+			address -= PAGE_SIZE;
+			if (find_vma(vma->vm_mm, address) != vma)
+				return -ENOMEM;
 
-		expand_stack(vma, address);
+			expand_stack(vma, address);
+		}
+	} else if (vma->vm_flags & VM_GROWSUP) {
+		address = PAGE_ALIGN(address + 1);
+		if (address == vma->vm_end) {
+			address += PAGE_SIZE;
+			if ((v = find_vma(vma->vm_mm, address)) &&
+				v->vm_start <= address) {
+				return -ENOMEM;
+			}
+			expand_upwards(vma, address);
+		}
 	}
 	return 0;
 }

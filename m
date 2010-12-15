Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0LOWU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:20:58 -0500
Received: from claw.goop.org ([74.207.240.146]:47916 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab0LOWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:12 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 9/9] xen/grant-table: use apply_to_page_range_batch()
Date: Wed, 15 Dec 2010 14:19:55 -0800
Message-Id: <e0a4f34179d6e85c018a80a89ecce8367ec20255.1292450600.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

No need to call the callback per-pte.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/grant-table.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index 5bf892a..11a8a45 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -44,19 +44,27 @@
 
 #include <asm/pgtable.h>
 
-static int map_pte_fn(pte_t *pte, unsigned long addr, void *data)
+static int map_pte_fn(pte_t *pte, unsigned count, unsigned long addr, void *data)
 {
 	unsigned long **frames = (unsigned long **)data;
 
-	set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
-	(*frames)++;
+	while (count--) {
+		set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
+		(*frames)++;
+		pte++;
+		addr += PAGE_SIZE;
+	}
 	return 0;
 }
 
-static int unmap_pte_fn(pte_t *pte, unsigned long addr, void *data)
+static int unmap_pte_fn(pte_t *pte, unsigned count, unsigned long addr, void *data)
 {
+	while (count--) {
+		pte_clear(&init_mm, addr, pte);
+		addr += PAGE_SIZE;
+		pte++;
+	}
 
-	set_pte_at(&init_mm, addr, pte, __pte(0));
 	return 0;
 }
 
@@ -75,15 +83,15 @@ int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 		*__shared = shared;
 	}
 
-	rc = apply_to_page_range(&init_mm, (unsigned long)shared,
-				 PAGE_SIZE * nr_gframes,
-				 map_pte_fn, &frames);
+	rc = apply_to_page_range_batch(&init_mm, (unsigned long)shared,
+				       PAGE_SIZE * nr_gframes,
+				       map_pte_fn, &frames);
 	return rc;
 }
 
 void arch_gnttab_unmap_shared(struct grant_entry *shared,
 			      unsigned long nr_gframes)
 {
-	apply_to_page_range(&init_mm, (unsigned long)shared,
-			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
+	apply_to_page_range_batch(&init_mm, (unsigned long)shared,
+				  PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
 }
-- 
1.7.3.3


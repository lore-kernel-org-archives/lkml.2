Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0JNVQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:16:17 -0400
Received: from king.tilera.com ([72.1.168.226]:52859 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab0JNVQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:16 -0400
Message-Id: <dabe98c972091818762e02841ab1f982e573e7d0.1287090286.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1287090280.git.cmetcalf@tilera.com>
References: <cover.1287090280.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 14 Oct 2010 15:19:04 -0400
Subject: [PATCH 06/14] arch/tile: prevent corrupt top frame from causing backtracer runaway
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 14 Oct 2010 21:16:15.0496 (UTC) FILETIME=[091FE880:01CB6BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backtracer will normally cut itself off after 100 frames anyway,
but it's messy.  With this change we notice that the frame being
reported is the same as the last one, and cut off the dump with a
message similar to what gdb displays in the same circumstance.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/stack.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index ea2e0ce..0d54106 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -30,6 +30,10 @@
 #include <arch/abi.h>
 #include <arch/interrupts.h>
 
+#define KBT_ONGOING	0  /* Backtrace still ongoing */
+#define KBT_DONE	1  /* Backtrace cleanly completed */
+#define KBT_RUNNING	2  /* Can't run backtrace on a running task */
+#define KBT_LOOP	3  /* Backtrace entered a loop */
 
 /* Is address on the specified kernel stack? */
 static int in_kernel_stack(struct KBacktraceIterator *kbt, VirtualAddress sp)
@@ -207,11 +211,11 @@ static int KBacktraceIterator_next_item_inclusive(
 	for (;;) {
 		do {
 			if (!KBacktraceIterator_is_sigreturn(kbt))
-				return 1;
+				return KBT_ONGOING;
 		} while (backtrace_next(&kbt->it));
 
 		if (!KBacktraceIterator_restart(kbt))
-			return 0;
+			return KBT_DONE;
 	}
 }
 
@@ -264,7 +268,7 @@ void KBacktraceIterator_init(struct KBacktraceIterator *kbt,
 	kbt->pgtable = NULL;
 	kbt->verbose = 0;   /* override in caller if desired */
 	kbt->profile = 0;   /* override in caller if desired */
-	kbt->end = 0;
+	kbt->end = KBT_ONGOING;
 	kbt->new_context = 0;
 	if (is_current) {
 		HV_PhysAddr pgdir_pa = hv_inquire_context().page_table;
@@ -290,7 +294,7 @@ void KBacktraceIterator_init(struct KBacktraceIterator *kbt,
 	if (regs == NULL) {
 		if (is_current || t->state == TASK_RUNNING) {
 			/* Can't do this; we need registers */
-			kbt->end = 1;
+			kbt->end = KBT_RUNNING;
 			return;
 		}
 		pc = get_switch_to_pc();
@@ -305,26 +309,29 @@ void KBacktraceIterator_init(struct KBacktraceIterator *kbt,
 	}
 
 	backtrace_init(&kbt->it, read_memory_func, kbt, pc, lr, sp, r52);
-	kbt->end = !KBacktraceIterator_next_item_inclusive(kbt);
+	kbt->end = KBacktraceIterator_next_item_inclusive(kbt);
 }
 EXPORT_SYMBOL(KBacktraceIterator_init);
 
 int KBacktraceIterator_end(struct KBacktraceIterator *kbt)
 {
-	return kbt->end;
+	return kbt->end != KBT_ONGOING;
 }
 EXPORT_SYMBOL(KBacktraceIterator_end);
 
 void KBacktraceIterator_next(struct KBacktraceIterator *kbt)
 {
+	VirtualAddress old_pc = kbt->it.pc, old_sp = kbt->it.sp;
 	kbt->new_context = 0;
-	if (!backtrace_next(&kbt->it) &&
-	    !KBacktraceIterator_restart(kbt)) {
-			kbt->end = 1;
-			return;
-		}
-
-	kbt->end = !KBacktraceIterator_next_item_inclusive(kbt);
+	if (!backtrace_next(&kbt->it) && !KBacktraceIterator_restart(kbt)) {
+		kbt->end = KBT_DONE;
+		return;
+	}
+	kbt->end = KBacktraceIterator_next_item_inclusive(kbt);
+	if (old_pc == kbt->it.pc && old_sp == kbt->it.sp) {
+		/* Trapped in a loop; give up. */
+		kbt->end = KBT_LOOP;
+	}
 }
 EXPORT_SYMBOL(KBacktraceIterator_next);
 
@@ -387,6 +394,8 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 			break;
 		}
 	}
+	if (kbt->end == KBT_LOOP)
+		pr_err("Stack dump stopped; next frame identical to this one\n");
 	if (headers)
 		pr_err("Stack dump complete\n");
 }
-- 
1.6.5.2


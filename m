Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab1CATmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:42:32 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52545 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab1CAThT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:19 -0500
Message-Id: <201103011934.p21JYbK7010299@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 13:24:37 -0500
Subject: [PATCH] arch/tile: stop disabling INTCTRL_1 interrupts during hypervisor downcalls
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:37.0873 (UTC) FILETIME=[B3A9FA10:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem was that this could lead to IPIs being disabled during
the softirq processing after a hypervisor downcall (e.g. for I/O),
since both IPI and device interrupts use the INCTRL_1 downcall mechanism.
When this happened at the wrong time, it could lead to deadlock.

Luckily, we were already maintaining the per-interrupt state we need,
and using it in the proper way in the hypervisor, so all we had to do
was to change Linux to stop blocking downcall interrupts for the entire
length of the downcall.  (Now they're blocked while we're executing the
downcall routine itself, but not while we're executing any subsequent
softirq routines.)  The hypervisor is doing a very small amount of
work it no longer needs to do (masking INTCTRL_1 on entry to the client
interrupt routine), but doing so means that older versions of Tile Linux
will continue to work with a current hypervisor, so that seems reasonable.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S |   54 ++++--------------------------------------
 1 files changed, 5 insertions(+), 49 deletions(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 5eed4a0..abf92f5 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -32,10 +32,6 @@
 # error "No support for kernel preemption currently"
 #endif
 
-#if INT_INTCTRL_K < 32 || INT_INTCTRL_K >= 48
-# error INT_INTCTRL_K coded to set high interrupt mask
-#endif
-
 #define PTREGS_PTR(reg, ptreg) addli reg, sp, C_ABI_SAVE_AREA_SIZE + (ptreg)
 
 #define PTREGS_OFFSET_SYSCALL PTREGS_OFFSET_REG(TREG_SYSCALL_NR)
@@ -1199,46 +1195,6 @@ STD_ENTRY(interrupt_return)
 	STD_ENDPROC(interrupt_return)
 
 	/*
-	 * This interrupt variant clears the INT_INTCTRL_K interrupt mask bit
-	 * before returning, so we can properly get more downcalls.
-	 */
-	.pushsection .text.handle_interrupt_downcall,"ax"
-handle_interrupt_downcall:
-	finish_interrupt_save handle_interrupt_downcall
-	check_single_stepping normal, .Ldispatch_downcall
-.Ldispatch_downcall:
-
-	/* Clear INTCTRL_K from the set of interrupts we ever enable. */
-	GET_INTERRUPTS_ENABLED_MASK_PTR(r30)
-	{
-	 addi   r30, r30, 4
-	 movei  r31, INT_MASK(INT_INTCTRL_K)
-	}
-	{
-	 lw     r20, r30
-	 nor    r21, r31, zero
-	}
-	and     r20, r20, r21
-	sw      r30, r20
-
-	{
-	 jalr   r0
-	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
-	}
-	FEEDBACK_REENTER(handle_interrupt_downcall)
-
-	/* Allow INTCTRL_K to be enabled next time we enable interrupts. */
-	lw      r20, r30
-	or      r20, r20, r31
-	sw      r30, r20
-
-	{
-	 movei  r30, 0   /* not an NMI */
-	 j      interrupt_return
-	}
-	STD_ENDPROC(handle_interrupt_downcall)
-
-	/*
 	 * Some interrupts don't check for single stepping
 	 */
 	.pushsection .text.handle_interrupt_no_single_step,"ax"
@@ -2014,17 +1970,17 @@ int_unalign:
 #endif
 	int_hand     INT_INTCTRL_0, INTCTRL_0, bad_intr
 	int_hand     INT_MESSAGE_RCV_DWNCL, MESSAGE_RCV_DWNCL, \
-		     hv_message_intr, handle_interrupt_downcall
+		     hv_message_intr
 	int_hand     INT_DEV_INTR_DWNCL, DEV_INTR_DWNCL, \
-		     tile_dev_intr, handle_interrupt_downcall
+		     tile_dev_intr
 	int_hand     INT_I_ASID, I_ASID, bad_intr
 	int_hand     INT_D_ASID, D_ASID, bad_intr
 	int_hand     INT_DMATLB_MISS_DWNCL, DMATLB_MISS_DWNCL, \
-		     do_page_fault, handle_interrupt_downcall
+		     do_page_fault
 	int_hand     INT_SNITLB_MISS_DWNCL, SNITLB_MISS_DWNCL, \
-		     do_page_fault, handle_interrupt_downcall
+		     do_page_fault
 	int_hand     INT_DMATLB_ACCESS_DWNCL, DMATLB_ACCESS_DWNCL, \
-		     do_page_fault, handle_interrupt_downcall
+		     do_page_fault
 	int_hand     INT_SN_CPL, SN_CPL, bad_intr
 	int_hand     INT_DOUBLE_FAULT, DOUBLE_FAULT, do_trap
 #if CHIP_HAS_AUX_PERF_COUNTERS()
-- 
1.6.5.2


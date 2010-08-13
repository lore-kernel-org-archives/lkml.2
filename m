Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab0HMUi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 16:38:59 -0400
Received: from king.tilera.com ([72.1.168.226]:17731 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab0HMUi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 16:38:57 -0400
Message-Id: <201008132038.o7DKct4N002252@lab-8.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 13 Aug 2010 16:37:00 -0400
Subject: [PATCH] arch/tile: extend syscall ABI to set r1 on return as well.
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 13 Aug 2010 20:38:56.0114 (UTC) FILETIME=[8CBCD520:01CB3B27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, the tile architecture ABI for syscall return has just been
that r0 holds the return value, and an error is only signalled like it is
for kernel code, with a negative small number.

However, this means that in multiple places in userspace we end up writing
the same three-cycle idiom that tests for a small negative number for
error.  It seems cleaner to instead move that code into the kernel, and
set r1 to hold zero on success or errno on failure; previously, r1 was
just zeroed on return from the kernel (to avoid leaking kernel state).
This way a single conditional branch after the syscall is sufficient
to test for the failure case.  The number of cycles taken is the same,
but the error-checking code is in just one place, so total code size is
smaller, and random userspace syscall code is easier to understand.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 3404c75..84f296c 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -952,7 +952,7 @@ STD_ENTRY(interrupt_return)
 	 * able to safely read all the remaining words on those cache
 	 * lines without waiting for the memory subsystem.
 	 */
-	pop_reg_zero r0, r1, sp, PTREGS_OFFSET_REG(30) - PTREGS_OFFSET_REG(0)
+	pop_reg_zero r0, r28, sp, PTREGS_OFFSET_REG(30) - PTREGS_OFFSET_REG(0)
 	pop_reg_zero r30, r2, sp, PTREGS_OFFSET_PC - PTREGS_OFFSET_REG(30)
 	pop_reg_zero r21, r3, sp, PTREGS_OFFSET_EX1 - PTREGS_OFFSET_PC
 	pop_reg_zero lr, r4, sp, PTREGS_OFFSET_REG(52) - PTREGS_OFFSET_EX1
@@ -1017,7 +1017,17 @@ STD_ENTRY(interrupt_return)
 	{ move r22, zero; move r23, zero }
 	{ move r24, zero; move r25, zero }
 	{ move r26, zero; move r27, zero }
-	{ move r28, zero; move r29, zero }
+
+	/* Set r1 to errno if we are returning an error, otherwise zero. */
+	{
+	 moveli r29, 1024
+	 sub    r1, zero, r0
+	}
+	slt_u   r29, r1, r29
+	{
+	 mnz    r1, r29, r1
+	 move   r29, zero
+	}
 	iret
 
 	/*
-- 
1.6.5.2


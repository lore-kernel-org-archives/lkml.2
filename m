Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935144Ab2C3WxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:53:07 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934966Ab2C3VGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:04 -0400
Message-Id: <201203302105.q2UL57mo006302@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 16:11:09 -0400
Subject: [PATCH] arch/tile: fix single-stepping over swint1 instructions on tilegx
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:07.0663 (UTC) FILETIME=[C93D6DF0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are single-stepping and make a syscall, we call ptrace_notify()
explicitly on the return path back to user space, since we are returning
to a pc value set artificially to the next instruction, and otherwise
we won't register that we stepped over the syscall instruction (swint1).

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_64.S |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 6a1ea82..cbf7334 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -22,6 +22,7 @@
 #include <asm/irqflags.h>
 #include <asm/asm-offsets.h>
 #include <asm/types.h>
+#include <asm/signal.h>
 #include <hv/hypervisor.h>
 #include <arch/abi.h>
 #include <arch/interrupts.h>
@@ -1047,11 +1048,25 @@ handle_syscall:
 
 	/* Do syscall trace again, if requested. */
 	ld	r30, r31
-	andi    r30, r30, _TIF_SYSCALL_TRACE
-	beqzt	r30, 1f
+	andi    r0, r30, _TIF_SYSCALL_TRACE
+	{
+	 andi    r0, r30, _TIF_SINGLESTEP
+	 beqzt   r0, 1f
+	}
 	jal	do_syscall_trace
 	FEEDBACK_REENTER(handle_syscall)
-1:	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+	andi    r0, r30, _TIF_SINGLESTEP
+
+1:	beqzt	r0, 2f
+
+	/* Single stepping -- notify ptrace. */
+	{
+	 movei   r0, SIGTRAP
+	 jal     ptrace_notify
+	}
+	FEEDBACK_REENTER(handle_syscall)
+
+2:	j       .Lresume_userspace   /* jump into middle of interrupt_return */
 
 .Lcompat_syscall:
 	/*
-- 
1.6.5.2


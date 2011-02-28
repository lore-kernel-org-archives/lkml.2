Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1CATlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:41:00 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52545 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213Ab1CAThW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:22 -0500
Message-Id: <201103011934.p21JYdZK010305@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 15:22:40 -0500
Subject: [PATCH] arch/tile: use a cleaner technique to enable interrupt for cpu_idle()
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:39.0232 (UTC) FILETIME=[B4795800:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we used iret to atomically return to kernel PL with
interrupts enabled.  However, it turns out that we are architecturally
guaranteed that we can just set and clear the "interrupt critical
section" and only interrupt on the following instruction, so we
now do that instead, since it's cleaner.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/entry.S |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/tile/kernel/entry.S b/arch/tile/kernel/entry.S
index c3aa067..431e9ae 100644
--- a/arch/tile/kernel/entry.S
+++ b/arch/tile/kernel/entry.S
@@ -91,23 +91,17 @@ STD_ENTRY(smp_nap)
 
 /*
  * Enable interrupts racelessly and then nap until interrupted.
+ * Architecturally, we are guaranteed that enabling interrupts via
+ * mtspr to INTERRUPT_CRITICAL_SECTION only interrupts at the next PC.
  * This function's _cpu_idle_nap address is special; see intvec.S.
  * When interrupted at _cpu_idle_nap, we bump the PC forward 8, and
  * as a result return to the function that called _cpu_idle().
  */
 STD_ENTRY(_cpu_idle)
-	{
-	 lnk r0
-	 movei r1, KERNEL_PL
-	}
-	{
-	 addli r0, r0, _cpu_idle_nap - .
-	 mtspr INTERRUPT_CRITICAL_SECTION, r1
-	}
+	movei r1, 1
+	mtspr INTERRUPT_CRITICAL_SECTION, r1
 	IRQ_ENABLE(r2, r3)             /* unmask, but still with ICS set */
-	mtspr SPR_EX_CONTEXT_K_1, r1   /* Kernel PL, ICS clear */
-	mtspr SPR_EX_CONTEXT_K_0, r0
-	iret
+	mtspr INTERRUPT_CRITICAL_SECTION, zero
 	.global _cpu_idle_nap
 _cpu_idle_nap:
 	nap
-- 
1.6.5.2


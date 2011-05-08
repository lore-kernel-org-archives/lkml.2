Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab1EHMxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 08:53:20 -0400
Received: from service87.mimecast.com ([94.185.240.25]:42967 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753881Ab1EHMwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 08:52:05 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v5 15/19] ARM: LPAE: Add support for cpu_v7_do_(suspend|resume)
Date: Sun,  8 May 2011 13:51:34 +0100
Message-Id: <1304859098-10760-16-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 08 May 2011 12:51:52.0991 (UTC) FILETIME=[B45C9AF0:01CC0D7E]
X-MC-Unique: 111050813520201601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p48Crfbl020075

With LPAE, the TTBRx size is 64-bit so make sure that all the
information is saved and restored.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/proc-v7.S |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index ad22628..3e6999e 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -260,19 +260,32 @@ cpu_v7_name:
 
 /* Suspend/resume support: derived from arch/arm/mach-s5pv210/sleep.S */
 .globl	cpu_v7_suspend_size
+#ifdef CONFIG_ARM_LPAE
+.equ	cpu_v7_suspend_size, 4 * 10
+#else
 .equ	cpu_v7_suspend_size, 4 * 8
+#endif
 #ifdef CONFIG_PM_SLEEP
 ENTRY(cpu_v7_do_suspend)
 	stmfd	sp!, {r4 - r11, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ FCSE/PID
 	mrc	p15, 0, r5, c13, c0, 1	@ Context ID
 	mrc	p15, 0, r6, c3, c0, 0	@ Domain ID
+#ifdef CONFIG_ARM_LPAE
+	mrrc	p15, 0, r7, r8, c2	@ TTB 0
+	mrrc	p15, 1, r2, r3, c2	@ TTB 1
+#else
 	mrc	p15, 0, r7, c2, c0, 0	@ TTB 0
 	mrc	p15, 0, r8, c2, c0, 1	@ TTB 1
+#endif
 	mrc	p15, 0, r9, c1, c0, 0	@ Control register
 	mrc	p15, 0, r10, c1, c0, 1	@ Auxiliary control register
 	mrc	p15, 0, r11, c1, c0, 2	@ Co-processor access control
+#ifdef CONFIG_ARM_LPAE
+	stmia	r0, {r2 - r11}
+#else
 	stmia	r0, {r4 - r11}
+#endif
 	ldmfd	sp!, {r4 - r11, pc}
 ENDPROC(cpu_v7_do_suspend)
 
@@ -280,12 +293,21 @@ ENTRY(cpu_v7_do_resume)
 	mov	ip, #0
 	mcr	p15, 0, ip, c8, c7, 0	@ invalidate TLBs
 	mcr	p15, 0, ip, c7, c5, 0	@ invalidate I cache
+#ifdef CONFIG_ARM_LPAE
+	ldmia	r0, {r2 - r11}
+#else
 	ldmia	r0, {r4 - r11}
+#endif
 	mcr	p15, 0, r4, c13, c0, 0	@ FCSE/PID
 	mcr	p15, 0, r5, c13, c0, 1	@ Context ID
 	mcr	p15, 0, r6, c3, c0, 0	@ Domain ID
+#ifdef CONFIG_ARM_LPAE
+	mcrr	p15, 0, r7, r8, c2	@ TTB 0
+	mcrr	p15, 1, r2, r3, c2	@ TTB 1
+#else
 	mcr	p15, 0, r7, c2, c0, 0	@ TTB 0
 	mcr	p15, 0, r8, c2, c0, 1	@ TTB 1
+#endif
 	mcr	p15, 0, ip, c2, c0, 2	@ TTB control register
 	mcr	p15, 0, r10, c1, c0, 1	@ Auxiliary control register
 	mcr	p15, 0, r11, c1, c0, 2	@ Co-processor access control


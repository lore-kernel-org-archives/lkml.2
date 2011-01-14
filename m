Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1ANHm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:42:59 -0500
Received: from smtp-out.google.com ([74.125.121.67]:8940 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1ANHmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:42:54 -0500
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
Date: Thu, 13 Jan 2011 23:42:29 -0800
Message-Id: <1294990949-2729-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exception handler in entry-armv.S checks for thumb mode and
correctly determines the exception location and instruction,
but VFP_bounce uses the uncorrected location off the stack.
If the VFP exception occured in Thumb mode, fix up the
exception location to match the value that would be returned
in ARM mode.

Fixes segfaults in userspace applications running in Thumb mode
caused by a handled VFP exception returning to the middle of the
instruction that triggered the exception.

Change-Id: I6c6ba1ab88e107bec166ea334d7e0974a4f6bfba
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/vfp/vfpmodule.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 0797cb5..63ed73d 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -275,6 +275,16 @@ void VFP_bounce(u32 trigger, u32 fpexc, struct pt_regs *regs)
 	pr_debug("VFP: bounce: trigger %08x fpexc %08x\n", trigger, fpexc);
 
 	/*
+	 * If the exception occured in thumb mode, pc is exception location + 2,
+	 * the middle of the 32-bit VFP instruction.  Add 2 to get exception
+	 * location + 4, the same we get in ARM mode.
+	 */
+#ifdef CONFIG_ARM_THUMB
+	if (regs->ARM_cpsr & PSR_T_BIT)
+		regs->ARM_pc += 2;
+#endif
+
+	/*
 	 * At this point, FPEXC can have the following configuration:
 	 *
 	 *  EX DEX IXE
-- 
1.7.3.1


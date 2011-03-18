Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1CRCwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 22:52:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36030 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab1CRCwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 22:52:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6288"; a="80457986"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH] ARM: Merge v6 and v7 DEBUG_LL DCC support
Date: Thu, 17 Mar 2011 19:52:00 -0700
Message-Id: <1300416720-16305-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.266.ga62ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inline assembly differences for v6 vs. v7 are purely
optimizations. On a v7 processor, an mrc with the pc sets the
condition codes to the 28-31 bits of the register being read. It
just so happens that the TX/RX full bits the DCC support code is
testing for are high enough in the register to be put into the
condition codes. On a v6 processor, this "feature" isn't
implemented and thus we have to do the usual read, mask, test
operations to check for TX/RX full. Thus, we can drop the v7
implementation and just use the v6 implementation for both.

Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/compressed/head.S |   10 +---------
 arch/arm/boot/compressed/misc.c |   12 +-----------
 arch/arm/kernel/debug.S         |   19 +------------------
 3 files changed, 3 insertions(+), 38 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 7193884..01448ba 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -21,20 +21,12 @@
 
 #if defined(CONFIG_DEBUG_ICEDCC)
 
-#ifdef CONFIG_CPU_V6
+#if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_V7)
 		.macro	loadsp, rb, tmp
 		.endm
 		.macro	writeb, ch, rb
 		mcr	p14, 0, \ch, c0, c5, 0
 		.endm
-#elif defined(CONFIG_CPU_V7)
-		.macro	loadsp, rb, tmp
-		.endm
-		.macro	writeb, ch, rb
-wait:		mrc	p14, 0, pc, c0, c1, 0
-		bcs	wait
-		mcr	p14, 0, \ch, c0, c5, 0
-		.endm
 #elif defined(CONFIG_CPU_XSCALE)
 		.macro	loadsp, rb, tmp
 		.endm
diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index e653a6d..23c67af 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -36,7 +36,7 @@ extern void error(char *x);
 
 #ifdef CONFIG_DEBUG_ICEDCC
 
-#ifdef CONFIG_CPU_V6
+#if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_V7)
 
 static void icedcc_putc(int ch)
 {
@@ -52,16 +52,6 @@ static void icedcc_putc(int ch)
 	asm("mcr p14, 0, %0, c0, c5, 0" : : "r" (ch));
 }
 
-#elif defined(CONFIG_CPU_V7)
-
-static void icedcc_putc(int ch)
-{
-	asm(
-	"wait:	mrc	p14, 0, pc, c0, c1, 0			\n\
-		bcs	wait					\n\
-		mcr     p14, 0, %0, c0, c5, 0			"
-	: : "r" (ch));
-}
 
 #elif defined(CONFIG_CPU_XSCALE)
 
diff --git a/arch/arm/kernel/debug.S b/arch/arm/kernel/debug.S
index a0f0752..50d86b6 100644
--- a/arch/arm/kernel/debug.S
+++ b/arch/arm/kernel/debug.S
@@ -25,7 +25,7 @@
 		.macro	addruart, rp, rv
 		.endm
 
-#if defined(CONFIG_CPU_V6)
+#if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_V7)
 
 		.macro	senduart, rd, rx
 		mcr	p14, 0, \rd, c0, c5, 0
@@ -49,23 +49,6 @@
 1002:
 		.endm
 
-#elif defined(CONFIG_CPU_V7)
-
-		.macro	senduart, rd, rx
-		mcr	p14, 0, \rd, c0, c5, 0
-		.endm
-
-		.macro	busyuart, rd, rx
-busy:		mrc	p14, 0, pc, c0, c1, 0
-		bcs	busy
-		.endm
-
-		.macro	waituart, rd, rx
-wait:		mrc	p14, 0, pc, c0, c1, 0
-		bcs	wait
-
-		.endm
-
 #elif defined(CONFIG_CPU_XSCALE)
 
 		.macro	senduart, rd, rx
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


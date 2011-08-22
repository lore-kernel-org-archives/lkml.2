Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab1HVNzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:55:05 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:37673 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863Ab1HVNzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:55:04 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jamie Iles <jamie@jamieiles.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] ARM: vexpress: Use wfi macro in platform_do_lowpower.
Date: Mon, 22 Aug 2011 09:54:19 -0400
Message-Id: <1314021259-31710-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <CAHkRjk6Fq+1b_uM+DFACS1QVd7B6_1XhqRw-27i88U1VyvLk+Q@mail.gmail.com>
References: <CAHkRjk6Fq+1b_uM+DFACS1QVd7B6_1XhqRw-27i88U1VyvLk+Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current Versatile Express CPU hotplug code includes a hardcoded WFI
instruction, in ARM encoding.  When the kernel is compiled in Thumb-2
mode, this is invalid and causes the machine to hang hard when a CPU
is offlined.

Using the wfi macro (which uses the appropriate assembler mnemonic)
causes the correct instruction to be emitted in either case.  As a
consequence of this change, an apparently vestigial "cc" clobber is
dropped from the asm (the macro uses "memory" only).

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 arch/arm/mach-vexpress/hotplug.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

OK.  If this version is acceptable, I'll follow up with patches for the
other platforms.

diff --git a/arch/arm/mach-vexpress/hotplug.c b/arch/arm/mach-vexpress/hotplug.c
index ea4cbfb..3668cf9 100644
--- a/arch/arm/mach-vexpress/hotplug.c
+++ b/arch/arm/mach-vexpress/hotplug.c
@@ -13,6 +13,7 @@
 #include <linux/smp.h>
 
 #include <asm/cacheflush.h>
+#include <asm/system.h>
 
 extern volatile int pen_release;
 
@@ -62,13 +63,7 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 	 * code will have already disabled interrupts
 	 */
 	for (;;) {
-		/*
-		 * here's the WFI
-		 */
-		asm(".word	0xe320f003\n"
-		    :
-		    :
-		    : "memory", "cc");
+		wfi();
 
 		if (pen_release == cpu) {
 			/*
-- 
1.7.3.4


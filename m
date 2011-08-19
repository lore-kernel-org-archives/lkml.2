Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1HSSDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:03:45 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:35762 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1HSSDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:03:43 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH RFC] ARM: vexpress: Use assembler mnemonic for WFI in platform_do_lowpower.
Date: Fri, 19 Aug 2011 14:03:24 -0400
Message-Id: <1313777004-4716-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current Versatile Express CPU hotplug code includes a hardcoded WFI
instruction, in ARM encoding.  When the kernel is compiled in Thumb-2
mode, this is invalid and causes the machine to hang hard when a CPU
is offlined.

Using the assembler mnemonic instead of hardcoding it causes the correct
instruction to be emitted in either case.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 arch/arm/mach-vexpress/hotplug.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

OK.  I assume that the reason for the hardcoded instruction is that
older versions of binutils did not support the mnemonic.  Looking at the
binutils CVS history, support seems to have been added in 2005, and was
included in the 2.16 release.  If we care about those old assembler
versions, I can resubmit this patch using ARM/THUMB macros instead,
which should work just as well.

I imagine that other platforms which use this same construct, such as
realview, will have similar problems in thumb mode.  I can't test
changes on those platforms, unfortunately.

diff --git a/arch/arm/mach-vexpress/hotplug.c b/arch/arm/mach-vexpress/hotplug.c
index ea4cbfb..d6be197 100644
--- a/arch/arm/mach-vexpress/hotplug.c
+++ b/arch/arm/mach-vexpress/hotplug.c
@@ -62,10 +62,7 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 	 * code will have already disabled interrupts
 	 */
 	for (;;) {
-		/*
-		 * here's the WFI
-		 */
-		asm(".word	0xe320f003\n"
+		asm("wfi\n"
 		    :
 		    :
 		    : "memory", "cc");
-- 
1.7.3.4


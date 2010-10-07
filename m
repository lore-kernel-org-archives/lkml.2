Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0JGToY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:44:24 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:57205 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0JGToX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:44:23 -0400
Date: Thu, 7 Oct 2010 21:44:15 +0200
From: Anders Larsen <al@alarsen.net>
To: patches@arm.linux.org.uk
Cc: Andrew Victor <avictor.za@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: AT91: Fix power-saving in idle-mode on 926T processors
Message-ID: <20101007194415.GA24709@alarsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: anders@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Atmel, their 926T processors (AT91 post RM9200) requires
'Wait for Interrupt' mode be entered right after disabling the processor clock
in order to minimise current consumption when idle, so do both provided we're
not running on a 920T (an RM9200).

Furthermore, get rid of the #ifndef CONFIG_DEBUG_KERNEL, since arch_idle()
can be turned off completely with the kernel parameter 'nohlt'.

Signed-off-by: Anders Larsen <al@alarsen.net>
Cc: Andrew Victor <avictor.za@gmail.com>
---
KernelVersion: 2.6.35

 arch/arm/mach-at91/include/mach/system.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/system.h b/arch/arm/mach-at91/include/mach/system.h
index c80e090..ee8db15 100644
--- a/arch/arm/mach-at91/include/mach/system.h
+++ b/arch/arm/mach-at91/include/mach/system.h
@@ -28,17 +28,16 @@
 
 static inline void arch_idle(void)
 {
-#ifndef CONFIG_DEBUG_KERNEL
 	/*
 	 * Disable the processor clock.  The processor will be automatically
 	 * re-enabled by an interrupt or by a reset.
 	 */
 	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
-#else
+#ifndef CONFIG_CPU_ARM920T
 	/*
 	 * Set the processor (CP15) into 'Wait for Interrupt' mode.
-	 * Unlike disabling the processor clock via the PMC (above)
-	 *  this allows the processor to be woken via JTAG.
+	 * Post-RM9200 processors need this in conjunction with the above
+	 * to save power when idle.
 	 */
 	cpu_do_idle();
 #endif
-- 
1.7.0.4


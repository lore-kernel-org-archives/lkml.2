Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab0JZC4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:56:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab0JZC4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:56:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 33/43] MN10300: Make various interrupt priority settings
 configurable
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:55:57 +0100
Message-ID: <20101026025557.23512.95868.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Make the settings of interrupt priorities used by various services configurable
at run time.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig                |   74 +++++++++++++++++++++++++++++++++++
 arch/mn10300/include/asm/irqflags.h |    8 +---
 2 files changed, 76 insertions(+), 6 deletions(-)


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index a1f334c..a0a16e6 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -351,6 +351,80 @@ config MN10300_TTYSM2_CTS
 
 endmenu
 
+menu "Interrupt request priority options"
+
+comment "[!] NOTE: A lower number/level indicates a higher priority (0 is highest, 6 is lowest)"
+
+comment "____Non-maskable interrupt levels____"
+comment "The following must be set to a higher priority than local_irq_disable() and on-chip serial"
+
+config GDBSTUB_IRQ_LEVEL
+	int "GDBSTUB interrupt priority"
+	depends on GDBSTUB
+	range 0 1 if LINUX_CLI_LEVEL = 2
+	range 0 2 if LINUX_CLI_LEVEL = 3
+	range 0 3 if LINUX_CLI_LEVEL = 4
+	range 0 4 if LINUX_CLI_LEVEL = 5
+	range 0 5 if LINUX_CLI_LEVEL = 6
+	default 0
+
+comment "The following must be set to a higher priority than local_irq_disable()"
+
+config MN10300_SERIAL_IRQ_LEVEL
+	int "MN10300 on-chip serial interrupt priority"
+	depends on MN10300_TTYSM
+	range 1 1 if LINUX_CLI_LEVEL = 2
+	range 1 2 if LINUX_CLI_LEVEL = 3
+	range 1 3 if LINUX_CLI_LEVEL = 4
+	range 1 4 if LINUX_CLI_LEVEL = 5
+	range 1 5 if LINUX_CLI_LEVEL = 6
+	default 1
+
+comment "-"
+comment "____Maskable interrupt levels____"
+
+config LINUX_CLI_LEVEL
+	int "The highest interrupt priority excluded by local_irq_disable() (2-6)"
+	range 2 6
+	default 2
+	help
+	  local_irq_disable() doesn't actually disable maskable interrupts -
+	  what it does is restrict the levels of interrupt which are permitted
+	  (a lower level indicates a higher priority) by lowering the value in
+	  EPSW.IM from 7.  Any interrupt is permitted for which the level is
+	  lower than EPSW.IM.
+
+	  Certain interrupts, such as GDBSTUB and virtual MN10300 on-chip
+	  serial DMA interrupts are allowed to interrupt normal disabled
+	  sections.
+
+comment "The following must be set to a equal to or lower priority than LINUX_CLI_LEVEL"
+
+config TIMER_IRQ_LEVEL
+	int "Kernel timer interrupt priority"
+	range LINUX_CLI_LEVEL 6
+	default 4
+
+config PCI_IRQ_LEVEL
+	int "PCI interrupt priority"
+	depends on PCI
+	range LINUX_CLI_LEVEL 6
+	default 5
+
+config ETHERNET_IRQ_LEVEL
+	int "Ethernet interrupt priority"
+	depends on SMC91X || SMC911X || SMSC911X
+	range LINUX_CLI_LEVEL 6
+	default 6
+
+config EXT_SERIAL_IRQ_LEVEL
+	int "External serial port interrupt priority"
+	depends on SERIAL_8250
+	range LINUX_CLI_LEVEL 6
+	default 6
+
+endmenu
+
 source "mm/Kconfig"
 
 menu "Power management options"
diff --git a/arch/mn10300/include/asm/irqflags.h b/arch/mn10300/include/asm/irqflags.h
index f1b64b2..b3ab207 100644
--- a/arch/mn10300/include/asm/irqflags.h
+++ b/arch/mn10300/include/asm/irqflags.h
@@ -23,11 +23,7 @@
  *   - level 6 - timer interrupt
  * - "enabled":  run in IM7
  */
-#ifdef CONFIG_MN10300_TTYSM
-#define MN10300_CLI_LEVEL	EPSW_IM_2
-#else
-#define MN10300_CLI_LEVEL	EPSW_IM_1
-#endif
+#define MN10300_CLI_LEVEL	(CONFIG_LINUX_CLI_LEVEL << EPSW_IM_SHIFT)
 
 #ifndef __ASSEMBLY__
 
@@ -94,7 +90,7 @@ static inline void arch_local_irq_restore(unsigned long flags)
 
 static inline bool arch_irqs_disabled_flags(unsigned long flags)
 {
-	return (flags & EPSW_IM) <= MN10300_CLI_LEVEL;
+	return (flags & (EPSW_IE | EPSW_IM)) != (EPSW_IE | EPSW_IM_7);
 }
 
 static inline bool arch_irqs_disabled(void)


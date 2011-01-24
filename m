Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1AXEbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:31:07 -0500
Received: from www.tglx.de ([62.245.132.106]:55748 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab1AXE3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:29:50 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH TIP 11/14] x86/ce4100: use OF for ioapic
Date: Mon, 24 Jan 2011 09:58:59 +0530
Message-Id: <1295843342-1122-12-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and hpet and a few others things....

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/platform/ce4100/ce4100.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index d2c0d51..7877453 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -15,21 +15,19 @@
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
 
+#include <asm/prom.h>
 #include <asm/setup.h>
+#include <asm/i8259.h>
 #include <asm/io.h>
+#include <asm/io_apic.h>
 
 static int ce4100_i8042_detect(void)
 {
 	return 0;
 }
 
-static void __init sdv_find_smp_config(void)
-{
-}
-
 #ifdef CONFIG_SERIAL_8250
 
-
 static unsigned int mem_serial_in(struct uart_port *p, int offset)
 {
 	offset = offset << p->regshift;
@@ -118,6 +116,13 @@ static void __init sdv_arch_setup(void)
 	sdv_serial_fixup();
 }
 
+static void __cpuinit sdv_pci_init(void)
+{
+	x86_of_pci_init();
+	/* We can't set this earlier, because we need calibrate the timer */
+	legacy_pic = &null_legacy_pic;
+}
+
 /*
  * CE4100 specific x86_init function overrides and early setup
  * calls.
@@ -127,6 +132,11 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.oem.arch_setup = sdv_arch_setup;
 	x86_platform.i8042_detect = ce4100_i8042_detect;
 	x86_init.resources.probe_roms = x86_init_noop;
-	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
-	x86_init.mpparse.find_smp_config = sdv_find_smp_config;
+	x86_init.mpparse.get_smp_config = x86_dtb_get_config;
+	x86_init.mpparse.find_smp_config = x86_dtb_find_config;
+
+#ifdef CONFIG_X86_IO_APIC
+	x86_init.pci.init_irq = sdv_pci_init;
+	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
+#endif
 }
-- 
1.7.3.2


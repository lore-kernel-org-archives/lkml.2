Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0KYRoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:44:16 -0500
Received: from www.tglx.de ([62.245.132.106]:50956 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab0KYRoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:44:13 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 11/11] x86/ce4100: use OF for ioapic
Date: Thu, 25 Nov 2010 18:40:01 +0100
Message-Id: <1290706801-7323-12-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and hpet and a few others things....

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: x86@kernel.org
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/platform/ce4100/ce4100.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 0ede12b..5ed25df 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -13,7 +13,11 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 
+#include <asm/prom.h>
 #include <asm/setup.h>
+#include <asm/io.h>
+#include <asm/i8259.h>
+#include <asm/io_apic.h>
 
 static int ce4100_i8042_detect(void)
 {
@@ -24,8 +28,11 @@ static void __init sdv_arch_setup(void)
 {
 }
 
-static void __init sdv_find_smp_config(void)
+static void __cpuinit sdv_pci_init(void)
 {
+	x86_of_pci_init();
+	/* We can't set this earlier, because we need calibrate the timer */
+	legacy_pic = &null_legacy_pic;
 }
 
 /*
@@ -38,5 +45,10 @@ void __init x86_ce4100_early_setup(void)
 	x86_platform.i8042_detect = ce4100_i8042_detect;
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
-	x86_init.mpparse.find_smp_config = sdv_find_smp_config;
+	x86_init.mpparse.find_smp_config = x86_early_of_parse;
+
+#ifdef CONFIG_X86_IO_APIC
+	x86_init.pci.init_irq = sdv_pci_init;
+	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_apicid;
+#endif
 }
-- 
1.7.3.2


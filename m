Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab1BWVw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:52:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:57140 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab1BWVwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:52:55 -0500
Date: Wed, 23 Feb 2011 21:52:40 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1298405266-1624-11-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-11-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: ce4100: Use OF to setup devices
Message-ID: <tip-1fa4163bdc199a0b80f9e333d718b3f65e901593@git.kernel.org>
Git-Commit-ID: 1fa4163bdc199a0b80f9e333d718b3f65e901593
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 21:52:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1fa4163bdc199a0b80f9e333d718b3f65e901593
Gitweb:     http://git.kernel.org/tip/1fa4163bdc199a0b80f9e333d718b3f65e901593
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue, 22 Feb 2011 21:07:45 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Feb 2011 22:27:54 +0100

x86: ce4100: Use OF to setup devices

Use device tree information to setup IO_APIC configuration, interrupt
routing, HPET and everything else which cannot be enumerated by other
means.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: sodaville@linutronix.de
Cc: devicetree-discuss@lists.ozlabs.org
LKML-Reference: <1298405266-1624-11-git-send-email-bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/platform/ce4100/ce4100.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index d2c0d51..b3436d3 100644
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
@@ -118,6 +116,15 @@ static void __init sdv_arch_setup(void)
 	sdv_serial_fixup();
 }
 
+#ifdef CONFIG_X86_IO_APIC
+static void __cpuinit sdv_pci_init(void)
+{
+	x86_of_pci_init();
+	/* We can't set this earlier, because we need to calibrate the timer */
+	legacy_pic = &null_legacy_pic;
+}
+#endif
+
 /*
  * CE4100 specific x86_init function overrides and early setup
  * calls.
@@ -127,6 +134,11 @@ void __init x86_ce4100_early_setup(void)
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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0KYRoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:44:00 -0500
Received: from www.tglx.de ([62.245.132.106]:50938 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab0KYRn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:43:58 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 06/11] x86/dtb: add support hpet
Date: Thu, 25 Nov 2010 18:39:56 +0100
Message-Id: <1290706801-7323-7-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set hpet_address based on information provied form DTB

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: x86@kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/kernel/prom.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index 9551f2f..f61c541 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -9,6 +9,7 @@
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
+#include <asm/hpet.h>
 #include <asm/irq_controller.h>
 #include <asm/io_apic.h>
 
@@ -99,6 +100,27 @@ void __init add_dtb(u64 data)
 				offsetof(struct setup_data, data));
 }
 
+static int __init early_scan_hpet(unsigned long node, const char *uname,
+				   int depth, void *data)
+{
+	unsigned long l;
+	int ret;
+	__be32 *cell;
+
+	if (depth != 2)
+		return 0;
+
+	ret = of_flat_dt_is_compatible(node, "intel,hpet");
+	if (!ret)
+		return 0;
+
+	cell = of_get_flat_dt_prop(node, "phys_reg", &l);
+	if (!cell)
+		return 0;
+	hpet_address = of_read_ulong(cell, l / 4);
+	return 1;
+}
+
 static void __init of_lapic_setup(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -195,6 +217,7 @@ void __init x86_early_of_parse(void)
 
 	/* root level address cells */
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+	of_scan_flat_dt(early_scan_hpet, NULL);
 	of_apic_setup();
 
 	early_iounmap(initial_boot_params, size);
-- 
1.7.3.2


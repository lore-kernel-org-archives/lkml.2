Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946195Ab2EKTlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:41:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35597 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946166Ab2EKTlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:41:45 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        horms@verge.net.au, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Sat, 12 May 2012 04:42:40 +0900
Message-Id: <20120511194240.6567.71240.sendpatchset@w520>
In-Reply-To: <20120511194151.6567.53888.sendpatchset@w520>
References: <20120511194151.6567.53888.sendpatchset@w520>
Subject: [PATCH 05/06] mach-shmobile: KZM9D board Ethernet support V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Tie in the on-board Ethernet controller on KZM9D
and make use of the GPIO controller for external
IRQ pin support.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes from V1:
 - none - this is the first public release

 arch/arm/mach-shmobile/board-kzm9d.c |   44 +++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

--- 0009/arch/arm/mach-shmobile/board-kzm9d.c
+++ work/arch/arm/mach-shmobile/board-kzm9d.c	2012-05-12 03:49:52.000000000 +0900
@@ -20,18 +20,60 @@
 
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/smsc911x.h>
 #include <mach/common.h>
 #include <mach/emev2.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
 
+/* Ether */
+static struct resource smsc911x_resources[] = {
+	[0] = {
+		.start	= 0x20000000,
+		.end	= 0x2000ffff,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= EMEV2_GPIO_IRQ(1),
+		.flags	= IORESOURCE_IRQ | IRQF_TRIGGER_HIGH,
+	},
+};
+
+static struct smsc911x_platform_config smsc911x_platdata = {
+	.flags		= SMSC911X_USE_32BIT,
+	.irq_type	= SMSC911X_IRQ_TYPE_PUSH_PULL,
+	.irq_polarity	= SMSC911X_IRQ_POLARITY_ACTIVE_HIGH,
+};
+
+static struct platform_device smsc91x_device = {
+	.name	= "smsc911x",
+	.id	= 0,
+	.dev	= {
+		  .platform_data = &smsc911x_platdata,
+		},
+	.num_resources	= ARRAY_SIZE(smsc911x_resources),
+	.resource	= smsc911x_resources,
+};
+
+static struct platform_device *kzm9d_devices[] __initdata = {
+	&smsc91x_device,
+};
+
+void __init kzm9d_add_standard_devices(void)
+{
+	emev2_add_standard_devices();
+
+	platform_add_devices(kzm9d_devices, ARRAY_SIZE(kzm9d_devices));
+}
+
 MACHINE_START(KZM9D, "kzm9d")
 	.map_io		= emev2_map_io,
 	.init_early	= emev2_add_early_devices,
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= emev2_init_irq,
 	.handle_irq	= gic_handle_irq,
-	.init_machine	= emev2_add_standard_devices,
+	.init_machine	= kzm9d_add_standard_devices,
 	.timer		= &shmobile_timer,
 MACHINE_END

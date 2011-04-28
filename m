Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1D1EDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 00:03:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41412 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1D1EDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 00:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IYUuRIBRknHejtjhq7X4UJLCbmb4o1B4ONf4ry3BZC8NTdtLrgcAA7rcoq5nrh8n+f
         Twp0e4AURqpN0lUDEeqS2uaHmewMQPrxKn5h+f0M2Z5RSSJQj76Q2U4KoDu/ZZ29s84k
         ZCYA1uRKnPvrN3/8IcoUEkzDVJyDvEVYQYP0M=
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: haojian.zhuang@marvell.com, eric.y.miao@gmail.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 3/3] ARM: mmp: add hardware lock support in PXA910
Date: Thu, 28 Apr 2011 12:02:38 +0800
Message-Id: <1303963358-4652-3-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <2011042801>
References: <2011042801>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RIPC register is used to implement hardware lock between CP and
AP in Marvell PXA910.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-mmp/include/mach/pxa910.h |    3 ++
 arch/arm/mach-mmp/pxa910.c              |   21 +++++++++++++-
 arch/arm/mach-mmp/ttc_dkb.c             |   45 +++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mmp/include/mach/pxa910.h b/arch/arm/mach-mmp/include/mach/pxa910.h
index 91be755..e7659a1 100644
--- a/arch/arm/mach-mmp/include/mach/pxa910.h
+++ b/arch/arm/mach-mmp/include/mach/pxa910.h
@@ -5,6 +5,9 @@ struct sys_timer;
 
 extern struct sys_timer pxa910_timer;
 extern void __init pxa910_init_irq(void);
+extern void pxa910_ripc_lock(void);
+extern void pxa910_ripc_unlock(void);
+extern int pxa910_ripc_trylock(void);
 
 #include <linux/i2c.h>
 #include <linux/i2c/pxa-i2c.h>
diff --git a/arch/arm/mach-mmp/pxa910.c b/arch/arm/mach-mmp/pxa910.c
index 8f92ccd..3190257 100644
--- a/arch/arm/mach-mmp/pxa910.c
+++ b/arch/arm/mach-mmp/pxa910.c
@@ -28,7 +28,10 @@
 #include "common.h"
 #include "clock.h"
 
-#define MFPR_VIRT_BASE	(APB_VIRT_BASE + 0x1e000)
+#define MFPR_VIRT_BASE		(APB_VIRT_BASE + 0x1e000)
+
+#define RIPC0_VIRT_BASE		(APB_VIRT_BASE + 0x3D000)
+#define RIPC0_STATUS		(RIPC0_VIRT_BASE + 0x00)
 
 static struct mfp_addr_map pxa910_mfp_addr_map[] __initdata =
 {
@@ -100,6 +103,22 @@ void __init pxa910_init_irq(void)
 	pxa910_init_gpio();
 }
 
+void pxa910_ripc_lock(void)
+{
+	while (__raw_readl(RIPC0_STATUS))
+		cpu_relax();
+}
+
+int pxa910_ripc_trylock(void)
+{
+	return (!__raw_readl(RIPC0_STATUS));
+}
+
+void pxa910_ripc_unlock(void)
+{
+	__raw_writel(1, RIPC0_STATUS);
+}
+
 /* APB peripheral clocks */
 static APBC_CLK(uart1, PXA910_UART0, 1, 14745600);
 static APBC_CLK(uart2, PXA910_UART1, 1, 14745600);
diff --git a/arch/arm/mach-mmp/ttc_dkb.c b/arch/arm/mach-mmp/ttc_dkb.c
index e411039..c6af021 100644
--- a/arch/arm/mach-mmp/ttc_dkb.c
+++ b/arch/arm/mach-mmp/ttc_dkb.c
@@ -15,6 +15,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/onenand.h>
 #include <linux/interrupt.h>
+#include <linux/mfd/88pm860x.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -32,6 +33,10 @@ static unsigned long ttc_dkb_pin_config[] __initdata = {
 	GPIO47_UART2_RXD,
 	GPIO48_UART2_TXD,
 
+	/* I2C */
+	GPIO53_CI2C_SCL,
+	GPIO54_CI2C_SDA,
+
 	/* DFI */
 	DF_IO0_ND_IO0,
 	DF_IO1_ND_IO1,
@@ -113,12 +118,52 @@ static struct platform_device *ttc_dkb_devices[] = {
 	&ttc_dkb_device_onenand,
 };
 
+static struct pm860x_led_pdata dkb_pm860x_led[] = {
+	{
+		.id		= PM8606_ID_LED,
+		.iset		= PM8606_LED_CURRENT(12),
+		.flags		= PM8606_LED1_RED,
+	}, {
+		.id		= PM8606_ID_LED,
+		.iset		= PM8606_LED_CURRENT(12),
+		.flags		= PM8606_LED1_GREEN,
+	}, {
+		.id		= PM8606_ID_LED,
+		.iset		= PM8606_LED_CURRENT(12),
+		.flags		= PM8606_LED1_BLUE,
+	},
+};
+
+static struct pm860x_platform_data dkb_pm8607_info = {
+	.led			= &dkb_pm860x_led[0],
+	.i2c_port		= GI2C_PORT,
+	.companion_addr		= 0x11,
+	.irq_mode		= 0,
+	.irq_base		= IRQ_BOARD_START,
+};
+
+static struct i2c_board_info dkb_i2c_info[] = {
+	{
+		.type		= "88PM860x",
+		.addr		= 0x34,
+		.platform_data	= &dkb_pm8607_info,
+		.irq		= IRQ_PXA910_PMIC_INT,
+	},
+};
+
+static struct i2c_pxa_platform_data dkb_i2c_pdata = {
+	.hardware_lock		= pxa910_ripc_lock,
+	.hardware_unlock	= pxa910_ripc_unlock,
+	.hardware_trylock	= pxa910_ripc_trylock,
+};
+
 static void __init ttc_dkb_init(void)
 {
 	mfp_config(ARRAY_AND_SIZE(ttc_dkb_pin_config));
 
 	/* on-chip devices */
 	pxa910_add_uart(1);
+	pxa910_add_twsi(0, &dkb_i2c_pdata, ARRAY_AND_SIZE(dkb_i2c_info));
 
 	/* off-chip devices */
 	platform_add_devices(ARRAY_AND_SIZE(ttc_dkb_devices));
-- 
1.7.1


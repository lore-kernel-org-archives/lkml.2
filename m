Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259Ab1D1PQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:16:42 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:48134 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760615Ab1D1PQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:16:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RyDCjDSS+Dgpk61qDISSUxNe4Qyd4CqpA9z5gsquqcSSo/y6sFHMDWGW0hDzOa3hZa
         hydxAxJOazpmXF8sY3ubhX9dt4hT2Y5hbvrTKuzUjMETW/vXzLkEFI2ZX76kRNENjkpO
         sXYfs9TSfbK29vNsTR3R92RSCWoZgk+olXGWc=
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: eric.y.miao@gmail.com, khali@linux-fr.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 3/3] ARM: mmp: add hardware lock support in PXA910
Date: Thu, 28 Apr 2011 23:15:46 +0800
Message-Id: <1304003746-12127-3-git-send-email-haojian.zhuang@gmail.com>
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
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-mmp/include/mach/pxa910.h |   13 +++++---
 arch/arm/mach-mmp/pxa910.c              |   23 +++++++++++++++-
 arch/arm/mach-mmp/ttc_dkb.c             |   45 +++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-mmp/include/mach/pxa910.h b/arch/arm/mach-mmp/include/mach/pxa910.h
index 91be755..2973466 100644
--- a/arch/arm/mach-mmp/include/mach/pxa910.h
+++ b/arch/arm/mach-mmp/include/mach/pxa910.h
@@ -1,16 +1,19 @@
 #ifndef __ASM_MACH_PXA910_H
 #define __ASM_MACH_PXA910_H
 
-struct sys_timer;
-
-extern struct sys_timer pxa910_timer;
-extern void __init pxa910_init_irq(void);
-
 #include <linux/i2c.h>
 #include <linux/i2c/pxa-i2c.h>
 #include <mach/devices.h>
 #include <plat/pxa3xx_nand.h>
 
+struct sys_timer;
+
+extern struct sys_timer pxa910_timer;
+extern void __init pxa910_init_irq(void);
+extern void pxa910_ripc_lock(struct i2c_adapter *);
+extern void pxa910_ripc_unlock(struct i2c_adapter *);
+extern int pxa910_ripc_trylock(struct i2c_adapter *);
+
 extern struct pxa_device_desc pxa910_device_uart1;
 extern struct pxa_device_desc pxa910_device_uart2;
 extern struct pxa_device_desc pxa910_device_twsi0;
diff --git a/arch/arm/mach-mmp/pxa910.c b/arch/arm/mach-mmp/pxa910.c
index 8f92ccd..4fbe485 100644
--- a/arch/arm/mach-mmp/pxa910.c
+++ b/arch/arm/mach-mmp/pxa910.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/io.h>
+#include <linux/i2c.h>
 
 #include <asm/mach/time.h>
 #include <mach/addr-map.h>
@@ -28,7 +29,10 @@
 #include "common.h"
 #include "clock.h"
 
-#define MFPR_VIRT_BASE	(APB_VIRT_BASE + 0x1e000)
+#define MFPR_VIRT_BASE		(APB_VIRT_BASE + 0x1e000)
+
+#define RIPC0_VIRT_BASE		(APB_VIRT_BASE + 0x3D000)
+#define RIPC0_STATUS		(RIPC0_VIRT_BASE + 0x00)
 
 static struct mfp_addr_map pxa910_mfp_addr_map[] __initdata =
 {
@@ -100,6 +104,23 @@ void __init pxa910_init_irq(void)
 	pxa910_init_gpio();
 }
 
+void pxa910_ripc_lock(struct i2c_adapter *adap)
+{
+	while (__raw_readl(RIPC0_STATUS))
+		cpu_relax();
+}
+
+/* return 1 -- succeed to get lock; 0 -- fail to get lock */
+int pxa910_ripc_trylock(struct i2c_adapter *adap)
+{
+	return (!__raw_readl(RIPC0_STATUS));
+}
+
+void pxa910_ripc_unlock(struct i2c_adapter *adap)
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


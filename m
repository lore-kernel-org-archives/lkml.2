Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1G1JvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:51:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54216 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab1G1JvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:51:15 -0400
From: Tommy Lin <tommy.lin.1101@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <avorontsov@mvista.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tommy Lin <tommy.lin.1101@gmail.com>
Subject: [PATCH 3/3] arch: arm: mach-cns3xxx: Add external interrupt pin demo program
Date: Fri, 29 Jul 2011 01:17:55 +0800
Message-Id: <1311873475-26111-1-git-send-email-tommy.lin.1101@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add external interrupt pin configuration demo program to CNS3XXX
platform. The external interrupt pins are dedicate input pins that
direct connect to ARM MPCore GIC module.

Signed-off-by: Tommy Lin <tommy.lin.1101@gmail.com>
---
 arch/arm/configs/cns3420vb_defconfig |    1 +
 arch/arm/mach-cns3xxx/Kconfig        |   11 ++
 arch/arm/mach-cns3xxx/Makefile       |    1 +
 arch/arm/mach-cns3xxx/ext_intr.c     |  194 ++++++++++++++++++++++++++++++++++
 4 files changed, 207 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-cns3xxx/ext_intr.c

diff --git a/arch/arm/configs/cns3420vb_defconfig b/arch/arm/configs/cns3420vb_defconfig
index c83d14c..6eefa7e 100644
--- a/arch/arm/configs/cns3420vb_defconfig
+++ b/arch/arm/configs/cns3420vb_defconfig
@@ -21,6 +21,7 @@ CONFIG_MODVERSIONS=y
 CONFIG_IOSCHED_CFQ=m
 CONFIG_ARCH_CNS3XXX=y
 CONFIG_MACH_CNS3420VB=y
+CONFIG_CNS3XXX_EXT_INTR_DEMO=m
 CONFIG_AEABI=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
diff --git a/arch/arm/mach-cns3xxx/Kconfig b/arch/arm/mach-cns3xxx/Kconfig
index 29b13f2..b4736e6 100644
--- a/arch/arm/mach-cns3xxx/Kconfig
+++ b/arch/arm/mach-cns3xxx/Kconfig
@@ -10,4 +10,15 @@ config MACH_CNS3420VB
 	  This is a platform with an on-board ARM11 MPCore and has support
 	  for USB, USB-OTG, MMC/SD/SDIO, SATA, PCI-E, etc.
 
+config CNS3XXX_EXT_INTR_DEMO
+        tristate "External interrupt demo program"
+        depends on MACH_CNS3420VB
+        help
+	  This program hook interrupt service routine to external interrupts
+	  0 ~ 3.
+	    Name	EVB		Trigger		ISR
+	    Ext_Int0			Rising edge
+	    Ext_Int1	Push button S3	Rising edge	Toggle LED D6
+	    Ext_Int2	Push button S4	High level	Toggle LED D7
+
 endmenu
diff --git a/arch/arm/mach-cns3xxx/Makefile b/arch/arm/mach-cns3xxx/Makefile
index 7bb9c88..a610c59 100644
--- a/arch/arm/mach-cns3xxx/Makefile
+++ b/arch/arm/mach-cns3xxx/Makefile
@@ -2,3 +2,4 @@ obj-y					+= gpio.o
 obj-$(CONFIG_ARCH_CNS3XXX)		+= core.o pm.o devices.o
 obj-$(CONFIG_PCI)			+= pcie.o
 obj-$(CONFIG_MACH_CNS3420VB)		+= cns3420vb.o
+obj-$(CONFIG_CNS3XXX_EXT_INTR_DEMO)	+= ext_intr.o
diff --git a/arch/arm/mach-cns3xxx/ext_intr.c b/arch/arm/mach-cns3xxx/ext_intr.c
new file mode 100644
index 0000000..5127860
--- /dev/null
+++ b/arch/arm/mach-cns3xxx/ext_intr.c
@@ -0,0 +1,194 @@
+/*******************************************************************************
+ *
+ *  arch/arm/mach-cns3xxx/ext_intr.c
+ *
+ *  External interrupt driver for the CNS3XXX SOCs
+ *
+ *  Copyright (c) 2011 Cavium
+ *		       Tommy Lin <tommy.lin@caviumnetworks.com>
+ *
+ *  This file is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License, Version 2, as
+ *  published by the Free Software Foundation.
+ *
+ *  This file is distributed in the hope that it will be useful,
+ *  but AS-IS and WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
+ *  NONINFRINGEMENT.  See the GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this file; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA or
+ *  visit http://www.gnu.org/licenses/.
+ *
+ *  This file may also be available under a different license from Cavium.
+ *  Contact Cavium for more information
+ *
+ ******************************************************************************/
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+
+#include <mach/gpio.h>
+#include <mach/cns3xxx.h>
+
+
+/*   CNS3XXX has three external interrupt pins, Ext_Intr0, Ext_Intr1 and
+ * Ext_Intr3. Each pin has its own interrupt ID which is not shared with other
+ * function. It is not like 32 gpio pins in group A or B shared one irq. The
+ * external interrupt pins are special functions that shared with GPIOB[27:29].
+ * Users could turn on shared pin function to enable external interrupt pin with
+ * cns3xxx_sharepin_request API.
+ *
+ *   The external interrupt trigger method is controlled by ARM MPCore GIC. GIC
+ * only suppot high active level trigger and rising edge trigger. Configure GIC
+ * with other trigger type will have no effect.
+ *
+ *   Name	irq	Shared gpio pin
+ *   Ext_Intr0	93	GPIOB[29]
+ *   Ext_Intr1	94	GPIOB[28]
+ *   Ext_Intr2	95	GPIOB[27]
+ */
+
+#define hw_debug(fmt, args...)		printk(KERN_ERR ">>>>>> %s\t"\
+						fmt, __func__, ##args)
+
+struct ext_intr_data {
+	int		irq;
+	unsigned	gpio;
+	char		*name;
+	char		*alias;
+};
+
+static unsigned led_D6 = GPIOA(6);
+static unsigned led_D7 = GPIOA(5);
+
+static struct ext_intr_data eintr_data[] = {
+	{IRQ_CNS3XXX_EXTERNAL_PIN0, GPIOB(29), "Ext_Intr0", "HIB_REQ"},
+	{IRQ_CNS3XXX_EXTERNAL_PIN1, GPIOB(28), "Ext_Intr1", "Push Button S3"},
+	{IRQ_CNS3XXX_EXTERNAL_PIN2, GPIOB(27), "Ext_Intr2", "Push Button S4"},
+};
+
+static irqreturn_t cns3xxx_ext_intr0_handler(int irq, void *dev_id)
+{
+	struct ext_intr_data *data = dev_id;
+
+	printk(KERN_WARNING "%s detected!\n", data->alias);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cns3xxx_ext_intr1_handler(int irq, void *dev_id)
+{
+	int value;
+
+	value = gpio_get_value(led_D6);
+
+	disable_irq_nosync(irq);
+
+	gpio_set_value(led_D6, !value);
+
+	enable_irq(irq);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cns3xxx_ext_intr2_handler(int irq, void *dev_id)
+{
+	int value;
+
+	value = gpio_get_value(led_D7);
+
+	disable_irq_nosync(irq);
+
+	gpio_set_value(led_D7, !value);
+
+	enable_irq(irq);
+
+	return IRQ_HANDLED;
+}
+
+int __init cns3xxx_eintr_init(void)
+{
+	int ret;
+
+	ret = gpio_request(led_D6, "INTR Test LED(D6)");
+	if (ret)
+		goto err1;
+	gpio_direction_output(led_D6, 0);
+
+	ret = gpio_request(led_D7, "INTR Test LED(D7)");
+	if (ret)
+		goto err2;
+	gpio_direction_output(led_D7, 0);
+
+	/************ Ext_Intr0 ************/
+	ret = cns3xxx_sharepin_request(eintr_data[0].gpio, eintr_data[0].alias);
+	if (ret)
+		goto err3;
+
+	ret = request_irq(eintr_data[0].irq, cns3xxx_ext_intr0_handler,
+			IRQF_SHARED | IRQF_TRIGGER_RISING,
+			eintr_data[0].name, &eintr_data[0]);
+	if (ret)
+		goto err4;
+
+	/************ Ext_Intr1 ************/
+	ret = cns3xxx_sharepin_request(eintr_data[1].gpio, eintr_data[1].alias);
+	if (ret)
+		goto err5;
+
+	ret = request_irq(eintr_data[1].irq, cns3xxx_ext_intr1_handler,
+			IRQF_SHARED | IRQF_TRIGGER_RISING,
+			eintr_data[1].name, &eintr_data[1]);
+	if (ret)
+		goto err6;
+
+	/************ Ext_Intr2 ************/
+	ret = cns3xxx_sharepin_request(eintr_data[2].gpio, eintr_data[2].alias);
+	if (ret)
+		goto err7;
+
+	ret = request_irq(eintr_data[2].irq, cns3xxx_ext_intr2_handler,
+			IRQF_SHARED | IRQF_TRIGGER_HIGH,
+			eintr_data[2].name, &eintr_data[2]);
+	if (ret)
+		goto err8;
+
+	return 0;
+
+err8:
+	cns3xxx_sharepin_free(eintr_data[2].gpio);
+err7:
+	free_irq(eintr_data[1].irq, &eintr_data[1]);
+err6:
+	cns3xxx_sharepin_free(eintr_data[1].gpio);
+err5:
+	free_irq(eintr_data[0].irq, &eintr_data[0]);
+err4:
+	cns3xxx_sharepin_free(eintr_data[0].gpio);
+err3:
+	gpio_free(led_D7);
+err2:
+	gpio_free(led_D6);
+err1:
+	return ret;
+}
+
+void __exit cns3xxx_eintr_exit(void)
+{
+	free_irq(eintr_data[2].irq, &eintr_data[2]);
+	free_irq(eintr_data[1].irq, &eintr_data[1]);
+	free_irq(eintr_data[0].irq, &eintr_data[0]);
+	cns3xxx_sharepin_free(eintr_data[2].gpio);
+	cns3xxx_sharepin_free(eintr_data[1].gpio);
+	cns3xxx_sharepin_free(eintr_data[0].gpio);
+	gpio_free(led_D7);
+	gpio_free(led_D6);
+}
+
+module_init(cns3xxx_eintr_init);
+module_exit(cns3xxx_eintr_exit);
+
+MODULE_LICENSE("GPL");
+
-- 
1.7.6


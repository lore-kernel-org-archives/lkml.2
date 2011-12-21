Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab1LUH2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:28:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41647 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1LUH2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:28:51 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <davinci-linux-open-source@linux.davincidsp.com>
CC: <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        Ajay Kumar Gupta <ajay.gupta@ti.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH v2] davinci: DA850 EVM: OHCI platform code
Date: Wed, 21 Dec 2011 12:50:02 +0530
Message-ID: <1324452002-8388-1-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ajay Kumar Gupta <ajay.gupta@ti.com>

On this board the OHCI port's power control and over-current signals from
TPS2065 power switch are connected via GPIO2[4] and GPIO6[13] respectively,
so we can implement the DA8xx OHCI glue layer's hooks for overriding the
root hub port's power and over-current status bits.

We also have to properly set up the clocking mode in the CFGCHIP2 register,
so that internal 24 MHz reference clock is fed to the USB 2.0 (MUSB) PHY and
its output is used to clock the USB 1.1 (OHCI) PHY...

Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
Since v1:
Fixed Sergei's review comments.

 arch/arm/mach-davinci/board-da850-evm.c |  125 +++++++++++++++++++++++++++++++
 1 files changed, 125 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 6659a90..c505992 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -22,6 +22,7 @@
 #include <linux/gpio.h>
 #include <linux/gpio_keys.h>
 #include <linux/platform_device.h>
+#include <linux/interrupt.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
@@ -42,6 +43,7 @@
 #include <mach/nand.h>
 #include <mach/mux.h>
 #include <mach/aemif.h>
+#include <mach/usb.h>
 #include <mach/spi.h>
 
 #define DA850_EVM_PHY_ID		"0:00"
@@ -734,6 +736,126 @@ static struct davinci_i2c_platform_data da850_evm_i2c_0_pdata = {
 	.bus_delay	= 0,	/* usec */
 };
 
+/*
+ * USB1 VBUS is controlled by GPIO2[4], over-current is reported on GPIO6[13].
+ */
+#define ON_BD_USB_DRV	GPIO_TO_PIN(2, 4)
+#define ON_BD_USB_OVC	GPIO_TO_PIN(6, 13)
+
+static const short da850_evm_usb11_pins[] = {
+	DA850_GPIO2_4, DA850_GPIO6_13,
+	-1
+};
+
+static da8xx_ocic_handler_t da850_evm_usb_ocic_handler;
+
+static int da850_evm_usb_set_power(unsigned port, int on)
+{
+	gpio_set_value(ON_BD_USB_DRV, on);
+	return 0;
+}
+
+static int da850_evm_usb_get_power(unsigned port)
+{
+	return gpio_get_value(ON_BD_USB_DRV);
+}
+
+static int da850_evm_usb_get_oci(unsigned port)
+{
+	return !gpio_get_value(ON_BD_USB_OVC);
+}
+
+static irqreturn_t da850_evm_usb_ocic_irq(int, void *);
+
+static int da850_evm_usb_ocic_notify(da8xx_ocic_handler_t handler)
+{
+	int irq		= gpio_to_irq(ON_BD_USB_OVC);
+	int error	= 0;
+
+	if (handler != NULL) {
+		da850_evm_usb_ocic_handler = handler;
+
+		error = request_irq(irq, da850_evm_usb_ocic_irq,
+				    IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				    "OHCI over-current indicator", NULL);
+		if (error)
+			printk(KERN_ERR "%s: could not request IRQ to watch "
+			       "over-current indicator changes\n", __func__);
+	} else
+		free_irq(irq, NULL);
+
+	return error;
+}
+
+static struct da8xx_ohci_root_hub da850_evm_usb11_pdata = {
+	.set_power	= da850_evm_usb_set_power,
+	.get_power	= da850_evm_usb_get_power,
+	.get_oci	= da850_evm_usb_get_oci,
+	.ocic_notify	= da850_evm_usb_ocic_notify,
+
+	/* TPS2065 switch @ 5V */
+	.potpgt		= (3 + 1) / 2,	/* 3 ms max */
+};
+
+static irqreturn_t da850_evm_usb_ocic_irq(int irq, void *dev_id)
+{
+	da850_evm_usb_ocic_handler(&da850_evm_usb11_pdata, 1);
+	return IRQ_HANDLED;
+}
+
+static __init void da850_evm_usb_init(void)
+{
+	u32 cfgchip2;
+	int ret;
+
+	/*
+	 * Set up USB clock/mode in the CFGCHIP2 register.
+	 * FYI:  CFGCHIP2 is 0x0000ef00 initially.
+	 */
+	cfgchip2 = __raw_readl(DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP2_REG));
+
+	/* USB2.0 PHY reference clock is 24 MHz */
+	cfgchip2 &= ~CFGCHIP2_REFFREQ;
+	cfgchip2 |=  CFGCHIP2_REFFREQ_24MHZ;
+
+	/*
+	 * Select internal reference clock for USB 2.0 PHY
+	 * and use it as a clock source for USB 1.1 PHY
+	 * (this is the default setting anyway).
+	 */
+	cfgchip2 &= ~CFGCHIP2_USB1PHYCLKMUX;
+	cfgchip2 |=  CFGCHIP2_USB2PHYCLKMUX;
+
+	__raw_writel(cfgchip2, DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP2_REG));
+
+	ret = davinci_cfg_reg_list(da850_evm_usb11_pins);
+	if (ret) {
+		pr_warning("%s: USB 1.1 PinMux setup failed: %d\n",
+			   __func__, ret);
+		return;
+	}
+
+	ret = gpio_request_one(ON_BD_USB_DRV, GPIOF_OUT_INIT_LOW,
+			"ON_BD_USB_DRV");
+	if (ret) {
+		pr_err("%s: failed to request GPIO for USB 1.1 port "
+		       "power control: %d\n", __func__, ret);
+		return;
+	}
+
+	ret = gpio_request_one(ON_BD_USB_OVC, GPIOF_IN, "ON_BD_USB_OVC");
+	if (ret) {
+		pr_err("%s: failed to request GPIO for USB 1.1 port "
+		       "over-current indicator: %d\n", __func__, ret);
+		return;
+	}
+
+	ret = da8xx_register_usb11(&da850_evm_usb11_pdata);
+	if (ret)
+		pr_warning("%s: USB 1.1 registration failed: %d\n",
+			   __func__, ret);
+}
+
 static struct davinci_uart_config da850_evm_uart_config __initdata = {
 	.enabled_uarts = 0x7,
 };
@@ -1386,6 +1508,9 @@ static __init void da850_evm_init(void)
 				ret);
 
 	da850_evm_setup_mac_addr();
+
+	/* initilaize usb module */
+	da850_evm_usb_init();
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
-- 
1.7.1


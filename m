Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1FXSvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 14:51:39 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:59860 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754013Ab1FXSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 14:51:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=makelinux.com;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type:X-Identified-User;
	b=t3/d3ylFp314U9H5M5M3SIkpzjH7Lyyko/KdJSLiJkeUrp2DuxBYyAxgkLw4yMAiccTn+NsJ9PwTSAykXl4enH3SYnuYZCKg2SxQmjx1rTIWc7sU/bw/uud4ewPSeSBF;
MIME-Version: 1.0
Date: Fri, 24 Jun 2011 21:51:31 +0300
Message-ID: <BANLkTims=UsUMkDQ8uB+J6YTVRSBD__otw@mail.gmail.com>
Subject: [PATCH] Enable USB on TI DM365
From: Constantine Shulyupin <const@makelinux.com>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Cc: nsekhar@ti.com, khilman@ti.com
Content-Type: text/plain; charset=ISO-8859-1
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.com} {sentby:smtp auth 209.85.216.181 authed with const@makelinux.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable USB on TI DM365

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 arch/arm/mach-davinci/Makefile           |    3 +-
 arch/arm/mach-davinci/include/mach/usb.h |    2 +-
 arch/arm/mach-davinci/usb.c              |   32 ++++++++++++++++++++++++++---
 drivers/usb/musb/davinci.c               |   13 ++++++++++++
 drivers/usb/musb/davinci.h               |    1 +
 5 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 0b87a1c..52961a8 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -5,7 +5,7 @@

 # Common objects
 obj-y 			:= time.o clock.o serial.o io.o psc.o \
-			   gpio.o dma.o usb.o common.o sram.o aemif.o
+			   gpio.o dma.o common.o sram.o aemif.o

 obj-$(CONFIG_DAVINCI_MUX)		+= mux.o

@@ -40,3 +40,4 @@ obj-$(CONFIG_MACH_OMAPL138_HAWKBOARD)	+= board-omapl138-hawk.o
 obj-$(CONFIG_CPU_FREQ)			+= cpufreq.o
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
 obj-$(CONFIG_SUSPEND)			+= pm.o sleep.o
+obj-$(CONFIG_USB_MUSB_DAVINCI)		+= usb.o
diff --git a/arch/arm/mach-davinci/include/mach/usb.h
b/arch/arm/mach-davinci/include/mach/usb.h
index e0bc4ab..863c27f 100644
--- a/arch/arm/mach-davinci/include/mach/usb.h
+++ b/arch/arm/mach-davinci/include/mach/usb.h
@@ -54,6 +54,6 @@ struct	da8xx_ohci_root_hub {
 	u8	potpgt;
 };

-void davinci_setup_usb(unsigned mA, unsigned potpgt_ms);
+int davinci_setup_usb(unsigned mA, unsigned potpgt_ms);

 #endif	/* ifndef __ASM_ARCH_USB_H */
diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
index 23d2b6d..8b12206 100644
--- a/arch/arm/mach-davinci/usb.c
+++ b/arch/arm/mach-davinci/usb.c
@@ -4,19 +4,22 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-
 #include <linux/usb/musb.h>

 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/cputype.h>
 #include <mach/usb.h>
+#include <mach/mux.h>
+#include <linux/gpio.h>

 #define DAVINCI_USB_OTG_BASE	0x01c64000

 #define DA8XX_USB0_BASE 	0x01e00000
 #define DA8XX_USB1_BASE 	0x01e25000

+static int retval;
+
 #if defined(CONFIG_USB_MUSB_HDRC) || defined(CONFIG_USB_MUSB_HDRC_MODULE)
 static struct musb_hdrc_eps_bits musb_eps[] = {
 	{ "ep1_tx", 8, },
@@ -87,7 +90,7 @@ static struct platform_device usb_dev = {
 	.num_resources  = ARRAY_SIZE(usb_resources),
 };

-void __init davinci_setup_usb(unsigned mA, unsigned potpgt_ms)
+int __init davinci_setup_usb(unsigned mA, unsigned potpgt_ms)
 {
 	usb_data.power = mA > 510 ? 255 : mA / 2;
 	usb_data.potpgt = (potpgt_ms + 1) / 2;
@@ -99,7 +102,8 @@ void __init davinci_setup_usb(unsigned mA, unsigned
potpgt_ms)
 	} else	/* other devices don't have dedicated CPPI IRQ */
 		usb_dev.num_resources = 2;

-	platform_device_register(&usb_dev);
+	retval = platform_device_register(&usb_dev);
+	return retval;
 }

 #ifdef CONFIG_ARCH_DAVINCI_DA8XX
@@ -132,7 +136,7 @@ int __init da8xx_register_usb20(unsigned mA,
unsigned potpgt)

 #else

-void __init davinci_setup_usb(unsigned mA, unsigned potpgt_ms)
+int __init davinci_setup_usb(unsigned mA, unsigned potpgt_ms)
 {
 }

@@ -178,3 +182,23 @@ int __init da8xx_register_usb11(struct
da8xx_ohci_root_hub *pdata)
 	return platform_device_register(&da8xx_usb11_device);
 }
 #endif	/* CONFIG_DAVINCI_DA8XX */
+
+#ifdef CONFIG_MACH_DAVINCI_DM365_EVM
+int __init dm365evm_usb_configure(void)
+{
+	davinci_cfg_reg(DM365_GPIO33);
+	gpio_request(33, "usb");
+	gpio_direction_output(33, 1);
+	retval = davinci_setup_usb(500, 8);
+	return retval;
+}
+subsys_initcall(dm365evm_usb_configure);
+
+static void __exit dm365evm_usb_exit(void)
+{
+	platform_device_unregister(&usb_dev);
+}
+module_exit(dm365evm_usb_exit);
+
+#endif
+MODULE_LICENSE("GPL");
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index 2a2adf6..0147f5c 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -72,6 +72,16 @@ static inline void phy_on(void)
 	/* power everything up; start the on-chip PHY and its PLL */
 	phy_ctrl &= ~(USBPHY_OSCPDWN | USBPHY_OTGPDWN | USBPHY_PHYPDWN);
 	phy_ctrl |= USBPHY_SESNDEN | USBPHY_VBDTCTEN | USBPHY_PHYPLLON;
+
+	if (cpu_is_davinci_dm365()) {
+		/*
+		 * DM365 PHYCLKFREQ field [15:12] is set to 2
+		 * to get clock from 24MHz crystal
+		 */
+		phy_ctrl |= USBPHY_CLKFREQ_24MHZ;
+		/*phy_ctrl &= ~USBPHY_PHYPDWN;*/
+	}
+
 	__raw_writel(phy_ctrl, USB_PHY_CTRL);

 	/* wait for PLL to lock before proceeding */
@@ -193,6 +203,9 @@ static void davinci_musb_source_power(struct musb
*musb, int is_on, int immediat
 		else
 			schedule_work(&evm_vbus_work);
 	}
+
+	if (cpu_is_davinci_dm365())
+		gpio_set_value(33, is_on);
 	if (immediate)
 		vbus_state = is_on;
 #endif
diff --git a/drivers/usb/musb/davinci.h b/drivers/usb/musb/davinci.h
index 046c844..1bf50e6 100644
--- a/drivers/usb/musb/davinci.h
+++ b/drivers/usb/musb/davinci.h
@@ -17,6 +17,7 @@
 /* Integrated highspeed/otg PHY */
 #define USBPHY_CTL_PADDR	(DAVINCI_SYSTEM_MODULE_BASE + 0x34)
 #define USBPHY_DATAPOL		BIT(11)	/* (dm355) switch D+/D- */
+#define USBPHY_CLKFREQ_24MHZ    BIT(13)
 #define USBPHY_PHYCLKGD		BIT(8)
 #define USBPHY_SESNDEN		BIT(7)	/* v(sess_end) comparator */
 #define USBPHY_VBDTCTEN		BIT(6)	/* v(bus) comparator */
-- 
1.7.0.4


-- 
Constantine Shulyupin
http://www.MakeLinux.com/
Embedded Linux Systems,
Device Drivers, TI DaVinci

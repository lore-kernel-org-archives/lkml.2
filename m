Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0KBAPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:15:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57277 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0KBAPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:15:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Yqwj+rEreov6R4ifuaWfSVaUtiUIGBw53e+Ohn5jfowUbHSXlMlLWq2hwkO6jr3ZES
         DcENMtxQr5dp+ZJq1Tj2z6OjuYcz5Uq8XP6us1INuF9cpZmI7gCFY26Hq3Sj31KeLKT2
         CoJ2siJ/0todfk2LFjlQeDikyoSvPavHQXd70=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb <linux-usb@vger.kernel.org>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mike Rapoport <mike@compulab.co.il>, linux-usb@vger.kernel.org
Subject: [PATCH v3 2/2] drivers: cleanup Kconfig stuff
Date: Tue,  2 Nov 2010 02:14:13 +0200
Message-Id: <1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.2.2.g0dc5c
In-Reply-To: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing dependencies, and remove redundant ones, and select sensible
defaults.

This is more user-friendly, and logical.

 - TWL4030_CORE people should be able to compile without ARM
 - REGULATOR_TWL4030 if TWL4030_CORE and REGULATOR, it's pretty clear we
   want this
 - USB_GADGET_SELECTED is already inside USB_GADGET
 - USB_GADGET_OMAP only works on ARCH_OMAP1, and USB_OTG_UTILS is
   already selected by NOP_USB_XCEIV
 - USB_GADGET_R8A66597 is meant for ARCH_SHMOBILE
 - USB_MUSB_HDRC needs either NOP_USB_XCEIV, or TWL4030_USB
 - USB_MUSB_AM35X, NOP_USB_XCEIV is already selected because MACH_OMAP3EVM

Finally, move:
config USB_MUSB_HDRC
	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
	select TWL4030_USB if MACH_OMAP_3430SDP

To:
config TWL4030_USB
	default y if ARCH_OMAP3

config NOP_USB_XCEIV
	default y if ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/mfd/Kconfig        |    2 +-
 drivers/regulator/Kconfig  |    1 +
 drivers/usb/gadget/Kconfig |    5 ++---
 drivers/usb/musb/Kconfig   |    7 ++-----
 drivers/usb/otg/Kconfig    |    2 ++
 5 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3a1493b..88e47a0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -169,7 +169,7 @@ config TWL4030_CORE
 
 config TWL4030_POWER
 	bool "Support power resources on TWL4030 family chips"
-	depends on TWL4030_CORE && ARM
+	depends on TWL4030_CORE
 	help
 	  Say yes here if you want to use the power resources on the
 	  TWL4030 family chips.  Most of these resources are regulators,
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index dd30e88..1397f7a 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -119,6 +119,7 @@ config REGULATOR_MAX8998
 config REGULATOR_TWL4030
 	bool "TI TWL4030/TWL5030/TWL6030/TPS695x0 PMIC"
 	depends on TWL4030_CORE
+	default y
 	help
 	  This driver supports the voltage regulators provided by
 	  this family of companion chips.
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 75733cd..0ad0c32 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -111,7 +111,6 @@ config	USB_GADGET_SELECTED
 #
 choice
 	prompt "USB Peripheral Controller"
-	depends on USB_GADGET
 	help
 	   A USB device uses a controller to talk to its host.
 	   Systems should have only one such upstream link.
@@ -190,9 +189,8 @@ config USB_LH7A40X
 
 config USB_GADGET_OMAP
 	boolean "OMAP USB Device Controller"
-	depends on ARCH_OMAP
+	depends on ARCH_OMAP1
 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
-	select USB_OTG_UTILS if ARCH_OMAP
 	help
 	   Many Texas Instruments OMAP processors have flexible full
 	   speed USB device controllers, with support for up to 30
@@ -244,6 +242,7 @@ config USB_PXA25X_SMALL
 
 config USB_GADGET_R8A66597
 	boolean "Renesas R8A66597 USB Peripheral Controller"
+	depends on ARCH_SHMOBILE
 	select USB_GADGET_DUALSPEED
 	help
 	   R8A66597 is a discrete USB host and peripheral controller chip that
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index f0e0495..5951b9f 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -11,8 +11,7 @@ config USB_MUSB_HDRC
 	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
 	depends on (USB || USB_GADGET)
 	depends on (ARM || (BF54x && !BF544) || (BF52x && !BF522 && !BF523))
-	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
-	select TWL4030_USB if MACH_OMAP_3430SDP
+	depends on (NOP_USB_XCEIV || TWL4030_USB)
 	select USB_OTG_UTILS
 	help
 	  Say Y here if your system has a dual role high speed USB
@@ -63,7 +62,6 @@ comment "Blackfin high speed USB Support"
 config USB_MUSB_AM35X
 	bool
 	depends on USB_MUSB_HDRC && !ARCH_OMAP2430 && !ARCH_OMAP4
-	select NOP_USB_XCEIV
 	default MACH_OMAP3517EVM
 	help
 	  Select this option if your platform is based on AM35x. As
@@ -73,8 +71,7 @@ config USB_MUSB_AM35X
 
 config USB_TUSB6010
 	boolean "TUSB 6010 support"
-	depends on USB_MUSB_HDRC && !USB_MUSB_SOC
-	select NOP_USB_XCEIV
+	depends on USB_MUSB_HDRC && !USB_MUSB_SOC && NOP_USB_XCEIV
 	default y
 	help
 	  The TUSB 6010 chip, from Texas Instruments, connects a discrete
diff --git a/drivers/usb/otg/Kconfig b/drivers/usb/otg/Kconfig
index 5ce0752..728b476 100644
--- a/drivers/usb/otg/Kconfig
+++ b/drivers/usb/otg/Kconfig
@@ -53,6 +53,7 @@ config TWL4030_USB
 	tristate "TWL4030 USB Transceiver Driver"
 	depends on TWL4030_CORE && REGULATOR_TWL4030
 	select USB_OTG_UTILS
+	default y if ARCH_OMAP3
 	help
 	  Enable this to support the USB OTG transceiver on TWL4030
 	  family chips (including the TWL5030 and TPS659x0 devices).
@@ -62,6 +63,7 @@ config TWL4030_USB
 config NOP_USB_XCEIV
 	tristate "NOP USB Transceiver Driver"
 	select USB_OTG_UTILS
+	default y if ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN
 	help
 	 this driver is to be used by all the usb transceiver which are either
 	 built-in with usb ip or which are autonomous and doesn't require any
-- 
1.7.3.2.2.g0dc5c


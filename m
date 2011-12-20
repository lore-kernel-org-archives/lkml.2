Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1LTBPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:15:55 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36781 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847Ab1LTBPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:15:40 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM 
	,commit_signer:4/5=80%),
        Pavankumar Kondeti <pkondeti@codeaurora.org> (commit_signer:2/5=40%),
        Benoit Goby <benoit@android.com> (commit_signer:1/5=20%),
        Li Yang <leoli@freescale.com> (commit_signer:1/5=20%),
        linux-usb@vger.kernel.org (open list:MUSB MULTIPOINT H...)
Subject: [PATCH v4 4/4] usb: simplify hdrc configuration
Date: Tue, 20 Dec 2011 03:15:17 +0200
Message-Id: <1324343717-7292-5-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
References: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HDRC requires either NOP_USB_XCEIV or TWLX030_USB, and it selects the
right one based on architectures or board.

However, many OMAP2+ boards are excluded from this selection and it's
possible to have a configuration with no transceiver, so HDRC doesn't
work.

What we need is a 'soft' dependency, and this can be achieved by
transforming the 'selects' to 'default'. This way we can have sane
defaults for all OMAP2+ boards, and the ones that need NOP can just
specify that manually.

This simplifies the config from:

     CONFIG_USB=y
     CONFIG_TWL4030_CORE=y
     CONFIG_TWL4030_USB=y

To:

     CONFIG_USB=y
     CONFIG_TWL4030_CORE=y

And so on.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/musb/Kconfig |    4 +---
 drivers/usb/otg/Kconfig  |    3 +++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 07a0346..b60d3a5 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -7,9 +7,7 @@
 config USB_MUSB_HDRC
 	depends on USB && USB_GADGET
 	depends on (ARM || (BF54x && !BF544) || (BF52x && !BF522 && !BF523))
-	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
-	select TWL4030_USB if MACH_OMAP_3430SDP
-	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
+	depends on (NOP_USB_XCEIV || TWL4030_USB || TWL6030_USB)
 	select USB_OTG_UTILS
 	select USB_GADGET_DUALSPEED
 	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
diff --git a/drivers/usb/otg/Kconfig b/drivers/usb/otg/Kconfig
index c66481a..5beb8b7 100644
--- a/drivers/usb/otg/Kconfig
+++ b/drivers/usb/otg/Kconfig
@@ -60,6 +60,7 @@ config TWL4030_USB
 	tristate "TWL4030 USB Transceiver Driver"
 	depends on TWL4030_CORE && REGULATOR_TWL4030
 	select USB_OTG_UTILS
+	default y if ARCH_OMAP3
 	help
 	  Enable this to support the USB OTG transceiver on TWL4030
 	  family chips (including the TWL5030 and TPS659x0 devices).
@@ -70,6 +71,7 @@ config TWL6030_USB
 	tristate "TWL6030 USB Transceiver Driver"
 	depends on TWL4030_CORE
 	select USB_OTG_UTILS
+	default y if ARCH_OMAP4
 	help
 	  Enable this to support the USB OTG transceiver on TWL6030
 	  family chips. This TWL6030 transceiver has the VBUS and ID GND
@@ -81,6 +83,7 @@ config TWL6030_USB
 config NOP_USB_XCEIV
 	tristate "NOP USB Transceiver Driver"
 	select USB_OTG_UTILS
+	default y if ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN
 	help
 	 this driver is to be used by all the usb transceiver which are either
 	 built-in with usb ip or which are autonomous and doesn't require any
-- 
1.7.8.rc1.14.g248db


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab2HFEVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:21:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62117 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2HFEVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:21:41 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 05 Aug 2012 23:21:41 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: dri-devel@lists.freedesktop.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] gpu/mfd/usb: Fix USB randconfig problems
Date: Sun,  5 Aug 2012 21:21:34 -0700
Message-Id: <1344226894-22402-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix config warning:

warning: ( ... && DRM_USB) selects USB which has unmet direct dependencies
(USB_SUPPORT && USB_ARCH_HAS_HCD)

by adding the missing dependency on USB_ARCH_HAS_HCD to DRM_UDL and DRM_USB.

This exposes:
drivers/video/Kconfig:36:error: recursive dependency detected!
drivers/video/Kconfig:36:       symbol FB is selected by DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:28:     symbol DRM_KMS_HELPER is selected by DRM_UDL
drivers/gpu/drm/udl/Kconfig:1:  symbol DRM_UDL depends on USB_ARCH_HAS_HCD
drivers/usb/Kconfig:78: symbol USB_ARCH_HAS_HCD depends on USB_ARCH_HAS_OHCI
drivers/usb/Kconfig:16: symbol USB_ARCH_HAS_OHCI depends on I2C
drivers/i2c/Kconfig:5:  symbol I2C is selected by FB_DDC
drivers/video/Kconfig:86:       symbol FB_DDC is selected by FB_CYBER2000_DDC
drivers/video/Kconfig:385:      symbol FB_CYBER2000_DDC depends on FB_CYBER2000
drivers/video/Kconfig:373:      symbol FB_CYBER2000 depends on FB

which is due to drivers/usb/Kconfig:
config USB_ARCH_HAS_OHCI
	...
	default y if ARCH_PNX4008 && I2C

Fix by dropping I2C from the above dependency; logic is that this is not a
platform dependency but a configuration dependency: the _architecture_ still
supports USB even is I2C is not selected.

This exposes:
drivers/video/Kconfig:36:error: recursive dependency detected!
drivers/video/Kconfig:36:       symbol FB is selected by DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:28:     symbol DRM_KMS_HELPER is selected by DRM_UDL
drivers/gpu/drm/udl/Kconfig:1:  symbol DRM_UDL depends on USB_ARCH_HAS_HCD
drivers/usb/Kconfig:78: symbol USB_ARCH_HAS_HCD depends on USB_ARCH_HAS_OHCI
drivers/usb/Kconfig:17: symbol USB_ARCH_HAS_OHCI depends on MFD_TC6393XB
drivers/mfd/Kconfig:396:        symbol MFD_TC6393XB depends on GPIOLIB
drivers/gpio/Kconfig:35:        symbol GPIOLIB is selected by FB_VIA
drivers/video/Kconfig:1560:     symbol FB_VIA depends on FB

which can be fixed by having MFD_TC6393XB select GPIOLIB instead of depending on
it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
If anyone has a better idea how to fix this set of problems, please let me know.
Also, I'll be happy to split the patch into three parts if that helps to get it
integrated.

 drivers/gpu/drm/Kconfig     |    1 +
 drivers/gpu/drm/udl/Kconfig |    1 +
 drivers/mfd/Kconfig         |    3 ++-
 drivers/usb/Kconfig         |    2 +-
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 23120c0..90e2808 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -22,6 +22,7 @@ menuconfig DRM
 config DRM_USB
 	tristate
 	depends on DRM
+	depends on USB_ARCH_HAS_HCD
 	select USB
 
 config DRM_KMS_HELPER
diff --git a/drivers/gpu/drm/udl/Kconfig b/drivers/gpu/drm/udl/Kconfig
index 0b5e096..56e0bf3 100644
--- a/drivers/gpu/drm/udl/Kconfig
+++ b/drivers/gpu/drm/udl/Kconfig
@@ -1,6 +1,7 @@
 config DRM_UDL
 	tristate "DisplayLink"
 	depends on DRM && EXPERIMENTAL
+	depends on USB_ARCH_HAS_HCD
 	select DRM_USB
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d1facef..b1a1462 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -395,7 +395,8 @@ config MFD_TC6387XB
 
 config MFD_TC6393XB
 	bool "Support Toshiba TC6393XB"
-	depends on GPIOLIB && ARM && HAVE_CLK
+	depends on ARM && HAVE_CLK
+	select GPIOLIB
 	select MFD_CORE
 	select MFD_TMIO
 	help
diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index a7773a3..7065df6 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -13,7 +13,7 @@ config USB_ARCH_HAS_OHCI
 	default y if PXA3xx
 	default y if ARCH_EP93XX
 	default y if ARCH_AT91
-	default y if ARCH_PNX4008 && I2C
+	default y if ARCH_PNX4008
 	default y if MFD_TC6393XB
 	default y if ARCH_W90X900
 	default y if ARCH_DAVINCI_DA8XX
-- 
1.7.9.7


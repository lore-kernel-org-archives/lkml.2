Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1JBOrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:47:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1JBOqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 02/30] video/omap: fix dependencies
Date: Sun,  2 Oct 2011 16:45:32 +0200
Message-Id: <1317566760-25681-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:FvC56UotX34e60d22jjSemb4y8jX77zW+wYWxbkj6sa
 ngRE6LW1ABpWMKczih4Vku5cb4eyvLMpQWypjl5q7AvLlooETb
 pMzAqTqwNS3VoDOgNWH/zZivQ2EJZORRUWqkxXdoqEtt6DpsE2
 ei4q6rizF/rPiyrRghNBCd9OjQUdcY+aQDU+q7ZQaN2WaMxVP0
 6o0pOo8lLHqSZ/dlp3OBDQEQCJMKR3N3Jpr6Ct5qLHRVpExmD7
 oTiNdVqLlpjaWETuGciZbHzuK7hjtFls5xTCpiP3MbfmsQNPnC
 wu40KyuDqCx/3hnI1QO/Yz3GXju8gPvdDcJ5tWJbmN7oGxEojJ
 khLCAtn3ObMIGBf9cpmQtJZcwWvxylwMTcJaVppu8z1K1VCnPH
 AybUia0b7m47w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lcd_2430sdp and lcd_ldp drivers depend on TWL4030, which is not
well expressed in the Kconfig. Create new configuration options for
these in order to describe the dependencies correctly.

In some cases, the driver cannot be a loadable module, so better
force it to be built-in.

While we're at it, simplify the Makefile syntax.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/video/omap/Kconfig  |   41 +++++++++++++++++++++++++---
 drivers/video/omap/Makefile |   64 ++++++++++++++++++++-----------------------
 2 files changed, 67 insertions(+), 38 deletions(-)

diff --git a/drivers/video/omap/Kconfig b/drivers/video/omap/Kconfig
index 196fa2e..bd15431 100644
--- a/drivers/video/omap/Kconfig
+++ b/drivers/video/omap/Kconfig
@@ -1,11 +1,11 @@
 config FB_OMAP
-	tristate "OMAP frame buffer support (EXPERIMENTAL)"
-	depends on FB && (OMAP2_DSS = "n")
+	bool "OMAP frame buffer support (EXPERIMENTAL)"
+	# cannot be a module if more than one LCD driver is linked in
+	depends on (FB = "y") && (OMAP2_DSS = "n")
 	depends on ARCH_OMAP1 || ARCH_OMAP2 || ARCH_OMAP3
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select TWL4030_CORE if MACH_OMAP_2430SDP
 	help
           Frame buffer driver for OMAP based boards.
 
@@ -105,4 +105,37 @@ config FB_OMAP_DMA_TUNE
           answer yes. Answer no if you have a dedicated video
           memory, or don't use any of the accelerated features.
 
-
+config FB_OMAP_SOSSI
+	def_bool y
+	depends on ARCH_OMAP1
+	depends on FB_OMAP_LCDC_EXTERNAL
+
+config FB_OMAP_RFBI
+	def_bool y
+	depends on ARCH_OMAP2 || ARCH_OMAP3
+	depends on FB_OMAP_LCDC_EXTERNAL
+
+config FB_OMAP_INN1610
+	def_bool y
+	depends on ARCH_OMAP16XX
+	depends on MACH_OMAP_INNOVATOR
+
+config FB_OMAP_INN1510
+	def_bool y
+	depends on ARCH_OMAP15XX
+	depends on MACH_OMAP_INNOVATOR
+
+config FB_OMAP_OMAP3EVM
+	def_bool y
+	depends on MACH_OMAP3EVM
+	depends on TWL4030_CORE
+
+config FB_OMAP_X430SDP
+	def_bool y
+	depends on MACH_OMAP_2430SDP || MACH_OMAP_3430SDP
+	depends on TWL4030_CORE
+
+config FB_OMAP_LDP
+	def_bool y
+	depends on MACH_OMAP_LDP
+	depends on TWL4030_CORE
diff --git a/drivers/video/omap/Makefile b/drivers/video/omap/Makefile
index 25db556..8c2cd56 100644
--- a/drivers/video/omap/Makefile
+++ b/drivers/video/omap/Makefile
@@ -4,37 +4,33 @@
 
 obj-$(CONFIG_FB_OMAP) += omapfb.o
 
-objs-yy := omapfb_main.o
-
-objs-y$(CONFIG_ARCH_OMAP1) += lcdc.o
-objs-y$(CONFIG_ARCH_OMAP2) += dispc.o
-objs-y$(CONFIG_ARCH_OMAP3) += dispc.o
-
-objs-$(CONFIG_ARCH_OMAP1)$(CONFIG_FB_OMAP_LCDC_EXTERNAL) += sossi.o
-objs-$(CONFIG_ARCH_OMAP2)$(CONFIG_FB_OMAP_LCDC_EXTERNAL) += rfbi.o
-
-objs-y$(CONFIG_FB_OMAP_LCDC_HWA742) += hwa742.o
-objs-y$(CONFIG_FB_OMAP_LCDC_BLIZZARD) += blizzard.o
-
-objs-y$(CONFIG_MACH_AMS_DELTA) += lcd_ams_delta.o
-objs-y$(CONFIG_MACH_OMAP_H4) += lcd_h4.o
-objs-y$(CONFIG_MACH_OMAP_H3) += lcd_h3.o
-objs-y$(CONFIG_MACH_OMAP_PALMTE) += lcd_palmte.o
-objs-y$(CONFIG_MACH_OMAP_PALMTT) += lcd_palmtt.o
-objs-y$(CONFIG_MACH_OMAP_PALMZ71) += lcd_palmz71.o
-objs-$(CONFIG_ARCH_OMAP16XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1610.o
-objs-$(CONFIG_ARCH_OMAP15XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1510.o
-objs-y$(CONFIG_MACH_OMAP_OSK) += lcd_osk.o
-
-objs-y$(CONFIG_MACH_OMAP_APOLLON) += lcd_apollon.o
-objs-y$(CONFIG_MACH_OMAP_2430SDP) += lcd_2430sdp.o
-objs-y$(CONFIG_MACH_OMAP_3430SDP) += lcd_2430sdp.o
-objs-y$(CONFIG_MACH_OMAP_LDP) += lcd_ldp.o
-objs-y$(CONFIG_MACH_OMAP3EVM) += lcd_omap3evm.o
-objs-y$(CONFIG_MACH_OMAP3_BEAGLE) += lcd_omap3beagle.o
-objs-y$(CONFIG_FB_OMAP_LCD_MIPID) += lcd_mipid.o
-objs-y$(CONFIG_MACH_OVERO) += lcd_overo.o
-objs-y$(CONFIG_MACH_HERALD) += lcd_htcherald.o
-
-omapfb-objs := $(objs-yy)
-
+omapfb-y				+= omapfb_main.o
+
+omapfb-$(CONFIG_ARCH_OMAP1)		+= lcdc.o
+omapfb-$(CONFIG_ARCH_OMAP2)		+= dispc.o
+omapfb-$(CONFIG_ARCH_OMAP3)		+= dispc.o
+
+omapfb-$(CONFIG_FB_OMAP_SOSSI)		+= sossi.o
+omapfb-$(CONFIG_FB_OMAP_RFBI)		+= rfbi.o
+
+omapfb-$(CONFIG_FB_OMAP_LCDC_HWA742)	+= hwa742.o
+omapfb-$(CONFIG_FB_OMAP_LCDC_BLIZZARD)	+= blizzard.o
+
+omapfb-$(CONFIG_MACH_AMS_DELTA)		+= lcd_ams_delta.o
+omapfb-$(CONFIG_MACH_OMAP_H4)		+= lcd_h4.o
+omapfb-$(CONFIG_MACH_OMAP_H3)		+= lcd_h3.o
+omapfb-$(CONFIG_MACH_OMAP_PALMTE)	+= lcd_palmte.o
+omapfb-$(CONFIG_MACH_OMAP_PALMTT)	+= lcd_palmtt.o
+omapfb-$(CONFIG_MACH_OMAP_PALMZ71)	+= lcd_palmz71.o
+omapfb-$(CONFIG_FB_OMAP_INN1610)	+= lcd_inn1610.o
+omapfb-$(CONFIG_FB_OMAP_INN1510)	+= lcd_inn1510.o
+omapfb-$(CONFIG_MACH_OMAP_OSK)		+= lcd_osk.o
+
+omapfb-$(CONFIG_MACH_OMAP_APOLLON)	+= lcd_apollon.o
+omapfb-$(CONFIG_FB_OMAP_X430SDP)	+= lcd_2430sdp.o
+omapfb-$(CONFIG_FB_OMAP_LDP)		+= lcd_ldp.o
+omapfb-$(CONFIG_FB_OMAP_OMAP3EVM)	+= lcd_omap3evm.o
+omapfb-$(CONFIG_MACH_OMAP3_BEAGLE)	+= lcd_omap3beagle.o
+omapfb-$(CONFIG_FB_OMAP_LCD_MIPID)	+= lcd_mipid.o
+omapfb-$(CONFIG_MACH_OVERO)		+= lcd_overo.o
+omapfb-$(CONFIG_MACH_HERALD)		+= lcd_htcherald.o
-- 
1.7.5.4


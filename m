Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3AGSvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:51:43 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:58389 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104Ab3AGSvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:51:40 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 5/5] capemgr: Weather cape cape definition
Date: Mon,  7 Jan 2013 20:51:06 +0200
Message-Id: <1357584666-17374-6-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the weather cape to the supported capes.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 arch/arm/boot/dts/am335x-bone.dts         |  9 ++++-
 firmware/Makefile                         |  5 +++
 firmware/capes/cape-bone-weather-00A0.dts | 66 +++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 1 deletion(-)
 create mode 100644 firmware/capes/cape-bone-weather-00A0.dts

diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index 5faeece..b02f29a 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -146,7 +146,14 @@
 
 		/* mapping between board names and dtb objects */
 		capemaps {
-
+			/* Weather cape */
+			cape@0 {
+				part-number = "BB-BONE-WTHR-01";
+				version@00A0 {
+					version = "00A0";
+					dtbo = "cape-bone-weather-00A0.dtbo";
+				};
+			};
 		};
 	};
 };
diff --git a/firmware/Makefile b/firmware/Makefile
index 361b2af..5ebb757 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -136,6 +136,11 @@ fw-shipped-$(CONFIG_USB_VICAM) += vicam/firmware.fw
 fw-shipped-$(CONFIG_VIDEO_CPIA2) += cpia2/stv0672_vp4.bin
 fw-shipped-$(CONFIG_YAM) += yam/1200.bin yam/9600.bin
 
+# Capes
+
+# the weather cape
+fw-shipped-$(CONFIG_CAPE_BEAGLEBONE) += capes/cape-bone-weather-00A0.dtbo
+
 fw-shipped-all := $(fw-shipped-y) $(fw-shipped-m) $(fw-shipped-)
 
 # Directories which we _might_ need to create, so we have a rule for them.
diff --git a/firmware/capes/cape-bone-weather-00A0.dts b/firmware/capes/cape-bone-weather-00A0.dts
new file mode 100644
index 0000000..ad91577
--- /dev/null
+++ b/firmware/capes/cape-bone-weather-00A0.dts
@@ -0,0 +1,66 @@
+/*
+* Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*/
+/dts-v1/;
+/plugin/;
+
+/ {
+       compatible = "ti,beaglebone";
+       part-number = "BB-BONE-WTHR-01";
+       version = "00A0";
+
+       fragment@0 {
+               target = <&am33xx_pinmux>;
+               __overlay__ {
+			pinctrl-single,pins = <
+				0x0c 0x37       /* gpmc_ad3.gpio1_3, OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE7 - w1-gpio */
+			>;
+               };
+       };
+
+       fragment@1 {
+               target = <&i2c3>;	/* actually I2C2 */
+
+               __overlay__ {
+		       /* needed to avoid gripping by DTC */
+		       #address-cells = <1>;
+		       #size-cells = <0>;
+
+		       /* Ambient light sensor */
+		       tsl2550@39 {
+			       compatible = "tsl,tsl2550";
+			       reg = <0x39>;
+		       };
+
+		       /* Humidity Sensor */
+		       sht21@40 {
+			       compatible = "sensiron,sht21";
+			       reg = <0x40>;
+		       };
+
+		       /* Barometric pressure sensor */
+		       bmp085@77 {
+			       compatible = "bosch,bmp085";
+			       reg = <0x77>;
+		       };
+               };
+       };
+
+       fragment@2 {
+               target = <&ocp>;
+               __overlay__ {
+		       onewire@0 {
+			       compatible      = "w1-gpio";
+			       pinctrl-names   = "default";
+			       pinctrl-0       = <&weather_cape_w1_pins>;
+			       status          = "okay";
+
+			       gpios = <&gpio2 3 0>;
+		       };
+               };
+       };
+};
-- 
1.7.12


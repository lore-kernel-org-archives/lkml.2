Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412Ab2GMKmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:42:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53036 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030272Ab2GMKmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:42:39 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] Documentation: Describe the AB8500 Device Tree bindings
Date: Fri, 13 Jul 2012 12:42:26 +0200
Message-Id: <1342176146-22765-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although for the most part, the AB8500 uses common bindings, some
of the ways in which they are used differ slightly to the common
uses of those bindings. To clear up some of these varying concepts
we provide some documentation describing each of the properties and
how they are used.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mfd/ab8500.txt |  123 ++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/ab8500.txt

diff --git a/Documentation/devicetree/bindings/mfd/ab8500.txt b/Documentation/devicetree/bindings/mfd/ab8500.txt
new file mode 100644
index 0000000..69e757a
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/ab8500.txt
@@ -0,0 +1,123 @@
+* AB8500 Multi-Functional Device (MFD)
+
+Required parent device properties:
+- compatible             : contains "stericsson,ab8500";
+- interrupts             : contains the IRQ line for the AB8500
+- interrupt-controller   : describes the AB8500 as an Interrupt Controller (has its own domain)
+- #interrupt-cells       : should be 2, for 2-cell format
+                            - The first cell is the AB8500 local IRQ number
+                            - The second cell is used to specify optional parameters
+                              - bits[3:0] trigger type and level flags:
+                                  1 = low-to-high edge triggered
+                                  2 = high-to-low edge triggered
+                                  4 = active high level-sensitive
+                                  8 = active low level-sensitive
+
+Optional parent device properties:
+- reg                    : contains the PRCMU mailbox address for the AB8500 i2c port
+
+The AB8500 consists of a large and varied group of sub-devices:
+
+Device                     IRQ Names              Supply Names   Description
+------                     ---------              ------------   -----------
+ab8500-bm                :                      :              : Battery Manager
+ab8500-btemp             :                      :              : Battery Temperature
+ab8500-charger           :                      :              : Battery Charger
+ab8500-fg                :                      :              : Fuel Gauge
+ab8500-gpadc             : HW_CONV_END          : vddadc       : Analogue to Digital Converter
+                           SW_CONV_END          :              :
+ab8500-gpio              :                      :              : GPIO Controller
+ab8500-ponkey            : ONKEY_DBF            :              : Power-on Key
+                           ONKEY_DBR            :              :
+ab8500-pwm               :                      :              : Pulse Width Modulator
+ab8500-regulator         :                      :              : Regulators
+ab8500-rtc               : 60S                  :              : Real Time Clock
+                         : ALARM                :              :
+ab8500-sysctrl           :                      :              : System Control
+ab8500-usb               : ID_WAKEUP_R          : vddulpivio18 : Universal Serial Bus
+                         : ID_WAKEUP_F          : v-ape        :
+                         : VBUS_DET_F           : musb_1v8     :
+                         : VBUS_DET_R           :              :
+                         : USB_LINK_STATUS      :              :
+                         : USB_ADP_PROBE_PLUG   :              :
+                         : USB_ADP_PROBE_UNPLUG :              :
+
+Required child device properties:
+- compatible             : "stericsson,ab8500-[bm|btemp|charger|fg|gpadc|gpio|ponkey|
+                                               pwm|regulator|rtc|sysctrl|usb]";
+
+Optional child device properties:
+- interrupts             : contains the device IRQ(s) using the 2-cell format (see above)
+- interrupt-names        : contains names of IRQ resource in the order in which they were
+                           supplied in the interrupts property
+- <supply_name>-supply   : contains a phandle to the regulator supply node in Device Tree
+
+ab8500@5 {
+         compatible = "stericsson,ab8500";
+         reg = <5>; /* mailbox 5 is i2c */
+         interrupts = <0 40 0x4>;
+         interrupt-controller;
+         #interrupt-cells = <2>;
+
+         ab8500-rtc {
+                 compatible = "stericsson,ab8500-rtc";
+                 interrupts = <17 0x4
+                               18 0x4>;
+                 interrupt-names = "60S", "ALARM";
+         };
+
+        ab8500-gpadc {
+                compatible = "stericsson,ab8500-gpadc";
+                interrupts = <32 0x4
+                              39 0x4>;
+                interrupt-names = "HW_CONV_END", "SW_CONV_END";
+                vddadc-supply = <&ab8500_ldo_tvout_reg>;
+        };
+
+        ab8500-usb {
+                compatible = "stericsson,ab8500-usb";
+                interrupts = < 90 0x4
+                               96 0x4
+                               14 0x4
+                               15 0x4
+                               79 0x4
+                               74 0x4
+                               75 0x4>;
+                interrupt-names = "ID_WAKEUP_R",
+                                  "ID_WAKEUP_F",
+                                  "VBUS_DET_F",
+                                  "VBUS_DET_R",
+                                  "USB_LINK_STATUS",
+                                  "USB_ADP_PROBE_PLUG",
+                                  "USB_ADP_PROBE_UNPLUG";
+                vddulpivio18-supply = <&ab8500_ldo_initcore_reg>;
+                v-ape-supply = <&db8500_vape_reg>;
+                musb_1v8-supply = <&db8500_vsmps2_reg>;
+        };
+
+        ab8500-ponkey {
+                compatible = "stericsson,ab8500-ponkey";
+                interrupts = <6 0x4
+                              7 0x4>;
+                interrupt-names = "ONKEY_DBF", "ONKEY_DBR";
+        };
+
+        ab8500-sysctrl {
+                compatible = "stericsson,ab8500-sysctrl";
+        };
+
+        ab8500-pwm {
+                compatible = "stericsson,ab8500-pwm";
+        };
+
+        ab8500-regulators {
+                compatible = "stericsson,ab8500-regulator";
+
+                ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
+                        /*
+                         * See: Documentation/devicetree/bindings/regulator/regulator.txt
+                         * for more information on regulators
+                         */
+                };
+        };
+};
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2ISI5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:57:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2ISI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:57:47 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dt: Document general interrupt controller bindings
Date: Wed, 19 Sep 2012 10:57:35 +0200
Message-Id: <1348045056-29769-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:x77R6bBpPgP2KErnVr2Zzd2rMozpXcvMi3uO1iry+Sk
 069TRM8pDWXUVAsWQAgxGTYN+yoVzon2rGm/33Nw6tMUkdgsvM
 Sw/AfB5hYm5J3aE5KZBoVjpgbVG+emF3emrPB6/MT7zrkalEUJ
 t3Upd9sOi47vk/lmyR9xRttBN7opLrjQw3G/+Wg4yRj5j2/k6g
 f8Yz8/43oy0DawvShVMUKgxHc4jONH+mYXGA5vXdxZkUCHZ9Le
 n/COOsGnoYbvBJZAgoQWCvdT0m/PPv9BCis81Pw0554fbSVjpr
 7suYHelJ+Rk65iyVuNv8/tueLwJkmMPtTjpnmUrMqxbtqJ9HOs
 XVWAvizCWQhr+g2nMfmwb6WwFGbQ5ibdDhFmimpAZ3UZFcSQ+G
 p0i3BoIffI9iMnWesGV3RjRckVyG5/tczZzStrlzk0rLuFdhNV
 H+e5l
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to use a device as interrupt controller, it needs to be marked
with the DT interrupt-controller property. This commit adds rudimentary
documentation about the required standard properties and describes the
most commonly used interrupt specifiers.

Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
This patch is for Rob's tree as it documents the general bindings.

 .../bindings/interrupt-controller/interrupts.txt   | 94 ++++++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/interrupts.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
new file mode 100644
index 0000000..6cafe3a
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
@@ -0,0 +1,94 @@
+Specifying interrupt information for devices
+============================================
+
+1) Interrupt user nodes
+-----------------------
+
+A device that generates interrupts can specify the interrupt controller to
+which the interrupts are routed by passing the controller's phandle in the
+"interrupt-parent" property.
+
+The "interrupts" property is a list of specifiers that describe each of the
+interrupts. See section 2 below for details.
+
+2) Interrupt controller nodes
+-----------------------------
+
+A device is marked as an interrupt controller with the "interrupt-controller"
+property. This is a empty, boolean property. An additional "#interrupt-cells"
+property defines the number of cells needed to specify a single interrupt.
+
+It is the responsibility of the interrupt controller's binding to define the
+length and format of the interrupt specifier. The following two variants are
+commonly used:
+
+  a) one cell
+  -----------
+  The #interrupt-cells property is set to 1 and the single cell defines the
+  index of the interrupt within the controller.
+
+  Example:
+
+	vic: intc@10140000 {
+		compatible = "arm,versatile-vic";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0x10140000 0x1000>;
+	};
+
+	sic: intc@10003000 {
+		compatible = "arm,versatile-sic";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0x10003000 0x1000>;
+		interrupt-parent = <&vic>;
+		interrupts = <31>; /* Cascaded to vic */
+	};
+
+  b) two cells
+  ------------
+  The #interrupt-cells property is set to 2 and the first cell defines the
+  index of the interrupt within the controller, while the second cell is used
+  to specify any of the following flags:
+    - bits[3:0] trigger type and level flags
+        1 = low-to-high edge triggered
+        2 = high-to-low edge triggered
+        4 = active high level-sensitive
+        8 = active low level-sensitive
+
+  Example:
+
+	gpio: gpio {
+		compatible = "nvidia,tegra20-gpio";
+		reg = <0x6000d000 0x1000>;
+		interrupts = <0 32 0x04
+			      0 33 0x04
+			      0 34 0x04
+			      0 35 0x04
+			      0 55 0x04
+			      0 87 0x04
+			      0 89 0x04>;
+		#gpio-cells = <2>;
+		gpio-controller;
+		#interrupt-cells = <2>;
+		interrupt-controller;
+	};
+
+	i2c@7000c000 {
+		status = "okay";
+		clock-frequency = <400000>;
+
+		wm8903: wm8903@1a {
+			compatible = "wlf,wm8903";
+			reg = <0x1a>;
+			interrupt-parent = <&gpio>;
+			interrupts = <187 0x04>;
+
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			micdet-cfg = <0>;
+			micdet-delay = <100>;
+			gpio-cfg = <0xffffffff 0xffffffff 0 0xffffffff 0xffffffff>;
+		};
+	};
-- 
1.7.12


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1IPTIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 15:08:52 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:61697 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832Ab1IPTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 15:08:51 -0400
From: Daniel Drake <dsd@laptop.org>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2 RESEND 2] gpio-vx855: add device tree binding
Message-Id: <20110916181220.E12109D401C@zog.reactivated.net>
Date: Fri, 16 Sep 2011 19:12:20 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=JFhAaHLcjawA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=x7EdvbJ8gsB9n6TrBDgA:9 a=2VOpp8wDU8semRwgGpEA:7 a=d4CUUju0HPYA:10 a=XRHo941U3qHBMacx:21 a=yClDitE5-8W8Zd-a:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to enable the HDD LED on the OLPC XO-1.5 laptop,
enabled through devicetree and the gpio-leds driver.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 .../devicetree/bindings/gpio/gpio_vx855.txt        |   20 ++++++++++++++++++++
 drivers/gpio/gpio-vx855.c                          |    5 +++++
 2 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio_vx855.txt

v2: extended the documentation with information about the pin numbering
scheme, which matches that of the driver.

diff --git a/Documentation/devicetree/bindings/gpio/gpio_vx855.txt b/Documentation/devicetree/bindings/gpio/gpio_vx855.txt
new file mode 100644
index 0000000..17285a5
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio_vx855.txt
@@ -0,0 +1,20 @@
+VIA VX855 GPIO controller
+
+Required properties:
+- compatible : "via,vx855-gpio"
+- #gpio-cells : Should be two. The first cell is the pin number and the
+  second cell is used to specify optional parameters:
+  - bit 0 specifies polarity (0 for normal, 1 for inverted)
+- gpio-controller : Marks the device node as a GPIO controller.
+
+As VIA differentiates between GPI, GPO and GPIO on its 42 available pins,
+with each pin type restarting numbering at 0, the following numbering scheme
+is used in the device tree for the pin number:
+
+PIN NO		VIA NAME
+0..13		GPI 0..13
+14..26		GPO 0..12
+27..41		GPIO 0..14
+
+For example, GPIO 11 (VIA name) is referred to with pin number 38 in the
+device tree.
diff --git a/drivers/gpio/gpio-vx855.c b/drivers/gpio/gpio-vx855.c
index ef5aabd..5b7e9ba 100644
--- a/drivers/gpio/gpio-vx855.c
+++ b/drivers/gpio/gpio-vx855.c
@@ -31,6 +31,7 @@
 #include <linux/platform_device.h>
 #include <linux/pci.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 #define MODULE_NAME "vx855_gpio"
 
@@ -216,6 +217,10 @@ static void vx855gpio_gpio_setup(struct vx855_gpio *vg)
 	c->ngpio = NR_VX855_GP;
 	c->can_sleep = 0;
 	c->names = vx855gpio_names;
+
+#ifdef CONFIG_OF_GPIO
+	c->of_node = of_find_compatible_node(NULL, NULL, "via,vx855-gpio");
+#endif
 }
 
 /* This platform device is ordinarily registered by the vx855 mfd driver */
-- 
1.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3AGFLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:11:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60674 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3AGFK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:10:56 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sekhar Nori <nsekhar@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH 08/10] video: da8xx-fb: obtain fb_videomode info from dt
Date: Mon, 7 Jan 2013 10:41:30 +0530
Message-ID: <78e026555731e0bbe8475610279d3e5265d124b9.1357304090.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357304090.git.afzal@ti.com>
References: <cover.1357304090.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obtain fb_videomode details for the connected lcd panel using the
display timing details present in DT.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 .../devicetree/bindings/video/fb-da8xx.txt         |   20 ++++++++++++++++++++
 drivers/video/da8xx-fb.c                           |   16 ++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/Documentation/devicetree/bindings/video/fb-da8xx.txt b/Documentation/devicetree/bindings/video/fb-da8xx.txt
index 581e014..eeb935b 100644
--- a/Documentation/devicetree/bindings/video/fb-da8xx.txt
+++ b/Documentation/devicetree/bindings/video/fb-da8xx.txt
@@ -6,6 +6,11 @@ Required properties:
 	AM335x SoC's - "ti,am3352-lcdc", "ti,da830-lcdc"
 - reg: Address range of lcdc register set
 - interrupts: lcdc interrupt
+- display-timings: list of different videomodes supported by the lcd
+  panel, represented as childs, can have multiple modes supported, if
+  only one, then it is considered native mode, if multiple modes are
+  provided, native mode can be set explicitly, more details available
+  @Documentation/devicetree/bindings/video/display-timing.txt
 
 Example:
 
@@ -13,4 +18,19 @@ lcdc@4830e000 {
 	compatible = "ti,am3352-lcdc", "ti,da830-lcdc";
 	reg =  <0x4830e000 0x1000>;
 	interrupts = <36>;
+	display-timings {
+		800x480p62 {
+			clock-frequency = <30000000>;
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <39>;
+			hback-porch = <39>;
+			hsync-len = <47>;
+			vback-porch = <29>;
+			vfront-porch = <13>;
+			vsync-len = <2>;
+			hsync-active = <1>;
+			vsync-active = <1>;
+		};
+	};
 };
diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 68ae925..94add01 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1261,8 +1261,24 @@ static struct fb_videomode *da8xx_fb_get_videomode(struct platform_device *dev)
 {
 	struct da8xx_lcdc_platform_data *fb_pdata = dev->dev.platform_data;
 	struct fb_videomode *lcdc_info;
+	struct device_node *np = dev->dev.of_node;
 	int i;
 
+	if (np) {
+		lcdc_info = devm_kzalloc(&dev->dev,
+					 sizeof(struct fb_videomode),
+					 GFP_KERNEL);
+		if (!lcdc_info) {
+			dev_err(&dev->dev, "memory allocation failed\n");
+			return NULL;
+		}
+		if (of_get_fb_videomode(np, lcdc_info, 0)) {
+			dev_err(&dev->dev, "timings not available in DT\n");
+			return NULL;
+		}
+		return lcdc_info;
+	}
+
 	for (i = 0, lcdc_info = known_lcd_panels;
 		i < ARRAY_SIZE(known_lcd_panels); i++, lcdc_info++) {
 		if (strcmp(fb_pdata->type, lcdc_info->name) == 0)
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3AGFLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:11:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60685 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3AGFLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:11:06 -0500
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
Subject: [PATCH 10/10] video: da8xx-fb: setup struct lcd_ctrl_config for dt
Date: Mon, 7 Jan 2013 10:41:49 +0530
Message-ID: <c58ee6abc9a364f4a9d8b4d075fd79ac3cc8bf75.1357304090.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357304090.git.afzal@ti.com>
References: <cover.1357304090.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strcut lcd_ctrl_config information required for driver is currently
obtained via platform data. To handle DT probing, create
lcd_ctrl_config and populate it with default values, these values are
sufficient for the panels so far used with this controller to work.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 3e590d4..4a4b4dc 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1257,6 +1257,35 @@ static struct fb_ops da8xx_fb_ops = {
 	.fb_blank = cfb_blank,
 };
 
+static struct lcd_ctrl_config *da8xx_fb_create_cfg(struct platform_device *dev)
+{
+	struct lcd_ctrl_config *cfg;
+
+	cfg = devm_kzalloc(&dev->dev, sizeof(struct fb_videomode), GFP_KERNEL);
+	if (!cfg) {
+		dev_err(&dev->dev, "memory allocation failed\n");
+		return NULL;
+	}
+
+	/* default values */
+
+	if (lcd_revision == LCD_VERSION_1)
+		cfg->bpp = 16;
+	else
+		cfg->bpp = 32;
+
+	/*
+	 * For panels so far used with this LCDC, below statement is sufficient.
+	 * For new panels, if required, struct lcd_ctrl_cfg fields to be updated
+	 * with additional/modified values. Those values would have to be then
+	 * obtained from dt(requiring new dt bindings).
+	 */
+
+	cfg->panel_shade = COLOR_ACTIVE;
+
+	return cfg;
+}
+
 static struct fb_videomode *da8xx_fb_get_videomode(struct platform_device *dev)
 {
 	struct da8xx_lcdc_platform_data *fb_pdata = dev->dev.platform_data;
@@ -1348,7 +1377,10 @@ static int __devinit fb_probe(struct platform_device *device)
 		break;
 	}
 
-	lcd_cfg = (struct lcd_ctrl_config *)fb_pdata->controller_data;
+	if (device->dev.of_node)
+		lcd_cfg = da8xx_fb_create_cfg(device);
+	else
+		lcd_cfg = (struct lcd_ctrl_config *)fb_pdata->controller_data;
 
 	if (!lcd_cfg) {
 		ret = -EINVAL;
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab2EPLM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:12:59 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:42812 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967446Ab2EPLMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:12:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        peter.ujfalusi@ti.com, Misael Lopez Cruz <misael.lopez@ti.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH v3 3/4] MFD: twl6040: Register the child for the ASoC codec unconditionally
Date: Wed, 16 May 2012 14:11:57 +0300
Message-Id: <1337166718-8458-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
References: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main function of the twl6040 is to provide audio on OMAP4+ platforms.
Since the ASoC codec driver can work without the pdata we can register the
child to load the codec driver whenever the twl6040 MFD driver is loaded.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index c50fba7..9765dc2 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -507,7 +507,7 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	struct twl6040_platform_data *pdata = client->dev.platform_data;
 	struct twl6040 *twl6040;
 	struct mfd_cell *cell = NULL;
-	int ret, children = 0;
+	int irq, ret, children = 0;
 
 	if (!pdata) {
 		dev_err(&client->dev, "Platform data is missing\n");
@@ -589,22 +589,27 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	/* dual-access registers controlled by I2C only */
 	twl6040_set_bits(twl6040, TWL6040_REG_ACCCTL, TWL6040_I2CSEL);
 
+	/*
+	 * The main functionality of twl6040 to provide audio on OMAP4+ systems.
+	 * We can add the ASoC codec child whenever this driver has been loaded.
+	 * The ASoC codec can work without pdata, pass the platform_data only if
+	 * it has been provided.
+	 */
+	irq = twl6040->irq_base + TWL6040_IRQ_PLUG;
+	cell = &twl6040->cells[children];
+	cell->name = "twl6040-codec";
+	twl6040_codec_rsrc[0].start = irq;
+	twl6040_codec_rsrc[0].end = irq;
+	cell->resources = twl6040_codec_rsrc;
+	cell->num_resources = ARRAY_SIZE(twl6040_codec_rsrc);
 	if (pdata->codec) {
-		int irq = twl6040->irq_base + TWL6040_IRQ_PLUG;
-
-		cell = &twl6040->cells[children];
-		cell->name = "twl6040-codec";
-		twl6040_codec_rsrc[0].start = irq;
-		twl6040_codec_rsrc[0].end = irq;
-		cell->resources = twl6040_codec_rsrc;
-		cell->num_resources = ARRAY_SIZE(twl6040_codec_rsrc);
 		cell->platform_data = pdata->codec;
 		cell->pdata_size = sizeof(*pdata->codec);
-		children++;
 	}
+	children++;
 
 	if (pdata->vibra) {
-		int irq = twl6040->irq_base + TWL6040_IRQ_VIB;
+		irq = twl6040->irq_base + TWL6040_IRQ_VIB;
 
 		cell = &twl6040->cells[children];
 		cell->name = "twl6040-vibra";
@@ -618,16 +623,10 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 		children++;
 	}
 
-	if (children) {
-		ret = mfd_add_devices(&client->dev, -1, twl6040->cells,
-				      children, NULL, 0);
-		if (ret)
-			goto mfd_err;
-	} else {
-		dev_err(&client->dev, "No platform data found for children\n");
-		ret = -ENODEV;
+	ret = mfd_add_devices(&client->dev, -1, twl6040->cells, children,
+			      NULL, 0);
+	if (ret)
 		goto mfd_err;
-	}
 
 	return 0;
 
-- 
1.7.8.6


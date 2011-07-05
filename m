Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab1GENtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:49:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54195 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1GENts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:49:48 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 1/5] MFD: twl6040: Use resource to provide irq number for slaves
Date: Tue, 5 Jul 2011 16:49:31 +0300
Message-ID: <1309873775-17927-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309873775-17927-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309873775-17927-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the irq number for slaves via resource on the
platform device.
The irq number configuration is done in the twl6040-core
at probe time, so machine drivers do not need to be
modified.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index cfaedb5..471f489 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -435,6 +435,18 @@ unsigned int twl6040_get_sysclk(struct twl6040 *twl6040)
 }
 EXPORT_SYMBOL(twl6040_get_sysclk);
 
+static struct resource twl6040_vibra_rsrc[] = {
+	{
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource twl6040_codec_rsrc[] = {
+	{
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
 static int __devinit twl6040_probe(struct platform_device *pdev)
 {
 	struct twl4030_audio_data *pdata = pdev->dev.platform_data;
@@ -499,16 +511,29 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	twl6040_set_bits(twl6040, TWL6040_REG_ACCCTL, TWL6040_I2CSEL);
 
 	if (pdata->codec) {
+		int irq = twl6040->irq_base + TWL6040_IRQ_PLUG;
+
 		cell = &twl6040->cells[children];
 		cell->name = "twl6040-codec";
+		twl6040_codec_rsrc[0].start = irq;
+		twl6040_codec_rsrc[0].end = irq;
+		cell->resources = twl6040_codec_rsrc;
+		cell->num_resources = ARRAY_SIZE(twl6040_codec_rsrc);
 		cell->platform_data = pdata->codec;
 		cell->pdata_size = sizeof(*pdata->codec);
 		children++;
 	}
 
 	if (pdata->vibra) {
+		int irq = twl6040->irq_base + TWL6040_IRQ_VIB;
+
 		cell = &twl6040->cells[children];
 		cell->name = "twl6040-vibra";
+		twl6040_vibra_rsrc[0].start = irq;
+		twl6040_vibra_rsrc[0].end = irq;
+		cell->resources = twl6040_vibra_rsrc;
+		cell->num_resources = ARRAY_SIZE(twl6040_vibra_rsrc);
+
 		cell->platform_data = pdata->vibra;
 		cell->pdata_size = sizeof(*pdata->vibra);
 		children++;
-- 
1.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2BBMRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:17:31 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54968 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060Ab2BBMR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:17:29 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC 7/7] MFD: TWL6040: Add regulator support for VIO, V2V1 supplies
Date: Thu,  2 Feb 2012 14:16:59 +0200
Message-Id: <1328185019-29575-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl6040 has three power supply source:
VBAT needs to be connected to VBAT
VIO, and V2V1.
Add regulator support for the VIO, V2V1 supplies.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/twl6040.h |    2 ++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 21d6a99..04568ea 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -27,12 +27,14 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
+#include <linux/regulator/consumer.h>
 
 #define VIBRACTRL_MEMBER(reg) ((reg == TWL6040_REG_VIBCTLL) ? 0 : 1)
 
@@ -541,6 +543,33 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, twl6040);
 
+	twl6040->vio = regulator_get(&client->dev, "vio");
+	if (IS_ERR(twl6040->vio)) {
+		ret = PTR_ERR(twl6040->vio);
+		dev_err(&client->dev, "Failed to request VIO supply: %d\n",
+			ret);
+		goto regulator_get_err;
+	}
+	twl6040->v2v1 = regulator_get(&client->dev, "v2v1");
+	if (IS_ERR(twl6040->v2v1)) {
+		ret = PTR_ERR(twl6040->v2v1);
+		dev_err(&client->dev, "Failed to request V2V1 supply: %d\n",
+			ret);
+		regulator_put(twl6040->vio);
+		goto regulator_get_err;
+	}
+	ret = regulator_enable(twl6040->vio);
+	if (ret != 0) {
+		dev_err(&client->dev, "Failed to enable VIO: %d\n", ret);
+		goto power_err;
+	}
+	ret = regulator_enable(twl6040->v2v1);
+	if (ret != 0) {
+		dev_err(&client->dev, "Failed to enable V2V1: %d\n", ret);
+		regulator_disable(twl6040->vio);
+		goto power_err;
+	}
+
 	twl6040->dev = &client->dev;
 	twl6040->control_data = client;
 	twl6040->irq = client->irq;
@@ -632,6 +661,12 @@ gpio2_err:
 	if (gpio_is_valid(twl6040->audpwron))
 		gpio_free(twl6040->audpwron);
 gpio1_err:
+	regulator_disable(twl6040->v2v1);
+	regulator_disable(twl6040->vio);
+power_err:
+	regulator_put(twl6040->vio);
+	regulator_put(twl6040->v2v1);
+regulator_get_err:
 	i2c_set_clientdata(client, NULL);
 	kfree(twl6040);
 	return ret;
@@ -652,6 +687,12 @@ static int __devexit twl6040_remove(struct i2c_client *client)
 
 	mfd_remove_devices(&client->dev);
 	i2c_set_clientdata(client, NULL);
+
+	regulator_disable(twl6040->v2v1);
+	regulator_disable(twl6040->vio);
+	regulator_put(twl6040->vio);
+	regulator_put(twl6040->v2v1);
+
 	kfree(twl6040);
 
 	return 0;
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 72f530f..146de4e 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -201,6 +201,8 @@ struct twl6040_platform_data {
 struct twl6040 {
 	struct i2c_client *control_data;
 	struct device *dev;
+	struct regulator *vio;
+	struct regulator *v2v1;
 	struct mutex mutex;
 	struct mutex io_mutex;
 	struct mutex irq_mutex;
-- 
1.7.8.4


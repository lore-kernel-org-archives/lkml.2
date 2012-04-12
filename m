Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716Ab2DLVOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:14:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36328 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab2DLVOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:14:41 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 1/2] i2c: Add a struct device * parameter to i2c_add_mux_adapter()
Date: Thu, 12 Apr 2012 14:14:22 -0700
Message-Id: <1334265263-13549-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com>
References: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

And adjust all callers.

The new device parameter is used in the next patch to initialize the
mux's of_node so that its children may be automatically populated.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/i2c/i2c-mux.c           |   19 ++++++++++---------
 drivers/i2c/muxes/gpio-i2cmux.c |    3 ++-
 drivers/i2c/muxes/pca9541.c     |    3 ++-
 drivers/i2c/muxes/pca954x.c     |    2 +-
 include/linux/i2c-mux.h         |    3 ++-
 5 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index d7a4833..26ab31d 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -31,11 +31,11 @@ struct i2c_mux_priv {
 	struct i2c_algorithm algo;
 
 	struct i2c_adapter *parent;
-	void *mux_dev;	/* the mux chip/device */
+	void *mux_priv;	/* the mux chip/device */
 	u32  chan_id;	/* the channel id */
 
-	int (*select)(struct i2c_adapter *, void *mux_dev, u32 chan_id);
-	int (*deselect)(struct i2c_adapter *, void *mux_dev, u32 chan_id);
+	int (*select)(struct i2c_adapter *, void *mux_priv, u32 chan_id);
+	int (*deselect)(struct i2c_adapter *, void *mux_priv, u32 chan_id);
 };
 
 static int i2c_mux_master_xfer(struct i2c_adapter *adap,
@@ -47,11 +47,11 @@ static int i2c_mux_master_xfer(struct i2c_adapter *adap,
 
 	/* Switch to the right mux port and perform the transfer. */
 
-	ret = priv->select(parent, priv->mux_dev, priv->chan_id);
+	ret = priv->select(parent, priv->mux_priv, priv->chan_id);
 	if (ret >= 0)
 		ret = parent->algo->master_xfer(parent, msgs, num);
 	if (priv->deselect)
-		priv->deselect(parent, priv->mux_dev, priv->chan_id);
+		priv->deselect(parent, priv->mux_priv, priv->chan_id);
 
 	return ret;
 }
@@ -67,12 +67,12 @@ static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
 
 	/* Select the right mux port and perform the transfer. */
 
-	ret = priv->select(parent, priv->mux_dev, priv->chan_id);
+	ret = priv->select(parent, priv->mux_priv, priv->chan_id);
 	if (ret >= 0)
 		ret = parent->algo->smbus_xfer(parent, addr, flags,
 					read_write, command, size, data);
 	if (priv->deselect)
-		priv->deselect(parent, priv->mux_dev, priv->chan_id);
+		priv->deselect(parent, priv->mux_priv, priv->chan_id);
 
 	return ret;
 }
@@ -87,7 +87,8 @@ static u32 i2c_mux_functionality(struct i2c_adapter *adap)
 }
 
 struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
-				void *mux_dev, u32 force_nr, u32 chan_id,
+				struct device *mux_dev,
+				void *mux_priv, u32 force_nr, u32 chan_id,
 				int (*select) (struct i2c_adapter *,
 					       void *, u32),
 				int (*deselect) (struct i2c_adapter *,
@@ -102,7 +103,7 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 
 	/* Set up private adapter data */
 	priv->parent = parent;
-	priv->mux_dev = mux_dev;
+	priv->mux_priv = mux_priv;
 	priv->chan_id = chan_id;
 	priv->select = select;
 	priv->deselect = deselect;
diff --git a/drivers/i2c/muxes/gpio-i2cmux.c b/drivers/i2c/muxes/gpio-i2cmux.c
index e5fa695..fc5c1ef 100644
--- a/drivers/i2c/muxes/gpio-i2cmux.c
+++ b/drivers/i2c/muxes/gpio-i2cmux.c
@@ -105,7 +105,8 @@ static int __devinit gpiomux_probe(struct platform_device *pdev)
 	for (i = 0; i < pdata->n_values; i++) {
 		u32 nr = pdata->base_nr ? (pdata->base_nr + i) : 0;
 
-		mux->adap[i] = i2c_add_mux_adapter(parent, mux, nr, i,
+		mux->adap[i] = i2c_add_mux_adapter(parent, &pdev->dev, mux,
+						   nr, i,
 						   gpiomux_select, deselect);
 		if (!mux->adap[i]) {
 			ret = -ENODEV;
diff --git a/drivers/i2c/muxes/pca9541.c b/drivers/i2c/muxes/pca9541.c
index e0df9b6..8aacde1 100644
--- a/drivers/i2c/muxes/pca9541.c
+++ b/drivers/i2c/muxes/pca9541.c
@@ -353,7 +353,8 @@ static int pca9541_probe(struct i2c_client *client,
 	force = 0;
 	if (pdata)
 		force = pdata->modes[0].adap_id;
-	data->mux_adap = i2c_add_mux_adapter(adap, client, force, 0,
+	data->mux_adap = i2c_add_mux_adapter(adap, &client->dev, client,
+					     force, 0,
 					     pca9541_select_chan,
 					     pca9541_release_chan);
 
diff --git a/drivers/i2c/muxes/pca954x.c b/drivers/i2c/muxes/pca954x.c
index 0e37ef2..f2dfe0d 100644
--- a/drivers/i2c/muxes/pca954x.c
+++ b/drivers/i2c/muxes/pca954x.c
@@ -226,7 +226,7 @@ static int pca954x_probe(struct i2c_client *client,
 		}
 
 		data->virt_adaps[num] =
-			i2c_add_mux_adapter(adap, client,
+			i2c_add_mux_adapter(adap, &client->dev, client,
 				force, num, pca954x_select_chan,
 				(pdata && pdata->modes[num].deselect_on_exit)
 					? pca954x_deselect_mux : NULL);
diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
index 747f0cd..c790838 100644
--- a/include/linux/i2c-mux.h
+++ b/include/linux/i2c-mux.h
@@ -34,7 +34,8 @@
  * mux control.
  */
 struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
-				void *mux_dev, u32 force_nr, u32 chan_id,
+				struct device *mux_dev,
+				void *mux_priv, u32 force_nr, u32 chan_id,
 				int (*select) (struct i2c_adapter *,
 					       void *mux_dev, u32 chan_id),
 				int (*deselect) (struct i2c_adapter *,
-- 
1.7.2.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab2BJBmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 20:42:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59222 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2BJBmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 20:42:49 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TRgVYD6ZyiEA:10 a=vGjuO-vQnTQA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=yQdBAQUQAAAA:8 a=Yy02Jf9F3dnwX-l911kA:9 a=jXESwwUM2F31nsx6vycA:7 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 75.81.36.228
Date: Thu, 09 Feb 2012 19:42:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: chunkeey@web.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org
Subject: [RFC/RFT V2] p54pci: Convert driver to use asynchronous firmware
 loading
Message-ID: <4f347616.jXdqWXSZa+x+oGh0%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers that load firmware from their probe routine have problems with the
latest versions of udev as they get timeouts while waiting for user
space to start. The problem is fixed by using request_firmware_nowait()
and delaying the start of mac80211 until the firmware is loaded.

To prevent the possibility of the driver being unloaded while the firmware
loading callback is still active, a completion queue entry is used.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - get the driver name right

This conversion of p54pci to use asynchronous firmware loading is based
on the method used in p54usb. As I do not have the hardware, it is only
compile tested. I would appreciate any feedback from people that have the
hardware.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/p54/p54pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/p54/p54pci.c
+++ wireless-testing-new/drivers/net/wireless/p54/p54pci.c
@@ -488,6 +488,69 @@ static int p54p_open(struct ieee80211_hw
 	return 0;
 }
 
+static void p54_start_ops(struct ieee80211_hw *dev)
+{
+	struct p54p_priv *priv = dev->priv;
+	int err;
+
+	err = p54p_open(dev);
+	if (err) {
+		dev_err(&priv->pdev->dev, "Failed in p54p_open\n");
+		return;
+	}
+	err = p54_read_eeprom(dev);
+	p54p_stop(dev);
+	if (err) {
+		dev_err(&priv->pdev->dev, "Failed in p54p_read_eeprom\n");
+		return;
+	}
+
+	err = p54_register_common(dev, &priv->pdev->dev);
+	if (err) {
+		dev_err(&priv->pdev->dev,
+			"Failed in p54_register_common\n");
+		return;
+	}
+}
+
+static void p54p_load_firmware_cb2(const struct firmware *firmware,
+				  void *context)
+{
+	struct ieee80211_hw *dev = context;
+	struct p54p_priv *priv = dev->priv;
+
+	if (!firmware) {
+		/* alternate firmware not found */
+		dev_err(&priv->pdev->dev, "Firmware loading failed\n");
+		return;
+	}
+	complete(&priv->fw_loaded);
+	priv->firmware = firmware;
+	p54_start_ops(dev);
+}
+
+static void p54p_load_firmware_cb(const struct firmware *firmware,
+				  void *context)
+{
+	struct ieee80211_hw *dev = context;
+	struct p54p_priv *priv = dev->priv;
+	int err;
+
+	if (!firmware) {
+		/* Primary firmware not found - try for alternate file */
+		dev_info(&priv->pdev->dev, "Loading firmware file isl3886");
+		err = request_firmware_nowait(THIS_MODULE, 1,
+					      "isl3886",
+					      &priv->pdev->dev, GFP_KERNEL, dev,
+					      p54p_load_firmware_cb2);
+		if (err)
+			return;
+	}
+	complete(&priv->fw_loaded);
+	priv->firmware = firmware;
+	p54_start_ops(dev);
+}
+
 static int __devinit p54p_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id)
 {
@@ -561,28 +624,15 @@ static int __devinit p54p_probe(struct p
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->tasklet, p54p_tasklet, (unsigned long)dev);
 
-	err = request_firmware(&priv->firmware, "isl3886pci",
-			       &priv->pdev->dev);
+	init_completion(&priv->fw_loaded);
+	dev_info(&priv->pdev->dev, "Loading firmware file isl3886pci\n");
+	err = request_firmware_nowait(THIS_MODULE, 1, "isl3886pci",
+				      &pdev->dev, GFP_KERNEL, dev,
+				      p54p_load_firmware_cb);
 	if (err) {
-		dev_err(&pdev->dev, "Cannot find firmware (isl3886pci)\n");
-		err = request_firmware(&priv->firmware, "isl3886",
-				       &priv->pdev->dev);
-		if (err)
-			goto err_free_common;
-	}
-
-	err = p54p_open(dev);
-	if (err)
-		goto err_free_common;
-	err = p54_read_eeprom(dev);
-	p54p_stop(dev);
-	if (err)
+		dev_err(&pdev->dev, "Cannot load firmware (isl3886pci)\n");
 		goto err_free_common;
-
-	err = p54_register_common(dev, &pdev->dev);
-	if (err)
-		goto err_free_common;
-
+	}
 	return 0;
 
  err_free_common:
@@ -612,8 +662,9 @@ static void __devexit p54p_remove(struct
 	if (!dev)
 		return;
 
-	p54_unregister_common(dev);
 	priv = dev->priv;
+	wait_for_completion(&priv->fw_loaded);
+	p54_unregister_common(dev);
 	release_firmware(priv->firmware);
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
Index: wireless-testing-new/drivers/net/wireless/p54/p54pci.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/p54/p54pci.h
+++ wireless-testing-new/drivers/net/wireless/p54/p54pci.h
@@ -105,6 +105,7 @@ struct p54p_priv {
 	struct sk_buff *tx_buf_data[32];
 	struct sk_buff *tx_buf_mgmt[4];
 	struct completion boot_comp;
+	struct completion fw_loaded;
 };
 
 #endif /* P54USB_H */

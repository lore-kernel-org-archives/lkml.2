Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab2BJBFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 20:05:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab2BJBFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 20:05:44 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TRgVYD6ZyiEA:10 a=PpbjMBYbAasA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=yQdBAQUQAAAA:8 a=I5bUxF1VxH2wb6pcP14A:9 a=Ouj1IebUWkgCi1o-j3oA:7 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 75.81.36.228
Date: Thu, 09 Feb 2012 19:05:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: chunkeey@web.de
Cc: m@bues.ch, jcmvbkbc@gmail.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: [RFC/RFT] p54spi: Convert driver to use asynchronous firmware
 loading
Message-ID: <4f346d61.3S6x22TS5RH2gGO5%Larry.Finger@lwfinger.net>
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

This conversion of p54spi to use asynchronous firmware loading is based
on the method used in p54usb. As I do not have the hardware, it is only
compile tested. I would appreciate any feedback from people that have the
hardware.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/p54/p54spi.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/p54/p54spi.c
+++ wireless-testing-new/drivers/net/wireless/p54/p54spi.c
@@ -163,25 +163,41 @@ static int p54spi_spi_write_dma(struct p
 	return 0;
 }
 
-static int p54spi_request_firmware(struct ieee80211_hw *dev)
+
+static void p54s_load_firmware_cb(const struct firmware *firmware,
+				  void *context)
 {
+	struct ieee80211_hw *dev = context;
 	struct p54s_priv *priv = dev->priv;
 	int ret;
 
-	/* FIXME: should driver use it's own struct device? */
-	ret = request_firmware(&priv->firmware, "3826.arm", &priv->spi->dev);
-
-	if (ret < 0) {
-		dev_err(&priv->spi->dev, "request_firmware() failed: %d", ret);
-		return ret;
+	if (!firmware) {
+		/* alternate firmware not found */
+		dev_err(&priv->spi->dev, "Firmware loading failed\n");
+		return;
 	}
+	complete(&priv->fw_loaded);
+	priv->firmware = firmware;
 
 	ret = p54_parse_firmware(dev, priv->firmware);
-	if (ret) {
+	if (ret)
 		release_firmware(priv->firmware);
+}
+
+static int p54spi_request_firmware(struct ieee80211_hw *dev)
+{
+	struct p54s_priv *priv = dev->priv;
+	int ret;
+
+	init_completion(&priv->fw_loaded);
+	/* FIXME: should driver use it's own struct device? */
+	ret = request_firmware_nowait(THIS_MODULE, 1, "3826.arm",
+				      &priv->spi->dev, GFP_KERNEL, dev,
+				      p54s_load_firmware_cb);
+	if (ret < 0) {
+		dev_err(&priv->spi->dev, "request_firmware() failed: %d", ret);
 		return ret;
 	}
-
 	return 0;
 }
 
@@ -681,6 +697,7 @@ static int __devexit p54spi_remove(struc
 {
 	struct p54s_priv *priv = dev_get_drvdata(&spi->dev);
 
+	wait_for_completion(&priv->fw_loaded);
 	p54_unregister_common(priv->hw);
 
 	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
Index: wireless-testing-new/drivers/net/wireless/p54/p54spi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/p54/p54spi.h
+++ wireless-testing-new/drivers/net/wireless/p54/p54spi.h
@@ -120,6 +120,7 @@ struct p54s_priv {
 
 	enum fw_state fw_state;
 	const struct firmware *firmware;
+	struct completion fw_loaded;
 };
 
 #endif /* P54SPI_H */

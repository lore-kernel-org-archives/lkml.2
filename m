Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab2IJIyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:54:01 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:45294 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab2IJIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:50:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CAHGoTVBbdWObgWdsb2JhbABFhge1SiIBARYmJ4IgAQEFIwQLATQSECAFAiYCAlcGE4gUqBWSO4EhjxaBEgOVXZMF
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262498"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 08/20] Staging: ipack: Switch to 8MHz operation before reading ID.
Date: Mon, 10 Sep 2012 10:51:46 +0200
Message-Id: <1347267118-9580-8-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Reading the ID space at 8 MHz is always supported.  Most carriers will
boot up in 8MHz mode.  Still, play it safe and ensure we are operating at
8Mhz.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index 4f3c945..95f56b8 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -376,6 +376,9 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 	dev_set_name(&dev->dev,
 		     "ipack-dev.%u.%u", dev->bus_nr, dev->slot);
 
+	if (bus->ops->set_clockrate(dev, 8))
+		dev_warn(&dev->dev, "failed to switch to 8 MHz operation for reading of device ID.\n");
+
 	ret = ipack_device_read_id(dev);
 	if (ret < 0) {
 		dev_err(&dev->dev, "error reading device id section.\n");
@@ -384,9 +387,11 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 	}
 
 	/* if the device supports 32 MHz operation, use it. */
-	ret = bus->ops->set_clockrate(dev, dev->speed_32mhz ? 32 : 8);
-	if (ret < 0)
-		dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
+	if (dev->speed_32mhz) {
+		ret = bus->ops->set_clockrate(dev, 32);
+		if (ret < 0)
+			dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
+	}
 
 	ret = device_register(&dev->dev);
 	if (ret < 0) {
-- 
1.7.10.4


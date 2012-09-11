Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab2IKLif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:38:35 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:55378 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218Ab2IKLem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4IgAQEFIwQLATQSECAFAiYCAlcGE4gUqGiTN4EhjwOBEgOVXZMF
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505348"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 08/20] Staging: ipack: Switch to 8MHz operation before reading ID.
Date: Tue, 11 Sep 2012 13:35:01 +0200
Message-Id: <1347363313-17094-9-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
References: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
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
index 6895426..e2f819c 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -377,6 +377,9 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 	dev_set_name(&dev->dev,
 		     "ipack-dev.%u.%u", dev->bus_nr, dev->slot);
 
+	if (bus->ops->set_clockrate(dev, 8))
+		dev_warn(&dev->dev, "failed to switch to 8 MHz operation for reading of device ID.\n");
+
 	ret = ipack_device_read_id(dev);
 	if (ret < 0) {
 		dev_err(&dev->dev, "error reading device id section.\n");
@@ -385,9 +388,11 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 	}
 
 	/* if the device supports 32 MHz operation, use it. */
-	ret = bus->ops->set_clockrate(dev, dev->speed_32mhz ? 32 : 8);
-	if (ret < 0)
-		dev_err(&dev->dev, "failed to perform set_clock_rate operation.\n");
+	if (dev->speed_32mhz) {
+		ret = bus->ops->set_clockrate(dev, 32);
+		if (ret < 0)
+			dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
+	}
 
 	ret = device_register(&dev->dev);
 	if (ret < 0) {
-- 
1.7.10.4


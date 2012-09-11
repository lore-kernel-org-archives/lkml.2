Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab2IKLh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:37:58 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:43407 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759141Ab2IKLen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBSoaJM3gSGJeIULgRIDlV2TBYFY
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505358"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 10/20] Staging: ipack: check the device ID space CRC.
Date: Tue, 11 Sep 2012 13:35:03 +0200
Message-Id: <1347363313-17094-11-git-send-email-siglesias@igalia.com>
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

We check the CRC and store the result of the check in struct ipac_device.
A warning is emitted if the check fails.  However we leave it to the
IPack module device to refuse to initialize due to a bad CRC.  I have seen
otherwise good modules with bad CRCs.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |   59 ++++++++++++++++++++++++++++++++++++++++-
 drivers/staging/ipack/ipack.h |    1 +
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index 08b122d..26dc976 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -253,20 +253,71 @@ void ipack_driver_unregister(struct ipack_driver *edrv)
 }
 EXPORT_SYMBOL_GPL(ipack_driver_unregister);
 
+static u16 ipack_crc_byte(u16 crc, u8 c)
+{
+	int i;
+
+	crc ^= c << 8;
+	for (i = 0; i < 8; i++)
+		crc = (crc << 1) ^ ((crc & 0x8000) ? 0x1021 : 0);
+	return crc;
+}
+
+/*
+ * The algorithm in lib/crc-ccitt.c does not seem to apply since it uses the
+ * opposite bit ordering.
+ */
+static u8 ipack_calc_crc1(struct ipack_device *dev)
+{
+	u8 c;
+	u16 crc;
+	unsigned int i;
+
+	crc = 0xffff;
+	for (i = 0; i < dev->id_avail; i++) {
+		c = (i != 11) ? dev->id[i] : 0;
+		crc = ipack_crc_byte(crc, c);
+	}
+	crc = ~crc;
+	return crc & 0xff;
+}
+
+static u16 ipack_calc_crc2(struct ipack_device *dev)
+{
+	u8 c;
+	u16 crc;
+	unsigned int i;
+
+	crc = 0xffff;
+	for (i = 0; i < dev->id_avail; i++) {
+		c = ((i != 0x18) && (i != 0x19)) ? dev->id[i] : 0;
+		crc = ipack_crc_byte(crc, c);
+	}
+	crc = ~crc;
+	return crc;
+}
+
 static void ipack_parse_id1(struct ipack_device *dev)
 {
 	u8 *id = dev->id;
+	u8 crc;
 
 	dev->id_vendor = id[4];
 	dev->id_device = id[5];
 	dev->speed_8mhz = 1;
 	dev->speed_32mhz = (id[7] == 'H');
+	crc = ipack_calc_crc1(dev);
+	dev->id_crc_correct = (crc == id[11]);
+	if (!dev->id_crc_correct) {
+		dev_warn(&dev->dev, "ID CRC invalid found 0x%x, expected 0x%x.\n",
+				id[11], crc);
+	}
 }
 
 static void ipack_parse_id2(struct ipack_device *dev)
 {
 	__be16 *id = (__be16 *) dev->id;
-	u16 flags;
+	u16 flags, crc;
 
 	dev->id_vendor = ((be16_to_cpu(id[3]) & 0xff) << 16)
 			 + be16_to_cpu(id[4]);
@@ -274,6 +325,12 @@ static void ipack_parse_id2(struct ipack_device *dev)
 	flags = be16_to_cpu(id[10]);
 	dev->speed_8mhz = !!(flags & 2);
 	dev->speed_32mhz = !!(flags & 4);
+	crc = ipack_calc_crc2(dev);
+	dev->id_crc_correct = (crc == be16_to_cpu(id[12]));
+	if (!dev->id_crc_correct) {
+		dev_warn(&dev->dev, "ID CRC invalid found 0x%x, expected 0x%x.\n",
+				id[11], crc);
+	}
 }
 
 static int ipack_device_read_id(struct ipack_device *dev)
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index ad4c3bf..77d8075 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -77,6 +77,7 @@ struct ipack_device {
 	u32			 id_vendor;
 	u32			 id_device;
 	u8			 id_format;
+	unsigned int		 id_crc_correct:1;
 	unsigned int		 speed_8mhz:1;
 	unsigned int		 speed_32mhz:1;
 };
-- 
1.7.10.4


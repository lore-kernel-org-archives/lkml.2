Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab1IZIzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:55:52 -0400
Received: from mx15.lb01.inode.at ([62.99.145.17]:31041 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751315Ab1IZIzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:55:51 -0400
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH v2] spi: detect wrong transfer->len values
Date: Mon, 26 Sep 2011 10:55:18 +0200
Message-Id: <1317027318-4889-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <20110923233204.GJ24631@ponder.secretlab.ca>
References: <20110923233204.GJ24631@ponder.secretlab.ca>
MIME-Version: 1.0
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: p8Q8tgu4024913
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1317632144.21279@Ro3A0NiO1hDKLc5NoRMjvg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Helmut Raiger <helmut.raiger@hale.at>

Instead of returning an error, which could have unknown consequences for
different drivers, just use dev_WARN_ONCE to output a warning.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 drivers/spi/spi.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 4d1b9f5..49f6666 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -760,6 +760,20 @@ EXPORT_SYMBOL_GPL(spi_setup);
 static int __spi_async(struct spi_device *spi, struct spi_message *message)
 {
 	struct spi_master *master = spi->master;
+	struct spi_transfer *xfer;
+
+	/* check if number of bytes relates to bits per word mode */
+	list_for_each_entry(xfer, &message->transfers, transfer_list) {
+		u8 bpw = xfer->bits_per_word ?
+				xfer->bits_per_word : spi->bits_per_word;
+
+		dev_WARN_ONCE(&spi->dev,
+				((bpw == 16 && (xfer->len & 1)) ||
+				(bpw == 32 && (xfer->len & 3))),
+				"incorrect number of bytes detected: "
+				"bpw=%u xfer->len=%u", bpw, xfer->len);
+
+	}
 
 	/* Half-duplex links include original MicroWire, and ones with
 	 * only one data pin like SPI_3WIRE (switches direction) or where
@@ -768,7 +782,6 @@ static int __spi_async(struct spi_device *spi, struct spi_message *message)
 	 */
 	if ((master->flags & SPI_MASTER_HALF_DUPLEX)
 			|| (spi->mode & SPI_3WIRE)) {
-		struct spi_transfer *xfer;
 		unsigned flags = master->flags;
 
 		list_for_each_entry(xfer, &message->transfers, transfer_list) {
-- 
1.7.6.2



--
Scanned by MailScanner.


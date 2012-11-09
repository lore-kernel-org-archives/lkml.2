Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2KIJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:09:56 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5210 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2KIJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:09:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 09 Nov 2012 00:56:08 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <broonie@opensource.wolfsonmicro.com>
CC: <swarren@nvidia.com>, <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] spi: make sure all transfer has bits_per_word set
Date: Fri, 9 Nov 2012 14:36:45 +0530
Message-ID: <1352452005-13789-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When spi client does the spi transfer and does not sets
the bits_per_word for each transfer then set it as default
of spi device in spi core before calling low level transfer.

Removing the similar code from spi-tegra20-slink driver as
it is not required.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
---
When reviewing the change
	[PATCH] spi: tegra: add spi driver for SLINK controller
it was suggested by Mark and Stephen that we should move the
bits_per_word setting to the core as it almost exist in all driver.
Creating this patch for doing this.

Creating teh patch 
 drivers/spi/spi-tegra20-slink.c |    3 +--
 drivers/spi/spi.c               |   11 ++++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index b8985be..07dc735 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -727,8 +727,7 @@ static int tegra_slink_start_transfer_one(struct spi_device *spi,
 	unsigned long command;
 	unsigned long command2;
 
-	bits_per_word = t->bits_per_word ? t->bits_per_word :
-					spi->bits_per_word;
+	bits_per_word = t->bits_per_word;
 	speed = t->speed_hz ? t->speed_hz : spi->max_speed_hz;
 	if (!speed)
 		speed = tspi->spi_max_frequency;
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index fc0da39..6891a03 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1193,6 +1193,7 @@ EXPORT_SYMBOL_GPL(spi_setup);
 static int __spi_async(struct spi_device *spi, struct spi_message *message)
 {
 	struct spi_master *master = spi->master;
+	struct spi_transfer *xfer;
 
 	/* Half-duplex links include original MicroWire, and ones with
 	 * only one data pin like SPI_3WIRE (switches direction) or where
@@ -1201,7 +1202,6 @@ static int __spi_async(struct spi_device *spi, struct spi_message *message)
 	 */
 	if ((master->flags & SPI_MASTER_HALF_DUPLEX)
 			|| (spi->mode & SPI_3WIRE)) {
-		struct spi_transfer *xfer;
 		unsigned flags = master->flags;
 
 		list_for_each_entry(xfer, &message->transfers, transfer_list) {
@@ -1214,6 +1214,15 @@ static int __spi_async(struct spi_device *spi, struct spi_message *message)
 		}
 	}
 
+	/**
+	 * Set transfer bits_per_word as spi device default if it is not
+	 * set for this transfer.
+	 */
+	list_for_each_entry(xfer, &message->transfers, transfer_list) {
+		if (!xfer->bits_per_word)
+			xfer->bits_per_word = spi->bits_per_word;
+	}
+
 	message->spi = spi;
 	message->status = -EINPROGRESS;
 	return master->transfer(spi, message);
-- 
1.7.1.1


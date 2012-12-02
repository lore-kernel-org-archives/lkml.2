Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2LBDyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 22:54:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56623 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709Ab2LBDye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 22:54:34 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] spi: Remove SPI_BUFSIZ restriction on spi_write_then_read()
Date: Sun,  2 Dec 2012 12:54:25 +0900
Message-Id: <1354420465-29315-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid constantly allocating and deallocating there is a fixed
buffer which spi_write_then_read() uses for transfers, with an early error
check to ensure that the transfer fits within the buffer. This limits the
size of transfers to this size, currently max(32, SMP_CACHE_BYTES).

Since we can dynamically allocate and in fact already have a fallback
to do so when there is contention for the fixed buffer remove this
restriction and instead dynamically allocate a suitably sized buffer if
the transfer won't fit.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index c4f7d71..224b7bc 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1646,12 +1646,18 @@ int spi_write_then_read(struct spi_device *spi,
 	struct spi_transfer	x[2];
 	u8			*local_buf;
 
-	/* Use preallocated DMA-safe buffer.  We can't avoid copying here,
-	 * (as a pure convenience thing), but we can keep heap costs
-	 * out of the hot path ...
+	/* Use preallocated DMA-safe buffer if we can.  We can't avoid
+	 * copying here, (as a pure convenience thing), but we can
+	 * keep heap costs out of the hot path unless someone else is
+	 * using the pre-allocated buffer or the transfer is too large.
 	 */
-	if ((n_tx + n_rx) > SPI_BUFSIZ)
-		return -EINVAL;
+	if ((n_tx + n_rx) > SPI_BUFSIZ || !mutex_trylock(&lock)) {
+		local_buf = kmalloc(max(SPI_BUFSIZ, n_tx + n_rx), GFP_KERNEL);
+		if (!local_buf)
+			return -ENOMEM;
+	} else {
+		local_buf = buf;
+	}
 
 	spi_message_init(&message);
 	memset(x, 0, sizeof x);
@@ -1664,14 +1670,6 @@ int spi_write_then_read(struct spi_device *spi,
 		spi_message_add_tail(&x[1], &message);
 	}
 
-	/* ... unless someone else is using the pre-allocated buffer */
-	if (!mutex_trylock(&lock)) {
-		local_buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
-		if (!local_buf)
-			return -ENOMEM;
-	} else
-		local_buf = buf;
-
 	memcpy(local_buf, txbuf, n_tx);
 	x[0].tx_buf = local_buf;
 	x[1].rx_buf = local_buf + n_tx;
-- 
1.7.10.4


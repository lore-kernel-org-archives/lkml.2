Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1BGT6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:58:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:39062 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab1BGT5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:57:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="600292956"
From: Russ Gorby <russ.gorby@intel.com>
To: Russ Gorby <russ.gorby@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 5/6] serial: ifx6x60: probe routine needs to call spi_setup
Date: Mon,  7 Feb 2011 12:02:31 -0800
Message-Id: <1297108952-27371-6-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
References: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe routine should call spi_setup() to configure
the SPI bus so it can properly communicate with the device.
E.g. the device operates in SPI mode 1.

Called spi_setup to configure SPI mode, max_speed_hz, and bpw

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/serial/ifx6x60.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 766f0c3..59e9cb8 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -67,6 +67,7 @@
 #define IFX_SPI_MORE_MASK		0x10
 #define IFX_SPI_MORE_BIT		12	/* bit position in u16 */
 #define IFX_SPI_CTS_BIT			13	/* bit position in u16 */
+#define IFX_SPI_MODE			SPI_MODE_1
 #define IFX_SPI_TTY_ID			0
 #define IFX_SPI_TIMEOUT_SEC		2
 #define IFX_SPI_HEADER_0		(-1)
@@ -992,7 +993,15 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 	ifx_dev->modem = pl_data->modem_type;
 	ifx_dev->use_dma = pl_data->use_dma;
 	ifx_dev->max_hz = pl_data->max_hz;
+	/* initialize spi mode, etc */
 	spi->max_speed_hz = ifx_dev->max_hz;
+	spi->mode = IFX_SPI_MODE | (SPI_LOOP & spi->mode);
+	spi->bits_per_word = spi_bpw;
+	ret = spi_setup(spi);
+	if (ret) {
+		dev_err(&spi->dev, "SPI setup wasn't successful %d", ret);
+		return -ENODEV;
+	}
 
 	/* ensure SPI protocol flags are initialized to enable transfer */
 	ifx_dev->spi_more = 0;
-- 
1.7.3.4


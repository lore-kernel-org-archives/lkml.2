Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1AFAEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:04:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:60668 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab1AFAES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:04:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="874833919"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg@vger.kernel.org, Kroah-Hartman@vger.kernel.org, <gregkh@suse.de>,
        Vasiliy@vger.kernel.org, Kulikov@vger.kernel.org,
        <segoon@openwall.com>, Alan@vger.kernel.org, Cox@vger.kernel.org,
        <alan@linux.intel.com>, Russ@vger.kernel.org, Gorby@vger.kernel.org,
        <richardx.r.gorby@intel.com>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 5/7] serial: ifx6x60: probe routine needs to call spi_setup
Date: Wed,  5 Jan 2011 16:05:11 -0800
Message-Id: <1294272313-15899-6-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe routine should call spi_setup() to configure
the SPI bus so it can properly communicate with the device.
E.g. the device operates in SPI mode 1.

Called spi_setup to configure SPI mode, max_speed_hz, and bpw

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/serial/ifx6x60.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/ifx6x60.c b/drivers/serial/ifx6x60.c
index b54a990..6dfb47a 100644
--- a/drivers/serial/ifx6x60.c
+++ b/drivers/serial/ifx6x60.c
@@ -67,6 +67,7 @@
 #define IFX_SPI_MORE_MASK		0x10
 #define IFX_SPI_MORE_BIT		12	/* bit position in u16 */
 #define IFX_SPI_CTS_BIT			13	/* bit position in u16 */
+#define IFX_SPI_MODE			SPI_MODE_1
 #define IFX_SPI_TTY_ID			0
 #define IFX_SPI_TIMEOUT_SEC		2
 #define IFX_SPI_HEADER_0		(-1)
@@ -984,10 +985,18 @@ static int ifx_spi_spi_probe(struct spi_device *spi)
 	ifx_dev->spi_timer.function = ifx_spi_timeout;
 	ifx_dev->spi_timer.data = (unsigned long)ifx_dev;
 	ifx_dev->is_6160 = pl_data->is_6160;
+	/* initialize spi mode, etc */
 	if (ifx_dev->is_6160)
 		spi->max_speed_hz = 12500000;
 	else
 		spi->max_speed_hz = 25000000;
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
1.7.2.3


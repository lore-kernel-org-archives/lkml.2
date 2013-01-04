Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3ADSsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 13:48:35 -0500
Received: from [216.228.121.35] ([216.228.121.35]:10334 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3ADSsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 13:48:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 Jan 2013 10:43:32 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>
CC: <spi-devel-general@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <swarren@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] spi: tegra: remove checks for valid speed
Date: Sat, 5 Jan 2013 00:17:15 +0530
Message-ID: <1357325235-25485-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357325235-25485-1-git-send-email-ldewangan@nvidia.com>
References: <1357325235-25485-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPI core make sure that all transfer has proper speed set
before calling low level spi transfer. Hence, it is not
require to have check in spi driver.

Remove the check for speed validity from transfer and use it directly.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/spi/spi-tegra20-sflash.c |   14 +++++++++++---
 drivers/spi/spi-tegra20-slink.c  |    6 +++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index 448a8cc..9a42c15 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -269,9 +269,7 @@ static int tegra_sflash_start_transfer_one(struct spi_device *spi,
 	u32 speed;
 	unsigned long command;
 
-	speed = t->speed_hz ? t->speed_hz : spi->max_speed_hz;
-	if (!speed)
-		speed = tsd->spi_max_frequency;
+	speed = t->speed_hz;
 	if (speed != tsd->cur_speed) {
 		clk_set_rate(tsd->clk, speed);
 		tsd->cur_speed = speed;
@@ -319,6 +317,15 @@ static int tegra_sflash_start_transfer_one(struct spi_device *spi,
 	return  tegra_sflash_start_cpu_based_transfer(tsd, t);
 }
 
+static int tegra_sflash_setup(struct spi_device *spi)
+{
+	struct tegra_sflash_data *tsd = spi_master_get_devdata(spi->master);
+
+	/* Set speed to the spi max fequency if spi device has not set */
+	spi->max_speed_hz = spi->max_speed_hz ? : tsd->spi_max_frequency;
+	return 0;
+}
+
 static int tegra_sflash_transfer_one_message(struct spi_master *master,
 			struct spi_message *msg)
 {
@@ -492,6 +499,7 @@ static int tegra_sflash_probe(struct platform_device *pdev)
 
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA;
+	master->setup = tegra_sflash_setup;
 	master->transfer_one_message = tegra_sflash_transfer_one_message;
 	master->num_chipselect = MAX_CHIP_SELECT;
 	master->bus_num = -1;
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 651167f..29039f1 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -728,9 +728,7 @@ static int tegra_slink_start_transfer_one(struct spi_device *spi,
 	unsigned long command2;
 
 	bits_per_word = t->bits_per_word;
-	speed = t->speed_hz ? t->speed_hz : spi->max_speed_hz;
-	if (!speed)
-		speed = tspi->spi_max_frequency;
+	speed = t->speed_hz;
 	if (speed != tspi->cur_speed) {
 		clk_set_rate(tspi->clk, speed * 4);
 		tspi->cur_speed = speed;
@@ -841,6 +839,8 @@ static int tegra_slink_setup(struct spi_device *spi)
 
 	BUG_ON(spi->chip_select >= MAX_CHIP_SELECT);
 
+	/* Set speed to the spi max fequency if spi device has not set */
+	spi->max_speed_hz = spi->max_speed_hz ? : tspi->spi_max_frequency;
 	ret = pm_runtime_get_sync(tspi->dev);
 	if (ret < 0) {
 		dev_err(tspi->dev, "pm runtime failed, e = %d\n", ret);
-- 
1.7.1.1


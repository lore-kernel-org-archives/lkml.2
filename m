Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0JPVUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 17:20:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47325 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab0JPVUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 17:20:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-mmc@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <avorontsov@mvista.com>,
        Ernst Schwab <eschwab@online.de>, Sonic Zhang <sonic.zhang@analog.com>,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH] MMC:mmc_spi: Recover from CRC error for SD read/write operation over SPI.
Date: Sat, 16 Oct 2010 17:19:36 -0400
Message-Id: <1287263976-9578-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20100827203639.GT23079@void.printf.net>
References: <20100827203639.GT23079@void.printf.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

SPI bus is not reliable on all platforms when doing large data transfer.
Current mmc spi driver fails SD read/write command immediately, if
occasional CRC error is reported by SD device. This patch makes the
operation recover from the CRC error by doing last SD command again.
The retry count is set to 5 to ensure the driver pass any stress test.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
[cjb: fixed merge conflict against current Linus]
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Andrew: we posted this months ago with no feedback ... could you pick it up ?

 drivers/mmc/host/mmc_spi.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 62a3582..fbd673e 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1055,6 +1055,8 @@ static void mmc_spi_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct mmc_spi_host	*host = mmc_priv(mmc);
 	int			status = -EINVAL;
+	int			crc_retry = 5;
+	struct mmc_command	stop;
 
 #ifdef DEBUG
 	/* MMC core and layered drivers *MUST* issue SPI-aware commands */
@@ -1087,10 +1089,30 @@ static void mmc_spi_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	/* request exclusive bus access */
 	spi_bus_lock(host->spi->master);
 
+ crc_recover:
 	/* issue command; then optionally data and stop */
 	status = mmc_spi_command_send(host, mrq, mrq->cmd, mrq->data != NULL);
 	if (status == 0 && mrq->data) {
 		mmc_spi_data_do(host, mrq->cmd, mrq->data, mrq->data->blksz);
+
+		/*
+		 * SPI bus is not reliable when doing large data transfer.
+		 * If occasional crc error is reported by SD device when do
+		 * data read/write over SPI, it can be recovered by doing
+		 * last SD command again. The retry count is set to 5 to
+		 * ensure the driver pass any stress test.
+		 */
+		if (mrq->data->error == -EILSEQ && crc_retry) {
+			stop.opcode = MMC_STOP_TRANSMISSION;
+			stop.arg = 0;
+			stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
+
+			status = mmc_spi_command_send(host, mrq, &stop, 0);
+			crc_retry--;
+			mrq->data->error = 0;
+			goto crc_recover;
+		}
+
 		if (mrq->stop)
 			status = mmc_spi_command_send(host, mrq, mrq->stop, 0);
 		else
-- 
1.7.3.1


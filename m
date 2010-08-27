Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0H0Ugp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:36:45 -0400
Received: from void.printf.net ([89.145.121.20]:51085 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab0H0Ugn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:36:43 -0400
Date: Fri, 27 Aug 2010 21:36:39 +0100
From: Chris Ball <cjb@laptop.org>
To: sonic zhang <sonic.adi@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <avorontsov@mvista.com>,
        Ernst Schwab <eschwab@online.de>, linux-mmc@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: [PATCH RESEND] MMC:mmc_spi: Recover from CRC error for SD
	read/write operation over SPI.
Message-ID: <20100827203639.GT23079@void.printf.net>
References: <1278921056.22437.1.camel@eight.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278921056.22437.1.camel@eight.analog.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There were no comments about this patch -- Andrew, please take it if
there are no objections.

From: Sonic Zhang <sonic.zhang@analog.com>
Date: Mon, 12 Jul 2010 15:50:56 +0800
Subject: [PATCH] mmc_spi: Recover from CRC error for SD read/write operation over SPI.

SPI bus is not reliable on all platforms when doing large data transfer.
Current mmc spi driver fails SD read/write command immediately, if
occasional CRC error is reported by SD device. This patch makes the
operation recover from the CRC error by doing last SD command again.
The retry count is set to 5 to ensure the driver pass any stress test.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
[cjb: fixed merge conflict against current Linus]
Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/mmc_spi.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 62a3582..3d48e21 100644
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
@@ -1087,10 +1089,29 @@ static void mmc_spi_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	/* request exclusive bus access */
 	spi_bus_lock(host->spi->master);
 
+crc_recover:
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
1.7.0.1

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

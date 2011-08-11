Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1HKKzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:55:33 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:26587
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464Ab1HKKzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:55:31 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <spi-devel-general@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] spi:spi_bfin5xx: SPI SSEL deasserted too early in soft irq mode.
Date: Thu, 11 Aug 2011 18:49:21 +0800
Message-ID: <1313059761-24703-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Poll the FIFO till it is empty before deassert SSEL in pump_transfers in
soft irq mode. No polling is necessary in interrupt mode and error handling.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/spi/spi-bfin5xx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-bfin5xx.c b/drivers/spi/spi-bfin5xx.c
index b8d25f2..b9e7e4d 100644
--- a/drivers/spi/spi-bfin5xx.c
+++ b/drivers/spi/spi-bfin5xx.c
@@ -870,8 +870,10 @@ static void bfin_spi_pump_transfers(unsigned long data)
 		message->actual_length += drv_data->len_in_bytes;
 		/* Move to next transfer of this msg */
 		message->state = bfin_spi_next_transfer(drv_data);
-		if (drv_data->cs_change)
+		if (drv_data->cs_change) {
+			bfin_spi_flush(drv_data);
 			bfin_spi_cs_deactive(drv_data, chip);
+		}
 	}
 
 	/* Schedule next transfer tasklet */
-- 
1.7.0.4



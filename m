Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1FXNKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:10:37 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2886 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab1FXNKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:10:35 -0400
Message-ID: <4E0488EE.5040706@imgtec.com>
Date: Fri, 24 Jun 2011 13:54:06 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Fleming <matt@console-pimps.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, james@albanarts.com
Subject: [PATCH 1/6] mmc: dw_mmc: clear TXDR/RXDR ints before enabling
References: <4E0488A9.6050109@imgtec.com>
In-Reply-To: <4E0488A9.6050109@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2011 12:54:07.0445 (UTC) FILETIME=[CDEAE850:01CC326D]
X-SEF-Processed: 7_3_0_01158__2011_06_24_13_54_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA is only used for transactions exceeding a certain length, otherwise
PIO is used. The TXDR and RXDR interrupts are masked when in DMA mode
but still fire. When switching to PIO mode (e.g. to get SCR field when
an SD card is inserted) these interrupts are not cleared and so they
trigger the ISR as soon as they are unmasked. If the previous DMA did a
write, then the ISR will handle the TXDR interrupt even if the
transaction is a read, completing the transaction without modifying the
read buffer.

This is fixed primarily by clearing these two interrupts before
unmasking them when setting up PIO mode, and also by making the ISR more
robust by only handling TXDR/RXDR in the correct read/write direction.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/mmc/host/dw_mmc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 22be372..08c0592 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -497,6 +497,7 @@ static void dw_mci_submit_data(struct dw_mci *host, struct mmc_data *data)
 		else
 			host->dir_status = DW_MCI_SEND_STATUS;
 
+		mci_writel(host, RINTSTS, SDMMC_INT_TXDR | SDMMC_INT_RXDR);
 		temp = mci_readl(host, INTMASK);
 		temp |= SDMMC_INT_TXDR | SDMMC_INT_RXDR;
 		mci_writel(host, INTMASK, temp);
@@ -1230,13 +1231,13 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 
 		if (pending & SDMMC_INT_RXDR) {
 			mci_writel(host, RINTSTS, SDMMC_INT_RXDR);
-			if (host->sg)
+			if (host->dir_status == DW_MCI_RECV_STATUS && host->sg)
 				dw_mci_read_data_pio(host);
 		}
 
 		if (pending & SDMMC_INT_TXDR) {
 			mci_writel(host, RINTSTS, SDMMC_INT_TXDR);
-			if (host->sg)
+			if (host->dir_status == DW_MCI_SEND_STATUS && host->sg)
 				dw_mci_write_data_pio(host);
 		}
 
-- 
1.7.2.3



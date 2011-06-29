Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1F2Iax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:30:53 -0400
Received: from multi.imgtec.com ([194.200.65.239]:62066 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1F2Iau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:30:50 -0400
Message-ID: <4E0AE2B7.3020006@imgtec.com>
Date: Wed, 29 Jun 2011 09:30:47 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chris Ball <cjb@laptop.org>, Will <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] mmc: dw_mmc: reset FIFO after an error
References: <4E0AE1FC.3070201@imgtec.com>
In-Reply-To: <4E0AE1FC.3070201@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2011 08:30:48.0103 (UTC) FILETIME=[D8D76370:01CC3636]
X-SEF-Processed: 7_3_0_01158__2011_06_29_09_30_48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an error occurs mid way through a transaction (such as a missing CRC
status response after the 2nd block written out of 3), then the FIFO may
still contain data which will interfere with the next transaction.
Therefore after an error has been detected, reset the fifo using the
CTRL register.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/mmc/host/dw_mmc.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 0dac397..0c839d3 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -849,7 +849,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 	struct mmc_command *cmd;
 	enum dw_mci_state state;
 	enum dw_mci_state prev_state;
-	u32 status;
+	u32 status, ctrl;
 
 	spin_lock(&host->lock);
 
@@ -929,6 +929,16 @@ static void dw_mci_tasklet_func(unsigned long priv)
 						status);
 					data->error = -EIO;
 				}
+				/*
+				 * After an error, there may be data lingering
+				 * in the FIFO, so reset it - doing so
+				 * generates a block interrupt, hence setting
+				 * the scatter-gather pointer to NULL.
+				 */
+				host->sg = NULL;
+				ctrl = mci_readl(host, CTRL);
+				ctrl |= SDMMC_CTRL_FIFO_RESET;
+				mci_writel(host, CTRL, ctrl);
 			} else {
 				data->bytes_xfered = data->blocks * data->blksz;
 				data->error = 0;
-- 
1.7.2.3



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab2GFK1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:27:47 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:7365 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab2GFK1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:27:46 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-mmc@vger.kernel.org, Ludovic.Desroches@atmel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH] mmc: atmel-mci: fix incorrect setting of host->data to NULL
Date: Fri,  6 Jul 2012 11:58:33 +0200
Message-Id: <1341568713-8869-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting host->data to NULL is incorrect sequence in STATE_SENDING_STOP
state of FSM: This early setting leads to the skip of dma_unmap_sg()
in atmci_dma_cleanup() which is a bug.

Idea taken form dw_mmc by Seungwon Jeon.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/mmc/host/atmel-mci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 78e5326..2ce109d 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1860,7 +1860,6 @@ static void atmci_tasklet_func(unsigned long priv)
 
 			dev_dbg(&host->pdev->dev, "FSM: cmd ready\n");
 			host->cmd = NULL;
-			host->data = NULL;
 			data->bytes_xfered = data->blocks * data->blksz;
 			data->error = 0;
 			atmci_command_complete(host, mrq->stop);
@@ -1874,6 +1873,7 @@ static void atmci_tasklet_func(unsigned long priv)
 				atmci_writel(host, ATMCI_IER, ATMCI_NOTBUSY);
 				state = STATE_WAITING_NOTBUSY;
 			}
+			host->data = NULL;
 			break;
 
 		case STATE_END_REQUEST:
-- 
1.7.5.4


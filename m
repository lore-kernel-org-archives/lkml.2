Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1FXNLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:11:11 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2635 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab1FXNLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:11:07 -0400
Message-ID: <4E04892E.406@imgtec.com>
Date: Fri, 24 Jun 2011 13:55:10 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Fleming <matt@console-pimps.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, james@albanarts.com
Subject: [PATCH 2/6] mmc: dw_mmc: fix race with request and removal
References: <4E0488A9.6050109@imgtec.com>
In-Reply-To: <4E0488A9.6050109@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2011 12:55:11.0366 (UTC) FILETIME=[F4047A60:01CC326D]
X-SEF-Processed: 7_3_0_01158__2011_06_24_13_55_13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a request is made, the card presence is checked and the request is
queued. These two parts must be atomic with respect to card removal, or
a card removal could be handled in between, and the new request wouldn't
get cancelled until another card was inserted. Therefore move the
spinlock protection from dw_mci_queue_request() up into dw_mci_request()
to cover the presence check.

Note that the test_bit() used for the presence check isn't atomic
itself, so should have been protected by a spinlock anyway.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/mmc/host/dw_mmc.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 08c0592..c4bddf6 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -625,13 +625,13 @@ static void dw_mci_start_request(struct dw_mci *host,
 		host->stop_cmdr = dw_mci_prepare_command(slot->mmc, mrq->stop);
 }
 
+/* must be called with host->lock held */
 static void dw_mci_queue_request(struct dw_mci *host, struct dw_mci_slot *slot,
 				 struct mmc_request *mrq)
 {
 	dev_vdbg(&slot->mmc->class_dev, "queue request: state=%d\n",
 		 host->state);
 
-	spin_lock_bh(&host->lock);
 	slot->mrq = mrq;
 
 	if (host->state == STATE_IDLE) {
@@ -640,8 +640,6 @@ static void dw_mci_queue_request(struct dw_mci *host, struct dw_mci_slot *slot,
 	} else {
 		list_add_tail(&slot->queue_node, &host->queue);
 	}
-
-	spin_unlock_bh(&host->lock);
 }
 
 static void dw_mci_request(struct mmc_host *mmc, struct mmc_request *mrq)
@@ -651,14 +649,23 @@ static void dw_mci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	WARN_ON(slot->mrq);
 
+	/*
+	 * The check for card presence and queueing of the request must be
+	 * atomic, otherwise the card could be removed in between and the
+	 * request wouldn't fail until another card was inserted.
+	 */
+	spin_lock_bh(&host->lock);
+
 	if (!test_bit(DW_MMC_CARD_PRESENT, &slot->flags)) {
+		spin_unlock_bh(&host->lock);
 		mrq->cmd->error = -ENOMEDIUM;
 		mmc_request_done(mmc, mrq);
 		return;
 	}
 
-	/* We don't support multiple blocks of weird lengths. */
 	dw_mci_queue_request(host, slot, mrq);
+
+	spin_unlock_bh(&host->lock);
 }
 
 static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
-- 
1.7.2.3


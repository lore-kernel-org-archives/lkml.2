Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2LVB6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:58:38 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34664 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2LVB6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:33 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, linux-mmc@vger.kernel.org
Subject: [PATCH 18/25] TMIO MMC: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:08 -0800
Message-Id: <1356141435-17340-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from tmio mmc.  Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: linux-mmc@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/mmc/host/tmio_mmc_pio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index 50bf495..f4f18b3 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -573,8 +573,7 @@ static bool __tmio_mmc_card_detect_irq(struct tmio_mmc_host *host,
 		tmio_mmc_ack_mmc_irqs(host, TMIO_STAT_CARD_INSERT |
 			TMIO_STAT_CARD_REMOVE);
 		if ((((ireg & TMIO_STAT_CARD_REMOVE) && mmc->card) ||
-		     ((ireg & TMIO_STAT_CARD_INSERT) && !mmc->card)) &&
-		    !work_pending(&mmc->detect.work))
+		     ((ireg & TMIO_STAT_CARD_INSERT) && !mmc->card)))
 			mmc_detect_change(host->mmc, msecs_to_jiffies(100));
 		return true;
 	}
-- 
1.8.0.2


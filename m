Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2IQMUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 08:20:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45802 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab2IQMU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:20:28 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: cjb@laptop.org
Cc: will.newton@imgtec.com, tgih.jun@samsung.com, jh80.chung@samsung.com,
        kyungmin.park@samsung.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH v2 1/4] drivers/mmc/host/dw_mmc.c: fix error return code
Date: Mon, 17 Sep 2012 14:20:17 +0200
Message-Id: <1347884417-26754-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
References: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/mmc/host/dw_mmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 36f98c0..43a2663 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2039,8 +2039,10 @@ int dw_mci_probe(struct dw_mci *host)
 	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
 	host->card_workqueue = alloc_workqueue("dw-mci-card",
 			WQ_MEM_RECLAIM | WQ_NON_REENTRANT, 1);
-	if (!host->card_workqueue)
+	if (!host->card_workqueue) {
+		ret = -ENOMEM;
 		goto err_dmaunmap;
+	}
 	INIT_WORK(&host->card_work, dw_mci_work_routine_card);
 	ret = request_irq(host->irq, dw_mci_interrupt, host->irq_flags, "dw-mci", host);
 	if (ret)
-- 
1.7.11.4


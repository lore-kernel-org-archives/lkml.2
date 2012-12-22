Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2LVCDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:03:24 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:50530 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2LVB6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:06 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Dan Williams <dcbw@redhat.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/25] libertas: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:56:56 -0800
Message-Id: <1356141435-17340-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* delayed_work_pending() test in lbs_cfg_scan() is spurious as
  priv->scan_req can't be NULL w/ scan_work pending; otherwise,
  lbs_scan_worker() will segfault.  Drop it.  BTW, the synchronization
  around scan_work seems racy.  There's nothing synchronizing accesses
  to scan related fields in lbs_private.

* Drop work_pending() test from if_sdio_reset_card().  As
  work_pending() becomes %false before if_sdio_reset_card_worker()
  starts executing, it doesn't really protect anything.  reset_host
  may change between mmc_remove_host() and mmc_add_host().  Make
  if_sdio_reset_card_worker() cache the target mmc_host so that it
  isn't affected by if_sdio_reset_card() racing with it.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dan Williams <dcbw@redhat.com>
Cc: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/net/wireless/libertas/cfg.c     | 2 +-
 drivers/net/wireless/libertas/if_sdio.c | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index ec6d5d6..ec30cd1 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -814,7 +814,7 @@ static int lbs_cfg_scan(struct wiphy *wiphy,
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
-	if (priv->scan_req || delayed_work_pending(&priv->scan_work)) {
+	if (priv->scan_req) {
 		/* old scan request not yet processed */
 		ret = -EAGAIN;
 		goto out;
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 739309e..8c53c17 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1074,6 +1074,8 @@ static struct mmc_host *reset_host;
 
 static void if_sdio_reset_card_worker(struct work_struct *work)
 {
+	struct mmc_host *target = reset_host;
+
 	/*
 	 * The actual reset operation must be run outside of lbs_thread. This
 	 * is because mmc_remove_host() will cause the device to be instantly
@@ -1085,8 +1087,8 @@ static void if_sdio_reset_card_worker(struct work_struct *work)
 	 */
 
 	pr_info("Resetting card...");
-	mmc_remove_host(reset_host);
-	mmc_add_host(reset_host);
+	mmc_remove_host(target);
+	mmc_add_host(target);
 }
 static DECLARE_WORK(card_reset_work, if_sdio_reset_card_worker);
 
@@ -1094,9 +1096,6 @@ static void if_sdio_reset_card(struct lbs_private *priv)
 {
 	struct if_sdio_card *card = priv->card;
 
-	if (work_pending(&card_reset_work))
-		return;
-
 	reset_host = card->func->card->host;
 	schedule_work(&card_reset_work);
 }
-- 
1.8.0.2


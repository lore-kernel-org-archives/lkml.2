Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3ABDt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 22:49:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53874 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3ABDt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 22:49:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        netdev@vger.kernel.org, Stable <stable@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        ath9k-devel@lists.ath9k.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k_htc: Fix skb leaks
Date: Tue,  1 Jan 2013 21:49:27 -0600
Message-Id: <1357098567-8558-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running with kmemleak shows that this driver leaks every skb allocated in
routine htc_connect_service() whether the service connection succeeds or
fails.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/htc_hst.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 4a9570d..a304748 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -278,10 +278,12 @@ int htc_connect_service(struct htc_target *target,
 	if (!time_left) {
 		dev_err(target->dev, "Service connection timeout for: %d\n",
 			service_connreq->service_id);
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto err;
 	}
 
 	*conn_rsp_epid = target->conn_rsp_epid;
+	kfree_skb(skb);
 	return 0;
 err:
 	kfree_skb(skb);
-- 
1.7.10.4


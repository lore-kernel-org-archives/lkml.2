Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab1IATG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:06:28 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:36037
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757498Ab1IATGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:06:17 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 07/10] staging: hv: fix counting of available buffer slots when send fails
Date: Thu,  1 Sep 2011 12:19:45 -0700
Message-Id: <1314904788-32746-8-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
References: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the number of available buffer slots doesn't decrease for failed
sends, we should not call netvsc_xmit_completion(), which increase the
count of available slots. In this failed case, just free the memory is
enough.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index b49a08f..81e3c49 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -190,7 +190,8 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	} else {
 		/* we are shutting down or bus overloaded, just drop packet */
 		net->stats.tx_dropped++;
-		netvsc_xmit_completion(packet);
+		kfree(packet);
+		dev_kfree_skb_any(skb);
 	}
 
 	return NETDEV_TX_OK;
-- 
1.6.3.2


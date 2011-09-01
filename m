Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab1IATG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:06:27 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:54790
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757144Ab1IATGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:06:17 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: stable <stable@kernel.org>
Subject: [PATCH 04/10] staging: hv: fix a kernel warning in netvsc_linkstatus_callback()
Date: Thu,  1 Sep 2011 12:19:42 -0700
Message-Id: <1314904788-32746-5-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
References: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netif_notify_peers() caused a kernel warning in netvsc_linkstatus_callback(),
because netvsc_linkstatus_callback() is within IRQ context. So we move
the first call to netif_notify_peers() into queued work as well, but with
zero delay.

In addition to "staging-next", this should also be back-ported to stable
kernels 2.6.32 and later.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: stable <stable@kernel.org>
---
 drivers/staging/hv/netvsc_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 30a0cb2..e6513be 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -214,8 +214,8 @@ void netvsc_linkstatus_callback(struct hv_device *device_obj,
 	if (status == 1) {
 		netif_carrier_on(net);
 		netif_wake_queue(net);
-		netif_notify_peers(net);
 		ndev_ctx = netdev_priv(net);
+		schedule_delayed_work(&ndev_ctx->dwork, 0);
 		schedule_delayed_work(&ndev_ctx->dwork, msecs_to_jiffies(20));
 	} else {
 		netif_carrier_off(net);
-- 
1.6.3.2


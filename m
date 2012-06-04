Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933Ab2FDQbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:31:03 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51609
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755294Ab2FDQbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:31:01 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [PATCH] net/hyperv: Use wait_event on outstanding sends during device removal
Date: Mon,  4 Jun 2012 09:42:38 -0700
Message-Id: <1338828158-3133-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the busy-waiting/udelay to wait_event on outstanding sends.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |    1 +
 drivers/net/hyperv/netvsc.c     |   12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 4ffcd57..2857ab0 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -478,6 +478,7 @@ struct netvsc_device {
 	u32 nvsp_version;
 
 	atomic_t num_outstanding_sends;
+	wait_queue_head_t wait_drain;
 	bool start_remove;
 	bool destroy;
 	/*
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 8b91947..0c56983 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -42,6 +42,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	if (!net_device)
 		return NULL;
 
+	init_waitqueue_head(&net_device->wait_drain);
 	net_device->start_remove = false;
 	net_device->destroy = false;
 	net_device->dev = device;
@@ -387,12 +388,8 @@ int netvsc_device_remove(struct hv_device *device)
 	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
 
 	/* Wait for all send completions */
-	while (atomic_read(&net_device->num_outstanding_sends)) {
-		dev_info(&device->device,
-			"waiting for %d requests to complete...\n",
-			atomic_read(&net_device->num_outstanding_sends));
-		udelay(100);
-	}
+	wait_event(net_device->wait_drain,
+		   atomic_read(&net_device->num_outstanding_sends) == 0);
 
 	netvsc_disconnect_vsp(net_device);
 
@@ -486,6 +483,9 @@ static void netvsc_send_completion(struct hv_device *device,
 		num_outstanding_sends =
 			atomic_dec_return(&net_device->num_outstanding_sends);
 
+		if (net_device->destroy && num_outstanding_sends == 0)
+			wake_up(&net_device->wait_drain);
+
 		if (netif_queue_stopped(ndev) && !net_device->start_remove &&
 			(hv_ringbuf_avail_percent(&device->channel->outbound)
 			> RING_AVAIL_PERCENT_HIWATER ||
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab1EFAsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:48:37 -0400
Received: from kroah.org ([198.145.64.141]:37007 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab1EFAZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:13 2011
Message-Id: <20110506002213.651877852@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bruce Rogers <brogers@novell.com>, Olaf Kirch <okir@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [086/143] virtio_net: Add schedule check to napi_enable call
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Bruce Rogers <brogers@novell.com>

commit 3e9d08ec0a68f6faf718d5a7e050fe5ca0ba004f upstream.

Under harsh testing conditions, including low memory, the guest would
stop receiving packets. With this patch applied we no longer see any
problems in the driver while performing these tests for extended periods
of time.

Make sure napi is scheduled subsequent to each napi_enable.

Signed-off-by: Bruce Rogers <brogers@novell.com>
Signed-off-by: Olaf Kirch <okir@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[bwh: Adjust for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/virtio_net.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -391,6 +391,20 @@ static void skb_recv_done(struct virtque
 	}
 }
 
+static void virtnet_napi_enable(struct virtnet_info *vi)
+{
+	napi_enable(&vi->napi);
+
+	/* If all buffers were filled by other side before we napi_enabled, we
+	 * won't get another interrupt, so process any outstanding packets
+	 * now.  virtnet_poll wants re-enable the queue, so we disable here.
+	 * We synchronize against interrupts via NAPI_STATE_SCHED */
+	if (napi_schedule_prep(&vi->napi)) {
+		vi->rvq->vq_ops->disable_cb(vi->rvq);
+		__napi_schedule(&vi->napi);
+	}
+}
+
 static void refill_work(struct work_struct *work)
 {
 	struct virtnet_info *vi;
@@ -399,7 +413,7 @@ static void refill_work(struct work_stru
 	vi = container_of(work, struct virtnet_info, refill.work);
 	napi_disable(&vi->napi);
 	still_empty = !try_fill_recv(vi, GFP_KERNEL);
-	napi_enable(&vi->napi);
+	virtnet_napi_enable(vi);
 
 	/* In theory, this can happen: if we don't get any buffers in
 	 * we will *never* try to fill again. */
@@ -591,16 +605,7 @@ static int virtnet_open(struct net_devic
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 
-	napi_enable(&vi->napi);
-
-	/* If all buffers were filled by other side before we napi_enabled, we
-	 * won't get another interrupt, so process any outstanding packets
-	 * now.  virtnet_poll wants re-enable the queue, so we disable here.
-	 * We synchronize against interrupts via NAPI_STATE_SCHED */
-	if (napi_schedule_prep(&vi->napi)) {
-		vi->rvq->vq_ops->disable_cb(vi->rvq);
-		__napi_schedule(&vi->napi);
-	}
+	virtnet_napi_enable(vi);
 	return 0;
 }
 



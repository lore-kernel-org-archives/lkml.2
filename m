Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab1BPAWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:45 -0500
Received: from kroah.org ([198.145.64.141]:49212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463Ab1BPAWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:41 2011
Message-Id: <20110216001441.118287698@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bruce Rogers <brogers@novell.com>, Olaf Kirch <okir@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [160/272] virtio_net: Add schedule check to napi_enable call
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/virtio_net.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -446,6 +446,20 @@ static void skb_recv_done(struct virtque
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
+		virtqueue_disable_cb(vi->rvq);
+		__napi_schedule(&vi->napi);
+	}
+}
+
 static void refill_work(struct work_struct *work)
 {
 	struct virtnet_info *vi;
@@ -454,7 +468,7 @@ static void refill_work(struct work_stru
 	vi = container_of(work, struct virtnet_info, refill.work);
 	napi_disable(&vi->napi);
 	still_empty = !try_fill_recv(vi, GFP_KERNEL);
-	napi_enable(&vi->napi);
+	virtnet_napi_enable(vi);
 
 	/* In theory, this can happen: if we don't get any buffers in
 	 * we will *never* try to fill again. */
@@ -638,16 +652,7 @@ static int virtnet_open(struct net_devic
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 
-	napi_enable(&vi->napi);
-
-	/* If all buffers were filled by other side before we napi_enabled, we
-	 * won't get another interrupt, so process any outstanding packets
-	 * now.  virtnet_poll wants re-enable the queue, so we disable here.
-	 * We synchronize against interrupts via NAPI_STATE_SCHED */
-	if (napi_schedule_prep(&vi->napi)) {
-		virtqueue_disable_cb(vi->rvq);
-		__napi_schedule(&vi->napi);
-	}
+	virtnet_napi_enable(vi);
 	return 0;
 }
 



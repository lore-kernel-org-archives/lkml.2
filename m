Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2HNBuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:50:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48650 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab2HNBuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:50:04 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@redhat.com,
        lauro.venancio@openbossa.org, jak@jak-linux.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 5/6] workqueue: deprecate system_nrt[_freezable]_wq
Date: Mon, 13 Aug 2012 18:49:45 -0700
Message-Id: <1344908986-18152-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344908986-18152-1-git-send-email-tj@kernel.org>
References: <1344908986-18152-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

system_nrt[_freezable]_wq are now spurious.  Mark them deprecated and
convert all users to system[_freezable]_wq.

If you're cc'd and wondering what's going on: Now all workqueues are
non-reentrant, so there's no reason to use system_nrt[_freezable]_wq.
Please use system[_freezable]_wq instead.

This patch doesn't make any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: David Airlie <airlied@linux.ie>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
---
 block/blk-throttle.c              |    7 +++----
 block/genhd.c                     |   10 +++++-----
 drivers/gpu/drm/drm_crtc_helper.c |    6 +++---
 drivers/hid/hid-wiimote-ext.c     |    2 +-
 drivers/mmc/core/host.c           |    4 ++--
 drivers/net/virtio_net.c          |   12 ++++++------
 include/linux/workqueue.h         |    4 ++--
 kernel/srcu.c                     |    4 ++--
 security/keys/gc.c                |    8 ++++----
 security/keys/key.c               |    2 +-
 10 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3d3dcae..a9664fa 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -180,7 +180,7 @@ static inline unsigned int total_nr_queued(struct throtl_data *td)
 
 /*
  * Worker for allocating per cpu stat for tgs. This is scheduled on the
- * system_nrt_wq once there are some groups on the alloc_list waiting for
+ * system_wq once there are some groups on the alloc_list waiting for
  * allocation.
  */
 static void tg_stats_alloc_fn(struct work_struct *work)
@@ -194,8 +194,7 @@ alloc_stats:
 		stats_cpu = alloc_percpu(struct tg_stats_cpu);
 		if (!stats_cpu) {
 			/* allocation failed, try again after some time */
-			queue_delayed_work(system_nrt_wq, dwork,
-					   msecs_to_jiffies(10));
+			schedule_delayed_work(dwork, msecs_to_jiffies(10));
 			return;
 		}
 	}
@@ -238,7 +237,7 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
 	 */
 	spin_lock_irqsave(&tg_stats_alloc_lock, flags);
 	list_add(&tg->stats_alloc_node, &tg_stats_alloc_list);
-	queue_delayed_work(system_nrt_wq, &tg_stats_alloc_work, 0);
+	schedule_delayed_work(&tg_stats_alloc_work, 0);
 	spin_unlock_irqrestore(&tg_stats_alloc_lock, flags);
 }
 
diff --git a/block/genhd.c b/block/genhd.c
index 5d8b44a..a2f3d6a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1490,9 +1490,9 @@ static void __disk_unblock_events(struct gendisk *disk, bool check_now)
 	intv = disk_events_poll_jiffies(disk);
 	set_timer_slack(&ev->dwork.timer, intv / 4);
 	if (check_now)
-		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, 0);
+		queue_delayed_work(system_freezable_wq, &ev->dwork, 0);
 	else if (intv)
-		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, intv);
+		queue_delayed_work(system_freezable_wq, &ev->dwork, intv);
 out_unlock:
 	spin_unlock_irqrestore(&ev->lock, flags);
 }
@@ -1535,7 +1535,7 @@ void disk_flush_events(struct gendisk *disk, unsigned int mask)
 	spin_lock_irq(&ev->lock);
 	ev->clearing |= mask;
 	if (!ev->block)
-		mod_delayed_work(system_nrt_freezable_wq, &ev->dwork, 0);
+		mod_delayed_work(system_freezable_wq, &ev->dwork, 0);
 	spin_unlock_irq(&ev->lock);
 }
 
@@ -1571,7 +1571,7 @@ unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask)
 
 	/* uncondtionally schedule event check and wait for it to finish */
 	disk_block_events(disk);
-	queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, 0);
+	queue_delayed_work(system_freezable_wq, &ev->dwork, 0);
 	flush_delayed_work(&ev->dwork);
 	__disk_unblock_events(disk, false);
 
@@ -1608,7 +1608,7 @@ static void disk_events_workfn(struct work_struct *work)
 
 	intv = disk_events_poll_jiffies(disk);
 	if (!ev->block && intv)
-		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, intv);
+		queue_delayed_work(system_freezable_wq, &ev->dwork, intv);
 
 	spin_unlock_irq(&ev->lock);
 
diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 3252e70..8fa9d52 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -968,7 +968,7 @@ static void output_poll_execute(struct work_struct *work)
 	}
 
 	if (repoll)
-		queue_delayed_work(system_nrt_wq, delayed_work, DRM_OUTPUT_POLL_PERIOD);
+		schedule_delayed_work(delayed_work, DRM_OUTPUT_POLL_PERIOD);
 }
 
 void drm_kms_helper_poll_disable(struct drm_device *dev)
@@ -993,7 +993,7 @@ void drm_kms_helper_poll_enable(struct drm_device *dev)
 	}
 
 	if (poll)
-		queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
+		schedule_delayed_work(&dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
 }
 EXPORT_SYMBOL(drm_kms_helper_poll_enable);
 
@@ -1020,6 +1020,6 @@ void drm_helper_hpd_irq_event(struct drm_device *dev)
 	/* kill timer and schedule immediate execution, this doesn't block */
 	cancel_delayed_work(&dev->mode_config.output_poll_work);
 	if (drm_kms_helper_poll)
-		queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, 0);
+		schedule_delayed_work(&dev->mode_config.output_poll_work, 0);
 }
 EXPORT_SYMBOL(drm_helper_hpd_irq_event);
diff --git a/drivers/hid/hid-wiimote-ext.c b/drivers/hid/hid-wiimote-ext.c
index 0a1805c..d37cd09 100644
--- a/drivers/hid/hid-wiimote-ext.c
+++ b/drivers/hid/hid-wiimote-ext.c
@@ -204,7 +204,7 @@ static void wiiext_worker(struct work_struct *work)
 /* schedule work only once, otherwise mark for reschedule */
 static void wiiext_schedule(struct wiimote_ext *ext)
 {
-	queue_work(system_nrt_wq, &ext->worker);
+	schedule_work(&ext->worker);
 }
 
 /*
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 597f189..ee2e16b 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -204,8 +204,8 @@ void mmc_host_clk_release(struct mmc_host *host)
 	host->clk_requests--;
 	if (mmc_host_may_gate_card(host->card) &&
 	    !host->clk_requests)
-		queue_delayed_work(system_nrt_wq, &host->clk_gate_work,
-				msecs_to_jiffies(host->clkgate_delay));
+		schedule_delayed_work(&host->clk_gate_work,
+				      msecs_to_jiffies(host->clkgate_delay));
 	spin_unlock_irqrestore(&host->clk_lock, flags);
 }
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 83d2b0c..9650c41 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -521,7 +521,7 @@ static void refill_work(struct work_struct *work)
 	/* In theory, this can happen: if we don't get any buffers in
 	 * we will *never* try to fill again. */
 	if (still_empty)
-		queue_delayed_work(system_nrt_wq, &vi->refill, HZ/2);
+		schedule_delayed_work(&vi->refill, HZ/2);
 }
 
 static int virtnet_poll(struct napi_struct *napi, int budget)
@@ -540,7 +540,7 @@ again:
 
 	if (vi->num < vi->max / 2) {
 		if (!try_fill_recv(vi, GFP_ATOMIC))
-			queue_delayed_work(system_nrt_wq, &vi->refill, 0);
+			schedule_delayed_work(&vi->refill, 0);
 	}
 
 	/* Out of packets? */
@@ -745,7 +745,7 @@ static int virtnet_open(struct net_device *dev)
 
 	/* Make sure we have some buffers: if oom use wq. */
 	if (!try_fill_recv(vi, GFP_KERNEL))
-		queue_delayed_work(system_nrt_wq, &vi->refill, 0);
+		schedule_delayed_work(&vi->refill, 0);
 
 	virtnet_napi_enable(vi);
 	return 0;
@@ -1020,7 +1020,7 @@ static void virtnet_config_changed(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
 
-	queue_work(system_nrt_wq, &vi->config_work);
+	schedule_work(&vi->config_work);
 }
 
 static int init_vqs(struct virtnet_info *vi)
@@ -1152,7 +1152,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	   otherwise get link status from config. */
 	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STATUS)) {
 		netif_carrier_off(dev);
-		queue_work(system_nrt_wq, &vi->config_work);
+		schedule_work(&vi->config_work);
 	} else {
 		vi->status = VIRTIO_NET_S_LINK_UP;
 		netif_carrier_on(dev);
@@ -1264,7 +1264,7 @@ static int virtnet_restore(struct virtio_device *vdev)
 	netif_device_attach(vi->dev);
 
 	if (!try_fill_recv(vi, GFP_KERNEL))
-		queue_delayed_work(system_nrt_wq, &vi->refill, 0);
+		schedule_delayed_work(&vi->refill, 0);
 
 	mutex_lock(&vi->config_lock);
 	vi->config_enable = true;
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index ffaaec0..2b58905 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -310,12 +310,12 @@ extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_unbound_wq;
 extern struct workqueue_struct *system_freezable_wq;
 
-static inline struct workqueue_struct *__system_nrt_wq(void)
+static inline struct workqueue_struct * __deprecated __system_nrt_wq(void)
 {
 	return system_wq;
 }
 
-static inline struct workqueue_struct *__system_nrt_freezable_wq(void)
+static inline struct workqueue_struct * __deprecated __system_nrt_freezable_wq(void)
 {
 	return system_freezable_wq;
 }
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 2095be3..97c465e 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -379,7 +379,7 @@ void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
 	rcu_batch_queue(&sp->batch_queue, head);
 	if (!sp->running) {
 		sp->running = true;
-		queue_delayed_work(system_nrt_wq, &sp->work, 0);
+		schedule_delayed_work(&sp->work, 0);
 	}
 	spin_unlock_irqrestore(&sp->queue_lock, flags);
 }
@@ -631,7 +631,7 @@ static void srcu_reschedule(struct srcu_struct *sp)
 	}
 
 	if (pending)
-		queue_delayed_work(system_nrt_wq, &sp->work, SRCU_INTERVAL);
+		schedule_delayed_work(&sp->work, SRCU_INTERVAL);
 }
 
 /*
diff --git a/security/keys/gc.c b/security/keys/gc.c
index 61ab7c8..d67c97b 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -62,7 +62,7 @@ void key_schedule_gc(time_t gc_at)
 
 	if (gc_at <= now || test_bit(KEY_GC_REAP_KEYTYPE, &key_gc_flags)) {
 		kdebug("IMMEDIATE");
-		queue_work(system_nrt_wq, &key_gc_work);
+		schedule_work(&key_gc_work);
 	} else if (gc_at < key_gc_next_run) {
 		kdebug("DEFERRED");
 		key_gc_next_run = gc_at;
@@ -77,7 +77,7 @@ void key_schedule_gc(time_t gc_at)
 void key_schedule_gc_links(void)
 {
 	set_bit(KEY_GC_KEY_EXPIRED, &key_gc_flags);
-	queue_work(system_nrt_wq, &key_gc_work);
+	schedule_work(&key_gc_work);
 }
 
 /*
@@ -120,7 +120,7 @@ void key_gc_keytype(struct key_type *ktype)
 	set_bit(KEY_GC_REAP_KEYTYPE, &key_gc_flags);
 
 	kdebug("schedule");
-	queue_work(system_nrt_wq, &key_gc_work);
+	schedule_work(&key_gc_work);
 
 	kdebug("sleep");
 	wait_on_bit(&key_gc_flags, KEY_GC_REAPING_KEYTYPE, key_gc_wait_bit,
@@ -369,7 +369,7 @@ maybe_resched:
 	}
 
 	if (gc_state & KEY_GC_REAP_AGAIN)
-		queue_work(system_nrt_wq, &key_gc_work);
+		schedule_work(&key_gc_work);
 	kleave(" [end %x]", gc_state);
 	return;
 
diff --git a/security/keys/key.c b/security/keys/key.c
index 50d96d4..3cbe352 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -598,7 +598,7 @@ void key_put(struct key *key)
 		key_check(key);
 
 		if (atomic_dec_and_test(&key->usage))
-			queue_work(system_nrt_wq, &key_gc_work);
+			schedule_work(&key_gc_work);
 	}
 }
 EXPORT_SYMBOL(key_put);
-- 
1.7.7.3


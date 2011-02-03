Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1BCORo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:17:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab1BCORk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:17:40 -0500
Message-Id: <20110203141548.346089735@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 15:09:44 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Faisal Latif <faisal.latif@intel.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] workqueue: Remove now superfluous cancel_delayed_work() calls
References: <20110203140940.072679794@chello.nl>
Content-Disposition: inline; filename=workqueue-remove-cancel_delayed_work.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since queue_delayed_work() can now deal with existing timers, we don't
need to explicitly call cancel_delayed_work() anymore.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Faisal Latif <faisal.latif@intel.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@ipvvis.unipv.it>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 block/blk-throttle.c                |    5 -----
 drivers/infiniband/hw/nes/nes_hw.c  |    2 --
 drivers/infiniband/hw/nes/nes_nic.c |    2 --
 drivers/input/keyboard/qt2160.c     |    3 ---
 drivers/input/mouse/synaptics_i2c.c |    7 -------
 drivers/misc/bh1770glc.c            |    1 -
 drivers/net/phy/phy.c               |    1 -
 drivers/power/jz4740-battery.c      |    2 --
 fs/nfs/nfs4renewd.c                 |    1 -
 fs/ocfs2/cluster/heartbeat.c        |    1 -
 net/core/dst.c                      |    1 -
 net/rfkill/input.c                  |    1 -
 12 files changed, 27 deletions(-)

Index: linux-2.6/block/blk-throttle.c
===================================================================
--- linux-2.6.orig/block/blk-throttle.c
+++ linux-2.6/block/blk-throttle.c
@@ -814,11 +814,6 @@ void throtl_schedule_delayed_work(struct
 	struct delayed_work *dwork = &td->throtl_work;
 
 	if (total_nr_queued(td) > 0) {
-		/*
-		 * We might have a work scheduled to be executed in future.
-		 * Cancel that and schedule a new one.
-		 */
-		__cancel_delayed_work(dwork);
 		kblockd_schedule_delayed_work(q, dwork, delay);
 		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
 				delay, jiffies);
Index: linux-2.6/drivers/infiniband/hw/nes/nes_hw.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/nes/nes_hw.c
+++ linux-2.6/drivers/infiniband/hw/nes/nes_hw.c
@@ -2651,8 +2651,6 @@ static void nes_process_mac_intr(struct
 			}
 		}
 		if (nesadapter->phy_type[mac_index] == NES_PHY_TYPE_SFP_D) {
-			if (nesdev->link_recheck)
-				cancel_delayed_work(&nesdev->work);
 			nesdev->link_recheck = 1;
 			schedule_delayed_work(&nesdev->work,
 					      NES_LINK_RECHECK_DELAY);
Index: linux-2.6/drivers/infiniband/hw/nes/nes_nic.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/nes/nes_nic.c
+++ linux-2.6/drivers/infiniband/hw/nes/nes_nic.c
@@ -243,8 +243,6 @@ static int nes_netdev_open(struct net_de
 
 	spin_lock_irqsave(&nesdev->nesadapter->phy_lock, flags);
 	if (nesdev->nesadapter->phy_type[nesdev->mac_index] == NES_PHY_TYPE_SFP_D) {
-		if (nesdev->link_recheck)
-			cancel_delayed_work(&nesdev->work);
 		nesdev->link_recheck = 1;
 		schedule_delayed_work(&nesdev->work, NES_LINK_RECHECK_DELAY);
 	}
Index: linux-2.6/drivers/input/keyboard/qt2160.c
===================================================================
--- linux-2.6.orig/drivers/input/keyboard/qt2160.c
+++ linux-2.6/drivers/input/keyboard/qt2160.c
@@ -155,10 +155,7 @@ static irqreturn_t qt2160_irq(int irq, v
 	unsigned long flags;
 
 	spin_lock_irqsave(&qt2160->lock, flags);
-
-	__cancel_delayed_work(&qt2160->dwork);
 	schedule_delayed_work(&qt2160->dwork, 0);
-
 	spin_unlock_irqrestore(&qt2160->lock, flags);
 
 	return IRQ_HANDLED;
Index: linux-2.6/drivers/input/mouse/synaptics_i2c.c
===================================================================
--- linux-2.6.orig/drivers/input/mouse/synaptics_i2c.c
+++ linux-2.6/drivers/input/mouse/synaptics_i2c.c
@@ -374,14 +374,7 @@ static void synaptics_i2c_reschedule_wor
 	unsigned long flags;
 
 	spin_lock_irqsave(&touch->lock, flags);
-
-	/*
-	 * If work is already scheduled then subsequent schedules will not
-	 * change the scheduled time that's why we have to cancel it first.
-	 */
-	__cancel_delayed_work(&touch->dwork);
 	schedule_delayed_work(&touch->dwork, delay);
-
 	spin_unlock_irqrestore(&touch->lock, flags);
 }
 
Index: linux-2.6/drivers/misc/bh1770glc.c
===================================================================
--- linux-2.6.orig/drivers/misc/bh1770glc.c
+++ linux-2.6/drivers/misc/bh1770glc.c
@@ -636,7 +636,6 @@ static irqreturn_t bh1770_irq(int irq, v
 		 * Simulate missing no-proximity interrupt 50ms after the
 		 * next expected interrupt time.
 		 */
-		cancel_delayed_work_sync(&chip->prox_work);
 		schedule_delayed_work(&chip->prox_work,
 				msecs_to_jiffies(rate + 50));
 	}
Index: linux-2.6/drivers/net/phy/phy.c
===================================================================
--- linux-2.6.orig/drivers/net/phy/phy.c
+++ linux-2.6/drivers/net/phy/phy.c
@@ -677,7 +677,6 @@ static void phy_change(struct work_struc
 		goto irq_enable_err;
 
 	/* reschedule state queue work to run as soon as possible */
-	cancel_delayed_work_sync(&phydev->state_queue);
 	schedule_delayed_work(&phydev->state_queue, 0);
 
 	return;
Index: linux-2.6/drivers/power/jz4740-battery.c
===================================================================
--- linux-2.6.orig/drivers/power/jz4740-battery.c
+++ linux-2.6/drivers/power/jz4740-battery.c
@@ -173,7 +173,6 @@ static void jz_battery_external_power_ch
 {
 	struct jz_battery *jz_battery = psy_to_jz_battery(psy);
 
-	cancel_delayed_work(&jz_battery->work);
 	schedule_delayed_work(&jz_battery->work, 0);
 }
 
@@ -181,7 +180,6 @@ static irqreturn_t jz_battery_charge_irq
 {
 	struct jz_battery *jz_battery = data;
 
-	cancel_delayed_work(&jz_battery->work);
 	schedule_delayed_work(&jz_battery->work, 0);
 
 	return IRQ_HANDLED;
Index: linux-2.6/fs/nfs/nfs4renewd.c
===================================================================
--- linux-2.6.orig/fs/nfs/nfs4renewd.c
+++ linux-2.6/fs/nfs/nfs4renewd.c
@@ -115,7 +115,6 @@ nfs4_schedule_state_renewal(struct nfs_c
 		timeout = 5 * HZ;
 	dprintk("%s: requeueing work. Lease period = %ld\n",
 			__func__, (timeout + HZ - 1) / HZ);
-	cancel_delayed_work(&clp->cl_renewd);
 	schedule_delayed_work(&clp->cl_renewd, timeout);
 	set_bit(NFS_CS_RENEWD, &clp->cl_res_state);
 	spin_unlock(&clp->cl_lock);
Index: linux-2.6/fs/ocfs2/cluster/heartbeat.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/cluster/heartbeat.c
+++ linux-2.6/fs/ocfs2/cluster/heartbeat.c
@@ -332,7 +332,6 @@ static void o2hb_arm_write_timeout(struc
 		clear_bit(reg->hr_region_num, o2hb_failed_region_bitmap);
 		spin_unlock(&o2hb_live_lock);
 	}
-	cancel_delayed_work(&reg->hr_write_timeout_work);
 	reg->hr_last_timeout_start = jiffies;
 	schedule_delayed_work(&reg->hr_write_timeout_work,
 			      msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS));
Index: linux-2.6/net/core/dst.c
===================================================================
--- linux-2.6.orig/net/core/dst.c
+++ linux-2.6/net/core/dst.c
@@ -207,7 +207,6 @@ void __dst_free(struct dst_entry *dst)
 	if (dst_garbage.timer_inc > DST_GC_INC) {
 		dst_garbage.timer_inc = DST_GC_INC;
 		dst_garbage.timer_expires = DST_GC_MIN;
-		cancel_delayed_work(&dst_gc_work);
 		schedule_delayed_work(&dst_gc_work, dst_garbage.timer_expires);
 	}
 	spin_unlock_bh(&dst_garbage.lock);
Index: linux-2.6/net/rfkill/input.c
===================================================================
--- linux-2.6.orig/net/rfkill/input.c
+++ linux-2.6/net/rfkill/input.c
@@ -163,7 +163,6 @@ static void rfkill_schedule_global_op(en
 	rfkill_op_pending = true;
 	if (op == RFKILL_GLOBAL_OP_EPO && !rfkill_is_epo_lock_active()) {
 		/* bypass the limiter for EPO */
-		cancel_delayed_work(&rfkill_op_work);
 		schedule_delayed_work(&rfkill_op_work, 0);
 		rfkill_last_scheduled = jiffies;
 	} else



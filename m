Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab0JSPYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:24:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:39158 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab0JSPYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:24:42 -0400
Message-ID: <4CBDB834.2050905@kernel.org>
Date: Tue, 19 Oct 2010 17:24:36 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7] infiniband: update workqueue usage
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Oct 2010 15:24:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* ib_wq is added, which is used as the common workqueue for infiniband
  instead of the system workqueue.  All system workqueue usages
  including flush_scheduled_work() callers are converted to use and
  flush ib_wq.

* cancel_delayed_work() + flush_scheduled_work() converted to
  cancel_delayed_work_sync().

* qib_wq is removed and ib_wq is used instead.

This is to prepare for deprecation of flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello,

I think this patch is safe but don't have any experience with or
access to infiniband stuff and it's only compile tested.  Also, while
looking through the code, I got curious about several things.

* Can any of the works in infiniband be used during memory reclaim?

* qib_cq_wq is a separate singlethread workqueue.  Does the queue
  require strict single thread execution ordering?  IOW, does each
  work have to be executed in the exact queued order and no two works
  should execute in parallel?  Or was the singlethreadedness chosen
  just to reduce the number of workers?

* The same question for ipoib_workqueue.

Thank you.

 drivers/infiniband/core/cache.c                |    4 +--
 drivers/infiniband/core/device.c               |   11 ++++++++--
 drivers/infiniband/core/sa_query.c             |    4 +--
 drivers/infiniband/core/umem.c                 |    2 -
 drivers/infiniband/hw/ipath/ipath_driver.c     |    2 -
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    2 -
 drivers/infiniband/hw/qib/qib_iba7220.c        |    7 ++----
 drivers/infiniband/hw/qib/qib_iba7322.c        |   14 ++++++-------
 drivers/infiniband/hw/qib/qib_init.c           |   26 +++----------------------
 drivers/infiniband/hw/qib/qib_qsfp.c           |    9 +++-----
 drivers/infiniband/hw/qib/qib_verbs.h          |    5 +---
 drivers/infiniband/ulp/srp/ib_srp.c            |    4 +--
 include/rdma/ib_verbs.h                        |    3 ++
 13 files changed, 41 insertions(+), 52 deletions(-)

Index: work/drivers/infiniband/core/cache.c
===================================================================
--- work.orig/drivers/infiniband/core/cache.c
+++ work/drivers/infiniband/core/cache.c
@@ -308,7 +308,7 @@ static void ib_cache_event(struct ib_eve
 			INIT_WORK(&work->work, ib_cache_task);
 			work->device   = event->device;
 			work->port_num = event->element.port_num;
-			schedule_work(&work->work);
+			queue_work(ib_wq, &work->work);
 		}
 	}
 }
@@ -368,7 +368,7 @@ static void ib_cache_cleanup_one(struct
 	int p;

 	ib_unregister_event_handler(&device->cache.event_handler);
-	flush_scheduled_work();
+	flush_workqueue(ib_wq);

 	for (p = 0; p <= end_port(device) - start_port(device); ++p) {
 		kfree(device->cache.pkey_cache[p]);
Index: work/drivers/infiniband/core/device.c
===================================================================
--- work.orig/drivers/infiniband/core/device.c
+++ work/drivers/infiniband/core/device.c
@@ -38,7 +38,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
-#include <linux/workqueue.h>

 #include "core_priv.h"

@@ -52,6 +51,9 @@ struct ib_client_data {
 	void *            data;
 };

+struct workqueue_struct *ib_wq;
+EXPORT_SYMBOL_GPL(ib_wq);
+
 static LIST_HEAD(device_list);
 static LIST_HEAD(client_list);

@@ -718,6 +720,10 @@ static int __init ib_core_init(void)
 {
 	int ret;

+	ib_wq = alloc_workqueue("infiniband", 0, 0);
+	if (!ib_wq)
+		return -ENOMEM;
+
 	ret = ib_sysfs_setup();
 	if (ret)
 		printk(KERN_WARNING "Couldn't create InfiniBand device class\n");
@@ -726,6 +732,7 @@ static int __init ib_core_init(void)
 	if (ret) {
 		printk(KERN_WARNING "Couldn't set up InfiniBand P_Key/GID cache\n");
 		ib_sysfs_cleanup();
+		destroy_workqueue(ib_wq);
 	}

 	return ret;
@@ -736,7 +743,7 @@ static void __exit ib_core_cleanup(void)
 	ib_cache_cleanup();
 	ib_sysfs_cleanup();
 	/* Make sure that any pending umem accounting work is done. */
-	flush_scheduled_work();
+	destroy_workqueue(ib_wq);
 }

 module_init(ib_core_init);
Index: work/drivers/infiniband/core/sa_query.c
===================================================================
--- work.orig/drivers/infiniband/core/sa_query.c
+++ work/drivers/infiniband/core/sa_query.c
@@ -422,7 +422,7 @@ static void ib_sa_event(struct ib_event_
 		port->sm_ah = NULL;
 		spin_unlock_irqrestore(&port->ah_lock, flags);

-		schedule_work(&sa_dev->port[event->element.port_num -
+		queue_work(ib_wq, &sa_dev->port[event->element.port_num -
 					    sa_dev->start_port].update_task);
 	}
 }
@@ -1068,7 +1068,7 @@ static void ib_sa_remove_one(struct ib_d

 	ib_unregister_event_handler(&sa_dev->event_handler);

-	flush_scheduled_work();
+	flush_workqueue(ib_wq);

 	for (i = 0; i <= sa_dev->end_port - sa_dev->start_port; ++i) {
 		ib_unregister_mad_agent(sa_dev->port[i].agent);
Index: work/drivers/infiniband/core/umem.c
===================================================================
--- work.orig/drivers/infiniband/core/umem.c
+++ work/drivers/infiniband/core/umem.c
@@ -262,7 +262,7 @@ void ib_umem_release(struct ib_umem *ume
 			umem->mm   = mm;
 			umem->diff = diff;

-			schedule_work(&umem->work);
+			queue_work(ib_wq, &umem->work);
 			return;
 		}
 	} else
Index: work/drivers/infiniband/hw/ipath/ipath_driver.c
===================================================================
--- work.orig/drivers/infiniband/hw/ipath/ipath_driver.c
+++ work/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -757,7 +757,7 @@ static void __devexit ipath_remove_one(s
 	 */
 	ipath_shutdown_device(dd);

-	flush_scheduled_work();
+	flush_workqueue(ib_wq);

 	if (dd->verbs_dev)
 		ipath_unregister_ib_device(dd->verbs_dev);
Index: work/drivers/infiniband/hw/ipath/ipath_user_pages.c
===================================================================
--- work.orig/drivers/infiniband/hw/ipath/ipath_user_pages.c
+++ work/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -220,7 +220,7 @@ void ipath_release_user_pages_on_close(s
 	work->mm = mm;
 	work->num_pages = num_pages;

-	schedule_work(&work->work);
+	queue_work(ib_wq, &work->work);
 	return;

 bail_mm:
Index: work/drivers/infiniband/hw/qib/qib_iba7220.c
===================================================================
--- work.orig/drivers/infiniband/hw/qib/qib_iba7220.c
+++ work/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -1692,8 +1692,7 @@ static void qib_7220_quiet_serdes(struct
 	ppd->lflags &= ~QIBL_IB_AUTONEG_INPROG;
 	spin_unlock_irqrestore(&ppd->lflags_lock, flags);
 	wake_up(&ppd->cpspec->autoneg_wait);
-	cancel_delayed_work(&ppd->cpspec->autoneg_work);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&ppd->cpspec->autoneg_work);

 	shutdown_7220_relock_poll(ppd->dd);
 	val = qib_read_kreg64(ppd->dd, kr_xgxs_cfg);
@@ -3515,8 +3514,8 @@ static void try_7220_autoneg(struct qib_

 	toggle_7220_rclkrls(ppd->dd);
 	/* 2 msec is minimum length of a poll cycle */
-	schedule_delayed_work(&ppd->cpspec->autoneg_work,
-			      msecs_to_jiffies(2));
+	queue_delayed_work(ib_wq, &ppd->cpspec->autoneg_work,
+			   msecs_to_jiffies(2));
 }

 /*
Index: work/drivers/infiniband/hw/qib/qib_iba7322.c
===================================================================
--- work.orig/drivers/infiniband/hw/qib/qib_iba7322.c
+++ work/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2348,10 +2348,9 @@ static void qib_7322_mini_quiet_serdes(s
 	ppd->lflags &= ~QIBL_IB_AUTONEG_INPROG;
 	spin_unlock_irqrestore(&ppd->lflags_lock, flags);
 	wake_up(&ppd->cpspec->autoneg_wait);
-	cancel_delayed_work(&ppd->cpspec->autoneg_work);
+	cancel_delayed_work_sync(&ppd->cpspec->autoneg_work);
 	if (ppd->dd->cspec->r1)
-		cancel_delayed_work(&ppd->cpspec->ipg_work);
-	flush_scheduled_work();
+		cancel_delayed_work_sync(&ppd->cpspec->ipg_work);

 	ppd->cpspec->chase_end = 0;
 	if (ppd->cpspec->chase_timer.data) /* if initted */
@@ -2648,7 +2647,7 @@ static noinline void unknown_7322_gpio_i
 			if (!(pins & mask)) {
 				++handled;
 				qd->t_insert = get_jiffies_64();
-				schedule_work(&qd->work);
+				queue_work(ib_wq, &qd->work);
 			}
 		}
 	}
@@ -4926,8 +4925,8 @@ static void try_7322_autoneg(struct qib_
 	set_7322_ibspeed_fast(ppd, QIB_IB_DDR);
 	qib_7322_mini_pcs_reset(ppd);
 	/* 2 msec is minimum length of a poll cycle */
-	schedule_delayed_work(&ppd->cpspec->autoneg_work,
-			      msecs_to_jiffies(2));
+	queue_delayed_work(ib_wq, &ppd->cpspec->autoneg_work,
+			   msecs_to_jiffies(2));
 }

 /*
@@ -5057,7 +5056,8 @@ static void try_7322_ipg(struct qib_ppor
 		ib_free_send_mad(send_buf);
 retry:
 	delay = 2 << ppd->cpspec->ipg_tries;
-	schedule_delayed_work(&ppd->cpspec->ipg_work, msecs_to_jiffies(delay));
+	queue_delayed_work(ib_wq, &ppd->cpspec->ipg_work,
+			   msecs_to_jiffies(delay));
 }

 /*
Index: work/drivers/infiniband/hw/qib/qib_init.c
===================================================================
--- work.orig/drivers/infiniband/hw/qib/qib_init.c
+++ work/drivers/infiniband/hw/qib/qib_init.c
@@ -80,7 +80,6 @@ unsigned qib_wc_pat = 1; /* default (1)
 module_param_named(wc_pat, qib_wc_pat, uint, S_IRUGO);
 MODULE_PARM_DESC(wc_pat, "enable write-combining via PAT mechanism");

-struct workqueue_struct *qib_wq;
 struct workqueue_struct *qib_cq_wq;

 static void verify_interrupt(unsigned long);
@@ -1045,24 +1044,10 @@ static int __init qlogic_ib_init(void)
 	if (ret)
 		goto bail;

-	/*
-	 * We create our own workqueue mainly because we want to be
-	 * able to flush it when devices are being removed.  We can't
-	 * use schedule_work()/flush_scheduled_work() because both
-	 * unregister_netdev() and linkwatch_event take the rtnl lock,
-	 * so flush_scheduled_work() can deadlock during device
-	 * removal.
-	 */
-	qib_wq = create_workqueue("qib");
-	if (!qib_wq) {
-		ret = -ENOMEM;
-		goto bail_dev;
-	}
-
 	qib_cq_wq = create_singlethread_workqueue("qib_cq");
 	if (!qib_cq_wq) {
 		ret = -ENOMEM;
-		goto bail_wq;
+		goto bail_dev;
 	}

 	/*
@@ -1092,8 +1077,6 @@ bail_unit:
 	idr_destroy(&qib_unit_table);
 bail_cq_wq:
 	destroy_workqueue(qib_cq_wq);
-bail_wq:
-	destroy_workqueue(qib_wq);
 bail_dev:
 	qib_dev_cleanup();
 bail:
@@ -1117,7 +1100,6 @@ static void __exit qlogic_ib_cleanup(voi

 	pci_unregister_driver(&qib_driver);

-	destroy_workqueue(qib_wq);
 	destroy_workqueue(qib_cq_wq);

 	qib_cpulist_count = 0;
@@ -1289,7 +1271,7 @@ static int __devinit qib_init_one(struct

 	if (qib_mini_init || initfail || ret) {
 		qib_stop_timers(dd);
-		flush_scheduled_work();
+		flush_workqueue(ib_wq);
 		for (pidx = 0; pidx < dd->num_pports; ++pidx)
 			dd->f_quiet_serdes(dd->pport + pidx);
 		if (qib_mini_init)
@@ -1338,8 +1320,8 @@ static void __devexit qib_remove_one(str

 	qib_stop_timers(dd);

-	/* wait until all of our (qsfp) schedule_work() calls complete */
-	flush_scheduled_work();
+	/* wait until all of our (qsfp) queue_work() calls complete */
+	flush_workqueue(ib_wq);

 	ret = qibfs_remove(dd);
 	if (ret)
Index: work/drivers/infiniband/hw/qib/qib_qsfp.c
===================================================================
--- work.orig/drivers/infiniband/hw/qib/qib_qsfp.c
+++ work/drivers/infiniband/hw/qib/qib_qsfp.c
@@ -485,7 +485,7 @@ void qib_qsfp_init(struct qib_qsfp_data
 		goto bail;
 	/* We see a module, but it may be unwise to look yet. Just schedule */
 	qd->t_insert = get_jiffies_64();
-	schedule_work(&qd->work);
+	queue_work(ib_wq, &qd->work);
 bail:
 	return;
 }
@@ -493,10 +493,9 @@ bail:
 void qib_qsfp_deinit(struct qib_qsfp_data *qd)
 {
 	/*
-	 * There is nothing to do here for now.  our
-	 * work is scheduled with schedule_work(), and
-	 * flush_scheduled_work() from remove_one will
-	 * block until all work ssetup with schedule_work()
+	 * There is nothing to do here for now.  our work is scheduled
+	 * with queue_work(), and flush_workqueue() from remove_one
+	 * will block until all work setup with queue_work()
 	 * completes.
 	 */
 }
Index: work/drivers/infiniband/hw/qib/qib_verbs.h
===================================================================
--- work.orig/drivers/infiniband/hw/qib/qib_verbs.h
+++ work/drivers/infiniband/hw/qib/qib_verbs.h
@@ -805,7 +805,6 @@ static inline int qib_send_ok(struct qib
 		 !(qp->s_flags & QIB_S_ANY_WAIT_SEND));
 }

-extern struct workqueue_struct *qib_wq;
 extern struct workqueue_struct *qib_cq_wq;

 /*
@@ -815,10 +814,10 @@ static inline void qib_schedule_send(str
 {
 	if (qib_send_ok(qp)) {
 		if (qp->processor_id == smp_processor_id())
-			queue_work(qib_wq, &qp->s_work);
+			queue_work(ib_wq, &qp->s_work);
 		else
 			queue_work_on(qp->processor_id,
-				      qib_wq, &qp->s_work);
+				      ib_wq, &qp->s_work);
 	}
 }

Index: work/drivers/infiniband/ulp/srp/ib_srp.c
===================================================================
--- work.orig/drivers/infiniband/ulp/srp/ib_srp.c
+++ work/drivers/infiniband/ulp/srp/ib_srp.c
@@ -628,7 +628,7 @@ err:
 	if (target->state == SRP_TARGET_CONNECTING) {
 		target->state = SRP_TARGET_DEAD;
 		INIT_WORK(&target->work, srp_remove_work);
-		schedule_work(&target->work);
+		queue_work(ib_wq, &target->work);
 	}
 	spin_unlock_irq(target->scsi_host->host_lock);

@@ -2129,7 +2129,7 @@ static void srp_remove_one(struct ib_dev
 		 * started before we marked our target ports as
 		 * removed, and any target port removal tasks.
 		 */
-		flush_scheduled_work();
+		flush_workqueue(ib_wq);

 		list_for_each_entry_safe(target, tmp_target,
 					 &host->target_list, list) {
Index: work/include/rdma/ib_verbs.h
===================================================================
--- work.orig/include/rdma/ib_verbs.h
+++ work/include/rdma/ib_verbs.h
@@ -47,10 +47,13 @@
 #include <linux/list.h>
 #include <linux/rwsem.h>
 #include <linux/scatterlist.h>
+#include <linux/workqueue.h>

 #include <asm/atomic.h>
 #include <asm/uaccess.h>

+extern struct workqueue_struct *ib_wq;
+
 union ib_gid {
 	u8	raw[16];
 	struct {

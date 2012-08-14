Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2HNBud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:50:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56932 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab2HNBuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:50:07 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@redhat.com,
        lauro.venancio@openbossa.org, jak@jak-linux.org,
        Tejun Heo <tj@kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alasdair Kergon <agk@redhat.com>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Marc Dietrich <marvin24@gmx.de>,
        Rob Clark <rob@ti.com>, Christine Caulfield <ccaulfie@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Sage Weil <sage@inktank.com>
Subject: [PATCH 6/6] workqueue: deprecate WQ_NON_REENTRANT
Date: Mon, 13 Aug 2012 18:49:46 -0700
Message-Id: <1344908986-18152-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344908986-18152-1-git-send-email-tj@kernel.org>
References: <1344908986-18152-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WQ_NON_REENTRANT is now spurious.  Make alloc_workqueue() trigger
WARN_ON() if the flag is specified and drop it from all in-kernel
users.

If you're cc'd and wondering what's going on: Now all workqueues are
non-reentrant, so there's no reason to use WQ_NON_REENTRANT.

Some of the conversions in this patch aren't trivial.

* WQ_UNBOUND | WQ_NON_REENTRANT workqueues w/ max_active == 1 are
  converted to alloc_ordered_workqueue().

* NFC was using a lot of WQ_UNBOUND | WQ_NON_REENTRANT |
  WQ_MEM_RECLAIM workqueues w/ max_active == 1.  I converted them to
  alloc_ordered_workqueue() but can't understand why NFC would need
  the reclaim flag at all.  I added comments above all such
  occurrences.  If I'm missing something, please let me know;
  otherwise, please drop the flag.  Better, please try to use
  system_wq instead.

* drivers/staging/nvec doesn't seem to need its own workqueue.
  Converted to use system_wq and cancel work items on unload.  Plesae
  scream if it's wrong.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Julian Andres Klode <jak@jak-linux.org>
Cc: Marc Dietrich <marvin24@gmx.de>
Cc: Rob Clark <rob@ti.com>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Sage Weil <sage@inktank.com>
---
 Documentation/workqueue.txt         |   14 ++------------
 drivers/firewire/core-transaction.c |    3 +--
 drivers/gpu/drm/i915/i915_dma.c     |    6 ++----
 drivers/md/dm-crypt.c               |   10 ++--------
 drivers/md/dm-kcopyd.c              |    3 +--
 drivers/md/dm-raid1.c               |    3 +--
 drivers/md/dm.c                     |    3 +--
 drivers/mmc/host/dw_mmc.c           |    3 +--
 drivers/nfc/pn533.c                 |    5 ++---
 drivers/staging/nvec/nvec.c         |   10 ++++------
 drivers/staging/nvec/nvec.h         |    2 --
 drivers/staging/omapdrm/omap_drv.c  |    3 +--
 fs/dlm/ast.c                        |    5 +----
 fs/gfs2/main.c                      |    2 +-
 fs/xfs/xfs_super.c                  |    2 +-
 kernel/workqueue.c                  |    3 +++
 net/ceph/messenger.c                |    2 +-
 net/nfc/core.c                      |    6 +++---
 net/nfc/hci/core.c                  |    8 ++++----
 net/nfc/hci/shdlc.c                 |    4 ++--
 net/nfc/llcp/llcp.c                 |   18 ++++++------------
 21 files changed, 40 insertions(+), 75 deletions(-)

diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
index a6ab4b6..1fb8813 100644
--- a/Documentation/workqueue.txt
+++ b/Documentation/workqueue.txt
@@ -100,8 +100,8 @@ Subsystems and drivers can create and queue work items through special
 workqueue API functions as they see fit. They can influence some
 aspects of the way the work items are executed by setting flags on the
 workqueue they are putting the work item on. These flags include
-things like CPU locality, reentrancy, concurrency limits, priority and
-more.  To get a detailed overview refer to the API description of
+things like CPU locality, concurrency limits, priority and more.  To
+get a detailed overview refer to the API description of
 alloc_workqueue() below.
 
 When a work item is queued to a workqueue, the target gcwq and
@@ -166,16 +166,6 @@ resources, scheduled and executed.
 
 @flags:
 
-  WQ_NON_REENTRANT
-
-	By default, a wq guarantees non-reentrance only on the same
-	CPU.  A work item may not be executed concurrently on the same
-	CPU by multiple workers but is allowed to be executed
-	concurrently on multiple CPUs.  This flag makes sure
-	non-reentrance is enforced across all CPUs.  Work items queued
-	to a non-reentrant wq are guaranteed to be executed by at most
-	one worker system-wide at any given time.
-
   WQ_UNBOUND
 
 	Work items queued to an unbound wq are served by a special
diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index 87d6f2d..45acc0f 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -1257,8 +1257,7 @@ static int __init fw_core_init(void)
 {
 	int ret;
 
-	fw_workqueue = alloc_workqueue("firewire",
-				       WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	fw_workqueue = alloc_workqueue("firewire", WQ_MEM_RECLAIM, 0);
 	if (!fw_workqueue)
 		return -ENOMEM;
 
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 9cf7dfe..a55ca7a 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1536,11 +1536,9 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	 *
 	 * All tasks on the workqueue are expected to acquire the dev mutex
 	 * so there is no point in running more than one instance of the
-	 * workqueue at any time: max_active = 1 and NON_REENTRANT.
+	 * workqueue at any time.  Use an ordered one.
 	 */
-	dev_priv->wq = alloc_workqueue("i915",
-				       WQ_UNBOUND | WQ_NON_REENTRANT,
-				       1);
+	dev_priv->wq = alloc_ordered_workqueue("i915", 0);
 	if (dev_priv->wq == NULL) {
 		DRM_ERROR("Failed to create our workqueue.\n");
 		ret = -ENOMEM;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 664743d..a7472d6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1674,20 +1674,14 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	ret = -ENOMEM;
-	cc->io_queue = alloc_workqueue("kcryptd_io",
-				       WQ_NON_REENTRANT|
-				       WQ_MEM_RECLAIM,
-				       1);
+	cc->io_queue = alloc_workqueue("kcryptd_io", WQ_MEM_RECLAIM, 1);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
 	}
 
 	cc->crypt_queue = alloc_workqueue("kcryptd",
-					  WQ_NON_REENTRANT|
-					  WQ_CPU_INTENSIVE|
-					  WQ_MEM_RECLAIM,
-					  1);
+					  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 1);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index bed444c..7234f71 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -704,8 +704,7 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(void)
 		goto bad_slab;
 
 	INIT_WORK(&kc->kcopyd_work, do_work);
-	kc->kcopyd_wq = alloc_workqueue("kcopyd",
-					WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	kc->kcopyd_wq = alloc_workqueue("kcopyd", WQ_MEM_RECLAIM, 0);
 	if (!kc->kcopyd_wq)
 		goto bad_workqueue;
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index fd61f98..c282fc7 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1090,8 +1090,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_requests = 1;
 	ti->discard_zeroes_data_unsupported = true;
 
-	ms->kmirrord_wq = alloc_workqueue("kmirrord",
-					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	ms->kmirrord_wq = alloc_workqueue("kmirrord", WQ_MEM_RECLAIM, 0);
 	if (!ms->kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
 		r = -ENOMEM;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4e09b6f..7c5ef85 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1897,8 +1897,7 @@ static struct mapped_device *alloc_dev(int minor)
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
-	md->wq = alloc_workqueue("kdmflush",
-				 WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
 	if (!md->wq)
 		goto bad_thread;
 
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 72dc3cd..119e441 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2030,8 +2030,7 @@ int dw_mci_probe(struct dw_mci *host)
 	mci_writel(host, CLKSRC, 0);
 
 	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
-	host->card_workqueue = alloc_workqueue("dw-mci-card",
-			WQ_MEM_RECLAIM | WQ_NON_REENTRANT, 1);
+	host->card_workqueue = alloc_workqueue("dw-mci-card", WQ_MEM_RECLAIM, 1);
 	if (!host->card_workqueue)
 		goto err_dmaunmap;
 	INIT_WORK(&host->card_work, dw_mci_work_routine_card);
diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index d606f52..7dadcb8 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -2334,9 +2334,8 @@ static int pn533_probe(struct usb_interface *interface,
 	INIT_WORK(&dev->mi_work, pn533_wq_mi_recv);
 	INIT_WORK(&dev->tg_work, pn533_wq_tg_get_data);
 	INIT_WORK(&dev->poll_work, pn533_wq_poll);
-	dev->wq = alloc_workqueue("pn533",
-				  WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
-				  1);
+	/* XXX tj - why does NFC need WQ_MEM_RECLAIM? */
+	dev->wq = alloc_ordered_workqueue("pn533", WQ_MEM_RECLAIM);
 	if (dev->wq == NULL)
 		goto error;
 
diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 695ea35..9c39d53 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -264,7 +264,7 @@ int nvec_write_async(struct nvec_chip *nvec, const unsigned char *data,
 	list_add_tail(&msg->node, &nvec->tx_data);
 	spin_unlock_irqrestore(&nvec->tx_lock, flags);
 
-	queue_work(nvec->wq, &nvec->tx_work);
+	schedule_work(&nvec->tx_work);
 
 	return 0;
 }
@@ -470,7 +470,7 @@ static void nvec_rx_completed(struct nvec_chip *nvec)
 	if (!nvec_msg_is_event(nvec->rx))
 		complete(&nvec->ec_transfer);
 
-	queue_work(nvec->wq, &nvec->rx_work);
+	schedule_work(&nvec->rx_work);
 }
 
 /**
@@ -791,13 +791,11 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&nvec->tx_data);
 	INIT_WORK(&nvec->rx_work, nvec_dispatch);
 	INIT_WORK(&nvec->tx_work, nvec_request_master);
-	nvec->wq = alloc_workqueue("nvec", WQ_NON_REENTRANT, 2);
 
 	err = devm_gpio_request_one(&pdev->dev, nvec->gpio, GPIOF_OUT_INIT_HIGH,
 					"nvec gpio");
 	if (err < 0) {
 		dev_err(nvec->dev, "couldn't request gpio\n");
-		destroy_workqueue(nvec->wq);
 		return -ENODEV;
 	}
 
@@ -805,7 +803,6 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 				"nvec", nvec);
 	if (err) {
 		dev_err(nvec->dev, "couldn't request irq\n");
-		destroy_workqueue(nvec->wq);
 		return -ENODEV;
 	}
 	disable_irq(nvec->irq);
@@ -859,7 +856,8 @@ static int __devexit tegra_nvec_remove(struct platform_device *pdev)
 
 	nvec_write_async(nvec, EC_DISABLE_EVENT_REPORTING, 3);
 	mfd_remove_devices(nvec->dev);
-	destroy_workqueue(nvec->wq);
+	cancel_work_sync(&nvec->rx_work);
+	cancel_work_sync(&nvec->tx_work);
 
 	return 0;
 }
diff --git a/drivers/staging/nvec/nvec.h b/drivers/staging/nvec/nvec.h
index ba6ed8f..f522dbd 100644
--- a/drivers/staging/nvec/nvec.h
+++ b/drivers/staging/nvec/nvec.h
@@ -139,7 +139,6 @@ struct nvec_platform_data {
  * @nvec_status_notifier: Internal notifier (see nvec_status_notifier())
  * @rx_work: A work structure for the RX worker nvec_dispatch()
  * @tx_work: A work structure for the TX worker nvec_request_master()
- * @wq: The work queue in which @rx_work and @tx_work are executed
  * @rx: The message currently being retrieved or %NULL
  * @msg_pool: A pool of messages for allocation
  * @tx: The message currently being transferred
@@ -165,7 +164,6 @@ struct nvec_chip {
 	struct list_head rx_data, tx_data;
 	struct notifier_block nvec_status_notifier;
 	struct work_struct rx_work, tx_work;
-	struct workqueue_struct *wq;
 	struct nvec_msg msg_pool[NVEC_POOL_SIZE];
 	struct nvec_msg *rx;
 
diff --git a/drivers/staging/omapdrm/omap_drv.c b/drivers/staging/omapdrm/omap_drv.c
index 4beab94..672cb3a 100644
--- a/drivers/staging/omapdrm/omap_drv.c
+++ b/drivers/staging/omapdrm/omap_drv.c
@@ -571,8 +571,7 @@ static int dev_load(struct drm_device *dev, unsigned long flags)
 
 	dev->dev_private = priv;
 
-	priv->wq = alloc_workqueue("omapdrm",
-			WQ_UNBOUND | WQ_NON_REENTRANT, 1);
+	priv->wq = alloc_ordered_workqueue("omapdrm", 0);
 
 	INIT_LIST_HEAD(&priv->obj_list);
 
diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 63dc19c..cd24afd 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -267,10 +267,7 @@ void dlm_callback_work(struct work_struct *work)
 int dlm_callback_start(struct dlm_ls *ls)
 {
 	ls->ls_callback_wq = alloc_workqueue("dlm_callback",
-					     WQ_UNBOUND |
-					     WQ_MEM_RECLAIM |
-					     WQ_NON_REENTRANT,
-					     0);
+					     WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
 	if (!ls->ls_callback_wq) {
 		log_print("can't start dlm_callback workqueue");
 		return -ENOMEM;
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index e04d0e0..7b0f504 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -155,7 +155,7 @@ static int __init init_gfs2_fs(void)
 		goto fail_wq;
 
 	gfs2_control_wq = alloc_workqueue("gfs2_control",
-			       WQ_NON_REENTRANT | WQ_UNBOUND | WQ_FREEZABLE, 0);
+					  WQ_UNBOUND | WQ_FREEZABLE, 0);
 	if (!gfs2_control_wq)
 		goto fail_recovery;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e8e6be4..c7199a4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1531,7 +1531,7 @@ xfs_init_workqueues(void)
 	 * competing for ressources.  Use the default large max_active value
 	 * so that even lots of filesystems can perform these task in parallel.
 	 */
-	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_NON_REENTRANT, 0);
+	xfs_syncd_wq = alloc_workqueue("xfssyncd", 0, 0);
 	if (!xfs_syncd_wq)
 		return -ENOMEM;
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ce39467..910b1ee 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3195,6 +3195,9 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	unsigned int cpu;
 	size_t namelen;
 
+	WARN(flags & WQ_NON_REENTRANT,
+	     "workqueue: WQ_NON_REENTRANT is deprecated, all workqueues are non-reentrant\n");
+
 	/* determine namelen, allocate wq and format name */
 	va_start(args, lock_name);
 	va_copy(args1, args);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index b979675..fe1bd47 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -190,7 +190,7 @@ int ceph_msgr_init(void)
 	zero_page = ZERO_PAGE(0);
 	page_cache_get(zero_page);
 
-	ceph_msgr_wq = alloc_workqueue("ceph-msgr", WQ_NON_REENTRANT, 0);
+	ceph_msgr_wq = alloc_workqueue("ceph-msgr", 0, 0);
 	if (ceph_msgr_wq)
 		return 0;
 
diff --git a/net/nfc/core.c b/net/nfc/core.c
index ff74979..b071f97 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -791,9 +791,9 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 
 		INIT_WORK(&dev->check_pres_work, nfc_check_pres_work);
 		snprintf(name, sizeof(name), "nfc%d_check_pres_wq", dev->idx);
-		dev->check_pres_wq = alloc_workqueue(name, WQ_NON_REENTRANT |
-						     WQ_UNBOUND |
-						     WQ_MEM_RECLAIM, 1);
+		/* XXX tj - why does NFC need WQ_MEM_RECLAIM? */
+		dev->check_pres_wq = alloc_ordered_workqueue(name,
+							     WQ_MEM_RECLAIM);
 		if (dev->check_pres_wq == NULL) {
 			kfree(dev);
 			return NULL;
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 1ac7b3f..5e48792 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -670,8 +670,8 @@ int nfc_hci_register_device(struct nfc_hci_dev *hdev)
 
 	INIT_WORK(&hdev->msg_tx_work, nfc_hci_msg_tx_work);
 	snprintf(name, sizeof(name), "%s_hci_msg_tx_wq", devname);
-	hdev->msg_tx_wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND |
-					  WQ_MEM_RECLAIM, 1);
+	/* XXX tj - why does NFC need WQ_MEM_RECLAIM? */
+	hdev->msg_tx_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (hdev->msg_tx_wq == NULL) {
 		r = -ENOMEM;
 		goto exit;
@@ -685,8 +685,8 @@ int nfc_hci_register_device(struct nfc_hci_dev *hdev)
 
 	INIT_WORK(&hdev->msg_rx_work, nfc_hci_msg_rx_work);
 	snprintf(name, sizeof(name), "%s_hci_msg_rx_wq", devname);
-	hdev->msg_rx_wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND |
-					  WQ_MEM_RECLAIM, 1);
+	/* XXX tj - why does NFC need WQ_MEM_RECLAIM? */
+	hdev->msg_rx_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (hdev->msg_rx_wq == NULL) {
 		r = -ENOMEM;
 		goto exit;
diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index 6f840c1..04405101 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -877,8 +877,8 @@ struct nfc_shdlc *nfc_shdlc_allocate(struct nfc_shdlc_ops *ops,
 
 	INIT_WORK(&shdlc->sm_work, nfc_shdlc_sm_work);
 	snprintf(name, sizeof(name), "%s_shdlc_sm_wq", devname);
-	shdlc->sm_wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND |
-				       WQ_MEM_RECLAIM, 1);
+	/* XXX tj - why does NFC need WQ_MEM_RECLAIM? */
+	shdlc->sm_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (shdlc->sm_wq == NULL)
 		goto err_allocwq;
 
diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 82f0f75..57d5df2 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -1150,10 +1150,8 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	skb_queue_head_init(&local->tx_queue);
 	INIT_WORK(&local->tx_work, nfc_llcp_tx_work);
 	snprintf(name, sizeof(name), "%s_llcp_tx_wq", dev_name(dev));
-	local->tx_wq =
-		alloc_workqueue(name,
-				WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
-				1);
+	/* XXX tj - why does NFC need WQ_MEM_RECLAIM? */
+	local->tx_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (local->tx_wq == NULL) {
 		err = -ENOMEM;
 		goto err_local;
@@ -1162,10 +1160,8 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	local->rx_pending = NULL;
 	INIT_WORK(&local->rx_work, nfc_llcp_rx_work);
 	snprintf(name, sizeof(name), "%s_llcp_rx_wq", dev_name(dev));
-	local->rx_wq =
-		alloc_workqueue(name,
-				WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
-				1);
+	/* XXX tj - why does NFC need WQ_MEM_RECLAIM? */
+	local->rx_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (local->rx_wq == NULL) {
 		err = -ENOMEM;
 		goto err_tx_wq;
@@ -1173,10 +1169,8 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 
 	INIT_WORK(&local->timeout_work, nfc_llcp_timeout_work);
 	snprintf(name, sizeof(name), "%s_llcp_timeout_wq", dev_name(dev));
-	local->timeout_wq =
-		alloc_workqueue(name,
-				WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
-				1);
+	/* XXX tj - why does NFC need WQ_MEM_RECLAIM? */
+	local->timeout_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (local->timeout_wq == NULL) {
 		err = -ENOMEM;
 		goto err_rx_wq;
-- 
1.7.7.3


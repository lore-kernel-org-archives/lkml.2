Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab0KWIrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:47:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:55343 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab0KWIrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:47:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,241,1288594800"; 
   d="scan'208,223";a="860477710"
Date: Tue, 23 Nov 2010 16:44:22 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, arjan@linux.intel.com,
        hang.yuan@intel.com
Subject: [PATCH v1 2/4]Do background operations if need
Message-ID: <20101123084422.GC17754@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d29d84198f5b444e5ab7dc56bab7290f662494da Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Tue, 23 Nov 2010 10:51:16 +0800
Subject: [PATCH 2/4] mmc: Add background operations

Driver will check if need to do a BKOPS after completed each
user request. If BKOPS is need, then will start BKOPS when
request queue is idle.

So before start user request, driver should also check whether
card is doing a BKOPS. If so, check card status until BKOPS is done
or send HPI command is supported. In this patch, didnot enable HPI.

Added a workqueue to check whether the BKOPS is done. To consider
the runtime PM, driver needs to know when the BKOPS is done. After that
driver needs to put device in runtime suspend mode.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/card/block.c |   34 ++++++++
 drivers/mmc/card/queue.c |    1 +
 drivers/mmc/core/core.c  |  201 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/core.h  |    1 +
 drivers/mmc/core/host.c  |    1 +
 include/linux/mmc/card.h |   10 +++
 include/linux/mmc/core.h |    3 +
 include/linux/mmc/host.h |    2 +
 include/linux/mmc/mmc.h  |    1 +
 9 files changed, 254 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 217f820..de9ffd3 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -284,6 +284,15 @@ static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 	else
 		arg = MMC_ERASE_ARG;
 
+	/*
+	 * Before issuing a user req, host driver should
+	 * wait for the BKOPS is done or just use HPI to
+	 * interrupt it.
+	 */
+	err = mmc_wait_for_bkops(card);
+	if (err)
+		goto out;
+
 	err = mmc_erase(card, from, nr, arg);
 out:
 	spin_lock_irq(&md->lock);
@@ -318,6 +327,15 @@ static int mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 	else
 		arg = MMC_SECURE_ERASE_ARG;
 
+	/*
+	 * Before issuing a user req, host driver should
+	 * wait for the BKOPS is done or just use HPI to
+	 * interrupt it.
+	 */
+	err = mmc_wait_for_bkops(card);
+	if (err)
+		goto out;
+
 	err = mmc_erase(card, from, nr, arg);
 	if (!err && arg == MMC_SECURE_TRIM1_ARG)
 		err = mmc_erase(card, from, nr, MMC_SECURE_TRIM2_ARG);
@@ -422,6 +440,15 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 
 		mmc_queue_bounce_pre(mq);
 
+		/*
+		 * Before issuing a user req, host driver should
+		 * wait for the BKOPS is done or just use HPI to
+		 * interrupt it.
+		 */
+		ret = mmc_wait_for_bkops(card);
+		if (ret)
+			goto cmd_err;
+
 		mmc_wait_for_req(card->host, &brq.mrq);
 
 		mmc_queue_bounce_post(mq);
@@ -513,6 +540,13 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 		}
 
 		/*
+		 * Check if need to do bkops by each R1 response command
+		 */
+		if (mmc_card_mmc(card) &&
+				(brq.cmd.resp[0] & R1_URGENT_BKOPS))
+			mmc_card_set_need_bkops(card);
+
+		/*
 		 * A block was successfully transferred.
 		 */
 		spin_lock_irq(&md->lock);
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 4e42d03..9d2c0b4 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -65,6 +65,7 @@ static int mmc_queue_thread(void *d)
 				set_current_state(TASK_RUNNING);
 				break;
 			}
+			mmc_start_do_bkops(mq->card);
 			up(&mq->thread_sem);
 			schedule();
 			down(&mq->thread_sem);
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6286898..6891169 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -202,6 +202,71 @@ static void mmc_wait_done(struct mmc_request *mrq)
 }
 
 /**
+ *	mmc_wait_for_bkops- start a bkops check and wait for
+ *	completion
+ *	@card: MMC card need to check
+ *
+ *  start MMC_SEND_STATUS to check whether the card is busy for
+ *  BKOPS. Wait until the block finish BKOPS.
+ *
+ *  return value:
+ *  0: successful waiting for BKOPS or interrupt BKOPS
+ *  -EIO: failed during waiting for BKOPS
+ */
+int mmc_wait_for_bkops(struct mmc_card *card)
+{
+	struct mmc_command cmd;
+	int err;
+
+retry:
+	if (!card || !mmc_card_doing_bkops(card))
+		return 0;
+
+	if (card->ext_csd.hpi_en) {
+		/*
+		 * TODO
+		 * HPI to interrupt BKOPS if supported
+		 */
+	} else {
+		memset(&cmd, 0, sizeof(struct mmc_command));
+
+		cmd.opcode = MMC_SEND_STATUS;
+		cmd.arg = card->rca << 16;
+		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
+
+		err = mmc_wait_for_cmd(card->host, &cmd, 0);
+
+		if (err || (cmd.resp[0] & 0xFDF92000)) {
+			printk(KERN_ERR "error %d requesting status %#x\n",
+				err, cmd.resp[0]);
+			/*
+			 * abandon this BKOPS, let block layer handle
+			 * this
+			 */
+			err = -EIO;
+			goto out;
+		}
+
+		if (!(cmd.resp[0] & R1_READY_FOR_DATA) ||
+			 R1_CURRENT_STATE(cmd.resp[0]) == 7) {
+			/*
+			 * card is till busy for BKOPS, will
+			 * retry. Since background operations
+			 * may cause a lot time, here use schedule
+			 * to release CPU for other thread
+			 */
+			schedule();
+			goto retry;
+		}
+		err = 0;
+	}
+out:
+	mmc_card_clr_doing_bkops(card);
+	return err;
+}
+EXPORT_SYMBOL(mmc_wait_for_bkops);
+
+/**
  *	mmc_wait_for_req - start a request and wait for completion
  *	@host: MMC host to start command
  *	@mrq: MMC request to start
@@ -1469,6 +1534,142 @@ int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
 }
 EXPORT_SYMBOL(mmc_erase_group_aligned);
 
+/**
+ * mmc_bkops_scan - detect whether the BKOPS is done. If done, put
+ * device in runtime suspend state
+ *
+ * In this function, driver send cmd13 to check if BKOPS is done.
+ * If is not done, then start a new workqueue to detect again.
+ * If is done, then put try to put card in runtime suspend state
+ */
+void mmc_bkops_scan(struct work_struct *work)
+{
+	struct mmc_host *host =
+		container_of(work, struct mmc_host, bkops_scan.work);
+	struct mmc_command cmd;
+	struct mmc_card *card = host->card;
+	int err;
+
+	mmc_claim_host(host);
+
+	if (!card || !mmc_card_doing_bkops(card))
+		goto out;
+	/*
+	 * Check whether the BKOSP is done
+	 * First should claim host without
+	 * runtime get since the mmc_start_do_bkops
+	 * routine only release host without
+	 * runtime put.
+	 */
+	memset(&cmd, 0, sizeof(struct mmc_command));
+	cmd.opcode = MMC_SEND_STATUS;
+	cmd.arg = card->rca << 16;
+	cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
+	err = mmc_wait_for_cmd(host, &cmd, 0);
+	if (err || (cmd.resp[0] & 0xFDF92000)) {
+		printk(KERN_ERR "error %d requesting status %#x\n",
+			err, cmd.resp[0]);
+		/*
+		 * handle error
+		 * Abandon this BKOPS and just let card be
+		 * back to D0i3 mode if possible
+		 */
+		mmc_card_clr_doing_bkops(card);
+		goto out;
+	}
+
+	if (!(cmd.resp[0] & R1_READY_FOR_DATA) ||
+		 R1_CURRENT_STATE(cmd.resp[0]) == 7) {
+		mmc_release_host(host);
+		/* setup a timer to detect again */
+		mmc_schedule_delayed_work(&host->bkops_scan, HZ * 2);
+		return;
+	}
+	mmc_card_clr_doing_bkops(card);
+out:
+	/*
+	 * TODO runtime_put
+	 */
+	mmc_release_host(host);
+}
+
+/**
+ * mmc_start_do_bkops - start to do BKOPS if eMMC card supported
+ * @card: card to do BKOPS
+ *
+ * If this function, reserved place for runtime power management.
+ * Since background operations should be done when user request
+ * queue is empty, and at that time card and host controller maybe
+ * are in runtime suspend status, before sending any command, we
+ * should make sure the device is power on status.
+ *
+ * Also add a workqueue to detect when to put the device in runtime
+ * suspend status.
+ */
+void mmc_start_do_bkops(struct mmc_card *card)
+{
+	int err;
+	/*
+	 * If card is doing bkops or already need to
+	 * do bkops, just do nothing and return
+	 */
+	if (!card)
+		return;
+	if (!card->ext_csd.bkops_en)
+		return;
+	if (mmc_card_doing_bkops(card) ||
+			!mmc_card_need_bkops(card))
+		return;
+
+	/*
+	 * Start to do bkops
+	 * TODO if MMC driver has a runtime feature,
+	 * should call pm_runtime_get_sync here
+	 */
+	mmc_claim_host(card->host);
+	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+			EXT_CSD_BKOPS_START, 1);
+	if (err) {
+		/*
+		 * If occurred err, just abandon this BKOPS
+		 */
+		mmc_card_clr_need_bkops(card);
+		/*
+		 * TODO if MMC driver has a runtime feature,
+		 * should call pm_runtime_put here
+		 */
+		goto out;
+	}
+	mmc_card_clr_need_bkops(card);
+	mmc_card_set_doing_bkops(card);
+	/*
+	 * setup a workqueue to detect whether the BKOPS is done
+	 *
+	 * Note: why add a workqueue here.
+	 * If MMC driver has a runtime feature, before starting
+	 * BKOPS, card needs to be back from D0i3. So after
+	 * finishing BKOPS, card needs to be back to D0i3 again.
+	 * MMC driver cannot call pm_runtime_put immediately
+	 * after starting BKOPS since BKOPS is ongoing in the
+	 * background.
+	 *
+	 * So there is a questions: After card starts to do bkops
+	 * and there is no user request from that time on, how
+	 * does card be back to D0i3 again?
+	 *
+	 * Since driver cannot know when the BKOPS is done without
+	 * sending cmd13 to check card status, there must have a
+	 * mechanism to let MMC driver sending cmd13 periodically.
+	 * After BKOPS is done, mmc driver can issue pm_runtime_put
+	 * to let card be back to D0i3 again safely.
+	 */
+	mmc_schedule_delayed_work(&card->host->bkops_scan, HZ * 2);
+out:
+	mmc_release_host(card->host);
+	return;
+}
+EXPORT_SYMBOL(mmc_start_do_bkops);
+
 int mmc_set_blocklen(struct mmc_card *card, unsigned int blocklen)
 {
 	struct mmc_command cmd;
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 026c975..368216b 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -53,6 +53,7 @@ static inline void mmc_delay(unsigned int ms)
 	}
 }
 
+void mmc_bkops_scan(struct work_struct *work);
 void mmc_rescan(struct work_struct *work);
 void mmc_start_host(struct mmc_host *host);
 void mmc_stop_host(struct mmc_host *host);
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 92e3370..bd520c6 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -288,6 +288,7 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	init_waitqueue_head(&host->wq);
 	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
 	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
+	INIT_DELAYED_WORK(&host->bkops_scan, mmc_bkops_scan);
 #ifdef CONFIG_PM
 	host->pm_notify.notifier_call = mmc_pm_notify;
 #endif
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 9b755cb..4142ab5 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -56,6 +56,7 @@ struct mmc_ext_csd {
 	unsigned int		trim_timeout;		/* In milliseconds */
 	unsigned int		bkops:1; /* background support bit */
 	unsigned int		bkops_en:1; /* background enable bit */
+	unsigned int		hpi_en:1; /* HPI enable bit */
 };
 
 struct sd_scr {
@@ -117,6 +118,8 @@ struct mmc_card {
 #define MMC_STATE_HIGHSPEED	(1<<2)		/* card is in high speed mode */
 #define MMC_STATE_BLOCKADDR	(1<<3)		/* card uses block-addressing */
 #define MMC_STATE_HIGHSPEED_DDR (1<<4)		/* card is in high speed mode */
+#define MMC_STATE_NEED_BKOPS	(1<<5) /* card need to do BKOPS */
+#define MMC_STATE_DOING_BKOPS	(1<<6) /* card is doing BKOPS */
 	unsigned int		quirks; 	/* card quirks */
 #define MMC_QUIRK_LENIENT_FN0	(1<<0)		/* allow SDIO FN0 writes outside of the VS CCCR range */
 #define MMC_QUIRK_BLKSZ_FOR_BYTE_MODE (1<<1)	/* use func->cur_blksize */
@@ -159,12 +162,19 @@ struct mmc_card {
 #define mmc_card_highspeed(c)	((c)->state & MMC_STATE_HIGHSPEED)
 #define mmc_card_blockaddr(c)	((c)->state & MMC_STATE_BLOCKADDR)
 #define mmc_card_ddr_mode(c)	((c)->state & MMC_STATE_HIGHSPEED_DDR)
+#define mmc_card_need_bkops(c)	((c)->state & MMC_STATE_NEED_BKOPS)
+#define mmc_card_doing_bkops(c)	((c)->state & MMC_STATE_DOING_BKOPS)
 
 #define mmc_card_set_present(c)	((c)->state |= MMC_STATE_PRESENT)
 #define mmc_card_set_readonly(c) ((c)->state |= MMC_STATE_READONLY)
 #define mmc_card_set_highspeed(c) ((c)->state |= MMC_STATE_HIGHSPEED)
 #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
 #define mmc_card_set_ddr_mode(c) ((c)->state |= MMC_STATE_HIGHSPEED_DDR)
+#define mmc_card_set_need_bkops(c)	((c)->state |= MMC_STATE_NEED_BKOPS)
+#define mmc_card_set_doing_bkops(c)	((c)->state |= MMC_STATE_DOING_BKOPS)
+
+#define mmc_card_clr_need_bkops(c)	((c)->state &= ~MMC_STATE_NEED_BKOPS)
+#define mmc_card_clr_doing_bkops(c)	((c)->state &= ~MMC_STATE_DOING_BKOPS)
 
 static inline int mmc_card_lenient_fn0(const struct mmc_card *c)
 {
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 64e013f..0011d49 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -131,6 +131,7 @@ struct mmc_request {
 struct mmc_host;
 struct mmc_card;
 
+extern int mmc_wait_for_bkops(struct mmc_card *);
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
 extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
@@ -153,6 +154,8 @@ extern int mmc_can_secure_erase_trim(struct mmc_card *card);
 extern int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
 				   unsigned int nr);
 
+extern void mmc_start_do_bkops(struct mmc_card *card);
+
 extern int mmc_set_blocklen(struct mmc_card *card, unsigned int blocklen);
 
 extern void mmc_set_data_timeout(struct mmc_data *, const struct mmc_card *);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 381c77f..b3f50da 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -212,6 +212,8 @@ struct mmc_host {
 	unsigned int		disable_delay;	/* disable delay in msecs */
 	struct delayed_work	disable;	/* disabling work */
 
+	struct delayed_work	bkops_scan;	/* detect the BKOPS status */
+
 	struct mmc_card		*card;		/* device attached to this host */
 
 	wait_queue_head_t	wq;
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 14f7813..ef85e90 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -129,6 +129,7 @@
 #define R1_CURRENT_STATE(x)	((x & 0x00001E00) >> 9)	/* sx, b (4 bits) */
 #define R1_READY_FOR_DATA	(1 << 8)	/* sx, a */
 #define R1_SWITCH_ERROR		(1 << 7)	/* sx, c */
+#define R1_URGENT_BKOPS		(1 << 6) /* sx, a */
 #define R1_APP_CMD		(1 << 5)	/* sr, c */
 
 /*
-- 
1.6.6.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2KHNKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:10:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:19797 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab2KHNDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:03:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102109"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 06/26] mmc: block: add panic write support
Date: Thu,  8 Nov 2012 15:06:04 +0200
Message-Id: <1352379984-18381-7-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Define panic_write_operations for mmc block devices.
Also define host mmc panic ops for controling panic dumping.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/card/Kconfig |   11 ++
 drivers/mmc/card/block.c |  257 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/mmc/host.h |   92 +++++++++++++++++
 3 files changed, 359 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
index 3b1f783..06c09a3 100644
--- a/drivers/mmc/card/Kconfig
+++ b/drivers/mmc/card/Kconfig
@@ -50,6 +50,17 @@ config MMC_BLOCK_BOUNCE
 
 	  If unsure, say Y here.
 
+config MMC_BLOCK_PANIC_WRITE
+	bool "Panic write support"
+	depends on MMC_BLOCK
+	select BLK_DEV_PANIC_WRITE
+	default n
+	help
+	  Say Y here to support panic write. Panic write enables upper
+	  layers to write to MMC/SD cards during an oops or panic.
+	  However a host controller driver that supports panic writes
+	  is also needed. Panic writes are defined by mmc_panic_ops.
+
 config SDIO_UART
 	tristate "SDIO UART/GPS class support"
 	help
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 172a768..e18ce4a 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -108,6 +108,11 @@ struct mmc_blk_data {
 	struct device_attribute force_ro;
 	struct device_attribute power_ro_lock;
 	int	area_type;
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+	int			panic;
+	struct scatterlist	*panic_sg;
+	struct mmc_blk_request	*panic_brq;
+#endif
 };
 
 static DEFINE_MUTEX(open_lock);
@@ -517,7 +522,7 @@ static const struct block_device_operations mmc_bdops = {
 #endif
 };
 
-static inline int mmc_blk_part_switch(struct mmc_card *card,
+static int mmc_blk_part_switch(struct mmc_card *card,
 				      struct mmc_blk_data *md)
 {
 	int ret;
@@ -1432,6 +1437,253 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+
+static int mmc_blk_panic_init_cleanup(struct block_device *bdev, int init)
+{
+	struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
+	struct mmc_card *card;
+	int err = 0;
+
+	if (!md)
+		return -ENODEV;
+
+	card = md->queue.card;
+	if (!card) {
+		err = -ENODEV;
+		goto out_put;
+	}
+
+	mmc_claim_host(card->host);
+
+	if (!init) {
+		mmc_panic_cleanup_host(card->host);
+		goto out_free_brq;
+	}
+
+	md->panic_sg = kmalloc(sizeof(struct scatterlist), GFP_KERNEL);
+	if (!md->panic_sg) {
+		err = -ENOMEM;
+		goto out_release;
+	}
+	sg_init_table(md->panic_sg, 1);
+
+	md->panic_brq = kmalloc(sizeof(struct mmc_blk_request), GFP_KERNEL);
+	if (!md->panic_brq) {
+		err = -ENOMEM;
+		goto out_free_sg;
+	}
+
+	err = mmc_panic_init_host(card->host);
+	if (err)
+		goto out_free_brq;
+
+	goto out_release;
+
+out_free_brq:
+	kfree(md->panic_brq);
+out_free_sg:
+	kfree(md->panic_sg);
+out_release:
+	mmc_release_host(card->host);
+out_put:
+	mmc_blk_put(md);
+	return err;
+}
+
+static int mmc_blk_panic_init(struct block_device *bdev)
+{
+	return mmc_blk_panic_init_cleanup(bdev, 1);
+}
+
+static void mmc_blk_panic_cleanup(struct block_device *bdev)
+{
+	mmc_blk_panic_init_cleanup(bdev, 0);
+}
+
+static int get_card_status(struct mmc_card *card, u32 *status, int retries);
+
+static int mmc_blk_panic_do_write(struct mmc_blk_data *md,
+				  struct mmc_card *card, sector_t sect,
+				  void *addr, unsigned long len)
+{
+	struct mmc_blk_request *brq = md->panic_brq;
+	unsigned int blocks = len >> 9;
+	unsigned int blksz = 512;
+
+	int err = 0;
+
+	sg_init_one(md->panic_sg, addr, len);
+
+	memset(brq, 0, sizeof(struct mmc_blk_request));
+
+	brq->mrq.cmd = &brq->cmd;
+	brq->mrq.data = &brq->data;
+	brq->mrq.stop = &brq->stop;
+
+	if (blocks > 1)
+		brq->mrq.cmd->opcode = MMC_WRITE_MULTIPLE_BLOCK;
+	else
+		brq->mrq.cmd->opcode = MMC_WRITE_BLOCK;
+
+	brq->mrq.cmd->arg = sect;
+	if (!mmc_card_blockaddr(card))
+		brq->mrq.cmd->arg <<= 9;
+
+	brq->mrq.cmd->flags = MMC_RSP_R1 | MMC_CMD_ADTC;
+
+	if (blocks == 1)
+		brq->mrq.stop = NULL;
+	else {
+		brq->mrq.stop->opcode = MMC_STOP_TRANSMISSION;
+		brq->mrq.stop->arg = 0;
+		brq->mrq.stop->flags = MMC_RSP_R1B | MMC_CMD_AC;
+	}
+
+	brq->mrq.data->blksz = blksz;
+	brq->mrq.data->blocks = blocks;
+	brq->mrq.data->flags = MMC_DATA_WRITE;
+	brq->mrq.data->sg = md->panic_sg;
+	brq->mrq.data->sg_len = 1;
+
+	mmc_set_data_timeout(brq->mrq.data, card);
+
+	mmc_wait_for_req(card->host, &brq->mrq);
+
+	if (brq->cmd.error)
+		err = brq->cmd.error;
+	else if (brq->stop.error)
+		err = brq->stop.error;
+	else if (brq->data.error)
+		err = brq->data.error;
+
+	if (!mmc_host_is_spi(card->host)) {
+		u32 status;
+
+		do {
+			err = get_card_status(card, &status, 5);
+			if (err)
+				break;
+		} while (!(status & R1_READY_FOR_DATA) ||
+			 (R1_CURRENT_STATE(status) == R1_STATE_PRG));
+	}
+
+	return err;
+}
+
+static int mmc_blk_panic_reset(struct mmc_blk_data *md, struct mmc_host *host)
+{
+	struct mmc_blk_data *main_md = mmc_get_drvdata(host->card);
+	int err;
+
+	err = mmc_blk_reset(md, host, 0);
+	if (err != -EOPNOTSUPP)
+		goto out;
+
+	/* No hardware reset so try a software reset */
+	mmc_power_save_host(host);
+	mmc_power_restore_host(host);
+out:
+	/* Partition may have changed, force a switch */
+	main_md->part_curr = -1;
+
+	return err;
+}
+
+/*
+ * Tuning while panicing is not supported, so disable speeds that require it
+ * and reset.
+ */
+static int mmc_blk_panic_no_tuning(struct mmc_blk_data *md,
+				   struct mmc_host *host)
+{
+	if (host->ocr & SD_OCR_S18R) {
+		host->caps &= ~(MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25 |
+				MMC_CAP_UHS_SDR50 | MMC_CAP_UHS_SDR104 |
+				MMC_CAP_UHS_DDR50);
+		host->ocr &= ~SD_OCR_S18R;
+		return mmc_blk_panic_reset(md, host);
+	}
+	return 0;
+}
+
+static int mmc_blk_panic_write(struct block_device *bdev, sector_t sect,
+			       void *addr, unsigned long len)
+{
+	struct mmc_blk_data *md = bdev->bd_disk->private_data;
+	struct mmc_card *card;
+	size_t n;
+	int err = 0, err2;
+
+	if (!md)
+		return -ENODEV;
+	card = md->queue.card;
+	if (!card)
+		return -ENODEV;
+
+	card->host->panic_task = current;
+
+	if (!md->panic) {
+		u32 status;
+
+		md->panic = 1;
+		mmc_panic_begin_host(card->host);
+		mmc_blk_panic_no_tuning(md, card->host);
+		err2 = get_card_status(card, &status, 0);
+		if (err2 || !(status & R1_READY_FOR_DATA) ||
+		    R1_CURRENT_STATE(status) != R1_STATE_TRAN)
+			mmc_blk_panic_reset(md, card->host);
+		mmc_set_blocklen(card, 512);
+	}
+
+	err = mmc_blk_part_switch(card, md);
+	if (err)
+		return err;
+
+	while (len) {
+		n = min_t(size_t, card->host->panic_max_size, len);
+		err2 = mmc_blk_panic_do_write(md, card, sect, addr, n);
+		if (err2 && !err)
+			err = err2;
+		len -= n;
+		addr += n;
+		sect += n >> 9;
+	}
+
+	return err;
+}
+
+static int mmc_blk_panic_flush(struct block_device *bdev)
+{
+	struct mmc_blk_data *md = bdev->bd_disk->private_data;
+	struct mmc_card *card;
+
+	if (!md)
+		return -ENODEV;
+	card = md->queue.card;
+	if (!card)
+		return -ENODEV;
+
+	if (md->panic) {
+		card->host->panic_task = current;
+		mmc_panic_end_host(card->host);
+		md->panic = 0;
+	}
+
+	card->host->panic_task = NULL;
+
+	return 0;
+}
+
+static const struct panic_write_operations mmc_pwops = {
+	.init			= mmc_blk_panic_init,
+	.cleanup		= mmc_blk_panic_cleanup,
+	.write			= mmc_blk_panic_write,
+	.flush			= mmc_blk_panic_flush,
+};
+
+#endif
+
 static inline int mmc_blk_readonly(struct mmc_card *card)
 {
 	return mmc_card_readonly(card) ||
@@ -1500,6 +1752,9 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	md->disk->major	= MMC_BLOCK_MAJOR;
 	md->disk->first_minor = devidx * perdev_minors;
 	md->disk->fops = &mmc_bdops;
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+	md->disk->pwops = &mmc_pwops;
+#endif
 	md->disk->private_data = md;
 	md->disk->queue = md->queue.queue;
 	md->disk->driverfs_dev = parent;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7abb0e1..4205d2d 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -13,6 +13,7 @@
 #include <linux/leds.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/fault-inject.h>
 
@@ -138,6 +139,17 @@ struct mmc_host_ops {
 	void	(*hw_reset)(struct mmc_host *host);
 };
 
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+
+struct mmc_panic_ops {
+	int (*init)(struct mmc_host *host);
+	void (*cleanup)(struct mmc_host *host);
+	void (*begin)(struct mmc_host *host);
+	void (*end)(struct mmc_host *host);
+};
+
+#endif
+
 struct mmc_card;
 struct device;
 
@@ -257,6 +269,7 @@ struct mmc_host {
 #define MMC_CAP2_HC_ERASE_SZ	(1 << 9)	/* High-capacity erase size */
 #define MMC_CAP2_CD_ACTIVE_HIGH	(1 << 10)	/* Card-detect signal active high */
 #define MMC_CAP2_RO_ACTIVE_HIGH	(1 << 11)	/* Write-protect signal active high */
+#define MMC_CAP_PANIC_WRITE	(1 << 12)	/* Panic write support */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
@@ -337,6 +350,12 @@ struct mmc_host {
 
 	unsigned int		actual_clock;	/* Actual HC clock rate */
 
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+	struct task_struct	*panic_task;	/* task that is panic writing */
+	const struct mmc_panic_ops *pops;	/* panic operations */
+	size_t			panic_max_size;	/* max data transfer size */
+#endif
+
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
@@ -452,4 +471,77 @@ static inline unsigned int mmc_host_clk_rate(struct mmc_host *host)
 	return host->ios.clock;
 }
 #endif
+
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+
+static inline int mmc_panic_task_active(struct mmc_host *host)
+{
+	return host->panic_task != NULL;
+}
+
+static inline int mmc_am_panic_task(struct mmc_host *host)
+{
+	return host->panic_task == current;
+}
+
+static inline int mmc_am_nonpanic_task(struct mmc_host *host)
+{
+	return host->panic_task && host->panic_task != current;
+}
+
+static inline void mmc_trap_nonpanic_tasks(struct mmc_host *host)
+{
+	while (host->panic_task && host->panic_task != current)
+		msleep(100);
+}
+
+static inline int mmc_panic_init_host(struct mmc_host *host)
+{
+	if (!(host->caps2 & MMC_CAP_PANIC_WRITE))
+		return -EOPNOTSUPP;
+	if (host->pops->init)
+		return host->pops->init(host);
+	return 0;
+}
+
+static inline void mmc_panic_cleanup_host(struct mmc_host *host)
+{
+	if (host->pops->cleanup)
+		host->pops->cleanup(host);
+}
+
+static inline void mmc_panic_begin_host(struct mmc_host *host)
+{
+if (host->pops->begin)
+		host->pops->begin(host);
+}
+
+static inline void mmc_panic_end_host(struct mmc_host *host)
+{
+	if (host->pops->end)
+		host->pops->end(host);
+}
+
+#else
+
+static inline int mmc_panic_task_active(struct mmc_host *host)
+{
+	return 0;
+}
+
+static inline int mmc_am_panic_task(struct mmc_host *host)
+{
+	return 0;
+}
+
+static inline int mmc_am_nonpanic_task(struct mmc_host *host)
+{
+	return 0;
+}
+
+static inline void mmc_trap_nonpanic_tasks(struct mmc_host *host)
+{
+}
+
+#endif
 #endif /* LINUX_MMC_HOST_H */
-- 
1.7.9.5


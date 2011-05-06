Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab1EFAni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:43:38 -0400
Received: from kroah.org ([198.145.64.141]:37174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396Ab1EFAZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:15 2011
Message-Id: <20110506002215.642830578@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, <linux-mmc@vger.kernel.org>
Subject: [106/143] mmc: fix all hangs related to mmc/sd card insert/removal during suspend/resume
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Maxim Levitsky <maximlevitsky@gmail.com>

commit 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e upstream.

If you don't use CONFIG_MMC_UNSAFE_RESUME, as soon as you attempt to
suspend, the card will be removed, therefore this patch doesn't change the
behavior of this option.

However the removal will be done by pm notifier, which runs while
userspace is still not frozen and thus can freely use del_gendisk, without
the risk of deadlock which would happen otherwise.

Card detect workqueue is now disabled while userspace is frozen, Therefore
if you do use CONFIG_MMC_UNSAFE_RESUME, and remove the card during
suspend, the removal will be detected as soon as userspace is unfrozen,
again at the moment it is safe to call del_gendisk.

Tested with and without CONFIG_MMC_UNSAFE_RESUME with suspend and hibernate.

[akpm@linux-foundation.org: clean up function prototype]
[akpm@linux-foundation.org: fix CONFIG_PM-n linkage, small cleanups]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Adjust for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/core/core.c  |   81 ++++++++++++++++++++++++++++++++---------------
 drivers/mmc/core/host.c  |    4 ++
 include/linux/mmc/host.h |    3 +
 3 files changed, 63 insertions(+), 25 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1041,6 +1041,17 @@ void mmc_rescan(struct work_struct *work
 		container_of(work, struct mmc_host, detect.work);
 	u32 ocr;
 	int err;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	if (host->rescan_disable) {
+		spin_unlock_irqrestore(&host->lock, flags);
+		return;
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
 
 	mmc_bus_get(host);
 
@@ -1247,18 +1258,6 @@ int mmc_suspend_host(struct mmc_host *ho
 	if (host->bus_ops && !host->bus_dead) {
 		if (host->bus_ops->suspend)
 			err = host->bus_ops->suspend(host);
-		if (err == -ENOSYS || !host->bus_ops->resume) {
-			/*
-			 * We simply "remove" the card in this case.
-			 * It will be redetected on resume.
-			 */
-			if (host->bus_ops->remove)
-				host->bus_ops->remove(host);
-			mmc_claim_host(host);
-			mmc_detach_bus(host);
-			mmc_release_host(host);
-			err = 0;
-		}
 	}
 	mmc_bus_put(host);
 
@@ -1288,28 +1287,60 @@ int mmc_resume_host(struct mmc_host *hos
 			printk(KERN_WARNING "%s: error %d during resume "
 					    "(card was removed?)\n",
 					    mmc_hostname(host), err);
-			if (host->bus_ops->remove)
-				host->bus_ops->remove(host);
-			mmc_claim_host(host);
-			mmc_detach_bus(host);
-			mmc_release_host(host);
-			/* no need to bother upper layers */
 			err = 0;
 		}
 	}
 	mmc_bus_put(host);
 
-	/*
-	 * We add a slight delay here so that resume can progress
-	 * in parallel.
-	 */
-	mmc_detect_change(host, 1);
-
 	return err;
 }
-
 EXPORT_SYMBOL(mmc_resume_host);
 
+/* Do the card removal on suspend if card is assumed removeable
+ * Do that in pm notifier while userspace isn't yet frozen, so we will be able
+   to sync the card.
+*/
+int mmc_pm_notify(struct notifier_block *notify_block,
+					unsigned long mode, void *unused)
+{
+	struct mmc_host *host = container_of(
+		notify_block, struct mmc_host, pm_notify);
+	unsigned long flags;
+
+
+	switch (mode) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+
+		spin_lock_irqsave(&host->lock, flags);
+		host->rescan_disable = 1;
+		spin_unlock_irqrestore(&host->lock, flags);
+		cancel_delayed_work_sync(&host->detect);
+
+		if (!host->bus_ops || host->bus_ops->suspend)
+			break;
+
+		mmc_claim_host(host);
+
+		if (host->bus_ops->remove)
+			host->bus_ops->remove(host);
+
+		mmc_detach_bus(host);
+		mmc_release_host(host);
+		break;
+
+	case PM_POST_SUSPEND:
+	case PM_POST_HIBERNATION:
+
+		spin_lock_irqsave(&host->lock, flags);
+		host->rescan_disable = 0;
+		spin_unlock_irqrestore(&host->lock, flags);
+		mmc_detect_change(host, 0);
+
+	}
+
+	return 0;
+}
 #endif
 
 static int __init mmc_init(void)
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -16,6 +16,7 @@
 #include <linux/idr.h>
 #include <linux/pagemap.h>
 #include <linux/leds.h>
+#include <linux/suspend.h>
 
 #include <linux/mmc/host.h>
 
@@ -84,6 +85,7 @@ struct mmc_host *mmc_alloc_host(int extr
 	init_waitqueue_head(&host->wq);
 	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
 	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
+	host->pm_notify.notifier_call = mmc_pm_notify;
 
 	/*
 	 * By default, hosts do not support SGIO or large requests.
@@ -132,6 +134,7 @@ int mmc_add_host(struct mmc_host *host)
 #endif
 
 	mmc_start_host(host);
+	register_pm_notifier(&host->pm_notify);
 
 	return 0;
 }
@@ -148,6 +151,7 @@ EXPORT_SYMBOL(mmc_add_host);
  */
 void mmc_remove_host(struct mmc_host *host)
 {
+	unregister_pm_notifier(&host->pm_notify);
 	mmc_stop_host(host);
 
 #ifdef CONFIG_DEBUG_FS
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -120,6 +120,7 @@ struct mmc_host {
 	unsigned int		f_min;
 	unsigned int		f_max;
 	u32			ocr_avail;
+	struct notifier_block	pm_notify;
 
 #define MMC_VDD_165_195		0x00000080	/* VDD voltage 1.65 - 1.95 */
 #define MMC_VDD_20_21		0x00000100	/* VDD voltage 2.0 ~ 2.1 */
@@ -177,6 +178,7 @@ struct mmc_host {
 
 	/* Only used with MMC_CAP_DISABLE */
 	int			enabled;	/* host is enabled */
+	int			rescan_disable;	/* disable card detection */
 	int			nesting_cnt;	/* "enable" nesting count */
 	int			en_dis_recurs;	/* detect recursion */
 	unsigned int		disable_delay;	/* disable delay in msecs */
@@ -249,6 +251,7 @@ int mmc_card_can_sleep(struct mmc_host *
 int mmc_host_enable(struct mmc_host *host);
 int mmc_host_disable(struct mmc_host *host);
 int mmc_host_lazy_disable(struct mmc_host *host);
+int mmc_pm_notify(struct notifier_block *notify_block, unsigned long, void *);
 
 static inline void mmc_set_disable_delay(struct mmc_host *host,
 					 unsigned int disable_delay)



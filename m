Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193Ab0FKTAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:00:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:48874 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab0FKTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:00:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sMRDCZKPchbMnBc4N+OCP3RGUCZmXOVwSTeoTAsIUvlBDsraUdVL9PtXF4iqm/WzF7
         rglIrPdMlMEE+JxpO2V1QG/XoK5G6Q0sfeiTM3gHyOP3FSH1r/kYjAF7Y6TRIPSjg4nu
         zPFChA3W77driwfJULrY3Bje6TMGLJSW1+Pgs=
Subject: [PATCH] Fix the outstanding issue with hangs on insert/removal of
 mmc cards
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-mmc <linux-mmc@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 22:00:01 +0300
Message-ID: <1276282801.8557.20.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After thinking a lot about how to fix properly the hangs caused by
insert/removal of mmc card during suspend/resume, and default behavior
of not trusting the card persistence over suspend, I finally come to
conclusion that changing the del_gendisk is wrong.

First of all there are 2 types of removal possible. First one happens
when system detects that some device is gone. At that point there is
really no point in syncing it.

The other type of removal is controlled removal, usually on user
request. Surly we must sync the device of this request.
This type of removal _shouldn't_ happen during suspend/resume
transaction. The only case when it does is today to protect against user
carelessness of switching the cards during suspend.

I think that it is just wrong to sync the device in suspend/resume time.
At that time userspace is frozen, but also its not known which drivers
are still running. They might even suspend asynchronously...
So, such cases should be moved to pm-notifier, thing that my patch does
for mmc.
Other users should be fixed as well.

We can, in addition to that, add a temporary hack to del_gendisk with
loud WARN_ON though.

If card is really removed during suspend, then we can just introduce
del_gendisk_dead or something like that which will be safe to call
during suspend.

I didn't do that but rather I made the card detection thread freezeable,
thus eliminated the whole problem.
If you remove the card during suspend, system will notice at end of
resume.

---

commit 395a40018e09b109811a1fc5b09572f30e7db9d6
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Fri Jun 11 20:14:13 2010 +0300

    MMC: fix all hangs related to mmc/sd card insert/removal during suspend/resume.
    
    If you don't use CONFIG_MMC_UNSAFE_RESUME, card will now be removed
    in pm notifier, while userspace is still running.
    Thus it will be possible to sync it properly.
    
    Card detect workqueue is now freezable, therefore a card insert/removal event will
    wait till userspace is unfrozen.
    
    Tested with and without CONFIG_MMC_UNSAFE_RESUME, with suspend and hibernate.
    
    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 85d15de..0cba53a 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1264,19 +1264,6 @@ int mmc_suspend_host(struct mmc_host *host)
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
-			host->pm_flags = 0;
-			err = 0;
-		}
 	}
 	mmc_bus_put(host);
 
@@ -1308,12 +1295,6 @@ int mmc_resume_host(struct mmc_host *host)
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
@@ -1328,6 +1309,37 @@ int mmc_resume_host(struct mmc_host *host)
 	return err;
 }
 
+/* Do the card removal on suspend if card is assumed removeable
+ * Do that in pm notifier while userspace isn't yet frozen, so we will be able
+   to sync the card.
+*/
+int mmc_pm_notify(struct notifier_block *notify_block,
+					unsigned long mode, void *unused)
+{
+	struct mmc_host *host = container_of(
+		notify_block, struct mmc_host, pm_notify);
+
+
+	switch (mode) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+
+		if (!host->bus_ops || host->bus_ops->suspend)
+			break;
+
+		if (host->bus_ops->remove)
+			host->bus_ops->remove(host);
+		mmc_claim_host(host);
+		mmc_detach_bus(host);
+		mmc_release_host(host);
+		host->pm_flags = 0;
+		break;
+
+	}
+
+	return 0;
+}
+
 EXPORT_SYMBOL(mmc_resume_host);
 
 #endif
@@ -1336,7 +1348,7 @@ static int __init mmc_init(void)
 {
 	int ret;
 
-	workqueue = create_singlethread_workqueue("kmmcd");
+	workqueue = create_freezeable_workqueue("kmmcd");
 	if (!workqueue)
 		return -ENOMEM;
 
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 4735390..53f3406 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -17,6 +17,7 @@
 #include <linux/pagemap.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
+#include <linux/suspend.h>
 
 #include <linux/mmc/host.h>
 
@@ -85,6 +86,8 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	init_waitqueue_head(&host->wq);
 	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
 	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
+	host->pm_notify.notifier_call = mmc_pm_notify;
+
 
 	/*
 	 * By default, hosts do not support SGIO or large requests.
@@ -132,6 +135,7 @@ int mmc_add_host(struct mmc_host *host)
 	mmc_add_host_debugfs(host);
 #endif
 
+	register_pm_notifier(&host->pm_notify);
 	mmc_start_host(host);
 
 	return 0;
@@ -158,6 +162,8 @@ void mmc_remove_host(struct mmc_host *host)
 	device_del(&host->class_dev);
 
 	led_trigger_unregister_simple(host->led);
+
+	unregister_pm_notifier(&host->pm_notify);
 }
 
 EXPORT_SYMBOL(mmc_remove_host);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index f65913c..b45812d 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -124,6 +124,7 @@ struct mmc_host {
 	unsigned int		f_min;
 	unsigned int		f_max;
 	u32			ocr_avail;
+	struct notifier_block	pm_notify;
 
 #define MMC_VDD_165_195		0x00000080	/* VDD voltage 1.65 - 1.95 */
 #define MMC_VDD_20_21		0x00000100	/* VDD voltage 2.0 ~ 2.1 */
@@ -257,6 +258,8 @@ int mmc_card_can_sleep(struct mmc_host *host);
 int mmc_host_enable(struct mmc_host *host);
 int mmc_host_disable(struct mmc_host *host);
 int mmc_host_lazy_disable(struct mmc_host *host);
+int mmc_pm_notify(struct notifier_block *notify_block, unsigned long, void *);
+
 
 static inline void mmc_set_disable_delay(struct mmc_host *host,
 					 unsigned int disable_delay)




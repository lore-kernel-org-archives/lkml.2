Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab0GNNII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:08:08 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:18746 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756767Ab0GNNIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:08:06 -0400
Date: Wed, 14 Jul 2010 17:08:04 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 5/8] sdhci: Turn host->lock into a mutex
Message-ID: <20100714130804.GE517@oksana.dev.rtsoft.ru>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, we can get rid of the host->lock spinlock, and turn it
into a mutex.

This patch does just this.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/mmc/host/sdhci.c |   53 +++++++++++++++++++--------------------------
 drivers/mmc/host/sdhci.h |    3 +-
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 0358b35..5eddbdb 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -20,6 +20,7 @@
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 #include <linux/scatterlist.h>
 
 #include <linux/leds.h>
@@ -228,16 +229,15 @@ static void sdhci_led_control(struct led_classdev *led,
 	enum led_brightness brightness)
 {
 	struct sdhci_host *host = container_of(led, struct sdhci_host, led);
-	unsigned long flags;
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (brightness == LED_OFF)
 		sdhci_deactivate_led(host);
 	else
 		sdhci_activate_led(host);
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 }
 #endif
 
@@ -1099,11 +1099,10 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct sdhci_host *host;
 	bool present;
-	unsigned long flags;
 
 	host = mmc_priv(mmc);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	WARN_ON(host->mrq != NULL);
 
@@ -1127,18 +1126,17 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		sdhci_send_command(host, mrq->cmd);
 
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 }
 
 static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 	u8 ctrl;
 
 	host = mmc_priv(mmc);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (host->flags & SDHCI_DEVICE_DEAD)
 		goto out;
@@ -1183,25 +1181,24 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 out:
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 }
 
 static int sdhci_get_ro(struct mmc_host *mmc)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 	int present;
 
 	host = mmc_priv(mmc);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (host->flags & SDHCI_DEVICE_DEAD)
 		present = 0;
 	else
 		present = sdhci_readl(host, SDHCI_PRESENT_STATE);
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 
 	if (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT)
 		return !!(present & SDHCI_WRITE_PROTECT);
@@ -1211,11 +1208,10 @@ static int sdhci_get_ro(struct mmc_host *mmc)
 static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 
 	host = mmc_priv(mmc);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (host->flags & SDHCI_DEVICE_DEAD)
 		goto out;
@@ -1227,7 +1223,7 @@ static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 out:
 	mmiowb();
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 }
 
 static const struct mmc_host_ops sdhci_ops = {
@@ -1246,11 +1242,10 @@ static const struct mmc_host_ops sdhci_ops = {
 static void sdhci_card_detect_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 
 	host = container_of(wk, struct sdhci_host, card_detect_work);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
 		if (host->mrq) {
@@ -1267,7 +1262,7 @@ static void sdhci_card_detect_work(struct work_struct *wk)
 		}
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 
 	mmc_detect_change(host->mmc, msecs_to_jiffies(200));
 }
@@ -1275,12 +1270,11 @@ static void sdhci_card_detect_work(struct work_struct *wk)
 static void sdhci_finish_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 	struct mmc_request *mrq;
 
 	host = container_of(wk, struct sdhci_host, finish_work);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	__cancel_delayed_work(&host->timeout_work);
 
@@ -1321,7 +1315,7 @@ static void sdhci_finish_work(struct work_struct *wk)
 #endif
 
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 
 	mmc_request_done(host->mmc, mrq);
 }
@@ -1329,11 +1323,10 @@ static void sdhci_finish_work(struct work_struct *wk)
 static void sdhci_timeout_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 
 	host = container_of(wk, struct sdhci_host, timeout_work.work);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (host->mrq) {
 		printk(KERN_ERR "%s: Timeout waiting for hardware "
@@ -1354,7 +1347,7 @@ static void sdhci_timeout_work(struct work_struct *wk)
 	}
 
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 }
 
 /*****************************************************************************\
@@ -1512,7 +1505,7 @@ static irqreturn_t sdhci_irq_thread(int irq, void *dev_id)
 	u32 intmask;
 	int cardint = 0;
 
-	spin_lock(&host->lock);
+	mutex_lock(&host->lock);
 
 	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
 	sdhci_writel(host, intmask, SDHCI_INT_STATUS);
@@ -1551,7 +1544,7 @@ static irqreturn_t sdhci_irq_thread(int irq, void *dev_id)
 
 	mmiowb();
 
-	spin_unlock(&host->lock);
+	mutex_unlock(&host->lock);
 
 	/*
 	 * We have to delay this as it calls back into the driver.
@@ -1816,7 +1809,7 @@ int sdhci_add_host(struct sdhci_host *host)
 		return -ENODEV;
 	}
 
-	spin_lock_init(&host->lock);
+	mutex_init(&host->lock);
 
 	/*
 	 * Maximum number of segments. Depends on if the hardware
@@ -1926,10 +1919,8 @@ EXPORT_SYMBOL_GPL(sdhci_add_host);
 
 void sdhci_remove_host(struct sdhci_host *host, int dead)
 {
-	unsigned long flags;
-
 	if (dead) {
-		spin_lock_irqsave(&host->lock, flags);
+		mutex_lock(&host->lock);
 
 		host->flags |= SDHCI_DEVICE_DEAD;
 
@@ -1941,7 +1932,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 			schedule_work(&host->finish_work);
 		}
 
-		spin_unlock_irqrestore(&host->lock, flags);
+		mutex_unlock(&host->lock);
 	}
 
 	sdhci_disable_card_detection(host);
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index d96e4dd..364d4e8 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -15,6 +15,7 @@
 #include <linux/workqueue.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/mutex.h>
 #include <linux/io.h>
 
 /*
@@ -256,7 +257,7 @@ struct sdhci_host {
 	char   led_name[32];
 #endif
 
-	spinlock_t		lock;		/* Mutex */
+	struct mutex		lock;		/* Mutex */
 
 	int			flags;		/* Host attributes */
 #define SDHCI_USE_SDMA		(1<<0)		/* Host is SDMA capable */
-- 
1.7.0.5


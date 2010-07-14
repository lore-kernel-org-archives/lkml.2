Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0GNNH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:07:59 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:18715 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754076Ab0GNNH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:07:58 -0400
Date: Wed, 14 Jul 2010 17:07:57 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 1/8] sdhci: Turn timeout timer into delayed work
Message-ID: <20100714130757.GA517@oksana.dev.rtsoft.ru>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for the timeout handler to run in the atomic
context, so this patch turns timeout timeout into the delayed
work.

Note that the timeout handler still grabs an irqsave spinlock,
we'll deal with it in a separate patch.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/mmc/host/sdhci.c |   14 ++++++++------
 drivers/mmc/host/sdhci.h |    3 ++-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index c6d1bd8..dc6328c 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -13,6 +13,8 @@
  *     - JMicron (hardware and technical support)
  */
 
+#include <linux/kernel.h>
+#include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
@@ -906,7 +908,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 		mdelay(1);
 	}
 
-	mod_timer(&host->timer, jiffies + 10 * HZ);
+	schedule_delayed_work(&host->timeout_work, 10 * HZ);
 
 	host->cmd = cmd;
 
@@ -1280,7 +1282,7 @@ static void sdhci_tasklet_finish(unsigned long param)
 
 	spin_lock_irqsave(&host->lock, flags);
 
-	del_timer(&host->timer);
+	__cancel_delayed_work(&host->timeout_work);
 
 	mrq = host->mrq;
 
@@ -1324,12 +1326,12 @@ static void sdhci_tasklet_finish(unsigned long param)
 	mmc_request_done(host->mmc, mrq);
 }
 
-static void sdhci_timeout_timer(unsigned long data)
+static void sdhci_timeout_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
 	unsigned long flags;
 
-	host = (struct sdhci_host*)data;
+	host = container_of(wk, struct sdhci_host, timeout_work.work);
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1877,7 +1879,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	tasklet_init(&host->finish_tasklet,
 		sdhci_tasklet_finish, (unsigned long)host);
 
-	setup_timer(&host->timer, sdhci_timeout_timer, (unsigned long)host);
+	INIT_DELAYED_WORK(&host->timeout_work, sdhci_timeout_work);
 
 	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
 		mmc_hostname(mmc), host);
@@ -1963,7 +1965,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 
 	free_irq(host->irq, host);
 
-	del_timer_sync(&host->timer);
+	flush_delayed_work(&host->timeout_work);
 
 	tasklet_kill(&host->card_tasklet);
 	tasklet_kill(&host->finish_tasklet);
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index c846813..55c114d 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -12,6 +12,7 @@
 #define __SDHCI_H
 
 #include <linux/scatterlist.h>
+#include <linux/workqueue.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/io.h>
@@ -290,7 +291,7 @@ struct sdhci_host {
 	struct tasklet_struct	card_tasklet;	/* Tasklet structures */
 	struct tasklet_struct	finish_tasklet;
 
-	struct timer_list	timer;		/* Timer for timeouts */
+	struct delayed_work	timeout_work;	/* Work for timeouts */
 
 	unsigned long		private[0] ____cacheline_aligned;
 };
-- 
1.7.0.5


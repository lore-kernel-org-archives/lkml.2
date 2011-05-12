Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab1ELRLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:11:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36688 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab1ELRLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T/GFkl3VvmaS6lHDmc0CMYCS7HNvVoy+5a3Hul0bmm3OfPJLvnXP5z+hObvDMbrF+M
         Ox4AnPWAb7E07nUpvjBHvPYLKee/CCntwc5QNfTISU4nW4XAPyXUVK5bwO4O6BDHEcKd
         7H73Ng4DA+pxbCqjyw1ihAeX+HA9OOvOssCo4=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: linux-pm@lists.linux-foundation.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>
Subject: [PATCH 3/4] mmc: bus and block device drivers: support for pm_loss
Date: Thu, 12 May 2011 19:11:04 +0200
Message-Id: <1305220265-9020-4-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
---
 drivers/mmc/card/block.c |   48 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/core/bus.c   |   49 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 90 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index bfc8a8a..c88afef 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -37,6 +37,9 @@
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/sd.h>
 
+#include <linux/pm.h>
+#include <linux/pm_loss.h>
+
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
@@ -755,14 +758,55 @@ static int mmc_blk_resume(struct mmc_card *card)
 	}
 	return 0;
 }
-#else
+
+#ifdef CONFIG_PM_LOSS
+
+#define dev_to_mmc_card(d)	container_of(d, struct mmc_card, dev)
+
+static int mmc_blk_power_changed(struct device *dev,
+				 enum sys_power_state s)
+{
+	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_blk_data *md = mmc_get_drvdata(card);
+
+	switch (s) {
+	case SYS_PWR_GOOD:
+		pr_debug_pm_loss("mmc_blk_power_changed(%d)\n", s);
+		mmc_blk_set_blksize(md, card);
+		mmc_queue_resume(&md->queue);
+		break;
+	case SYS_PWR_FAILING:
+		pr_debug_pm_loss("mmc_blk_power_changed(%d)\n", s);
+		mmc_queue_suspend(&md->queue);
+		break;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+static const struct dev_pm_ops mmc_blk_pm_ops = {
+	.power_changed = mmc_blk_power_changed,
+};
+
+#define MMC_BLK_DEV_PM_OPS_PTR (&mmc_blk_pm_ops)
+
+#else /* !CONFIG_PM_LOSS */
+
+#define MMC_BLK_DEV_PM_OPS_PTR NULL
+
+#endif /* !CONFIG_PM_LOSS */
+
+#else /* !CONFIG_PM */
 #define	mmc_blk_suspend	NULL
 #define mmc_blk_resume	NULL
-#endif
+#define MMC_BLK_DEV_PM_OPS_PTR NULL
+#endif /* !CONFIG_PM */
 
 static struct mmc_driver mmc_driver = {
 	.drv		= {
 		.name	= "mmcblk",
+		.pm     = MMC_BLK_DEV_PM_OPS_PTR,
 	},
 	.probe		= mmc_blk_probe,
 	.remove		= mmc_blk_remove,
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 63667a8..548d3a9 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -19,6 +19,8 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 
+#include <linux/pm_loss.h>
+
 #include "core.h"
 #include "sdio_cis.h"
 #include "bus.h"
@@ -163,19 +165,56 @@ static int mmc_runtime_idle(struct device *dev)
 	return pm_runtime_suspend(dev);
 }
 
+#define MMC_PM_RUNTIME_OPS_INIT \
+.runtime_suspend = mmc_runtime_suspend, \
+.runtime_resume		= mmc_runtime_resume, \
+.runtime_idle		= mmc_runtime_idle,
+
+#else /* !CONFIG_PM_RUNTIME */
+
+#define MMC_PM_RUNTIME_OPS_INIT
+
+#endif /* !CONFIG_PM_RUNTIME */
+
+#ifdef CONFIG_PM_LOSS
+
+static int mmc_bus_power_changed(struct device *dev,
+				 enum sys_power_state s)
+{
+	int ret = 0;
+
+	pr_debug_pm_loss("mmc_bus_power_changed()\n");
+
+	if (dev->driver && dev->driver->pm &&
+	    dev->driver->pm->power_changed)
+		ret = dev->driver->pm->power_changed(dev, s);
+
+	return ret;
+}
+
+#define MMC_PM_LOSS_OPS_INIT \
+.power_changed =  mmc_bus_power_changed,
+
+#else  /* !CONFIG_PM_LOSS */
+
+#define MMC_PM_LOSS_OPS_INIT
+
+#endif /* !CONFIG_PM_LOSS */
+
+#if defined CONFIG_PM_RUNTIME || defined CONFIG_PM_LOSS
+
 static const struct dev_pm_ops mmc_bus_pm_ops = {
-	.runtime_suspend	= mmc_runtime_suspend,
-	.runtime_resume		= mmc_runtime_resume,
-	.runtime_idle		= mmc_runtime_idle,
+	MMC_PM_RUNTIME_OPS_INIT
+	MMC_PM_LOSS_OPS_INIT
 };
 
 #define MMC_PM_OPS_PTR	(&mmc_bus_pm_ops)
 
-#else /* !CONFIG_PM_RUNTIME */
+#else /* !(CONFIG_PM_RUNTIME || CONFIG_PM_LOSS) */
 
 #define MMC_PM_OPS_PTR	NULL
 
-#endif /* !CONFIG_PM_RUNTIME */
+#endif /* !(CONFIG_PM_RUNTIME || CONFIG_PM_LOSS) */
 
 static struct bus_type mmc_bus_type = {
 	.name		= "mmc",
-- 
1.7.0.4


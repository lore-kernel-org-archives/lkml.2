Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0LIM23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:28:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:14003 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab0LIM21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:28:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,319,1288594800"; 
   d="scan'208";a="685461529"
Date: Thu, 9 Dec 2010 20:24:52 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, cjb@laptop.org,
        kmpark@infradead.org, leonard.mai@intel.com
Subject: [PATCH v5 3/4]implemented hardware_reset callback in SDHCI host
Message-ID: <20101209122452.GD13236@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hardware_reset callback will be used for host to trigger RST_n signal. The
signal should be triggered by pull some GPIO or use some hardware else. Only
SDHCI host controller driver can touch such specific hardware. So a new
callback reset_emmc was added to trigger the reset signal. This patch
implement hardware_reset callback for sdhci host controller.

reset_emmc: new callback. sdhci host controller can use GPIO lines or
something else to trigger reset signal by this callback. Different sdhci
host controller should implement this separately. So this patch only add
definition in head file for this callback.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/host/sdhci.c |   23 +++++++++++++++++++++++
 drivers/mmc/host/sdhci.h |   12 ++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 508ea5a..3a0c9b4 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1283,11 +1283,34 @@ out:
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
+/*
+ *  HW reset callback for eMMC4.4 card
+ *  In this function, HC will use reset_emmc callback to reset
+ *  for eMMC4.4 card
+ *
+ *  RETURN VALUE:
+ *  0: reset emmc successfully
+ *  -ENODEV: no valid hardware to do so
+ */
+static int sdhci_hardware_reset(struct mmc_host *mmc)
+{
+	int err = 1;
+	struct sdhci_host *host;
+
+	host = mmc_priv(mmc);
+
+	if (host->ops && host->ops->reset_emmc)
+		err = host->ops->reset_emmc(host);
+
+	return err;
+}
+
 static const struct mmc_host_ops sdhci_ops = {
 	.request	= sdhci_request,
 	.set_ios	= sdhci_set_ios,
 	.get_ro		= sdhci_get_ro,
 	.enable_sdio_irq = sdhci_enable_sdio_irq,
+	.hardware_reset = sdhci_hardware_reset,
 };
 
 /*****************************************************************************\
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 1efe7dc..2a9b20c 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -221,6 +221,18 @@ struct sdhci_ops {
 	void (*platform_send_init_74_clocks)(struct sdhci_host *host,
 					     u8 power_mode);
 	unsigned int    (*get_ro)(struct sdhci_host *host);
+
+	/*
+	 * eMMC card reset callback.
+	 * This callback can be used by sdhci layer to support eMMC4.4
+	 * hardware reset feature. In this function, should trigger a
+	 * RST_n signal to reset eMMC card.
+	 *
+	 * return value:
+	 * 0: successfully reset eMMC card.
+	 * -ENODEV: no valid hardware to reset eMMC card.
+	 */
+	int		(*reset_emmc)(struct sdhci_host *host);
 };
 
 #ifdef CONFIG_MMC_SDHCI_IO_ACCESSORS
-- 
1.6.6.1


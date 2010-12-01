Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0LAMwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:52:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:52927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab0LAMwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:52:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,283,1288594800"; 
   d="scan'208,223";a="863095128"
Date: Wed, 1 Dec 2010 20:49:37 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, arjan@linux.intel.com,
        alan@linux.intel.com, akpm@linux-foundation.org
Subject: [PATCH v4 3/4]implement hardware_reset callback for sdhci host
Message-ID: <20101201124937.GD5421@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0fadd39a6c09f9040a614bb251187b03f8fadd79 Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Wed, 1 Dec 2010 19:41:25 +0800
Subject: [PATCH 3/4] implement hardware_reset callback for sdhci host

hardware_reset callback will be used for host to trigger
RST_n signal. So a new callback reset_emmc was added to use
GPIO lines or something else to trigger reset signal.
This patch implement hardware_reset callback for sdhci host
controller.

reset_emmc: new callback. sdhci host controller can use GPIO
lines or something else to trigger reset signal by this callback.
Different sdhci host controller should implement this separately.
So this patch only add definition in head file for this callback.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/host/sdhci.c |   23 +++++++++++++++++++++++
 drivers/mmc/host/sdhci.h |   12 ++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 8a74fcb..d40b16c 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1283,11 +1283,34 @@ out:
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
+/*
+ *  HW reset callback for eMMC4.4 card
+ *  In this function, HC will do the real HW reset
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0KRDHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 22:07:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:48888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab0KRDHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 22:07:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,214,1288594800"; 
   d="scan'208,223";a="574960134"
Date: Thu, 18 Nov 2010 11:05:06 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, alan@linux.intel.com
Subject: [PATCH v3 2/2]mmc:implemented HW reset callback in sdhci layer
Message-ID: <20101118030506.GC10621@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 24a7a1fe58d4cbc49dde56adb442c97cbbaf690b Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Thu, 18 Nov 2010 10:34:42 +0800
Subject: [PATCH 2/2] mmc: implemented hardware reset callback for sdhci layer

The hardware reset callback in sdhci layer cannot really do
a reset for eMMC card. It need the real hardware controller
to trigger a RST_n signal to do so.

Different sdhci host controller need use reset_emmc callback
to implement the RST_n signal.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/host/sdhci.c |   23 +++++++++++++++++++++++
 drivers/mmc/host/sdhci.h |   10 ++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 154cbf8..a05b87c 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1266,11 +1266,34 @@ out:
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
index d52a716..24e49b0 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -218,6 +218,16 @@ struct sdhci_ops {
 	void (*platform_send_init_74_clocks)(struct sdhci_host *host,
 					     u8 power_mode);
 	unsigned int    (*get_ro)(struct sdhci_host *host);
+	/*
+	 * eMMC card reset callback.
+	 * This callback can be used by sdhci layer to support eMMC4.4
+	 * hardware reset feature. In this function, should trigger a
+	 * RST_n signal to reset eMMC card.
+	 * return value:
+	 * 0: successfully reset eMMC card.
+	 * -ENODEV: no valid hardware to reset eMMC card.
+	 */
+	int		(*reset_emmc)(struct sdhci_host *host);
 };
 
 #ifdef CONFIG_MMC_SDHCI_IO_ACCESSORS
-- 
1.6.6.1


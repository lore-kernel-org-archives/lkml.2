Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab0FYSGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:06:49 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:3821 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932266Ab0FYSGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:06:45 -0400
Date: Fri, 25 Jun 2010 22:06:44 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@simtec.co.uk>,
       Richard =?utf-8?Q?R=C3=B6jfors?= <richard.rojfors@pelagicore.com>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sdhci-pltfm: Add support for CNS3xxx SoC devices
Message-ID: <20100625180644.GC18241@oksana.dev.rtsoft.ru>
References: <20100625180527.GA11280@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100625180527.GA11280@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's nothing special, just SoC-specific ops and quirks.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/mmc/host/Kconfig         |    9 ++++
 drivers/mmc/host/Makefile        |    1 +
 drivers/mmc/host/sdhci-cns3xxx.c |   97 ++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci-pltfm.c   |    3 +
 drivers/mmc/host/sdhci-pltfm.h   |    4 ++
 5 files changed, 114 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mmc/host/sdhci-cns3xxx.c

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index e171e77..d40e39b 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -121,6 +121,15 @@ config MMC_SDHCI_PLTFM
 
 	  If unsure, say N.
 
+config MMC_SDHCI_CNS3XXX
+	bool "SDHCI support on the Cavium Networks CNS3xxx SoC"
+	depends on ARCH_CNS3XXX
+	depends on MMC_SDHCI_PLTFM
+	help
+	  This selects the SDHCI support for CNS3xxx System-on-Chip devices.
+
+	  If unsure, say N.
+
 config MMC_SDHCI_S3C
 	tristate "SDHCI support on Samsung S3C SoC"
 	depends on MMC_SDHCI && (PLAT_S3C24XX || PLAT_S3C64XX)
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 28622d5..070c5f3 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_MMC_SH_MMCIF)	+= sh_mmcif.o
 
 obj-$(CONFIG_MMC_SDHCI_PLTFM)			+= sdhci-platform.o
 sdhci-platform-y				:= sdhci-pltfm.o
+sdhci-platform-$(CONFIG_MMC_SDHCI_CNS3XXX)	+= sdhci-cns3xxx.o
 
 obj-$(CONFIG_MMC_SDHCI_OF)	+= sdhci-of.o
 sdhci-of-y				:= sdhci-of-core.o
diff --git a/drivers/mmc/host/sdhci-cns3xxx.c b/drivers/mmc/host/sdhci-cns3xxx.c
new file mode 100644
index 0000000..b7050b3
--- /dev/null
+++ b/drivers/mmc/host/sdhci-cns3xxx.c
@@ -0,0 +1,97 @@
+/*
+ * SDHCI support for CNS3xxx SoC
+ *
+ * Copyright 2008 Cavium Networks
+ * Copyright 2010 MontaVista Software, LLC.
+ *
+ * Authors: Scott Shu
+ *	    Anton Vorontsov <avorontsov@mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/mmc/host.h>
+#include <linux/sdhci-pltfm.h>
+#include <mach/cns3xxx.h>
+#include "sdhci.h"
+#include "sdhci-pltfm.h"
+
+static unsigned int sdhci_cns3xxx_get_max_clk(struct sdhci_host *host)
+{
+	return 150000000;
+}
+
+static void sdhci_cns3xxx_set_clock(struct sdhci_host *host, unsigned int clock)
+{
+	struct device *dev = mmc_dev(host->mmc);
+	int div = 1;
+	u16 clk;
+	unsigned long timeout;
+
+	if (clock == host->clock)
+		return;
+
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
+
+	if (clock == 0)
+		goto out;
+
+	while (host->max_clk / div > clock) {
+		/*
+		 * On CNS3xxx divider grows linearly up to 4, and then
+		 * exponentially up to 256.
+		 */
+		if (div < 4)
+			div += 1;
+		else if (div < 256)
+			div *= 2;
+		else
+			break;
+	}
+
+	dev_dbg(dev, "desired SD clock: %d, actual: %d\n",
+		clock, host->max_clk / div);
+
+	/* Divide by 3 is special. */
+	if (div != 3)
+		div >>= 1;
+
+	clk = div << SDHCI_DIVIDER_SHIFT;
+	clk |= SDHCI_CLOCK_INT_EN;
+	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
+
+	timeout = 20;
+	while (!((clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL))
+			& SDHCI_CLOCK_INT_STABLE)) {
+		if (timeout == 0) {
+			dev_warn(dev, "clock is unstable");
+			break;
+		}
+		timeout--;
+		mdelay(1);
+	}
+
+	clk |= SDHCI_CLOCK_CARD_EN;
+	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
+out:
+	host->clock = clock;
+}
+
+static struct sdhci_ops sdhci_cns3xxx_ops = {
+	.get_max_clock	= sdhci_cns3xxx_get_max_clk,
+	.set_clock	= sdhci_cns3xxx_set_clock,
+};
+
+struct sdhci_pltfm_data sdhci_cns3xxx_pdata = {
+	.ops = &sdhci_cns3xxx_ops,
+	.quirks = SDHCI_QUIRK_BROKEN_DMA |
+		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
+		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
+		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
+		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
+		  SDHCI_QUIRK_NONSTANDARD_CLOCK,
+};
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index 4c043bb..e045e3c 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -158,6 +158,9 @@ static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
 
 static const struct platform_device_id sdhci_pltfm_ids[] = {
 	{ "sdhci", },
+#ifdef CONFIG_MMC_SDHCI_CNS3XXX
+	{ "sdhci-cns3xxx", (kernel_ulong_t)&sdhci_cns3xxx_pdata },
+#endif
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, sdhci_pltfm_ids);
diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
index 4aa07a9..900f329 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -11,4 +11,8 @@
 #ifndef _DRIVERS_MMC_SDHCI_PLTFM_H
 #define _DRIVERS_MMC_SDHCI_PLTFM_H
 
+#include <linux/sdhci-pltfm.h>
+
+extern struct sdhci_pltfm_data sdhci_cns3xxx_pdata;
+
 #endif /* _DRIVERS_MMC_SDHCI_PLTFM_H */
-- 
1.7.0.5

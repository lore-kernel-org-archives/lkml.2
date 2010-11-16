Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0KPRVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:21:14 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:48020 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372Ab0KPRVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:21:13 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] mmci: handle clock frequency 0 properly
Date: Tue, 16 Nov 2010 18:17:49 +0100
Message-ID: <1289927869-14519-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the default clocking for the MMCI controller so that
the external MCI card clock does not activate until the first
.set_ios() call is issued. It will further handle the transitions
from a clock != 0 to 0 and vice versa by gating/ungating the
clock with clk_disable()/clk_enable().

This assures that the MCI clock will not be active unless there
is a card in the MMC slot.

By default the MMC core will not gate off the clock to a card
once it's enabled, but with the separate patch for aggressive
clocking this can optionally be enabled for the system.

Cc: Chris Ball <cjb@laptop.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Changes since v8:

The frequency registers shall be set with mmci_set_clkreg()
no matter whether the clock gets enabled or disabled, systems
without a clk framework will need this so that the clock
dividers are set to the apropriate values for clock 0 as
well, and that will probably mitigate power consumption
somewhat on these systems.

Chris: this is a new version after Russell found an error in
it. Can you please take the old version of this patch out of
the MMC tree so I can merge it through Russells ARM tree
instead? The patches are perfectly orthogonal so it doesn't
need to live in the MMC tree.
---
 drivers/mmc/host/mmci.c |   33 ++++++++++++++++++++++-----------
 drivers/mmc/host/mmci.h |    1 +
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 0814b88..3709ab3 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -689,6 +689,22 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	mmci_set_clkreg(host, ios->clock);
 
+	/*
+	 * Turn on clock whenever ios->clock transitions
+	 * from 0 to !=0 and gate it off whenever ios->clock
+	 * transitions from !=0 to 0.
+	 */
+	if (host->iosclock == 0 && ios->clock != 0) {
+		dev_dbg(mmc_dev(mmc), "enable clock f=%d\n", ios->clock);
+		clk_enable(host->clk);
+	} else if (host->iosclock != 0 && ios->clock == 0) {
+		dev_dbg(mmc_dev(mmc), "disable clock\n");
+		clk_disable(host->clk);
+	} else if (ios->clock != 0) {
+		dev_dbg(mmc_dev(mmc), "set clock f=%d\n", ios->clock);
+	}
+	host->iosclock = ios->clock;
+
 	if (host->pwr != pwr) {
 		host->pwr = pwr;
 		writel(pwr, host->base + MMCIPOWER);
@@ -772,6 +788,8 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;
+	host->plat = plat;
+	host->variant = variant;
 
 	host->gpio_wp = -ENOSYS;
 	host->gpio_cd = -ENOSYS;
@@ -782,19 +800,14 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 	dev_dbg(mmc_dev(mmc), "designer ID = 0x%02x\n", host->hw_designer);
 	dev_dbg(mmc_dev(mmc), "revision = 0x%01x\n", host->hw_revision);
 
+	/* This clock will be enabled/disabled by set_ios() calls later */
 	host->clk = clk_get(&dev->dev, NULL);
 	if (IS_ERR(host->clk)) {
 		ret = PTR_ERR(host->clk);
 		host->clk = NULL;
 		goto host_free;
 	}
-
-	ret = clk_enable(host->clk);
-	if (ret)
-		goto clk_free;
-
-	host->plat = plat;
-	host->variant = variant;
+	host->iosclock = 0;
 	host->mclk = clk_get_rate(host->clk);
 	/*
 	 * According to the spec, mclk is max 100 MHz,
@@ -804,7 +817,7 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 	if (host->mclk > 100000000) {
 		ret = clk_set_rate(host->clk, 100000000);
 		if (ret < 0)
-			goto clk_disable;
+			goto clk_free;
 		host->mclk = clk_get_rate(host->clk);
 		dev_dbg(mmc_dev(mmc), "eventual mclk rate: %u Hz\n",
 			host->mclk);
@@ -812,7 +825,7 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 	host->base = ioremap(dev->res.start, resource_size(&dev->res));
 	if (!host->base) {
 		ret = -ENOMEM;
-		goto clk_disable;
+		goto clk_free;
 	}
 
 	mmc->ops = &mmci_ops;
@@ -961,8 +974,6 @@ static int __devinit mmci_probe(struct amba_device *dev, struct amba_id *id)
 		gpio_free(host->gpio_cd);
  err_gpio_cd:
 	iounmap(host->base);
- clk_disable:
-	clk_disable(host->clk);
  clk_free:
 	clk_put(host->clk);
  host_free:
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index df06f01..4791a2b 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -167,6 +167,7 @@ struct mmci_host {
 
 	unsigned int		mclk;
 	unsigned int		cclk;
+	unsigned int		iosclock;
 	u32			pwr;
 	struct mmci_platform_data *plat;
 	struct variant_data	*variant;
-- 
1.6.3.3


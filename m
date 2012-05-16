Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788Ab2EPICo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:02:44 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:11932
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759751Ab2EPIBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:01:39 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: <sonic.zhang@analog.com>
To: Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 5/5] mmc: bfin_sdh: Reset SD controller when resume from power saving mode.
Date: Wed, 16 May 2012 15:50:37 +0800
Message-ID: <1337154637-11724-5-git-send-email-sonic.zhang@analog.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337154637-11724-1-git-send-email-sonic.zhang@analog.com>
References: <1337154637-11724-1-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Without reset, SD controller may stay in disable mode, SD card can't
be detected when resume from power saving mode.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/mmc/host/bfin_sdh.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index b31e1ab..751edf6 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -466,6 +466,23 @@ static irqreturn_t sdh_stat_irq(int irq, void *devid)
 	return IRQ_RETVAL(handled);
 }
 
+static void sdh_reset(void)
+{
+#if defined(CONFIG_BF54x)
+	/* Secure Digital Host shares DMA with Nand controller */
+	bfin_write_DMAC1_PERIMUX(bfin_read_DMAC1_PERIMUX() | 0x1);
+#endif
+
+	bfin_write_SDH_CFG(bfin_read_SDH_CFG() | CLKS_EN);
+	SSYNC();
+
+	/* Disable card inserting detection pin. set MMC_CAP_NEEDS_POLL, and
+	 * mmc stack will do the detection.
+	 */
+	bfin_write_SDH_CFG((bfin_read_SDH_CFG() & 0x1F) | (PUP_SDDAT | PUP_SDDAT3));
+	SSYNC();
+}
+
 static int __devinit sdh_probe(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
@@ -542,19 +559,8 @@ static int __devinit sdh_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "unable to request peripheral pins\n");
 		goto out4;
 	}
-#if defined(CONFIG_BF54x)
-	/* Secure Digital Host shares DMA with Nand controller */
-	bfin_write_DMAC1_PERIMUX(bfin_read_DMAC1_PERIMUX() | 0x1);
-#endif
 
-	bfin_write_SDH_CFG(bfin_read_SDH_CFG() | CLKS_EN);
-	SSYNC();
-
-	/* Disable card inserting detection pin. set MMC_CAP_NEEDS_POLL, and
-	 * mmc stack will do the detection.
-	 */
-	bfin_write_SDH_CFG((bfin_read_SDH_CFG() & 0x1F) | (PUP_SDDAT | PUP_SDDAT3));
-	SSYNC();
+	sdh_reset();
 
 	mmc_add_host(mmc);
 	return 0;
@@ -621,10 +627,7 @@ static int sdh_resume(struct platform_device *dev)
 		return ret;
 	}
 
-#if defined(CONFIG_BF54x)
-	/* Secure Digital Host shares DMA with Nand controller */
-	bfin_write_DMAC1_PERIMUX(bfin_read_DMAC1_PERIMUX() | 0x1);
-#endif
+	sdh_reset();
 
 	if (mmc)
 		ret = mmc_resume_host(mmc);
-- 
1.7.0.4



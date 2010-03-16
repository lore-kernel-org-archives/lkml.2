Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab0CPSec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:34:32 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:48215 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759980Ab0CPSea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:34:30 -0400
Date: Tue, 16 Mar 2010 21:34:27 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Vrabel <david.vrabel@csr.com>,
       Richard =?utf-8?Q?R=C3=B6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       Pierre Ossman <pierre@ossman.eu>, Ben Dooks <ben@simtec.co.uk>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] sdhci: Implement CAP_CLOCK_BASE_BROKEN quirk
Message-ID: <20100316183427.GA25670@oksana.dev.rtsoft.ru>
References: <20100316183400.GA24191@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100316183400.GA24191@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hosts (e.g. as found in CNS3xxx SOCs) report wrong value in
CLOCK_BASE capability field, and currently there is no way to
force the SDHCI core to use the platform-provided base clock value.

This patch implements CAP_CLOCK_BASE_BROKEN quirk. When enabled,
the SDHCI core will always use base clock frequency provided by
the platform.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |    3 ++-
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index d6ab62d..b03e875 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1743,7 +1743,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	host->max_clk =
 		(caps & SDHCI_CLOCK_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
 	host->max_clk *= 1000000;
-	if (host->max_clk == 0) {
+	if (host->max_clk == 0 || host->quirks &
+			SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN) {
 		if (!host->ops->get_max_clock) {
 			printk(KERN_ERR
 			       "%s: Hardware doesn't specify base clock "
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 842f46f..831bf7f 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -236,6 +236,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_DELAY_AFTER_POWER			(1<<23)
 /* Controller uses SDCLK instead of TMCLK for data timeouts */
 #define SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK		(1<<24)
+/* Controller reports wrong base clock capability */
+#define SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN		(1<<25)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.7.0


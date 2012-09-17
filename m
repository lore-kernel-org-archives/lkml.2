Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2IQAvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33956 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754459Ab2IQAvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:32 -0400
Message-Id: <20120917003630.961458095@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shawn Guo <shawn.guo@linaro.org>,
        Chris Ball <cjb@laptop.org>
Subject: [ 034/135] mmc: sdhci-esdhc: break out early if clock is 0
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit 74f330bceaa7b88d06062e1cac3d519a3dfc041e upstream.

Since commit 30832ab56 ("mmc: sdhci: Always pass clock request value
zero to set_clock host op") was merged, esdhc_set_clock starts hitting
"if (clock == 0)" where ESDHC_SYSTEM_CONTROL has been operated.  This
causes SDHCI card-detection function being broken.  Fix the regression
by moving "if (clock == 0)" above ESDHC_SYSTEM_CONTROL operation.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/sdhci-esdhc.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc.h b/drivers/mmc/host/sdhci-esdhc.h
index b97b2f5..d25f9ab 100644
--- a/drivers/mmc/host/sdhci-esdhc.h
+++ b/drivers/mmc/host/sdhci-esdhc.h
@@ -48,14 +48,14 @@ static inline void esdhc_set_clock(struct sdhci_host *host, unsigned int clock)
 	int div = 1;
 	u32 temp;
 
+	if (clock == 0)
+		goto out;
+
 	temp = sdhci_readl(host, ESDHC_SYSTEM_CONTROL);
 	temp &= ~(ESDHC_CLOCK_IPGEN | ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN
 		| ESDHC_CLOCK_MASK);
 	sdhci_writel(host, temp, ESDHC_SYSTEM_CONTROL);
 
-	if (clock == 0)
-		goto out;
-
 	while (host->max_clk / pre_div / 16 > clock && pre_div < 256)
 		pre_div *= 2;
 



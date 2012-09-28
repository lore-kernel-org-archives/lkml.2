Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab2I1UlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:41:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33208 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759577Ab2I1UlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:41:10 -0400
X-Sasl-enc: 3cWkynRM5plQF+0Ot/VegAkdaG0pDiBb5N0n6fFAIn5M 1348864869
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Shawn Guo <shawn.guo@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: [ 039/127] mmc: sdhci-esdhc: break out early if clock is 0
Date: Fri, 28 Sep 2012 13:33:32 -0700
Message-Id: <20120928203050.422131042@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-esdhc.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc.h
+++ b/drivers/mmc/host/sdhci-esdhc.h
@@ -48,14 +48,14 @@ static inline void esdhc_set_clock(struc
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
 



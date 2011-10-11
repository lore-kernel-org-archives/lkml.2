Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1JKRFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:05:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab1JKRFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:05:15 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:12 2011
Message-Id: <20111011165712.458014475@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:37 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Koen Beel <koen.beel@barco.com>, Chris Ball <cjb@laptop.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [27/38] mmc: mxs-mmc: fix clock rate setting
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Koen Beel <koen.beel@barco.com>

commit d982dcdc4e64eb1881df44b0035a8268bf1ab067 upstream.

Fix clock rate setting in the mxs-mmc driver. Previously, if div2 was 0
then the value for TIMING_CLOCK_RATE would have been 255 instead of 0.
The limits for div1 (TIMING_CLOCK_DIVIDE) and div2 (TIMING_CLOCK_RATE+1)
were also not correctly defined.

Can easily be reproduced on mx23evk: default clock for high speed sdio
cards is 50 MHz. With a SSP_CLK of 28.8 MHz default), this resulted in
an actual clock rate of about 56 kHz.  Tested on mx23evk.

Signed-off-by: Koen Beel <koen.beel@barco.com>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/mxs-mmc.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -564,40 +564,38 @@ static void mxs_mmc_request(struct mmc_h
 
 static void mxs_mmc_set_clk_rate(struct mxs_mmc_host *host, unsigned int rate)
 {
-	unsigned int ssp_rate, bit_rate;
-	u32 div1, div2;
+	unsigned int ssp_clk, ssp_sck;
+	u32 clock_divide, clock_rate;
 	u32 val;
 
-	ssp_rate = clk_get_rate(host->clk);
+	ssp_clk = clk_get_rate(host->clk);
 
-	for (div1 = 2; div1 < 254; div1 += 2) {
-		div2 = ssp_rate / rate / div1;
-		if (div2 < 0x100)
+	for (clock_divide = 2; clock_divide <= 254; clock_divide += 2) {
+		clock_rate = DIV_ROUND_UP(ssp_clk, rate * clock_divide);
+		clock_rate = (clock_rate > 0) ? clock_rate - 1 : 0;
+		if (clock_rate <= 255)
 			break;
 	}
 
-	if (div1 >= 254) {
+	if (clock_divide > 254) {
 		dev_err(mmc_dev(host->mmc),
 			"%s: cannot set clock to %d\n", __func__, rate);
 		return;
 	}
 
-	if (div2 == 0)
-		bit_rate = ssp_rate / div1;
-	else
-		bit_rate = ssp_rate / div1 / div2;
+	ssp_sck = ssp_clk / clock_divide / (1 + clock_rate);
 
 	val = readl(host->base + HW_SSP_TIMING);
 	val &= ~(BM_SSP_TIMING_CLOCK_DIVIDE | BM_SSP_TIMING_CLOCK_RATE);
-	val |= BF_SSP(div1, TIMING_CLOCK_DIVIDE);
-	val |= BF_SSP(div2 - 1, TIMING_CLOCK_RATE);
+	val |= BF_SSP(clock_divide, TIMING_CLOCK_DIVIDE);
+	val |= BF_SSP(clock_rate, TIMING_CLOCK_RATE);
 	writel(val, host->base + HW_SSP_TIMING);
 
-	host->clk_rate = bit_rate;
+	host->clk_rate = ssp_sck;
 
 	dev_dbg(mmc_dev(host->mmc),
-		"%s: div1 %d, div2 %d, ssp %d, bit %d, rate %d\n",
-		__func__, div1, div2, ssp_rate, bit_rate, rate);
+		"%s: clock_divide %d, clock_rate %d, ssp_clk %d, rate_actual %d, rate_requested %d\n",
+		__func__, clock_divide, clock_rate, ssp_clk, ssp_sck, rate);
 }
 
 static void mxs_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)



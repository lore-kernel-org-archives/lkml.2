Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab1BYSuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:50:13 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:42044 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755794Ab1BYSuL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:50:11 -0500
From: Philip Rakity <prakity@marvell.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jae hoon Chung <jh80.chung@gmail.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 25 Feb 2011 10:49:25 -0800
Subject: [PATCH V2] sdhci: always use max timeout for xfers
Thread-Topic: [PATCH V2] sdhci: always use max timeout for xfers
Thread-Index: AcvVHLqSSU9pHG6NQtykrm6kaJx+Fw==
Message-ID: <62F39533-530F-4DF4-BBC6-AF8E9AB9E751@marvell.com>
References: <D8739074-546D-4531-A8E9-23E9F7A33EB5@marvell.com>
 <20110225180248.GA15491@pengutronix.de>
 <9C437661-BFCC-4F73-989E-06589E0D37CA@marvell.com>
 <20110225182206.GC15491@pengutronix.de>
In-Reply-To: <20110225182206.GC15491@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2

use define for max timeout.  remove subroutine call and just
set the register directly

v1

The card/host controller may sometimes return a value that is
too low and cause the h/w to timeout a transfer that would have
worked.  Using the maximum value avoids this.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/mmc/host/sdhci.c |   59 +++++----------------------------------------
 drivers/mmc/host/sdhci.h |    1 +
 2 files changed, 8 insertions(+), 52 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 655617c..d615173 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -592,55 +592,6 @@ static void sdhci_adma_table_post(struct sdhci_host *host,
 		data->sg_len, direction);
 }
 
-static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_data *data)
-{
-	u8 count;
-	unsigned target_timeout, current_timeout;
-
-	/*
-	 * If the host controller provides us with an incorrect timeout
-	 * value, just skip the check and use 0xE.  The hardware may take
-	 * longer to time out, but that's much better than having a too-short
-	 * timeout value.
-	 */
-	if (host->quirks & SDHCI_QUIRK_BROKEN_TIMEOUT_VAL)
-		return 0xE;
-
-	/* timeout in us */
-	target_timeout = data->timeout_ns / 1000 +
-		data->timeout_clks / host->clock;
-
-	if (host->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)
-		host->timeout_clk = host->clock / 1000;
-
-	/*
-	 * Figure out needed cycles.
-	 * We do this in steps in order to fit inside a 32 bit int.
-	 * The first step is the minimum timeout, which will have a
-	 * minimum resolution of 6 bits:
-	 * (1) 2^13*1000 > 2^22,
-	 * (2) host->timeout_clk < 2^16
-	 *     =>
-	 *     (1) / (2) > 2^6
-	 */
-	count = 0;
-	current_timeout = (1 << 13) * 1000 / host->timeout_clk;
-	while (current_timeout < target_timeout) {
-		count++;
-		current_timeout <<= 1;
-		if (count >= 0xF)
-			break;
-	}
-
-	if (count >= 0xF) {
-		printk(KERN_WARNING "%s: Too large timeout requested!\n",
-			mmc_hostname(host->mmc));
-		count = 0xE;
-	}
-
-	return count;
-}
-
 static void sdhci_set_transfer_irqs(struct sdhci_host *host)
 {
 	u32 pio_irqs = SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL;
@@ -654,7 +605,6 @@ static void sdhci_set_transfer_irqs(struct sdhci_host *host)
 
 static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 {
-	u8 count;
 	u8 ctrl;
 	int ret;
 
@@ -671,8 +621,13 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	host->data = data;
 	host->data_early = 0;
 
-	count = sdhci_calc_timeout(host, data);
-	sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
+	/*
+	 * The host controller/card can provide us with an incorrect timeout
+	 * value, just use the maximum value 0xE.  The hardware may take
+	 * longer to time out, but that's much better than having a too-short
+	 * timeout value.
+	 */
+	sdhci_writeb(host, SDHCI_TIMEOUT_MAX, SDHCI_TIMEOUT_CONTROL);
 
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA))
 		host->flags |= SDHCI_REQ_USE_DMA;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 1f032c0..19b4d41 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -103,6 +103,7 @@
 #define  SDHCI_CLOCK_INT_EN	0x0001
 
 #define SDHCI_TIMEOUT_CONTROL	0x2E
+#define  SDHCI_TIMEOUT_MAX	0xE
 
 #define SDHCI_SOFTWARE_RESET	0x2F
 #define  SDHCI_RESET_ALL	0x01
-- 
1.7.0.4


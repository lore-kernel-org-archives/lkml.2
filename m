Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab2L1TSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:18:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55180 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586Ab2L1TSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:05 -0500
Message-Id: <20121228190357.092665294@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wolfram Sang <w.sang@pengutronix.de>,
        Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 130/173] mtd: nand: gpmi: reset BCH earlier, too, to avoid NAND startup
 problems
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 6f2a6a52560ad8d85710aabd92b7a3239b3a6b07 upstream.

It could happen (1 out of 100 times) that NAND did not start up
correctly after warm rebooting, so the kernel could not find the UBI or
DMA timed out due to a stalled BCH. When resetting BCH together with
GPMI, the issue could not be observed anymore (after 10000+ reboots). We
probably need the consistent state already before sending any command to
NAND, even when no ECC is needed. I chose to keep the extra reset for
BCH when changing the flash layout to be on the safe side.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index 1585c5b..d84699c 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -165,6 +165,15 @@ int gpmi_init(struct gpmi_nand_data *this)
 	if (ret)
 		goto err_out;
 
+	/*
+	 * Reset BCH here, too. We got failures otherwise :(
+	 * See later BCH reset for explanation of MX23 handling
+	 */
+	ret = gpmi_reset_block(r->bch_regs, GPMI_IS_MX23(this));
+	if (ret)
+		goto err_out;
+
+
 	/* Choose NAND mode. */
 	writel(BM_GPMI_CTRL1_GPMI_MODE, r->gpmi_regs + HW_GPMI_CTRL1_CLR);
 



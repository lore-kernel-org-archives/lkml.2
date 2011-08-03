Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1HCDQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 23:16:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48972 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab1HCDQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 23:16:09 -0400
Date: Wed, 3 Aug 2011 13:16:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lin <tony.lin@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: linux-next: manual merge of the mmc tree with Linus' tree
Message-Id: <20110803131603.1fb56fac0c3f82366fbc7b8c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Today's linux-next merge of the mmc tree got a conflict in
drivers/mmc/host/sdhci-esdhc-imx.c between commit 913413c307c9 ("mmc:
sdhci-esdhc-imx: extend card_detect and write_protect support for mx5")
from Linus' tree and commit 9259bee02100 ("mmc: esdhc-imx: fix card
interrupt loss on freescale eSDHC") from the mmc tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/sdhci-esdhc-imx.c
index 9ebfb4b,e62d33f..0000000
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@@ -140,14 -86,35 +141,36 @@@ static void esdhc_writel_le(struct sdhc
  {
  	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
  	struct pltfm_imx_data *imx_data = pltfm_host->priv;
 +	struct esdhc_platform_data *boarddata = &imx_data->boarddata;
- 
- 	if (unlikely((reg == SDHCI_INT_ENABLE || reg == SDHCI_SIGNAL_ENABLE)
- 			&& (boarddata->cd_type == ESDHC_CD_GPIO)))
- 		/*
- 		 * these interrupts won't work with a custom card_detect gpio
- 		 */
- 		val &= ~(SDHCI_INT_CARD_REMOVE | SDHCI_INT_CARD_INSERT);
+ 	u32 data;
+ 
+ 	if (unlikely(reg == SDHCI_INT_ENABLE || reg == SDHCI_SIGNAL_ENABLE)) {
 -		if (imx_data->flags & ESDHC_FLAG_GPIO_FOR_CD)
++		if (boarddata->cd_type == ESDHC_CD_GPIO))
+ 			/*
+ 			 * these interrupts won't work with a
+ 			 * custom card_detect gpio
+ 			 * (only applied to mx25/35)
+ 			 */
+ 			val &= ~(SDHCI_INT_CARD_REMOVE | SDHCI_INT_CARD_INSERT);
+ 
+ 		if (val & SDHCI_INT_CARD_INT) {
+ 			/*
+ 			 * clear D3CD bit and set D3CD bit to avoid
+ 			 * missing the card interrupt
+ 			 * this is a eSDHC controller problem so that
+ 			 * we need to apply the following workaround
+ 			 * clear and set D3CD bit will make eSDHC
+ 			 * re-sample the card interrupt, In case
+ 			 * a card interrupt was lost, re-sample it by
+ 			 * the following steps.
+ 			 */
+ 			data = readl(host->ioaddr + SDHCI_HOST_CONTROL);
+ 			data &= ~SDHCI_CTRL_D3CD;
+ 			writel(data, host->ioaddr + SDHCI_HOST_CONTROL);
+ 			data |= SDHCI_CTRL_D3CD;
+ 			writel(data, host->ioaddr + SDHCI_HOST_CONTROL);
+ 		}
+ 	}
  
  	if (unlikely((imx_data->flags & ESDHC_FLAG_MULTIBLK_NO_INT)
  				&& (reg == SDHCI_INT_STATUS)

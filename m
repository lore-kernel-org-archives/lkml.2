Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1HKD4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 23:56:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44955 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1HKD4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 23:56:02 -0400
Date: Thu, 11 Aug 2011 13:55:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Zhu <richard.zhu@linaro.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: linux-next: manual merge of the mmc tree with Linus' tree
Message-Id: <20110811135555.f4b26adb8a73c1a22f75abc5@canb.auug.org.au>
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
from Linus' tree and commit 612e807e4852 ("mmc: sdhci-esdhc-imx: Enable
ADMA2") from the mmc tree.

I fixed it up (I think - see below) anc can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/sdhci-esdhc-imx.c
index 9ebfb4b,53b2ec1..0000000
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@@ -32,6 -31,15 +33,14 @@@
  #define  SDHCI_VENDOR_SPEC_SDIO_QUIRK	0x00000002
  
  /*
+  * There is INT DMA ERR mis-match between eSDHC and STD SDHC SPEC
+  * Bit25 is used in STD SPEC, and is reserved in fsl eSDHC design,
+  * but bit28 is used as the INT DMA ERR in fsl eSDHC design.
+  * Define this macro DMA error INT for fsl eSDHC
+  */
+ #define  SDHCI_INT_VENDOR_SPEC_DMA_ERR	0x10000000
+ 
 -#define ESDHC_FLAG_GPIO_FOR_CD		(1 << 0)
+ /*
   * The CMDTYPE of the CMD register (offset 0xE) should be set to
   * "11" when the STOP CMD12 is issued on imx53 to abort one
   * open ended multi-blk IO. Otherwise the TC INT wouldn't
@@@ -140,14 -115,35 +170,36 @@@ static void esdhc_writel_le(struct sdhc
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
++		if (boarddata->cd_type == ESDHC_CD_GPIO)
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
@@@ -377,29 -316,22 +439,30 @@@ static int __devinit sdhci_esdhc_imx_pr
  	clk_enable(clk);
  	pltfm_host->clk = clk;
  
 -	if (!cpu_is_mx25())
 +	if (!is_imx25_esdhc(imx_data))
  		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
  
 -	if (cpu_is_mx25() || cpu_is_mx35()) {
 +	if (is_imx25_esdhc(imx_data) || is_imx35_esdhc(imx_data))
  		/* Fix errata ENGcm07207 present on i.MX25 and i.MX35 */
- 		host->quirks |= SDHCI_QUIRK_NO_MULTIBLOCK;
+ 		host->quirks |= SDHCI_QUIRK_NO_MULTIBLOCK
+ 			| SDHCI_QUIRK_BROKEN_ADMA;
 -		/* write_protect can't be routed to controller, use gpio */
 -		sdhci_esdhc_ops.get_ro = esdhc_pltfm_get_ro;
 -	}
  
 -	if (!(cpu_is_mx25() || cpu_is_mx35() || cpu_is_mx51()))
 +	if (is_imx53_esdhc(imx_data))
  		imx_data->flags |= ESDHC_FLAG_MULTIBLK_NO_INT;
  
 -	boarddata = host->mmc->parent->platform_data;
 -	if (boarddata) {
 +	boarddata = &imx_data->boarddata;
 +	if (sdhci_esdhc_imx_probe_dt(pdev, boarddata) < 0) {
 +		if (!host->mmc->parent->platform_data) {
 +			dev_err(mmc_dev(host->mmc), "no board data!\n");
 +			err = -EINVAL;
 +			goto no_board_data;
 +		}
 +		imx_data->boarddata = *((struct esdhc_platform_data *)
 +					host->mmc->parent->platform_data);
 +	}
 +
 +	/* write_protect */
 +	if (boarddata->wp_type == ESDHC_WP_GPIO) {
  		err = gpio_request_one(boarddata->wp_gpio, GPIOF_IN, "ESDHC_WP");
  		if (err) {
  			dev_warn(mmc_dev(host->mmc),

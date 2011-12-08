Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1LHI2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:28:44 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:18737
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753Ab1LHI2n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:28:43 -0500
X-SpamScore: -2
X-BigFish: VS-2(zzc89bh1432Nzz1202h1082kzz8275dhz2dh2a8h668h839h93fhb79i61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EE07550.5090509@freescale.com>
Date: Thu, 8 Dec 2011 16:29:04 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: Vinod Koul <vinod.koul@intel.com>, Wolfram Sang <w.sang@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 4/4] dma: mxs-dma: Don't use CLKGATE bits in CTRL0 to
 disable DMA channels
References: <cover.1323176362.git.LW@KARO-electronics.de> <689f40c73aabe244d65c52ce1ebb9e15220bc3c7.1323176362.git.LW@KARO-electronics.de>
In-Reply-To: <689f40c73aabe244d65c52ce1ebb9e15220bc3c7.1323176362.git.LW@KARO-electronics.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月08日 16:15, Lothar Waßmann 写道:
> This is how the original Freescale code (unintentionally) worked,
> because the code path which would have asserted the CLKGATE bit was
> never actually reached in their code.
> This fixes the nefarious "DMA timout" bug when multiple DMA channels
> (e.g. GPMI NAND and MMC) are used at the same time.
> If a better fix for this problem should be found, the clkgate handling
> could be reinstated.
> See http://lists.infradead.org/pipermail/linux-arm-kernel/2011-September/065228.html
>
> Also reverse the order of mxs_dma_disable_chan() and
> mxs_dma_reset_chan() in mxs_dma_control() because mxs_dma_reset_chan()
> can only work when the DMA channel is enabled.
>
> Signed-off-by: Lothar Waßmann<LW@KARO-electronics.de>
> ---
>   drivers/dma/mxs-dma.c |   29 +----------------------------
>   1 files changed, 1 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 78336b0..71ba93a 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -44,7 +44,6 @@
>   #define HW_APBHX_CTRL0				0x000
>   #define BM_APBH_CTRL0_APB_BURST8_EN		(1<<  29)
>   #define BM_APBH_CTRL0_APB_BURST_EN		(1<<  28)
> -#define BP_APBH_CTRL0_CLKGATE_CHANNEL		8
>   #define BP_APBH_CTRL0_RESET_CHANNEL		16
>   #define HW_APBHX_CTRL1				0x010
>   #define HW_APBHX_CTRL2				0x020
> @@ -131,23 +130,6 @@ struct mxs_dma_engine {
>   	struct mxs_dma_chan		mxs_chans[MXS_DMA_CHANNELS];
>   };
>
> -static inline void mxs_dma_clkgate(struct mxs_dma_chan *mxs_chan, int enable)
> -{
> -	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
> -	int chan_id = mxs_chan->chan.chan_id;
> -	int set_clr = enable ? MXS_CLR_ADDR : MXS_SET_ADDR;
> -
> -	/* enable apbh channel clock */
> -	if (dma_is_apbh()) {
> -		if (apbh_is_old())
> -			writel(1<<  (chan_id + BP_APBH_CTRL0_CLKGATE_CHANNEL),
> -				mxs_dma->base + HW_APBHX_CTRL0 + set_clr);
> -		else
> -			writel(1<<  chan_id,
> -				mxs_dma->base + HW_APBHX_CTRL0 + set_clr);
> -	}
> -}
> -
>   static void mxs_dma_reset_chan(struct mxs_dma_chan *mxs_chan)
>   {
>   	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
> @@ -166,9 +148,6 @@ static void mxs_dma_enable_chan(struct mxs_dma_chan *mxs_chan)
>   	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
>   	int chan_id = mxs_chan->chan.chan_id;
>
> -	/* clkgate needs to be enabled before writing other registers */
> -	mxs_dma_clkgate(mxs_chan, 1);
> -
>   	/* set cmd_addr up */
>   	writel(mxs_chan->ccw_phys,
>   		mxs_dma->base + HW_APBHX_CHn_NXTCMDAR(chan_id));
> @@ -179,9 +158,6 @@ static void mxs_dma_enable_chan(struct mxs_dma_chan *mxs_chan)
>
>   static void mxs_dma_disable_chan(struct mxs_dma_chan *mxs_chan)
>   {
> -	/* disable apbh channel clock */
> -	mxs_dma_clkgate(mxs_chan, 0);
> -
>   	mxs_chan->status = DMA_SUCCESS;
>   }
>
> @@ -339,10 +315,7 @@ static int mxs_dma_alloc_chan_resources(struct dma_chan *chan)
>   	if (ret)
>   		goto err_clk;
>
> -	/* clkgate needs to be enabled for reset to finish */
> -	mxs_dma_clkgate(mxs_chan, 1);
>   	mxs_dma_reset_chan(mxs_chan);
> -	mxs_dma_clkgate(mxs_chan, 0);
>
>   	dma_async_tx_descriptor_init(&mxs_chan->desc, chan);
>   	mxs_chan->desc.tx_submit = mxs_dma_tx_submit;
> @@ -542,8 +515,8 @@ static int mxs_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>
>   	switch (cmd) {
>   	case DMA_TERMINATE_ALL:
> -		mxs_dma_disable_chan(mxs_chan);
>   		mxs_dma_reset_chan(mxs_chan);
> +		mxs_dma_disable_chan(mxs_chan);
>   		break;
>   	case DMA_PAUSE:
>   		mxs_dma_pause_chan(mxs_chan);
I can test it.

Shawn, do you have any opnion?


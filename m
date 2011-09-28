Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1I1HqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:46:24 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:56294 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245Ab1I1HqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:46:23 -0400
Message-ID: <4E82D0A1.8050203@st.com>
Date: Wed, 28 Sep 2011 13:15:37 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/1] dmaengine/amba-pl08x: Add support for s3c64xx
 DMAC
References: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com> <1317189007-23033-2-git-send-email-alim.akhtar@samsung.com>
In-Reply-To: <1317189007-23033-2-git-send-email-alim.akhtar@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2011 11:20 AM, Alim Akhtar wrote:
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/dma/amba-pl08x.c |  135 ++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 112 insertions(+), 23 deletions(-)
> 

It would be good if you can add pick some part from cover-letter and put it in
commit log too.

> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index cd8df7f..501540f 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -110,6 +129,11 @@ struct pl08x_lli {
>  	u32 dst;
>  	u32 lli;
>  	u32 cctl;
> +	/*
> +	 * Samsung pl080 DMAC has one exrta control register
> +	 * which is used to hold the transfer_size
> +	 */
> +	u32 cctl1;

Will you write transfer_size in cctl also? What is the purpose of cctl1?

> @@ -215,11 +255,23 @@ static void pl08x_start_txd(struct pl08x_dma_chan *plchan,
>  		cpu_relax();
>  
>  	/* Do not access config register until channel shows as inactive */
> -	val = readl(phychan->base + PL080_CH_CONFIG);
> -	while ((val & PL080_CONFIG_ACTIVE) || (val & PL080_CONFIG_ENABLE))
> +	if (pl08x->vd->is_pl080_s3c) {
> +		val = readl(phychan->base + PL080S_CH_CONFIG);
> +		while ((val & PL080_CONFIG_ACTIVE) ||
> +			(val & PL080_CONFIG_ENABLE))
> +			val = readl(phychan->base + PL080S_CH_CONFIG);
> +
> +		writel(val | PL080_CONFIG_ENABLE,
> +			phychan->base + PL080S_CH_CONFIG);
> +	} else {
>  		val = readl(phychan->base + PL080_CH_CONFIG);
> +			while ((val & PL080_CONFIG_ACTIVE) ||
> +				(val & PL080_CONFIG_ENABLE))
> +				val = readl(phychan->base + PL080_CH_CONFIG);
>  
> -	writel(val | PL080_CONFIG_ENABLE, phychan->base + PL080_CH_CONFIG);
> +		writel(val | PL080_CONFIG_ENABLE,
> +			phychan->base + PL080_CH_CONFIG);
> +	}

You have similar stuff in most the the changes in this patch, because offset of
config register changes for s3c, you placed in if,else block.

If you check these changes again, there is a lot of code duplication in this if,else
blocks. The only different thing in if,else is the offset of CH_CONFIG register.

It would be much better if you can do following:

u32 ch_cfg_off;

	if (pl08x->vd->is_pl080_s3c)
		ch_cfg_off = PL080S_CH_CONFIG;
	else
		ch_cfg_off = PL080_CH_CONFIG;

Now, this offset can be used in existing code, without much code duplication.

> @@ -569,6 +641,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
>  	u32 cctl, early_bytes = 0;
>  	size_t max_bytes_per_lli, total_bytes = 0;
>  	struct pl08x_lli *llis_va;
> +	size_t lli_len = 0, target_len, tsize, odd_bytes;
>  
>  	txd->llis_va = dma_pool_alloc(pl08x->pool, GFP_NOWAIT, &txd->llis_bus);
>  	if (!txd->llis_va) {
> @@ -700,7 +773,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
>  		 * width left
>  		 */
>  		while (bd.remainder > (mbus->buswidth - 1)) {
> -			size_t lli_len, tsize, width;
> +			size_t width;
>  

why do we need above two changes. odd_bytes and target_len are still unused.

>  			/*
>  			 * If enough left try to send max possible,
> @@ -759,6 +832,9 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
>  	llis_va[num_llis - 1].lli = 0;
>  	/* The final LLI element shall also fire an interrupt. */
>  	llis_va[num_llis - 1].cctl |= PL080_CONTROL_TC_IRQ_EN;
> +	/* Keep the TransferSize seperate to fill samsung specific register */
> +	if (pl08x->vd->is_pl080_s3c)
> +		llis_va[num_llis - 1].cctl1 |= lli_len;

I couldn't get this completely. Why do you keep only length of
last lli in cctl1. what about all other llis. Also why |=
and not directly cctl1 = lli_len

--
viresh

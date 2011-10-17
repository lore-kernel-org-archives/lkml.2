Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1JQKAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 06:00:00 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:43234 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1JQJ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:59:59 -0400
Message-ID: <4E9BFC62.1080102@atmel.com>
Date: Mon, 17 Oct 2011 11:58:58 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com> <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
In-Reply-To: <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 07:38 AM, Vinod Koul :
> From: Vinod Koul <vinod.koul@linux.intel.com>
> 
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

[..]

> index fcfa0a8..7968a81 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -660,7 +660,7 @@ err_desc_get:
>   */
>  static struct dma_async_tx_descriptor *
>  atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
> -		unsigned int sg_len, enum dma_data_direction direction,
> +		unsigned int sg_len, enum dma_transfer_direction direction,
>  		unsigned long flags)
>  {
>  	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
> @@ -678,7 +678,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  
>  	dev_vdbg(chan2dev(chan), "prep_slave_sg (%d): %s f0x%lx\n",
>  			sg_len,
> -			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",
> +			direction == MEM_TO_DEV ? "TO DEVICE" : "FROM DEVICE",
>  			flags);
>  
>  	if (unlikely(!atslave || !sg_len)) {
> @@ -692,7 +692,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  	ctrlb = ATC_IEN;
>  
>  	switch (direction) {
> -	case DMA_TO_DEVICE:
> +	case MEM_TO_DEV:
>  		ctrla |=  ATC_DST_WIDTH(reg_width);
>  		ctrlb |=  ATC_DST_ADDR_MODE_FIXED
>  			| ATC_SRC_ADDR_MODE_INCR
> @@ -725,7 +725,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  			total_len += len;
>  		}
>  		break;
> -	case DMA_FROM_DEVICE:
> +	case DEV_TO_MEM:
>  		ctrla |=  ATC_SRC_WIDTH(reg_width);
>  		ctrlb |=  ATC_DST_ADDR_MODE_INCR
>  			| ATC_SRC_ADDR_MODE_FIXED
> @@ -787,7 +787,7 @@ err_desc_get:
>   */
>  static int
>  atc_dma_cyclic_check_values(unsigned int reg_width, dma_addr_t buf_addr,
> -		size_t period_len, enum dma_data_direction direction)
> +		size_t period_len, enum dma_transfer_direction direction)
>  {
>  	if (period_len > (ATC_BTSIZE_MAX << reg_width))
>  		goto err_out;
> @@ -795,7 +795,7 @@ atc_dma_cyclic_check_values(unsigned int reg_width, dma_addr_t buf_addr,
>  		goto err_out;
>  	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
>  		goto err_out;
> -	if (unlikely(!(direction & (DMA_TO_DEVICE | DMA_FROM_DEVICE))))
> +	if (unlikely(!(direction & (DEV_TO_MEM | MEM_TO_DEV))))
>  		goto err_out;
>  
>  	return 0;
> @@ -810,7 +810,7 @@ err_out:
>  static int
>  atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
>  		unsigned int period_index, dma_addr_t buf_addr,
> -		size_t period_len, enum dma_data_direction direction)
> +		size_t period_len, enum dma_transfer_direction direction)
>  {
>  	u32		ctrla;
>  	unsigned int	reg_width = atslave->reg_width;
> @@ -822,7 +822,7 @@ atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
>  		| period_len >> reg_width;
>  
>  	switch (direction) {
> -	case DMA_TO_DEVICE:
> +	case MEM_TO_DEV:
>  		desc->lli.saddr = buf_addr + (period_len * period_index);
>  		desc->lli.daddr = atslave->tx_reg;
>  		desc->lli.ctrla = ctrla;
> @@ -833,7 +833,7 @@ atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
>  				| ATC_DIF(AT_DMA_PER_IF);
>  		break;
>  
> -	case DMA_FROM_DEVICE:
> +	case DEV_TO_MEM:
>  		desc->lli.saddr = atslave->rx_reg;
>  		desc->lli.daddr = buf_addr + (period_len * period_index);
>  		desc->lli.ctrla = ctrla;
> @@ -861,7 +861,7 @@ atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
>   */
>  static struct dma_async_tx_descriptor *
>  atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> -		size_t period_len, enum dma_data_direction direction)
> +		size_t period_len, enum dma_transfer_direction direction)
>  {
>  	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
>  	struct at_dma_slave	*atslave = chan->private;
> @@ -872,7 +872,7 @@ atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
>  	unsigned int		i;
>  
>  	dev_vdbg(chan2dev(chan), "prep_dma_cyclic: %s buf@0x%08x - %d (%d/%d)\n",
> -			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",
> +			direction == MEM_TO_DEV ? "TO DEVICE" : "FROM DEVICE",
>  			buf_addr,
>  			periods, buf_len, period_len);
>  

For at_hdmac (Atmel DMA controller)

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Best regards,
-- 
Nicolas Ferre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0IHQxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:53:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53948 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab0IHQxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:53:45 -0400
Date: Wed, 8 Sep 2010 10:53:41 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Feng Tang <feng.tang@intel.com>, George Shore <george@georgeshore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dw_spi: Allow interrupt sharing
Message-ID: <20100908165341.GJ3686@angua.secretlab.ca>
References: <20100907072727.GA2152@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907072727.GA2152@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 03:27:27PM +0800, Yong Wang wrote:
> Allow interrupt sharing since exclusive interrupt line for
> DW SPI controller is not provided on every platform.
> 
> Signed-off-by: Yong Wang <yong.y.wang@intel.com>
> ---
>  drivers/spi/dw_spi.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/dw_spi.c b/drivers/spi/dw_spi.c
> index d256cb0..11fbbf6 100644
> --- a/drivers/spi/dw_spi.c
> +++ b/drivers/spi/dw_spi.c
> @@ -396,6 +396,11 @@ static irqreturn_t interrupt_transfer(struct dw_spi *dws)
>  static irqreturn_t dw_spi_irq(int irq, void *dev_id)
>  {
>  	struct dw_spi *dws = dev_id;
> +	u16 irq_status, irq_mask = 0x3f;
> +
> +	irq_status = dw_readw(dws, isr) & irq_mask;
> +	if (!irq_status)
> +		return IRQ_NONE;

To be more concise, this could have simply been:

if (!dw_readw(dws, isr) & 0x3f)
	return IRQ_NONE;

... but I'm nitpicking here.  If I don't get an updated version of
this patch from you in the next few days then I'll apply this one.

g.

>  
>  	if (!dws->cur_msg) {
>  		spi_mask_intr(dws, SPI_INT_TXEI);
> @@ -883,7 +888,7 @@ int __devinit dw_spi_add_host(struct dw_spi *dws)
>  	dws->dma_inited = 0;
>  	dws->dma_addr = (dma_addr_t)(dws->paddr + 0x60);
>  
> -	ret = request_irq(dws->irq, dw_spi_irq, 0,
> +	ret = request_irq(dws->irq, dw_spi_irq, IRQF_SHARED,
>  			"dw_spi", dws);
>  	if (ret < 0) {
>  		dev_err(&master->dev, "can not get IRQ\n");
> -- 
> 1.5.5.1
> 

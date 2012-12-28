Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2L1L5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 06:57:51 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:10792 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2L1L5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 06:57:49 -0500
Message-ID: <1356695860.17740.51.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [RFC/RFT] forcedeth: Fix 'device driver failed to check map
 error' warnings
From: Ben Hutchings <bhutchings@solarflare.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 28 Dec 2012 12:57:40 +0100
In-Reply-To: <50db61fe.u8zB6nsB1I7ajQXN%Larry.Finger@lwfinger.net>
References: <50db61fe.u8zB6nsB1I7ajQXN%Larry.Finger@lwfinger.net>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [151.217.219.220]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-26 at 14:45 -0600, Larry Finger wrote:
> With 3.8-rc1, there are WARNINGS that the driver is not checking for
> DMA mapping errors. The warnings start with
> 
> ------------[ cut here ]------------
> WARNING: at lib/dma-debug.c:933 check_unmap+0x480/0x950()
> Hardware name: HP Pavilion dv2700 Notebook PC
> forcedeth 0000:00:0a.0: DMA-API: device driver failed to check
>  map error[device address=0x00000000b176e002] [size=90 bytes] [mapped as single]
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Please check that the error returns are correctly done.
[...]
> @@ -2217,6 +2229,9 @@ static netdev_tx_t nv_start_xmit(struct
>  		bcnt = (size > NV_TX2_TSO_MAX_SIZE) ? NV_TX2_TSO_MAX_SIZE : size;
>  		np->put_tx_ctx->dma = pci_map_single(np->pci_dev, skb->data + offset, bcnt,
>  						PCI_DMA_TODEVICE);
> +		if (pci_dma_mapping_error(np->pci_dev,
> +					  np->put_tx_ctx->dma))
> +			return NETDEV_TX_BUSY;
>  		np->put_tx_ctx->dma_len = bcnt;
>  		np->put_tx_ctx->dma_single = 1;
>  		put_tx->buf = cpu_to_le32(np->put_tx_ctx->dma);
> @@ -2337,6 +2352,9 @@ static netdev_tx_t nv_start_xmit_optimiz
>  		bcnt = (size > NV_TX2_TSO_MAX_SIZE) ? NV_TX2_TSO_MAX_SIZE : size;
>  		np->put_tx_ctx->dma = pci_map_single(np->pci_dev, skb->data + offset, bcnt,
>  						PCI_DMA_TODEVICE);
> +		if (pci_dma_mapping_error(np->pci_dev,
> +					  np->put_tx_ctx->dma))
> +			return NETDEV_TX_BUSY;
>  		np->put_tx_ctx->dma_len = bcnt;
>  		np->put_tx_ctx->dma_single = 1;
>  		put_tx->bufhigh = cpu_to_le32(dma_high(np->put_tx_ctx->dma));
[...]

In these cases the skb should be freed and the return value should be
NETDEV_TX_OK.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


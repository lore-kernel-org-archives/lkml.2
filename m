Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab1LHIWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:22:32 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:30698
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822Ab1LHIWb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:22:31 -0500
X-SpamScore: -2
X-BigFish: VS-2(zzc89bh1432Nzz1202h1082kzzz2dh2a8h668h839h93fhb79i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EE073DC.7050803@freescale.com>
Date: Thu, 8 Dec 2011 16:22:52 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: Vinod Koul <vinod.koul@intel.com>, Wolfram Sang <w.sang@pengutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] dma: mxs-dma: make mxs_dma_prep_slave_sg() multi
 user safe
References: <cover.1323176362.git.LW@KARO-electronics.de> <fd785eed4c58e0ee591084aa5334cafcc8cfe082.1323176362.git.LW@KARO-electronics.de>
In-Reply-To: <fd785eed4c58e0ee591084aa5334cafcc8cfe082.1323176362.git.LW@KARO-electronics.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月08日 16:15, Lothar Waßmann 写道:
> Using a static variable for counting the number of CCWs attached to
> a DMA channel when appending a new descriptor is not multi user safe.
>
> Signed-off-by: Lothar Waßmann<LW@KARO-electronics.de>
> ---
>   drivers/dma/mxs-dma.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index c7574e8..78336b0 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -111,6 +111,7 @@ struct mxs_dma_chan {
>   	int				chan_irq;
>   	struct mxs_dma_ccw		*ccw;
>   	dma_addr_t			ccw_phys;
> +	int				desc_count;
>   	dma_cookie_t			last_completed;
>   	enum dma_status			status;
>   	unsigned int			flags;
> @@ -386,7 +387,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
>   	struct scatterlist *sg;
>   	int i, j;
>   	u32 *pio;
> -	static int idx;
> +	int idx = append ? mxs_chan->desc_count : 0;
>
>   	if (mxs_chan->status == DMA_IN_PROGRESS&&  !append)
>   		return NULL;
> @@ -462,6 +463,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
>   			}
>   		}
>   	}
> +	mxs_chan->desc_count = idx;
>
>   	return&mxs_chan->desc;
>
> @@ -523,6 +525,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_dma_cyclic(
>
>   		i++;
>   	}
> +	mxs_chan->desc_count = i;
>
>   	return&mxs_chan->desc;
>
I like this patch.


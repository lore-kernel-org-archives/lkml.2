Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2LQNwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:52:33 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:50240 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab2LQNwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:52:32 -0500
Message-ID: <1355752345.2676.2.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 3/3 v2] net/macb: Try to optimize struct macb layout
From: Ben Hutchings <bhutchings@solarflare.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Joachim Eastwood <manabian@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Havard Skinnemoen <havard@skinnemoen.net>
Date: Mon, 17 Dec 2012 13:52:25 +0000
In-Reply-To: <cd54582850d50ec7ae391aae423b8982875a123a.1355748676.git.nicolas.ferre@atmel.com>
References: <cover.1355748676.git.nicolas.ferre@atmel.com>
	 <cd54582850d50ec7ae391aae423b8982875a123a.1355748676.git.nicolas.ferre@atmel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 14:01 +0100, Nicolas Ferre wrote:
> From: Havard Skinnemoen <havard@skinnemoen.net>
> 
> Move TX-related fields to the top of the struct so that they end up on
> the same cache line. Move the NAPI struct below that since it is used
> from the interrupt handler. RX-related fields go below those.

> Move the spinlock before regs since they are usually used together.
>
> Signed-off-by: Havard Skinnemoen <havard@skinnemoen.net>
> [nicolas.ferre@atmel.com: adapt to newer kernel]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/net/ethernet/cadence/macb.h | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index cef146f..aeeb729 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -548,38 +548,39 @@ struct macb_or_gem_ops {
>  };
>  
>  struct macb {
> +	spinlock_t		lock;
>  	void __iomem		*regs;
>  
> +	unsigned int		tx_head;
> +	unsigned int		tx_tail;
> +	struct macb_dma_desc	*tx_ring;
> +	struct macb_tx_skb	*tx_skb;
> +	dma_addr_t		tx_ring_dma;
> +	struct work_struct	tx_error_task;
> +
> +	struct napi_struct	napi;
[...]

If this driver may be used on SMP systems them 'napi' should be declared
with the suffix ___cacheline_aligned_in_smp.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1HHRY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:24:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:32384 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1HHRY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,338,1309762800"; 
   d="scan'208";a="36332903"
Subject: Re: [RFC patch] DMA engine/Langwell: release LLI pool
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <CAJd=RBBU7SvVLmVqR_LmJMWG=rgya80DbdPNEc-nR=_d4YQrDQ@mail.gmail.com>
References: <CAJd=RBBU7SvVLmVqR_LmJMWG=rgya80DbdPNEc-nR=_d4YQrDQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 22:54:09 +0530
Message-ID: <1312824249.1539.40.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 21:24 +0800, Hillf Danton wrote:
> When releasing resources allocated before for DMA channel, checking LLI pool is
> added and it is reclaimed if still available.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  drivers/dma/intel_mid_dma.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
> index f653517..4c758fc 100644
> --- a/drivers/dma/intel_mid_dma.c
> +++ b/drivers/dma/intel_mid_dma.c
> @@ -833,6 +833,10 @@ static void
> intel_mid_dma_free_chan_resources(struct dma_chan *chan)
And this one, as well
>  	midc->descs_allocated = 0;
>  	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
>  		list_del(&desc->desc_node);
> +		if (desc->lli != NULL) {
> +			pci_pool_free(desc->lli_pool, desc->lli, desc->lli_phys);
> +			pci_pool_destroy(desc->lli_pool);
> +		}
>  		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
>  	}
>  	list_for_each_entry_safe(desc, _desc, &midc->free_list, desc_node) {
> @@ -841,6 +845,10 @@ static void
> intel_mid_dma_free_chan_resources(struct dma_chan *chan)
>  	}
>  	list_for_each_entry_safe(desc, _desc, &midc->queue, desc_node) {
>  		list_del(&desc->desc_node);
> +		if (desc->lli != NULL) {
> +			pci_pool_free(desc->lli_pool, desc->lli, desc->lli_phys);
> +			pci_pool_destroy(desc->lli_pool);
> +		}
>  		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
>  	}
>  	spin_unlock_bh(&midc->lock);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod


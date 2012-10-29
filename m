Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2J2P1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:27:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58748 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476Ab2J2P1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:27:11 -0400
Message-ID: <508EA04D.5050805@wwwdotorg.org>
Date: Mon, 29 Oct 2012 09:27:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dmitry Osipenko <digetx@gmail.com>, Laxman Dewangan <ldewangan@nvidia.com>
CC: vinod.koul@intel.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dma: tegra20-apbdma: channel freeing correction
References: <1351433873-14082-1-git-send-email-digetx@gmail.com>
In-Reply-To: <1351433873-14082-1-git-send-email-digetx@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2012 08:17 AM, Dmitry Osipenko wrote:
> Fixed channel "lock" after free.
> 
> Example: Channel 1 was allocated and prepared as slave_sg, used and freed. Now preparation of cyclic dma on channel 1 will fail with err "DMA
> configuration conflict" because tdc->isr_handler still selected to handle_once_dma_done.
> 
> This happens because tegra_dma_abort_all() won't be called on channel freeing if pending list is empty.

That commit description isn't correctly wrapped.

> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c

> @@ -1147,6 +1147,7 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
>  
>  	if (tdc->busy)
>  		tegra_dma_terminate_all(dc);
> +	tdc->isr_handler = NULL;

Should we remove that assignment from tegra_dma_abort_all(); perhaps it
is redundant now?

Actually, I wonder if the correct fix isn't to:

a) Always call tegra_dma_terminate_all() from
tegra_dma_free_chan_resources() irrespective of busy state.

b) Make tegra_dma_terminate_all() always call tegra_dma_abort_all()
irrespective of whether list_empty(&tdc->pending_sg_req).

But then I wonder: should tdc->isr_handler get left set to non-NULL in
the scenario mentioned in your commit description at all; should it be
cleared as soon as the channel is idle in all cases, so that it doesn't
need to be cleared when freeing the channel?

I CC'd Laxman, the driver author, to comment here.

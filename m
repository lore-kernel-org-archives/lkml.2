Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2H0HIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:08:23 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:35834 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2H0HIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:08:22 -0400
Date: Mon, 27 Aug 2012 09:08:18 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] avr32-linux: at32ap700x: set DMA slave properties for
 MCI dw_dmac
Message-ID: <20120827070818.GD28721@samfundet.no>
References: <503A8D97.4070403@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503A8D97.4070403@yahoo.es>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 27 Aug 2012 04:56:55 +0800 or thereabout, Hein Tibosch wrote:

PS: I prefer avr32: prefix in the Subject for AVR32 kernel stuff, we already
know this is for the Linux kernel ;)

> @Andrew: could you please push the patch below? Hans-Christian
> doesn't have a GIT tree on kernel.org
> 
> Thanks, Hein
> 
> The MCI makes use of the dw_dmac driver when DMA is being used.
> Due to recent changes the driver was broken because:
> - the SMS field in the CTLL register received the wrong value 0
> - a patch in dw_dmac allowed for 64-bit transfers on the
> memory side, giving an illegal value of 3 in the SRC/DST_TR_WIDTH
> register.
> This patch sets the SMS to 1 and limits the maximum transfer
> width to 2 (32 bits)
> 
> Note: this can only be applied after my patch:
> [PATCH 2/2] dw_dmac: max_mem_width limits value for
> SRC/DST_TR_WID register

Thanks for going through this and fixing the MCI/DMA-combo on AVR32.

> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
> ---
>  arch/avr32/mach-at32ap/at32ap700x.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>  diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index 0445c4f..e7202af 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -1355,6 +1355,10 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
>  				| DWC_CFGH_DST_PER(1));
>  	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
>  				| DWC_CFGL_HS_SRC_POL);
> +	/* Give CTLL SMS value 1 */

This comment gives me no information, I don't know what CTLL and SMS are, and
what does the magic value 1 do? Either skip the comment, or give a short
block here describing why src_master must be one, and max_mem_width must be 2.

> +	slave->sdata.src_master = 1;
> +	/* SRC/DST_TR_WIDTH register only accepts 0,1,2 */
> +	slave->sdata.max_mem_width = 2;

Something like:

/*
 * Setup DMA controller to let source be master, and transfer width to
 * 32-bit.
 */
slave->sdata.src_master = 1;
slave->sdata.max_mem_width = 2;

>  
>  	data->dma_slave = slave;
>  
-- 
mvh
Hans-Christian Egtvedt

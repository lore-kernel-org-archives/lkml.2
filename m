Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab0CYXd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:33:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:34540 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0CYXdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:33:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,310,1267430400"; 
   d="scan'208";a="503735069"
Subject: Re: [PATCH 1/2] DMAENGINE: generic slave control
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, Pavel Machek <pavel@ucw.cz>,
       Li Yang <leoli@freescale.com>, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Magnus Damm <damm@opensource.se>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1269529368-16645-1-git-send-email-linus.walleij@stericsson.com>
References: <1269529368-16645-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 16:30:14 -0700
Message-ID: <1269559814.28615.97.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 08:02 -0700, Linus Walleij wrote:
> Convert the device_terminate_all() operation on the
> DMA engine to a generic device_control() operation
> which can now optionally support also pausing and
> resuming DMA on a certain channel. Implemented for the
> COH 901 318 DMAC as an example.
> 
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Cc: Magnus Damm <damm@opensource.se>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  arch/arm/mach-u300/include/mach/coh901318.h |   14 ---------
>  drivers/dma/at_hdmac.c                      |   10 +++++-
>  drivers/dma/coh901318.c                     |   42 ++++++++++++++++++---------
>  drivers/dma/dmaengine.c                     |    2 +-
>  drivers/dma/dw_dmac.c                       |   10 +++++-
>  drivers/dma/fsldma.c                        |   11 ++++++-
>  drivers/dma/ipu/ipu_idmac.c                 |   19 ++++++++----
>  drivers/dma/shdma.c                         |   10 +++++-
>  drivers/dma/txx9dmac.c                      |   10 +++++-
>  drivers/mmc/host/atmel-mci.c                |    2 +-
>  drivers/serial/sh-sci.c                     |    2 +-
>  drivers/video/mx3fb.c                       |    3 +-
>  include/linux/dmaengine.h                   |   18 ++++++++++-
>  sound/soc/txx9/txx9aclc.c                   |    6 ++--
>  14 files changed, 106 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/arm/mach-u300/include/mach/coh901318.h b/arch/arm/mach-u300/include/mach/coh901318.h
> index b8155b4..43ec040 100644
> --- a/arch/arm/mach-u300/include/mach/coh901318.h
> +++ b/arch/arm/mach-u300/include/mach/coh901318.h
> @@ -110,20 +110,6 @@ struct coh901318_platform {
>  u32 coh901318_get_bytes_left(struct dma_chan *chan);
> 
>  /**
> - * coh901318_stop() - Stops dma transfer
> - * @chan: dma channel handle
> - * return 0 on success otherwise negative value
> - */
> -void coh901318_stop(struct dma_chan *chan);
> -
> -/**
> - * coh901318_continue() - Resumes a stopped dma transfer
> - * @chan: dma channel handle
> - * return 0 on success otherwise negative value
> - */
> -void coh901318_continue(struct dma_chan *chan);
> -
> -/**
>   * coh901318_filter_id() - DMA channel filter function
>   * @chan: dma channel handle
>   * @chan_id: id of dma channel to be filter out
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index efc1a61..3fa3658 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -759,13 +759,17 @@ err_desc_get:
>         return NULL;
>  }
> 
> -static void atc_terminate_all(struct dma_chan *chan)
> +static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
>  {
>         struct at_dma_chan      *atchan = to_at_dma_chan(chan);
>         struct at_dma           *atdma = to_at_dma(chan->device);
>         struct at_desc          *desc, *_desc;
>         LIST_HEAD(list);
> 
> +       /* Only supports DMA_TERMINATE_ALL */
> +       if (cmd != DMA_TERMINATE_ALL)
> +               return -EINVAL;
> +

I'd prefer ENXIO here since it may be a valid command, just not
implemented in this specific driver.

Here is the important bits from build_dma.sh:

drivers/dma/ipu/ipu_idmac.c: In function '__idmac_control':
drivers/dma/ipu/ipu_idmac.c:1512: warning: control reaches end of non-void function
drivers/dma/fsldma.c: In function 'fsl_dma_device_control':
drivers/dma/fsldma.c:788: warning: 'return' with no value, in function returning non-void
drivers/dma/ppc4xx/adma.c:3944: error: expected identifier or '(' before '{' token
drivers/dma/shdma.c: In function `sh_dmae_control':
drivers/dma/shdma.c:592: warning: `return' with no value, in function returning non-void

--
Dan



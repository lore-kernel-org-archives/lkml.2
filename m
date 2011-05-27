Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab1E0Bio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:38:44 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:60255 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab1E0Bin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:38:43 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1306460322!26961040!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Date: Thu, 26 May 2011 20:38:41 -0500
Subject: RE: [PATCH 1/5] dmaengine: add ep93xx DMA support
Thread-Topic: [PATCH 1/5] dmaengine: add ep93xx DMA support
Thread-Index: AcwYonp9s0fvyNsfTcWp/tqLq1eAmQDajcGw
Message-ID: <0D753D10438DA54287A00B027084269764D331A4B2@AUSP01VMBX24.collaborationhost.net>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
In-Reply-To: <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 22, 2011 10:03 AM, Mika Westerberg wrote:
>
> The ep93xx DMA controller has 10 independent memory to peripheral (M2P)
> channels, and 2 dedicated memory to memory (M2M) channels. M2M channels can
> also be used by SPI and IDE to perform DMA transfers to/from their memory
> mapped FIFOs.
>
> This driver supports both M2P and M2M channels with DMA_SLAVE, DMA_CYCLIC and
> DMA_MEMCPY (M2M only) capabilities.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> ---
>  arch/arm/mach-ep93xx/include/mach/dma.h |   87 ++
>  drivers/dma/Kconfig                     |    7 +
>  drivers/dma/Makefile                    |    1 +
>  drivers/dma/ep93xx_dma.c                | 1356 +++++++++++++++++++++++++++++++
>  4 files changed, 1451 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/dma/ep93xx_dma.c
>

[snip]

> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index a572600..614ce7b 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -235,6 +235,13 @@ config MXS_DMA
>  	  Support the MXS DMA engine. This engine including APBH-DMA
>  	  and APBX-DMA is integrated into Freescale i.MX23/28 chips.
>  
> +config EP93XX_DMA
> +	bool "Cirrus Logic EP93xx DMA support"
> +	depends on ARCH_EP93XX
> +	select DMA_ENGINE
> +	help
> +	  Enable support for the Cirrus Logic EP93xx M2P/M2M DMA controller.
> +
>  config DMA_ENGINE
>  	bool

The old dma-m2p support was always builtin.  Should ARCH_EP93XX select
EP93XX_DMA to keep this, or should it be added to the ep93xx_defconfig?
Ryan, what do you think?

[snip]

> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> new file mode 100644
> index 0000000..7898e8c
> --- /dev/null
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -0,0 +1,1356 @@
> +/*
> + * Driver for the Cirrus Logic EP93xx DMA Controller
> + *
> + * Copyright (C) 2011 Mika Westerberg
> + *
> + * DMA M2P implementation is based on the original
> + * arch/arm/mach-ep93xx/dma-m2p.c which has following copyrights:
> + *
> + *   Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
> + *   Copyright (C) 2006 Applied Data Systems
> + *   Copyright (C) 2009 Ryan Mallon <ryan@bluewatersys.com>
> + *
> + * This driver is based on dw_dmac and amba-pl08x drivers.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/dmaengine.h>
> +#include <linux/moduleparam.h>

Unnecessary header.

The reset looks fine to me.

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

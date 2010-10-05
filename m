Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab0JEXQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:16:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:57405 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595Ab0JEXQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:16:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,287,1283756400"; 
   d="scan'208";a="332607791"
Message-ID: <4CABB1B9.4080002@intel.com>
Date: Tue, 05 Oct 2010 16:16:09 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] dmaengine: Add Freescale i.MX1/21/27 DMA driver
References: <1285854995-6569-1-git-send-email-s.hauer@pengutronix.de> <1285854995-6569-5-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1285854995-6569-5-git-send-email-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/2010 6:56 AM, Sascha Hauer wrote:
> This driver is currently implemented as a user to the old i.MX
> DMA API. This allows us to convert each user of the old API to
> the dmaengine API one by one. Once this is done the old DMA
> driver can be merged into the i.MX dmaengine driver.
>
> Signed-off-by: Sascha Hauer<s.hauer@pengutronix.de>
> ---
>   drivers/dma/Kconfig   |    8 +
>   drivers/dma/Makefile  |    1 +
>   drivers/dma/imx-dma.c |  426 +++++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 435 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/dma/imx-dma.c
[..]
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> new file mode 100644
> index 0000000..6ef82ba
> --- /dev/null
> +++ b/drivers/dma/imx-dma.c
> @@ -0,0 +1,426 @@
> +/*
> + * drivers/dma/imx-dma.c
> + *
> + * This file contains a driver for the Freescale i.MX DMA engine
> + * found on i.MX1/21/27
> + *
> + * Copyright 2010 Sascha Hauer, Pengutronix<s.hauer@pengutronix.de>
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +#include<linux/init.h>
> +#include<linux/types.h>
> +#include<linux/mm.h>
> +#include<linux/interrupt.h>
> +#include<linux/spinlock.h>
> +#include<linux/device.h>
> +#include<linux/dma-mapping.h>
> +#include<linux/slab.h>
> +#include<linux/platform_device.h>
> +#include<linux/dmaengine.h>
> +
> +#include<asm/irq.h>
> +#include<mach/dma-v1.h>
> +#include<mach/hardware.h>
> +
> +struct imxdma_channel {
> +       struct imxdma_engine            *imxdma;
> +       unsigned int                    channel;
> +       unsigned int                    imxdma_channel;
> +
> +       enum dma_data_direction         direction;

Why does the channel have a direction isn't that a function of the 
transaction?  It's also unused.

> +       enum dma_slave_buswidth         word_size;
> +       dma_addr_t                      bd_phys;

unused?

> +       unsigned long                   flags;

unused?

> +       dma_addr_t                      per_address;
> +       u32                             watermark_level;
> +       struct dma_chan                 chan;
> +       spinlock_t                      lock;
> +       struct dma_async_tx_descriptor  desc;
> +       dma_cookie_t                    last_completed;
> +       enum dma_status                 status;
> +       int                             dma_request;
> +       struct scatterlist              *sg_list;
> +};
> +
> +#define MAX_DMA_CHANNELS 8
> +
> +struct imxdma_engine {
> +       struct device                   *dev;
> +       struct dma_device               dma_device;
> +       struct imxdma_channel           channel[MAX_DMA_CHANNELS];
> +};
> +
> +static struct imxdma_channel *to_imxdma_chan(struct dma_chan *chan)
> +{
> +       return container_of(chan, struct imxdma_channel, chan);
> +}
> +
> +static void imxdma_handle(struct imxdma_channel *imxdmac)
> +{
> +       if (imxdmac->desc.callback)
> +               imxdmac->desc.callback(imxdmac->desc.callback_param);
> +       imxdmac->last_completed = imxdmac->desc.cookie;
> +}
> +
> +static void imxdma_irq_handler(int channel, void *data)
> +{
> +       struct imxdma_channel *imxdmac = data;
> +printk("%s\n", __func__);

Debug leftover?

> +       imxdmac->status = DMA_SUCCESS;
> +       imxdma_handle(imxdmac);
> +}
> +
> +static void imxdma_err_handler(int channel, void *data, int error)
> +{
> +       struct imxdma_channel *imxdmac = data;
> +printk("%s 0x%08x\n", __func__, error);
> +dump_stack();

If you want to keep this I think it is better as a

WARN(1, "%s 0x%08x\n", __func__, error)

...assuming that errors are rare.

--
Dan

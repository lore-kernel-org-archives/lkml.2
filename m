Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2ISWBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 18:01:12 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2ISWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 18:01:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 01/14] davinci: vpfe: add dm3xx IPIPEIF hardware support module
Date: Thu, 20 Sep 2012 00:01:45 +0200
Message-ID: <2048611.Sb6fiWUyvr@avalon>
User-Agent: KMail/4.9.1 (Linux/3.3.8-gentoo; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1347626804-5703-2-git-send-email-prabhakar.lad@ti.com>
References: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com> <1347626804-5703-2-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thanks for the patch.

On Friday 14 September 2012 18:16:31 Prabhakar Lad wrote:
> From: Manjunath Hadli <manjunath.hadli@ti.com>
> 
> add support for dm3xx IPIPEIF hardware setup. This is the
> lowest software layer for the dm3x vpfe driver which directly
> accesses hardware. Add support for features like default
> pixel correction, dark frame substraction and hardware setup.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> ---
>  drivers/media/platform/davinci/dm3xx_ipipeif.c |  318 +++++++++++++++++++++
>  drivers/media/platform/davinci/dm3xx_ipipeif.h |  262 +++++++++++++++++++
>  include/linux/dm3xx_ipipeif.h                  |   62 +++++


>  3 files changed, 642 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/platform/davinci/dm3xx_ipipeif.c
>  create mode 100644 drivers/media/platform/davinci/dm3xx_ipipeif.h
>  create mode 100644 include/linux/dm3xx_ipipeif.h
> 
> diff --git a/drivers/media/platform/davinci/dm3xx_ipipeif.c
> b/drivers/media/platform/davinci/dm3xx_ipipeif.c new file mode 100644
> index 0000000..7961a74
> --- /dev/null
> +++ b/drivers/media/platform/davinci/dm3xx_ipipeif.c

[snip]

> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/uaccess.h>
> +#include <linux/v4l2-mediabus.h>
> +#include <linux/platform_device.h>

Just a side note, I usually sort headers alphabetically, but feel free to use 
whatever convention you like.

> +#include "dm3xx_ipipeif.h"
> +
> +static void *__iomem ipipeif_base_addr;

That's not good. You shouldn't have global constants like that. The value 
should instead be stored in your device structure, that you will need to pass 
around to all functions.

> +static inline u32 regr_if(u32 offset)
> +{
> +	return readl(ipipeif_base_addr + offset);
> +}
> +
> +static inline void regw_if(u32 val, u32 offset)
> +{
> +	writel(val, ipipeif_base_addr + offset);
> +}

Maybe ipipeif_read() and ipipeif_write() ?

> +void ipipeif_set_enable()
> +{
> +	regw_if(1, IPIPEIF_ENABLE);
> +}

Please define constants in a header file for register values, masks and shifts 
instead of hardcoding the raw numbers.

[snip]

> +static int __devinit dm3xx_ipipeif_probe(struct platform_device *pdev)
> +{
> +	static resource_size_t  res_len;
> +	struct resource *res;
> +	int status;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENOENT;
> +
> +	res_len = resource_size(res);
> +
> +	res = request_mem_region(res->start, res_len, res->name);
> +	if (!res)
> +		return -EBUSY;
> +
> +	ipipeif_base_addr = ioremap_nocache(res->start, res_len);
> +	if (!ipipeif_base_addr) {
> +		status = -EBUSY;
> +		goto fail;
> +	}
> +	return 0;
> +
> +fail:
> +	release_mem_region(res->start, res_len);
> +
> +	return status;
> +}
> +
> +static int dm3xx_ipipeif_remove(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +
> +	iounmap(ipipeif_base_addr);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res)
> +		release_mem_region(res->start, resource_size(res));
> +	return 0;
> +}
> +
> +static struct platform_driver dm3xx_ipipeif_driver = {
> +	.driver = {
> +		.name   = "dm3xx_ipipeif",
> +		.owner = THIS_MODULE,
> +	},
> +	.remove = __devexit_p(dm3xx_ipipeif_remove),
> +	.probe = dm3xx_ipipeif_probe,
> +};
> +
> +static int dm3xx_ipipeif_init(void)
> +{
> +	return platform_driver_register(&dm3xx_ipipeif_driver);
> +}
> +
> +static void dm3xx_ipipeif_exit(void)
> +{
> +	platform_driver_unregister(&dm3xx_ipipeif_driver);
> +}
> +
> +module_init(dm3xx_ipipeif_init);
> +module_exit(dm3xx_ipipeif_exit);

I'm not sure to like this. You're registering a module for a device that 
essentially sits there without doing anything, except providing functions that 
can be called by other modules.

I somehow feel that the way the code is split amongst the different layers 
isn't optimal. Could you briefly explain the rationale behind the current 
architecture ?

(BTW, please use the module_platform_driver() macro instead of 
module_init/module_exit)

[snip]

> diff --git a/include/linux/dm3xx_ipipeif.h b/include/linux/dm3xx_ipipeif.h
> new file mode 100644
> index 0000000..1c1a830
> --- /dev/null
> +++ b/include/linux/dm3xx_ipipeif.h

[snip]

> +#include <media/davinci/vpfe_types.h>
> +#include <media/davinci/vpfe.h>

This header file defines part of the userspace API, but includes media/ 
headers that are not exported to userspace.

Header files should be split between 3 directories:

- Definitions required by platform data used to go to media/ but the new 
include/linux/platform_data/ directory might be preferred nowadays. I have no 
strong opinion on this, as other headers are already in media/ you can 
probably keep using it for now.

- Definitions requires by userspace should go to include/linux/

- The rest should go to drivers/media/platform/davinci/.

-- 
Regards,

Laurent Pinchart


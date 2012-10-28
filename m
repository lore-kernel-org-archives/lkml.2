Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab2J1LEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 07:04:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36935 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2J1LEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 07:04:44 -0400
Message-ID: <508D110B.8010908@ti.com>
Date: Sun, 28 Oct 2012 16:33:39 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH v3 04/16] ARM: edma: add DT and runtime PM support
 for AM33XX
References: <1350566815-409-1-git-send-email-mporter@ti.com> <1350566815-409-5-git-send-email-mporter@ti.com>
In-Reply-To: <1350566815-409-5-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 6:56 PM, Matt Porter wrote:
> Adds support for parsing the TI EDMA DT data into the required
> EDMA private API platform data.
> 
> Calls runtime PM API only in the DT case in order to unidle the
> associated hwmods on AM33XX.

Runtime PM is supported on DaVinci now, so if that was the reason for
this choice, then it doesn't need to be that way.

> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/common/edma.c                      |  255 +++++++++++++++++++++++++--
>  arch/arm/mach-davinci/board-da830-evm.c     |    4 +-
>  arch/arm/mach-davinci/board-da850-evm.c     |    8 +-
>  arch/arm/mach-davinci/board-dm646x-evm.c    |    4 +-
>  arch/arm/mach-davinci/board-omapl138-hawk.c |    8 +-
>  arch/arm/mach-davinci/devices-da8xx.c       |    8 +-
>  arch/arm/mach-davinci/devices-tnetv107x.c   |    4 +-
>  arch/arm/mach-davinci/dm355.c               |    4 +-
>  arch/arm/mach-davinci/dm365.c               |    4 +-
>  arch/arm/mach-davinci/dm644x.c              |    4 +-
>  arch/arm/mach-davinci/dm646x.c              |    4 +-
>  include/linux/platform_data/edma.h          |    8 +-
>  12 files changed, 272 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index a3d189d..6d2a590 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -24,6 +24,13 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#include <linux/edma.h>
> +#include <linux/err.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/of_dma.h>
> +#include <linux/of_irq.h>
> +#include <linux/pm_runtime.h>
>  
>  #include <linux/platform_data/edma.h>
>  
> @@ -1366,31 +1373,237 @@ void edma_clear_event(unsigned channel)
>  EXPORT_SYMBOL(edma_clear_event);
>  
>  /*-----------------------------------------------------------------------*/
> +static int edma_of_read_u32_to_s8_array(const struct device_node *np,
> +					 const char *propname, s8 *out_values,
> +					 size_t sz)
> +{
> +	struct property *prop = of_find_property(np, propname, NULL);
> +	const __be32 *val;
> +
> +	if (!prop)
> +		return -EINVAL;
> +	if (!prop->value)
> +		return -ENODATA;
> +	if ((sz * sizeof(u32)) > prop->length)
> +		return -EOVERFLOW;
> +
> +	val = prop->value;
> +
> +	while (sz--)
> +		*out_values++ = (s8)(be32_to_cpup(val++) & 0xff);
> +
> +	/* Terminate it */
> +	*out_values++ = -1;
> +	*out_values++ = -1;
> +
> +	return 0;
> +}
> +
> +static int edma_of_read_u32_to_s16_array(const struct device_node *np,
> +					 const char *propname, s16 *out_values,
> +					 size_t sz)
> +{
> +	struct property *prop = of_find_property(np, propname, NULL);
> +	const __be32 *val;
> +
> +	if (!prop)
> +		return -EINVAL;
> +	if (!prop->value)
> +		return -ENODATA;
> +	if ((sz * sizeof(u32)) > prop->length)
> +		return -EOVERFLOW;
> +
> +	val = prop->value;
> +
> +	while (sz--)
> +		*out_values++ = (s16)(be32_to_cpup(val++) & 0xffff);
> +
> +	/* Terminate it */
> +	*out_values++ = -1;
> +	*out_values++ = -1;
> +
> +	return 0;
> +}

I think these helper functions will have some general use beyond EDMA
and can be kept in drivers/of/base.c. Grant/Rob need to agree though.

> diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
> index 95b5e10..ffcbec1 100644
> --- a/arch/arm/mach-davinci/board-da830-evm.c
> +++ b/arch/arm/mach-davinci/board-da830-evm.c
> @@ -512,7 +512,7 @@ static struct davinci_i2c_platform_data da830_evm_i2c_0_pdata = {
>   * example: Timer, GPIO, UART events etc) on da830/omap-l137 EVM, hence
>   * they are being reserved for codecs on the DSP side.
>   */
> -static const s16 da830_dma_rsv_chans[][2] = {
> +static s16 da830_dma_rsv_chans[][2] = {

I wonder why you had to remove const here and in other places. You seem
to be allocating new memory for DT case anyway. Its also not a good idea
to modify the passed platform data.

Thanks,
Sekhar

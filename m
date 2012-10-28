Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2J1ISh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:18:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58900 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2J1IS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:18:28 -0400
Message-ID: <508CEA05.8060200@ti.com>
Date: Sun, 28 Oct 2012 13:47:09 +0530
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
Subject: Re: [RFC PATCH v3 02/16] ARM: davinci: move private EDMA API to arm/common
References: <1350566815-409-1-git-send-email-mporter@ti.com> <1350566815-409-3-git-send-email-mporter@ti.com>
In-Reply-To: <1350566815-409-3-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 6:56 PM, Matt Porter wrote:
> Move mach-davinci/dma.c to common/edma.c so it can be used
> by OMAP (specifically AM33xx) as well. This just moves the
> private EDMA API but does not support OMAP.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---

> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
> index 4c48a36..f45d591 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
> @@ -19,9 +19,10 @@
>  #include <mach/irqs.h>
>  #include <mach/cputype.h>
>  #include <mach/mux.h>
> -#include <mach/edma.h>
>  #include <linux/platform_data/mmc-davinci.h>
>  #include <mach/time.h>
> +#include <linux/platform_data/edma.h>

Can you please introduce a patch to clean this mixture of linux/ and
mach/ includes?

> +
>  
>  #include "davinci.h"
>  #include "clock.h"
> @@ -141,10 +142,10 @@ static struct resource mmcsd0_resources[] = {
>  	},
>  	/* DMA channels: RX, then TX */
>  	{
> -		.start = EDMA_CTLR_CHAN(0, DAVINCI_DMA_MMCRXEVT),
> +		.start = EDMA_CTLR_CHAN(0, 26),

Instead of just replacing the event #defines with plain numbers, can you
introduce a mach-davinci local edma.h which can then be included in the
davinci platform files which refer to edma channel numbers?

> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
> index 7cd56ed..153fab8 100644
> --- a/arch/arm/plat-omap/Kconfig
> +++ b/arch/arm/plat-omap/Kconfig
> @@ -28,6 +28,7 @@ config ARCH_OMAP2PLUS
>  	select OMAP_DM_TIMER
>  	select PROC_DEVICETREE if PROC_FS
>  	select SPARSE_IRQ
> +	select TI_PRIV_EDMA

This hunk does not seem to belong to subject of this patch.

>  	select USE_OF
>  	help
>  	  "Systems based on OMAP2, OMAP3, OMAP4 or OMAP5"

> diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
> new file mode 100644
> index 0000000..7396f0b3
> --- /dev/null
> +++ b/include/linux/platform_data/edma.h
> @@ -0,0 +1,198 @@
> +/*
> + *  TI DAVINCI dma definitions
> + *
> + *  Copyright (C) 2006-2009 Texas Instruments.
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
> + *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
> + *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
> + *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
> + *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
> + *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
> + *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
> + *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
> + *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
> + *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

> + *  You should have received a copy of the  GNU General Public License along
> + *  with this program; if not, write  to the Free Software Foundation, Inc.,
> + *  675 Mass Ave, Cambridge, MA 02139, USA.

This part can be dropped, I suppose ;-)

Thanks,
Sekhar

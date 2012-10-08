Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2JHLmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 07:42:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53575 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab2JHLmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 07:42:11 -0400
Message-ID: <5072BBFB.1070804@ti.com>
Date: Mon, 8 Oct 2012 17:11:47 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Constantine Shulyupin <const@MakeLinux.com>
CC: <gregkh@linuxfoundation.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <khilman@ti.com>,
        <balbi@ti.com>, <miguel.aguilar@ridgerun.com>,
        <kernel-mentors@selenic.com>
Subject: Re: [PATCH v4] Enable USB peripheral on dm365 EVM
References: <1349367753-6725-1-git-send-email-const@MakeLinux.com>
In-Reply-To: <1349367753-6725-1-git-send-email-const@MakeLinux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Constantine,

On 10/4/2012 9:52 PM, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
> ---
> 
> Note:
> 
> USBPHY_CTL_PADDR and USBPHY_CLKFREQ_24MHZ are defined in board-dm365-evm.c because davinci.h can't be included from drivers/usb/musb/. May be davinci.h should be renamed and moved to arch/arm/mach-davinci/include/mach/usb.h like arch/arm/plat-omap/include/plat/usb.h
> 
> Tested with usb gadget g_zero.
> 
> Changelog 
> 
> Changes since v3 http://www.spinics.net/lists/kernel/msg1412544.html:
> - removed optional altering of pr_info
> 
> Changes since v2 http://article.gmane.org/gmane.linux.kernel/1159868/
> - reordered code
> - removed alternation of GPIO33, which is multiplexed with DRVVBUS, because is not need for peripheral USB
> 
> Changes since v1 http://marc.info/?l=linux-kernel&m=130894150803661&w=2:
> - removed optional code and reordered
> 
> This patch is based on code from Arago, Angstom, and RidgeRun projects.
> Original patch by miguel.aguilar@ridgerun.com is three years ago:
> - http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg14741.html
> 
> ---
>  arch/arm/mach-davinci/board-dm365-evm.c |    8 ++++++++
>  arch/arm/mach-davinci/usb.c             |    2 ++
>  drivers/usb/musb/davinci.h              |    1 +
>  drivers/usb/musb/musb_core.c            |   20 ++++++++++++--------
>  4 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> index 3a4743b..dfcb67f 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -38,6 +38,8 @@
>  #include <mach/mmc.h>
>  #include <mach/nand.h>
>  #include <mach/keyscan.h>
> +#include <mach/usb.h>
> +#include <mach/hardware.h>
>  
>  #include <media/tvp514x.h>
>  
> @@ -92,6 +94,9 @@ static inline int have_tvp7002(void)
>  #define CPLD_CCD_DIR3	CPLD_OFFSET(0x3f,0)
>  #define CPLD_CCD_IO3	CPLD_OFFSET(0x3f,1)
>  
> +#define USBPHY_CTL_PADDR	0x01c40034
> +#define USBPHY_CLKFREQ_24MHZ	BIT(13)
> +
>  static void __iomem *cpld;
>  
>  
> @@ -613,6 +618,9 @@ static __init void dm365_evm_init(void)
>  
>  	dm365_init_spi0(BIT(0), dm365_evm_spi_info,
>  			ARRAY_SIZE(dm365_evm_spi_info));
> +	writel(readl(IO_ADDRESS(USBPHY_CTL_PADDR)) | USBPHY_CLKFREQ_24MHZ,
> +			IO_ADDRESS(USBPHY_CTL_PADDR));
> +	davinci_setup_usb(500, 8);

Add a comment here on why current is limited to 500 mA? Probably coming
because of an on-board component?

>  }
>  
>  MACHINE_START(DAVINCI_DM365_EVM, "DaVinci DM365 EVM")
> diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
> index 23d2b6d..664c689 100644
> --- a/arch/arm/mach-davinci/usb.c
> +++ b/arch/arm/mach-davinci/usb.c
> @@ -49,6 +49,8 @@ static struct musb_hdrc_platform_data usb_data = {
>  	.mode           = MUSB_PERIPHERAL,
>  #elif defined(CONFIG_USB_MUSB_HOST)
>  	.mode           = MUSB_HOST,
> +#else
> +	.mode           = MUSB_OTG,

This does not look to be directly related to DM365 support and should be
separated into a different patch.


>  #endif
>  	.clock		= "usb",
>  	.config		= &musb_config,
> diff --git a/drivers/usb/musb/davinci.h b/drivers/usb/musb/davinci.h
> index 371baa0..e737d97 100644
> --- a/drivers/usb/musb/davinci.h
> +++ b/drivers/usb/musb/davinci.h
> @@ -16,6 +16,7 @@
>  
>  /* Integrated highspeed/otg PHY */
>  #define USBPHY_CTL_PADDR	0x01c40034
> +#define USBPHY_CLKFREQ_24MHZ	BIT(13)

You have added this repeat definition and do not use it anywhere.

Looks like all PHY related configuration is currently happening in
drivers/usb/musb/davinci.c and the same register is also being written
to for other platforms. Can you move the code you have included in board
file to the driver? As we move towards DT, we need to avoid register
configurations from board files anyway.

Thanks,
Sekhar

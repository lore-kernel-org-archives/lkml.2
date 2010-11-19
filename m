Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0KSQ7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:59:35 -0500
Received: from compulab.co.il ([67.18.134.219]:33663 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242Ab0KSQ7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:59:34 -0500
Message-ID: <4CE6ACE7.9010203@compulab.co.il>
Date: Fri, 19 Nov 2010 18:59:19 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.7) Gecko/20100816 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: srinath@mistralsolutions.com
CC: linux-omap@vger.kernel.org, jdk@ti.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, khilman@deeprootsystems.com,
        nm@ti.com, nagendra@mistralsolutions.com, umeshk@mistralsolutions.com
Subject: Re: [Patch v1] AM35xx: Craneboard: Add USB EHCI support
References: <[PATCH] AM35xx-Craneboard-Add-USB-EHCI-support> <1290182862-21837-1-git-send-email-srinath@mistralsolutions.com>
In-Reply-To: <1290182862-21837-1-git-send-email-srinath@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Srinath,

On 11/19/10 18:07, srinath@mistralsolutions.com wrote:
> From: Srinath <srinath@mistralsolutions.com>
>
> AM3517/05 Craneboard has one EHCI interface on board using port1.
>
> GPIO35 is used as power enable.
> GPIO38 is used as port1 PHY reset.
>
> Signed-off-by: Srinath <srinath@mistralsolutions.com>
> ---
>  arch/arm/mach-omap2/board-am3517crane.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
> index 13ead33..0e1a806 100644
> --- a/arch/arm/mach-omap2/board-am3517crane.c
> +++ b/arch/arm/mach-omap2/board-am3517crane.c
> @@ -28,8 +28,10 @@
>  
>  #include <plat/board.h>
>  #include <plat/common.h>
> +#include <plat/usb.h>
>  
>  #include "mux.h"
> +#include "control.h"
>  
>  /* Board initialization */
>  static struct omap_board_config_kernel am3517_crane_config[] __initdata = {
> @@ -53,10 +55,29 @@ static void __init am3517_crane_init_irq(void)
>  	omap_gpio_init();
>  }
>  
> +static struct ehci_hcd_omap_platform_data ehci_pdata __initdata = {
> +	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
> +	.port_mode[1] = EHCI_HCD_OMAP_MODE_UNKNOWN,
> +	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
> +
> +	.phy_reset  = true,
> +	.reset_gpio_port[0]  = 38,
> +	.reset_gpio_port[1]  = -EINVAL,
> +	.reset_gpio_port[2]  = -EINVAL
> +};
> +
>  static void __init am3517_crane_init(void)
>  {
>  	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
>  	omap_serial_init();
> +
> +	/* Configure GPIO for EHCI port */
> +	omap_mux_init_gpio(35, OMAP_PIN_OUTPUT);
> +	gpio_request(35, "usb_ehci_enable");

gpio_request() can fail, you should check this
and you should not use this gpio if the request fails.
Also, may be the regulators framework is more appropriate
for power enable line, but I'm not sure...

> +	gpio_direction_output(35, 1);
> +	gpio_set_value(35, 1);
> +	omap_mux_init_gpio(38, OMAP_PIN_OUTPUT);

Shouldn't the omap_mux_init_gpio() be called before you request the gpio?

> +	usb_ehci_init(&ehci_pdata);
>  }
>  
>  MACHINE_START(CRANEBOARD, "AM3517/05 CRANEBOARD")

-- 
Regards,
Igor.


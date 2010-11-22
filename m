Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab0KVR43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:56:29 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:62792 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0KVR40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:56:26 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: srinath@mistralsolutions.com
Cc: linux-omap@vger.kernel.org, jdk@ti.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, nm@ti.com,
        nagendra@mistralsolutions.com, umeshk@mistralsolutions.com,
        sshtylyov@mvista.com
Subject: Re: [Patch v2] AM35xx: Craneboard: Add USB EHCI support
Organization: Deep Root Systems, LLC
References: <1290414736-21973-1-git-send-email-srinath@mistralsolutions.com>
Date: Mon, 22 Nov 2010 09:56:21 -0800
In-Reply-To: <1290414736-21973-1-git-send-email-srinath@mistralsolutions.com>
	(srinath@mistralsolutions.com's message of "Mon, 22 Nov 2010 14:02:16
	+0530")
Message-ID: <87oc9hutru.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

srinath@mistralsolutions.com writes:

> From: Srinath <srinath@mistralsolutions.com>
>
> AM3517/05 Craneboard has one EHCI interface on board using port1.
>
> GPIO35 is used as power enable.
> GPIO38 is used as port1 PHY reset.
>
> Signed-off-by: Srinath <srinath@mistralsolutions.com>
> ---
>  arch/arm/mach-omap2/board-am3517crane.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
> index 13ead33..91791bc 100644
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
> @@ -53,10 +55,28 @@ static void __init am3517_crane_init_irq(void)
>  	omap_gpio_init();
>  }
>>  
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

Please define a symbolic constant for these GPIO numbers instead of using
hard-coded constants.

> +	gpio_request(35, "usb_ehci_enable");

GPIO APIs can fail.  Please check return value and act accordingly.

> +	gpio_direction_output(35, 1);
> +	omap_mux_init_gpio(38, OMAP_PIN_OUTPUT);
> +	usb_ehci_init(&ehci_pdata);
>  }
>  
>  MACHINE_START(CRANEBOARD, "AM3517/05 CRANEBOARD")

Kevin

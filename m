Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2CMQLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:11:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48399 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2CMQLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:11:31 -0400
Message-ID: <4F5F7F91.8010301@mvista.com>
Date: Tue, 13 Mar 2012 20:10:41 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm:da850: register musb device
References: <1331651015-32586-1-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1331651015-32586-1-git-send-email-prakash.pm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 06:03 PM, Manjunathappa, Prakash wrote:

> Properly set up the OTG mode thru the CFGCHIP2 register, enable the
> USB0_DRVVBUS pin,

    I don't see where you are enabling it.

> and finally register the MUSB platform device.
>
> Signed-off-by: Ajay Kumar Gupta<ajay.gupta@ti.com>
> Signed-off-by: Manjunathappa, Prakash<prakash.pm@ti.com>
> ---
> Patche are on top below posted patches:
> http://www.spinics.net/lists/linux-usb/msg59656.html

>   arch/arm/mach-davinci/board-da850-evm.c |   12 ++++++++++++
>   arch/arm/mach-davinci/usb.c             |    9 +++++++++
>   2 files changed, 21 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 178d178..539e12c 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -787,6 +787,18 @@ static __init void da850_evm_usb_init(void)
>   	 */
>   	cfgchip2&= ~CFGCHIP2_USB1PHYCLKMUX;
>   	cfgchip2 |=  CFGCHIP2_USB2PHYCLKMUX;
> +	/*
> +	 * We have to override VBUS/ID signals when MUSB is configured into the
> +	 * host-only mode -- ID pin will float if no cable is connected, so the
> +	 * controller won't be able to drive VBUS thinking that it's a B-device.
> +	 * Otherwise, we want to use the OTG mode and enable VBUS comparators.
> +	 */
> +	cfgchip2 &= ~CFGCHIP2_OTGMODE;
> +#if CONFIG_USB_MUSB_DA8XX

    This #ifdef doesn't make sense. It will make driver always work in host mode.

> +	cfgchip2 |=  CFGCHIP2_FORCE_HOST;
> +#else
> +	cfgchip2 |=  CFGCHIP2_SESENDEN | CFGCHIP2_VBDTCTEN;

    This is what you need to leave. The driver should always work in OTG mode now.

> +#endif
>
>   	__raw_writel(cfgchip2, DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP2_REG));
>
> diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
> index 25c3520..a941dc5 100644
> --- a/arch/arm/mach-davinci/usb.c
> +++ b/arch/arm/mach-davinci/usb.c
> @@ -284,6 +284,15 @@ void __init da8xx_board_usb_init(const short pins[],
>   		goto usb11_setup_fail;
>   	}
>
> +	/*
> +	 * TPS2065 switch @ 5V supplies 1 A (sustains 1.5 A),
> +	 * with the power on to power good time of 3 ms.
> +	 */
> +	ret = da8xx_register_usb20(1000, 3);
> +	if (ret)
> +		pr_warning("%s: USB 2.0 registration failed: %d\n",
> +			   __func__, ret);

    Er, why this code is moved there? And how will this work on DA830 -- try to 
register MUSB twice? Place this in the board file please where it belongs.

WBR, Sergei

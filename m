Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab1F0JNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:13:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46577 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab1F0JNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:13:15 -0400
Message-ID: <4E084965.4020409@mvista.com>
Date: Mon, 27 Jun 2011 13:12:05 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Constantine Shulyupin <const@makelinux.com>
CC: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] Enable USB on TI DM365
References: <BANLkTims=UsUMkDQ8uB+J6YTVRSBD__otw@mail.gmail.com>
In-Reply-To: <BANLkTims=UsUMkDQ8uB+J6YTVRSBD__otw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-06-2011 22:51, Constantine Shulyupin wrote:

> Enable USB on TI DM365

    On DM365 EVM board, you should have said.
    Do not duplicate the summary in the description. Also, more details here 
wouldn't hurt...

> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
[...]

> diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
> index 0b87a1c..52961a8 100644
> --- a/arch/arm/mach-davinci/Makefile
> +++ b/arch/arm/mach-davinci/Makefile
> @@ -5,7 +5,7 @@
>
>   # Common objects
>   obj-y 			:= time.o clock.o serial.o io.o psc.o \
> -			   gpio.o dma.o usb.o common.o sram.o aemif.o
> +			   gpio.o dma.o common.o sram.o aemif.o
>
>   obj-$(CONFIG_DAVINCI_MUX)		+= mux.o
>
> @@ -40,3 +40,4 @@ obj-$(CONFIG_MACH_OMAPL138_HAWKBOARD)	+= board-omapl138-hawk.o
>   obj-$(CONFIG_CPU_FREQ)			+= cpufreq.o
>   obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
>   obj-$(CONFIG_SUSPEND)			+= pm.o sleep.o
> +obj-$(CONFIG_USB_MUSB_DAVINCI)		+= usb.o

    And kernel linking will happily fail if CONFIG_USB_MUSB_DAVINCI=n. :-/
Also, I don't think making usb.c a module is a good idea...

> diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
> index 23d2b6d..8b12206 100644
> --- a/arch/arm/mach-davinci/usb.c
> +++ b/arch/arm/mach-davinci/usb.c
> @@ -4,19 +4,22 @@
>   #include<linux/init.h>
>   #include<linux/platform_device.h>
>   #include<linux/dma-mapping.h>
> -
>   #include<linux/usb/musb.h>
>
>   #include<mach/common.h>
>   #include<mach/irqs.h>
>   #include<mach/cputype.h>
>   #include<mach/usb.h>
> +#include<mach/mux.h>
> +#include<linux/gpio.h>
>
>   #define DAVINCI_USB_OTG_BASE	0x01c64000
>
>   #define DA8XX_USB0_BASE 	0x01e00000
>   #define DA8XX_USB1_BASE 	0x01e25000
>
> +static int retval;

    Why in the world it's 'static'? :-O

> @@ -87,7 +90,7 @@ static struct platform_device usb_dev = {
>   	.num_resources  = ARRAY_SIZE(usb_resources),
>   };
>
> -void __init davinci_setup_usb(unsigned mA, unsigned potpgt_ms)
> +int __init davinci_setup_usb(unsigned mA, unsigned potpgt_ms)
>   {
>   	usb_data.power = mA>  510 ? 255 : mA / 2;
>   	usb_data.potpgt = (potpgt_ms + 1) / 2;
> @@ -99,7 +102,8 @@ void __init davinci_setup_usb(unsigned mA, unsigned
> potpgt_ms)

    The patch is line-wrapped...

>   	} else	/* other devices don't have dedicated CPPI IRQ */
>   		usb_dev.num_resources = 2;
>
> -	platform_device_register(&usb_dev);
> +	retval = platform_device_register(&usb_dev);
> +	return retval;

    Why not just:

	return platform_device_register(&usb_dev);

>   }
>
>   #ifdef CONFIG_ARCH_DAVINCI_DA8XX
> @@ -132,7 +136,7 @@ int __init da8xx_register_usb20(unsigned mA,
> unsigned potpgt)
>
>   #else
>
> -void __init davinci_setup_usb(unsigned mA, unsigned potpgt_ms)
> +int __init davinci_setup_usb(unsigned mA, unsigned potpgt_ms)
>   {
>   }
>
> @@ -178,3 +182,23 @@ int __init da8xx_register_usb11(struct
> da8xx_ohci_root_hub *pdata)
>   	return platform_device_register(&da8xx_usb11_device);
>   }
>   #endif	/* CONFIG_DAVINCI_DA8XX */
> +
> +#ifdef CONFIG_MACH_DAVINCI_DM365_EVM

    How do you think why do we have arch/arm/mach-davinci/board-dm365-evm.c?

> +int __init dm365evm_usb_configure(void)
> +{
> +	davinci_cfg_reg(DM365_GPIO33);
> +	gpio_request(33, "usb");
> +	gpio_direction_output(33, 1);
> +	retval = davinci_setup_usb(500, 8);
> +	return retval;

    Why not just:

	return davinci_setup_usb(500, 8);

> diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
> index 2a2adf6..0147f5c 100644
> --- a/drivers/usb/musb/davinci.c
> +++ b/drivers/usb/musb/davinci.c
> @@ -72,6 +72,16 @@ static inline void phy_on(void)
>   	/* power everything up; start the on-chip PHY and its PLL */
>   	phy_ctrl&= ~(USBPHY_OSCPDWN | USBPHY_OTGPDWN | USBPHY_PHYPDWN);
>   	phy_ctrl |= USBPHY_SESNDEN | USBPHY_VBDTCTEN | USBPHY_PHYPLLON;
> +
> +	if (cpu_is_davinci_dm365()) {
> +		/*
> +		 * DM365 PHYCLKFREQ field [15:12] is set to 2
> +		 * to get clock from 24MHz crystal
> +		 */
> +		phy_ctrl |= USBPHY_CLKFREQ_24MHZ;

    I do think this should be set in the board specific code instead, like we 
do it on DA830.

> +		/*phy_ctrl&= ~USBPHY_PHYPDWN;*/

    Don't include commented out code.

> +	}
> +
>   	__raw_writel(phy_ctrl, USB_PHY_CTRL);
>
>   	/* wait for PLL to lock before proceeding */
> @@ -193,6 +203,9 @@ static void davinci_musb_source_power(struct musb
> *musb, int is_on, int immediat
>   		else
>   			schedule_work(&evm_vbus_work);
>   	}
> +
> +	if (cpu_is_davinci_dm365())
> +		gpio_set_value(33, is_on);

    This is board specific code, not CPU specific.

> diff --git a/drivers/usb/musb/davinci.h b/drivers/usb/musb/davinci.h
> index 046c844..1bf50e6 100644
> --- a/drivers/usb/musb/davinci.h
> +++ b/drivers/usb/musb/davinci.h
> @@ -17,6 +17,7 @@
>   /* Integrated highspeed/otg PHY */
>   #define USBPHY_CTL_PADDR	(DAVINCI_SYSTEM_MODULE_BASE + 0x34)
>   #define USBPHY_DATAPOL		BIT(11)	/* (dm355) switch D+/D- */
> +#define USBPHY_CLKFREQ_24MHZ    BIT(13)
>   #define USBPHY_PHYCLKGD		BIT(8)
>   #define USBPHY_SESNDEN		BIT(7)	/* v(sess_end) comparator */
>   #define USBPHY_VBDTCTEN		BIT(6)	/* v(bus) comparator */


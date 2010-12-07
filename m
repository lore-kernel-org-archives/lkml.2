Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0LGTwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:52:24 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:3206 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754504Ab0LGTwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:52:23 -0500
Message-ID: <4CFE90CA.9050004@bluewatersys.com>
Date: Wed, 08 Dec 2010 08:53:46 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Igor Plyatov <plyatov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, plagnioj@jcrosoft.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] mach-at91: Support for gms board added
References: <1291732927-9429-1-git-send-email-plyatov@gmail.com>
In-Reply-To: <1291732927-9429-1-git-send-email-plyatov@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 03:42 AM, Igor Plyatov wrote:
> * The gms is a board from GeoSIG Ltd company.
>   It is based on the Stamp9G20 module from Taskit company.
> * This is a second version of the patch with adjustments according
>   to comments from Ryan Mallon.
> * This patch made for Linux 2.6.37-rc5.
> 
> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> ---

Couple more comments below.

>  arch/arm/configs/stamp9g20gms_defconfig |  147 +++++++
>  arch/arm/mach-at91/Kconfig              |    6 +
>  arch/arm/mach-at91/Makefile             |    1 +
>  arch/arm/mach-at91/board-stamp9g20gms.c |  698 +++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/include/mach/gms.h   |   33 ++
>  5 files changed, 885 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/configs/stamp9g20gms_defconfig
>  create mode 100644 arch/arm/mach-at91/board-stamp9g20gms.c
>  create mode 100644 arch/arm/mach-at91/include/mach/gms.h
> 
> diff --git a/arch/arm/configs/stamp9g20gms_defconfig b/arch/arm/configs/stamp9g20gms_defconfig
> new file mode 100644
> index 0000000..c44057f
> --- /dev/null
> +++ b/arch/arm/configs/stamp9g20gms_defconfig
> @@ -0,0 +1,147 @@
> +CONFIG_EXPERIMENTAL=y
> +CONFIG_SYSVIPC=y
> +CONFIG_LOG_BUF_SHIFT=14
> +CONFIG_BLK_DEV_INITRD=y
> +CONFIG_SLAB=y
> +CONFIG_MODULES=y
> +CONFIG_MODULE_UNLOAD=y
> +CONFIG_ARCH_AT91=y
> +CONFIG_ARCH_AT91SAM9G20=y
> +CONFIG_MACH_STAMP9G20GMS=y

This is better and now looks (at a glance) almost identical to
stamp9g20_defconfig. Can you just add CONFIG_MACH_STAMP9G20GMS to
stamp9g20_defconfig and support both boards?

> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index c015b68..6bc9372 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -375,6 +375,12 @@ config MACH_STAMP9G20
>  	  evaluation board.
>  	  <http://www.taskit.de/en/>
>  
> +config MACH_STAMP9G20GMS
> +	bool "GeoSIG Stamp9G20 GMS"
> +	help
> +	  Select this if you are using taskit's Stamp9G20 with GeoSIG's GMS.
> +	  <http://www.geosig.com>
> +

Looking at this a bit more closely, the Stamp9G20 is a system on module
(SoM) board. The MACH_STAMP9G20 option supports the Stamp9G20 on
taskits's evaluation board and the MACH_PCONTROL_G20 option supports it
on the PControl carrier board. There is a reasonable amount of code
replication in each of the board files for the UARTs, NAND, MMC, etc.

Would it be better to have MACH_STAMPG20/board-stamp-9g20.c contain the
core support for the Stamp9G20 module and then each of the carrier board
files contain only the setup/devices found on the carrier board?

I don't know what the correct approach for SoMs. We are also interested
in this as we develop SoMs with carrier boards. Cc'ed Russell King for
his opinion.

<snip>

> +
> +static int pcf8574x_0x20_teardown(struct i2c_client *client, int gpio,
> +					unsigned ngpio, void *context)
> +{
> +	gpio_free(gpio + 4);

gpio_free(gpio + PCF_GPIO_ETH_DETECT)?

<snip>

> +
> +/*
> + * Compact Flash
> + */
> +#if	defined(CONFIG_PATA_AT91) || defined(CONFIG_PATA_AT91_MODULE)
> +static struct at91_cf_data __initdata stamp9g20gms_cf1_data = {
> +	.irq_pin	= AT91_PIN_PA27,
> +	.det_pin	= AT91_PIN_PB30,
> +	.rst_pin	= AT91_PIN_PB31,
> +	.chipselect	= 5,
> +	.flags		= AT91_CF_TRUE_IDE,
> +};
> +#endif /* CONFIG_PATA_AT91 */

I still think you can do away with some of these ifdef guards.
Registering the device is not a problem, and you are only saving a
handful of bytes by having this ifdef. I think the code is more
readable/maintainable without all the ifdefs.

> +/* Power Off by RTC */
> +static void stamp9g20gms_power_off(void)
> +{
> +	pr_notice("Power supply will be switched off automatically now or ");
> +	pr_notice("after 60 seconds without ArmDAS.\n");

No. It should all be one call to pr_notice on one single line so that
the full message can easily be grepped. Lines over 80 columns are
allowed for printk functions and checkpatch will not warn about this.

> +	at91_set_gpio_output(AT91_PIN_PA25, 1);
> +	/* Spin to death... */
> +	while (1)
> +		;
> +}

<snip>

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934

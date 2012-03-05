Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab2CEPBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:01:10 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50830 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab2CEPBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:01:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.68.189.5 as permitted sender) smtp.mail=glikely@secretlab.ca
Date: Mon, 5 Mar 2012 08:01:05 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: Guenter Roeck <guenter@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Peter Tyser <ptyser@xes-inc.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 v3] gpio: Add support for Intel ICHx/3100/Series[56]
 GPIO
Message-ID: <20120305150105.GB27229@ponder.secretlab.ca>
References: <8bf67546-b865-4de1-8436-049a79d656bd@zimbra>
 <7cddf613-68db-43d5-93f6-bc6e2d63af44@zimbra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cddf613-68db-43d5-93f6-bc6e2d63af44@zimbra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 12:18:26PM -0600, Aaron Sierra wrote:
> From: Peter Tyser <ptyser@xes-inc.com>
> 
> This driver works on many Intel chipsets, including the ICH6, ICH7,
> ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
> (Cougar Point), and NM10 (Tiger Point).
> 
> Additional Intel chipsets should be easily supported if needed, eg the
> ICH1-5, EP80579, etc.
> 
> Tested on QM67 (Cougar Point), QM57 (Ibex Peak), 3100 (Whitmore Lake),
> and NM10 (Tiger Point).
> 
> Includes work from Jean Delvare:
> 	- Resource leak removal during module load/unload
> 	- GPIO API bit value enforcement
> 
> Also includes code cleanup from Guenter Roeck.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> ---
>  MAINTAINERS             |    6 +
>  drivers/gpio/Kconfig    |   13 ++
>  drivers/gpio/Makefile   |    1 +
>  drivers/gpio/gpio-ich.c |  440 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 460 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/gpio-ich.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a1fce9a..9a0b59f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3284,6 +3284,12 @@ W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
>  S:	Supported
>  F:	drivers/scsi/ips.*
>  
> +ICH LPC DRIVER
> +M:	Peter Tyser <ptyser@xes-inc.com>
> +S:	Maintained
> +F:	drivers/mfd/lpc_ich.c
> +F:	drivers/gpio/gpio-ich.c
> +
>  IDE SUBSYSTEM
>  M:	"David S. Miller" <davem@davemloft.net>
>  L:	linux-ide@vger.kernel.org
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index d0c4118..3359f1e 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -178,6 +178,19 @@ config GPIO_SCH
>  	  The Intel Tunnel Creek processor has 5 GPIOs powered by the
>  	  core power rail and 9 from suspend power supply.
>  
> +config GPIO_ICH
> +	tristate "Intel ICH GPIO"
> +	depends on PCI && X86
> +	select MFD_CORE
> +	select LPC_ICH
> +	help
> +	  Say yes here to support the GPIO functionality of a number of Intel
> +	  ICH-based chipsets.  Currently supported devices: ICH6, ICH7, ICH8
> +	  ICH9, ICH10, Series 5/3400 (eg Ibex Peak), Series 6/C200 (eg
> +	  Cougar Point), NM10 (Tiger Point), and 3100 (Whitmore Lake).
> +
> +	  If unsure, say N.
> +
>  config GPIO_VX855
>  	tristate "VIA VX855/VX875 GPIO"
>  	depends on PCI
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index fa10df6..b538830 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -44,6 +44,7 @@ obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
>  obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
>  obj-$(CONFIG_PLAT_SAMSUNG)	+= gpio-samsung.o
>  obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
> +obj-$(CONFIG_GPIO_ICH)		+= gpio-ich.o
>  obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
>  obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
>  obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o

This list is alphabetized, please keep it that way.

[...]
> +static struct platform_driver ichx_gpio_driver = {
> +	.driver		= {
> +		.owner	= THIS_MODULE,
> +		.name	= DRV_NAME,
> +	},
> +	.probe		= ichx_gpio_probe,
> +	.remove		= __devexit_p(ichx_gpio_remove),
> +};
> +
> +static int __devinit ichx_gpio_init_module(void)
> +{
> +	return platform_driver_register(&ichx_gpio_driver);
> +}
> +
> +static void __devexit ichx_gpio_exit_module(void)
> +{
> +	platform_driver_unregister(&ichx_gpio_driver);
> +}
> +
> +subsys_initcall(ichx_gpio_init_module);
> +module_exit(ichx_gpio_exit_module);

Don't use subsys_initcall.  Futzing with initcalls to get drivers in the
right order isn't sustainable.  I'm going to try to get the probe_defer
patches into v3.4 which is a better solution to the problem.

Also, you should use module_platform_driver() for trivial platform driver
registrations.

Otherwise looks good.

g.


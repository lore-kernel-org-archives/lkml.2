Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab2GWQdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 12:33:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51907 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab2GWQdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:33:47 -0400
Date: Mon, 23 Jul 2012 18:33:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: wei_wang@realsil.com.cn
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
Message-ID: <20120723163340.GA4105@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, wei_wang@realsil.com.cn,
	gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org
References: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 05:42:38PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Realtek card reader core driver is the bus driver for Realtek
> driver-based card reader, which supplies adapter layer to
> be used by lower-level pci/usb card reader and upper-level
> sdmmc/memstick host driver.
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  Documentation/misc-devices/realtek_cr.txt |   27 ++
>  drivers/misc/Kconfig                      |    1 +
>  drivers/misc/Makefile                     |    1 +
>  drivers/misc/realtek_cr/Kconfig           |   26 ++
>  drivers/misc/realtek_cr/Makefile          |    7 +
>  drivers/misc/realtek_cr/core/Kconfig      |    6 +
>  drivers/misc/realtek_cr/core/Makefile     |    1 +
>  drivers/misc/realtek_cr/core/rtsx_core.c  |  492 +++++++++++++++++++++++++++++
>  include/linux/rtsx_core.h                 |  183 +++++++++++
>  9 files changed, 744 insertions(+)
>  create mode 100644 Documentation/misc-devices/realtek_cr.txt
>  create mode 100644 drivers/misc/realtek_cr/Kconfig
>  create mode 100644 drivers/misc/realtek_cr/Makefile
>  create mode 100644 drivers/misc/realtek_cr/core/Kconfig
>  create mode 100644 drivers/misc/realtek_cr/core/Makefile
>  create mode 100644 drivers/misc/realtek_cr/core/rtsx_core.c
>  create mode 100644 include/linux/rtsx_core.h
> 
> diff --git a/Documentation/misc-devices/realtek_cr.txt b/Documentation/misc-devices/realtek_cr.txt
> new file mode 100644
> index 0000000..b4e6fbe
> --- /dev/null
> +++ b/Documentation/misc-devices/realtek_cr.txt
> @@ -0,0 +1,27 @@
> +Realtek Driver-based Card Reader
> +================================
> +
> +Supported chips:
> +RTS5209
> +RTS5229
> +
> +Contact Email:
> +pc_sw_linux@realsil.com.cn
> +
> +
> +Description
> +-----------
> +
> +Realtek driver-based card reader supports access to many types of memory cards,
> +such as Memory Stick, Memory Stick Pro, Secure Digital and MultiMediaCard.
> +
> +
> +udev rules
> +----------
> +
> +In order to modprobe Realtek SD/MMC interface driver automatically, the following rule
> +should be added to the udev rules file:
> +
> +SUBSYSTEM=="rtsx_cr", ENV{RTSX_CARD_TYPE}=="SD", RUN+="/sbin/modprobe -bv rtsx_sdmmc"
> +
> +Typically, we may edit /lib/udev/rules.d/80-drivers.rules and copy the rule into it in Ubuntu.
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 2661f6e..09ce905 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -517,4 +517,5 @@ source "drivers/misc/lis3lv02d/Kconfig"
>  source "drivers/misc/carma/Kconfig"
>  source "drivers/misc/altera-stapl/Kconfig"
>  source "drivers/misc/mei/Kconfig"
> +source "drivers/misc/realtek_cr/Kconfig"
>  endmenu
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 456972f..c09f147 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -51,3 +51,4 @@ obj-y				+= carma/
>  obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
>  obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
>  obj-$(CONFIG_INTEL_MEI)		+= mei/
> +obj-$(CONFIG_REALTEK_CR_SUPPORT) += realtek_cr/
> diff --git a/drivers/misc/realtek_cr/Kconfig b/drivers/misc/realtek_cr/Kconfig
> new file mode 100644
> index 0000000..303d98a
> --- /dev/null
> +++ b/drivers/misc/realtek_cr/Kconfig
> @@ -0,0 +1,26 @@
> +#
> +# Realtek driver-based card reader
> +#
> +
> +menuconfig REALTEK_CR_SUPPORT
> +	tristate "Realtek driver-based card reader"
> +	help
> +	  Realtek driver-based card reader supports access to many types of
> +	  memory cards, such as Memory Stick, Memory Stick Pro, Secure Digital
> +	  and MultiMediaCard.
> +
> +	  If you want to use Realtek driver-based card reader, enable this
> +	  option and other options below.
> +
> +config REALTEK_CR_DEBUG
> +	bool "Realtek driver-based card reader debugging"
> +	depends on REALTEK_CR_SUPPORT != n
> +	help
> +	  This is an option for use by developers; most people should
> +	  say N here.  This enables Realtek card reader driver debugging.
> +
> +if REALTEK_CR_SUPPORT
> +
> +source "drivers/misc/realtek_cr/core/Kconfig"
> +
> +endif

Ok, maybe I'm a newbie here but this is a card reader driver and AFAICT
it should be placed under CONFIG_MMC. Why is it under drivers/misc?

-- 
Regards/Gruss,
Boris.

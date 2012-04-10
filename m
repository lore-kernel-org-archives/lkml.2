Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2DJPxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:53:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47943 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab2DJPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:53:08 -0400
Message-ID: <4F84575F.7090909@wwwdotorg.org>
Date: Tue, 10 Apr 2012 09:53:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: gregkh@linuxfoundation.org, Sudhakar Mamillapalli <sudhakar@fb.com>,
        linux-kernel@vger.kernel.org, ArndBergmannarnd@arndb.de,
        Grant Likely <grant.likely@secretlab.ca>, linux-serial@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Nhan H Mai <nhan.h.mai@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH v3 1/3] tegra, serial8250: add ->handle_break() uart_port
 op
References: <20120409194514.8004.53204.stgit@dwillia2-linux.jf.intel.com> <20120409194857.8004.86352.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120409194857.8004.86352.stgit@dwillia2-linux.jf.intel.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 01:48 PM, Dan Williams wrote:
> The "KT" serial port has another use case for a "received break" quirk,
> so before adding another special case to the 8250 core take this
> opportunity to push such quirks out of the core and into a uart_port op.

> diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
...
> +CONFIG_SERIAL_TEGRA=y

Instead of that,

> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
...
> +# FIXME remove this option when Tegra completes conversion to open firmware
> +config SERIAL_TEGRA
> +	bool "Tegra serial port support"
> +	depends on SERIAL_OF_PLATFORM=y
> +	help
> +	  If you have a machine based on NVIDIA Tegra you can enable its
> +	  onboard serial ports by enabling this option.
> +

Can we just make that default y if ARCH_TEGRA?

defconfig changes are apparently a little touchy.

Actually, why even introduce a new config variable; why not replace the
ifdefs in of_serial.[ch] with CONFIG_ARCH_TEGRA?

> diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
...
>  static struct platform_device *harmony_devices[] __initdata = {
> +#if IS_ENABLED(CONFIG_SERIAL_TEGRA)
>  	&debug_uart,
> +#endif

Yes, it'd be nice to avoid those ifdefs. If you used ARCH_TEGRA instead
of a new config variable for this, the ifdefs in the board files would
be guaranteed to be true.

> diff --git a/arch/arm/mach-tegra/devices.h b/arch/arm/mach-tegra/devices.h
> index ec45567..6e5f852 100644
> --- a/arch/arm/mach-tegra/devices.h
> +++ b/arch/arm/mach-tegra/devices.h
> @@ -53,5 +53,4 @@ extern struct platform_device tegra_i2s_device1;
>  extern struct platform_device tegra_i2s_device2;
>  extern struct platform_device tegra_das_device;
>  extern struct platform_device tegra_pcm_device;
> -
>  #endif

That's left over from a previous patch version.

> @@ -84,6 +106,9 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
>  		| UPF_FIXED_PORT | UPF_FIXED_TYPE;
>  	port->dev = &ofdev->dev;
>  
> +	if (type == PORT_TEGRA)
> +		port->handle_break = tegra_serial_handle_break;

This is going to mean that everything in 8250.c:uart_config[] will move
into the exact same data structure in of_serial.c eventually, so I still
don't see the point of this exercise. But, I guess I won't argue against
it any more.

> diff --git a/include/linux/of_serial.h b/include/linux/of_serial.h
...
> + * FIXME remove this file when tegra finishes conversion to open firmware,

remove this *prototype* not *file*?

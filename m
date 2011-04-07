Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1DGJBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:01:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52514 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1DGJBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:01:37 -0400
Date: Thu, 7 Apr 2011 11:01:25 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: oskar.andero@sonyericsson.com
Cc: linux@arm.linux.org.uk, nicolas.pitre@linaro.org, eric.y.miao@gmail.com,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Victor Boivie <victor.boivie@sonyericsson.com>
Subject: Re: [PATCH] ARM: Allow for kernel command line concatenation
Message-ID: <20110407090125.GH13963@pengutronix.de>
References: <1302164236-1516-1-git-send-email-oskar.andero@sonyericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302164236-1516-1-git-send-email-oskar.andero@sonyericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 10:17:16AM +0200, oskar.andero@sonyericsson.com wrote:
> From: Victor Boivie <victor.boivie@sonyericsson.com>
> 
> This patch allows the provided CONFIG_CMDLINE to be concatenated
> with the one provided by the boot loader. This is useful to
> merge the static values defined in CONFIG_CMDLINE with the
> boot loader's (possibly) more dynamic values, such as startup
> reasons and more.
> 
> Signed-off-by: Victor Boivie <victor.boivie@sonyericsson.com>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@sonyericsson.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
> ---
>  arch/arm/Kconfig        |   21 +++++++++++++++++++--
>  arch/arm/kernel/setup.c |    9 ++++++++-
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 5b9f78b..71b35e6 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1743,6 +1743,24 @@ config CMDLINE
>  	  time by entering them here. As a minimum, you should specify the
>  	  memory size and the root device (e.g., mem=64M root=/dev/nfs).
>  
> +choice
> +	prompt "Kernel command line type"
> +	default CMDLINE_DEFAULT
I'm not sure this works, but maybe use:

	choice
		prompt "Kernel command line type" if CMDLINE != ""
		default CMDLINE_DEFAULT

and then remove the explicit

	depends on CMDLINE != ""

from the options. This might hide the choice from the user if there is
only a single option to choose.

Best regards
Uwe

> +
> +config CMDLINE_DEFAULT
> +	bool "Use bootloader kernel arguments if available"
> +	help
> +	  Uses the command-line options passed by the boot loader. If
> +	  the boot loader doesn't provide any, the default kernel command
> +	  string provided in CMDLINE will be used.
"CMDLINE_DEFAULT" isn't a good name IMHO. It conflicts with

	config CMDLINE
		string "Default kernel command string"

Maybe better use CMDLINE_FROM_BOOTLOADER or similar?

> +
> +config CMDLINE_EXTEND
> +	bool "Extend bootloader kernel arguments"
> +	depends on CMDLINE != ""
> +	help
> +	  The default kernel command string will be concatenated with the
> +	  arguments provided by the boot loader.
> +
>  config CMDLINE_FORCE
>  	bool "Always use the default kernel command string"
>  	depends on CMDLINE != ""
> @@ -1751,8 +1769,7 @@ config CMDLINE_FORCE
>  	  loader passes other arguments to the kernel.
>  	  This is useful if you cannot or don't want to change the
>  	  command-line options your boot loader passes to the kernel.
> -
> -	  If unsure, say N.
> +endchoice
>  
>  config XIP_KERNEL
>  	bool "Kernel Execute-In-Place from ROM"
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 006c1e8..465bc7e 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -673,7 +673,14 @@ __tagtable(ATAG_REVISION, parse_tag_revision);
>  static int __init parse_tag_cmdline(const struct tag *tag)
>  {
>  #ifndef CONFIG_CMDLINE_FORCE
> -	strlcpy(default_command_line, tag->u.cmdline.cmdline, COMMAND_LINE_SIZE);
> +#ifdef CONFIG_CMDLINE_EXTEND
> +	strlcat(default_command_line, " ", COMMAND_LINE_SIZE);
> +	strlcat(default_command_line, tag->u.cmdline.cmdline,
> +		COMMAND_LINE_SIZE);
> +#else
> +	strlcpy(default_command_line, tag->u.cmdline.cmdline,
> +		COMMAND_LINE_SIZE);
> +#endif
>  #else
>  	pr_warning("Ignoring tag cmdline (using the default kernel command line)\n");
>  #endif /* CONFIG_CMDLINE_FORCE */
> -- 
> 1.7.4.2
I would prefer

	#ifdef CONFIG_CMDLINE_DEFAULT
		strlcpy(default_command_line, tag->u.cmdline.cmdline,
			COMMAND_LINE_SIZE);
	#elif CONFIG_CMDLINE_EXTEND
		...
	#else /* CMDLINE_FORCE */
		...
	#endif

as it is easier to parse for a human.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

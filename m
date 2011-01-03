Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab1ACNvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:51:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:45637 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab1ACNvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:51:50 -0500
Date: Mon, 3 Jan 2011 14:51:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: introduce 'notimeout' blacklist for Dell Vostro
 V13 (was Re: Synaptics touchpad on Dell Vostro V13)
In-Reply-To: <alpine.LNX.2.00.1012291444110.16569@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1101031450390.26685@pobox.suse.cz>
References: <alpine.LNX.2.00.1012141547570.15140@pobox.suse.cz> <20101214170027.GA11318@core.coreip.homeip.net> <alpine.LNX.2.00.1012152348440.16569@pobox.suse.cz> <201012151523.09476.dmitry.torokhov@gmail.com> <alpine.LNX.2.00.1012281124030.16569@pobox.suse.cz>
 <20101229074410.GC13061@core.coreip.homeip.net> <alpine.LNX.2.00.1012291341550.16569@pobox.suse.cz> <alpine.LNX.2.00.1012291444110.16569@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010, Jiri Kosina wrote:

> On Wed, 29 Dec 2010, Jiri Kosina wrote:
> 
> > > Well, another blacklist in i8042 I guess...
> > 
> > Sigh, seems so.
> > 
> > I'll send you patch once I get positive testing feedback.
> 
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] Input: introduce 'notimeout' blacklist for Dell Vostro V13
> 
> i8042 controller present in Dell Vostro V13 errorneously signals spurious
> timeouts.
> 
> Introduce i8042.notimeout parameter for ignoring i8042-signalled timeouts
> and apply this quirk automatically for Dell Vostro V13, based on DMI match.
> 
> In addition to that, this machine also needs to be added to nomux blacklist.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Just to be clear -- I have already received positive feedback from the 
bugreporter I had. I have attached the patch for testing to

	https://bugzilla.kernel.org/show_bug.cgi?id=15416

as well, but I already have confirmation from person owning the hardware, 
so I believe it could be applied.

Thanks.

> ---
>  drivers/input/serio/i8042-x86ia64io.h |   21 +++++++++++++++++++++
>  drivers/input/serio/i8042.c           |    6 +++++-
>  2 files changed, 26 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index a5475b5..b04dd27 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -424,6 +424,13 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
>  		},
>  	},
> +	{
> +		/* Dell Vostro V13 */
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
> +		},
> +	},
>  	{ }
>  };
>  
> @@ -545,6 +552,17 @@ static const struct dmi_system_id __initconst i8042_dmi_laptop_table[] = {
>  };
>  #endif
>  
> +static const struct dmi_system_id __initconst i8042_dmi_notimeout_table[] = {
> +	{
> +		/* Dell Vostro V13 */
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V13"),
> +		},
> +	},
> +	{ }
> +};
> +
>  /*
>   * Some Wistron based laptops need us to explicitly enable the 'Dritek
>   * keyboard extension' to make their extra keys start generating scancodes.
> @@ -897,6 +915,9 @@ static int __init i8042_platform_init(void)
>  	if (dmi_check_system(i8042_dmi_nomux_table))
>  		i8042_nomux = true;
>  
> +	if (dmi_check_system(i8042_dmi_notimeout_table))
> +		i8042_notimeout = true;
> +
>  	if (dmi_check_system(i8042_dmi_dritek_table))
>  		i8042_dritek = true;
>  #endif /* CONFIG_X86 */
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index 18db5a8..039037d 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -61,6 +61,10 @@ static bool i8042_noloop;
>  module_param_named(noloop, i8042_noloop, bool, 0);
>  MODULE_PARM_DESC(noloop, "Disable the AUX Loopback command while probing for the AUX port");
>  
> +static bool i8042_notimeout;
> +module_param_named(notimeout, i8042_notimeout, bool, 0);
> +MODULE_PARM_DESC(notimeout, "Ignore timeouts signalled by i8042");
> +
>  #ifdef CONFIG_X86
>  static bool i8042_dritek;
>  module_param_named(dritek, i8042_dritek, bool, 0);
> @@ -503,7 +507,7 @@ static irqreturn_t i8042_interrupt(int irq, void *dev_id)
>  	} else {
>  
>  		dfl = ((str & I8042_STR_PARITY) ? SERIO_PARITY : 0) |
> -		      ((str & I8042_STR_TIMEOUT) ? SERIO_TIMEOUT : 0);
> +		      ((str & I8042_STR_TIMEOUT && !i8042_notimeout) ? SERIO_TIMEOUT : 0);
>  
>  		port_no = (str & I8042_STR_AUXDATA) ?
>  				I8042_AUX_PORT_NO : I8042_KBD_PORT_NO;
> -- 
> 1.7.3.1
> 
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

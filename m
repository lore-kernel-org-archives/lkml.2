Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1AFBv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:51:58 -0500
Received: from 99-32-96-5.uvs.tulsok.sbcglobal.net ([99.32.96.5]:34600 "EHLO
	butch.jtdata.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1AFBv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 20:51:57 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jan 2011 20:51:56 EST
Date: Wed, 5 Jan 2011 19:42:11 -0600 (CST)
From: "James T. Dickson" <james.dickson@jtdata.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Message-ID: <5171053.20.1294278131468.JavaMail.root@butch.jtdata.net>
In-Reply-To: <alpine.LNX.2.00.1101031450390.26685@pobox.suse.cz>
Subject: Re: [PATCH] Input: introduce 'notimeout' blacklist for Dell Vostro
 V13 (was Re: Synaptics touchpad on Dell Vostro V13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.1.71]
X-Mailer: Zimbra 6.0.8_GA_2661 (ZimbraWebClient - SAF3 (Linux)/6.0.8_GA_2661)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have applied this patch and can report that it has fixed the problem Ubuntu 10.10. 

However, the mouse freezes when a coming out of suspend and the system will not shutdown. 

James Dickson 
 

----- Original Message -----
From: "Jiri Kosina" <jkosina@suse.cz>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Sent: Monday, January 3, 2011 7:51:48 AM
Subject: Re: [PATCH] Input: introduce 'notimeout' blacklist for Dell Vostro V13 (was Re: Synaptics touchpad on Dell Vostro V13)

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
--
To unsubscribe from this list: send the line "unsubscribe linux-input" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

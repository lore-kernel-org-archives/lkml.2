Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2LMTv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:51:26 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42831 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab2LMTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:51:24 -0500
Message-ID: <50CA31BB.2030507@acm.org>
Date: Thu, 13 Dec 2012 13:51:23 -0600
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Camuso <tcamuso@redhat.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, openipmi-developer@lists.sourceforge.net,
        grant.likely@secretlab.ca, Robert Evans <Robert.Evans@stratus.com>,
        Jim Paradis <jparadis@redhat.com>
Subject: Re: [PATCH] ipmi: add new kernel options to prevent automatic ipmi
 init
References: <1355424008-20491-1-git-send-email-tcamuso@redhat.com>
In-Reply-To: <1355424008-20491-1-git-send-email-tcamuso@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, the built-in driver works on systems that have more than one interface
and more than one BMC, and multiple IPMBs (and all of the other channel
types for that matter, and the driver handles all the multiplexing and nasty
addressing).  There is, in fact, no arbitrary limit, and IBM tested
this fairly extensively with some of their systems.  I'm not sure why you
would need a custom driver, and if there are some custom things that need
to be done for your servers, I'd be happy to add that.  I've worked with a
number of other vendors to get changes like this in.  And then ipmitool,
freeipmi, openipmi, etc. will work with the device.

I don't have a big problem with this patch.  I wonder why you would want
to compile the standard driver into your kernel if you expected to load a
module with a custom driver later, though.  None of the distros I know of
compile it in, it's always a module.

You can also dynamically remove the device from the driver using the hot
add/remove capability.  To remove it, you can do:
   echo remove,`cat /proc/ipmi/0/params`
and it will disassociate that device (IPMI interface 0 in this case) 
from the
driver.  So you can iterate through all the devices in /proc/ipmi and
remove them all at startup.

If none of the above options work for you, we can go ahead with this
patch.  Just wanted to let you know that current options exist, and see
if you wanted to take a different direction.

-corey

On 12/13/2012 12:40 PM, Tony Camuso wrote:
> The configuration change building ipmi_si into the kernel precludes the
> use of a custom driver that can utilize more than one KCS interface,
> multiple IPMBs, and more than one BMC. This capability is important for
> fault-tolerant systems.
>
> Even if the kernel option ipmi_si.trydefaults=0 is specified, ipmi_si
> discovers and claims one of the KCS interfaces on a Stratus server.
> The inability to now prevent the kernel from managing this device is a
> regression from previous kernels. The regression breaks a capability
> fault-tolerant vendors have relied upon.
>
> To support both ACPI opregion access and the need to avoid activation
> of ipmi_si on some platforms, we've added two new kernel options,
> ipmi_si.tryacpi and ipmi_si.trydmi be added to prevent ipmi_si from
> initializing when these options are set to 0 on the kernel command line.
> With these options at the default value of 1, ipmi_si init proceeds
> according to the kernel default.
>
> Tested-by: Jim Paradis <jparadis@redhat.com>
> Signed-off-by: Robert Evans <Robert.Evans@stratus.com>
> Signed-off-by: Jim Paradis <jparadis@redhat.com>
> Signed-off-by: Tony Camuso <tcamuso@redhat.com>
> ---
>   drivers/char/ipmi/ipmi_si_intf.c | 28 ++++++++++++++++++++++++----
>   1 file changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 20ab5b3..0a441cf 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -1208,6 +1208,12 @@ static int smi_num; /* Used to sequence the SMIs */
>   #define DEFAULT_REGSPACING	1
>   #define DEFAULT_REGSIZE		1
>   
> +#ifdef CONFIG_ACPI
> +static int           si_tryacpi = 1;
> +#endif
> +#ifdef CONFIG_DMI
> +static int           si_trydmi = 1;
> +#endif
>   static bool          si_trydefaults = 1;
>   static char          *si_type[SI_MAX_PARMS];
>   #define MAX_SI_TYPE_STR 30
> @@ -1238,6 +1244,16 @@ MODULE_PARM_DESC(hotmod, "Add and remove interfaces.  See"
>   		 " Documentation/IPMI.txt in the kernel sources for the"
>   		 " gory details.");
>   
> +#ifdef CONFIG_ACPI
> +module_param_named(tryacpi, si_tryacpi, bool, 0);
> +MODULE_PARM_DESC(tryacpi, "Setting this to zero will disable the"
> +		 " default scan of the interfaces identified via ACPI");
> +#endif
> +#ifdef CONFIG_DMI
> +module_param_named(trydmi, si_trydmi, bool, 0);
> +MODULE_PARM_DESC(trydmi, "Setting this to zero will disable the"
> +		 " default scan of the interfaces identified via DMI");
> +#endif
>   module_param_named(trydefaults, si_trydefaults, bool, 0);
>   MODULE_PARM_DESC(trydefaults, "Setting this to 'false' will disable the"
>   		 " default scan of the KCS and SMIC interface at the standard"
> @@ -3408,16 +3424,20 @@ static int init_ipmi_si(void)
>   #endif
>   
>   #ifdef CONFIG_ACPI
> -	pnp_register_driver(&ipmi_pnp_driver);
> -	pnp_registered = 1;
> +	if (si_tryacpi) {
> +		pnp_register_driver(&ipmi_pnp_driver);
> +		pnp_registered = 1;
> +	}
>   #endif
>   
>   #ifdef CONFIG_DMI
> -	dmi_find_bmc();
> +	if (si_trydmi)
> +		dmi_find_bmc();
>   #endif
>   
>   #ifdef CONFIG_ACPI
> -	spmi_find_bmc();
> +	if (si_tryacpi)
> +		spmi_find_bmc();
>   #endif
>   
>   	/* We prefer devices with interrupts, but in the case of a machine


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab2LNRJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:09:22 -0500
Received: from mailhub4.stratus.com ([134.111.1.17]:53995 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab2LNRJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:09:21 -0500
X-Greylist: delayed 2616 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2012 12:09:20 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH] ipmi: add new kernel options to prevent automatic ipmi init
Date: Fri, 14 Dec 2012 11:25:19 -0500
Message-ID: <AC1B83CE65082B4DBDDB681ED2F6B2EF023202AB@EXHQ.corp.stratus.com>
In-Reply-To: <AC1B83CE65082B4DBDDB681ED2F6B2EF023202A7@EXHQ.corp.stratus.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: [PATCH] ipmi: add new kernel options to prevent automatic ipmi init
thread-index: Ac3ZcQPWL45hUqr/QpuvzjYgvBGYwwAlEsYQAAQnJMA=
References: <50CA31BB.2030507@acm.org> <50CA38CE.2040005@redhat.com> <AC1B83CE65082B4DBDDB681ED2F6B2EF023202A7@EXHQ.corp.stratus.com>
From: "Evans, Robert" <Robert.Evans@stratus.com>
To: "Corey Minyard" <minyard@acm.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>,
        <openipmi-developer@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Cc: "Evans, Robert" <Robert.Evans@stratus.com>,
        "Tony Camuso" <tcamuso@redhat.com>, <jparadis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey,

Thanks for the thoughtful reply.  Below I respond in detail to
these three points.

1) Why building a variant kernel with ipmi_si as a module is not
   feasible.

2) User mode access to IPMI on Stratus systems (e.g. ipmitool).

3) ipmi_si hot removal seems to not work as needed.

Stratus might be able to use the hot removal option instead of the
proposed patch if hot removal can remove all interfaces from usage
by ipmi_si.  Our testing of this option was not successful as
shown below.

 - - -

1) Why building a variant kernel with ipmi_si as a module is not
feasible:

Stratus sells servers based upon Red Hat Enterprise Linux (RHEL).
In the next release of RHEL, ipmi_si will be built into the kernel
so that access to ACPI opregion is available early in kernel
startup.  Stratus systems run the Red Hat kernel so that the
system is certified and supported by Red Hat.  For this reason
using a custom kernel configured to build ipmi_si as a module is
not an option.



2) User mode access to IPMI on Stratus systems:

Although Stratus provides a replacement for ipmi_si, we depend
on ipmi_msghandler and ipmi_devintf.  The device /dev/ipmi0 is
present and this device is utilized by the user-mode system
management software Stratus supplies.

Therefore other programs like ipmitool can send IPMI commands and
get responses on Stratus systems.




3) Hot removal of the KCS interfaces discovered by ipmi_si seems
to not do enough... One KCS cannot successfully be removed:

Based upon your suggestion, we tried to use hot removal.  With
RHEL 6.4 Beta (kernel-2.6.32-343.el6), Stratus attempted to hot
remove the IPMI interfaces.  This was booted with 
 "ipmi_si.trydefaults=0"
although we expect that kernel option to have no effect since a
BMC is found before the defaults would be tried.

This is logged when ipmi_si initializes indicating that both BMCs
were discovered:

ipmi message handler version 39.2
IPMI System Interface driver.
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2,
slave address 0x0, irq 0
ipmi: Found new BMC (man_id: 0x000077,  prod_id: 0x05c6, dev_id: 0x41)
IPMI kcs interface initialized
ipmi_si: Adding SMBIOS-specified kcs state machine
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xda2,
slave address 0x20, irq 0
ipmi: interfacing existing BMC (man_id: 0x000077, prod_id: 0x05c6,
dev_id: 0x41)
IPMI kcs interface initialized

Although there are two different BMCs, because it says
 "interfacing existing BMC" 
it appears that ipmi_si assumes they are the same BMC.

Also, I notice the slave address for the first KCS (port CA2) seems
wrong.  Maybe these findings are relevant to what happens next.

After ipmi_si has been initialized, a script runs to load ftmod, the
module that contains the Stratus IPMI driver.  This code was added to
hot remove the interfaces discovered by ipmi_si before loading ftmod:

for i in $(cd /proc/ipmi; ls)
do
    dev="IPMI${i}"
    params="$(cat /proc/ipmi/${i}/params)"
    msg="Considering removal of dev: ${dev} ${params}"
    logger -p kern.info -t `basename ${0}` "${msg}"
    echo "${msg}" > /dev/console
    [ -n "${params}" ] &&
	echo "remove,`cat /proc/ipmi/${i}/params`" \
		> /sys/module/ipmi_si/parameters/hotmod
done

In the console log we can see this script run prior to loading the
Stratus ftmod.ko and we also see that ftmod exposes a BMC:

Considering removal of dev: IPMI0
kcs,i/o,0xca2,rsp=1,rsi=1,rsh=0,irq=0,ipmb=0
Considering removal of dev: IPMI1
kcs,i/o,0xda2,rsp=1,rsi=1,rsh=0,irq=0,ipmb=32
ftmod: module license 'LGPL' taints kernel.
Disabling lock debugging due to kernel taint
FTMOD version lsb-ft-ftmod-9.0.4-209
ftmod: GLOBAL_SIZE=4194304
ftmod: global_cc_memory 0xffff880037400000
ipmi: Found new BMC (man_id: 0x000000,  prod_id: 0x0000, dev_id: 0x00)
ipmi device interface

The KCS at port DA2 is removed from use by ipmi_si.  However, the
other KCS is still in use by ipmi_si.  Like ipmi_si, the Stratus IPMI
driver uses ipmi_msghandler.  With two interfaces sending commands to
the same BMC, responses seem to be misdirected.  The Stratus management
software cannot successfully commnicate with that BMC and many errors
like this are logged by ipmi_msghandler:

IPMI message handler: BMC returned incorrect response, expected netfn 3d
cmd 75, got netfn 3d cmd 71
IPMI message handler: BMC returned incorrect response, expected netfn 3d
cmd 71, got netfn 19 cmd 20
IPMI message handler: BMC returned incorrect response, expected netfn b
cmd 40, got netfn 3d cmd 71
IPMI message handler: BMC returned incorrect response, expected netfn 3d
cmd 71, got netfn d cmd 2

I tried a few variations on the remove string, but never got ipmi_si
to stop using the KCS at port CA2.

Robert N. Evans
Software Engineer
S T R A T U S   T E C H N O L O G I E S


-------- Original Message --------
Subject: Re: [PATCH] ipmi: add new kernel options to prevent automatic
ipmi init
Date: Thu, 13 Dec 2012 13:51:23 -0600
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
To: Tony Camuso <tcamuso@redhat.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
rob.herring@calxeda.com, openipmi-developer@lists.sourceforge.net,
grant.likely@secretlab.ca, Robert Evans <Robert.Evans@stratus.com>,
Jim Paradis <jparadis@redhat.com>

Well, the built-in driver works on systems that have more than one
interface
and more than one BMC, and multiple IPMBs (and all of the other channel
types for that matter, and the driver handles all the multiplexing and
nasty
addressing).  There is, in fact, no arbitrary limit, and IBM tested
this fairly extensively with some of their systems.  I'm not sure why
you
would need a custom driver, and if there are some custom things that
need
to be done for your servers, I'd be happy to add that.  I've worked with
a
number of other vendors to get changes like this in.  And then ipmitool,
freeipmi, openipmi, etc. will work with the device.

I don't have a big problem with this patch.  I wonder why you would want
to compile the standard driver into your kernel if you expected to load
a
module with a custom driver later, though.  None of the distros I know
of
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
> The configuration change building ipmi_si into the kernel precludes
the
> use of a custom driver that can utilize more than one KCS interface,
> multiple IPMBs, and more than one BMC. This capability is important
for
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
> initializing when these options are set to 0 on the kernel command
line.
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
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c
b/drivers/char/ipmi/ipmi_si_intf.c
> index 20ab5b3..0a441cf 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -1208,6 +1208,12 @@ static int smi_num; /* Used to sequence the
SMIs */
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
> @@ -1238,6 +1244,16 @@ MODULE_PARM_DESC(hotmod, "Add and remove
interfaces.  See"
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
>   MODULE_PARM_DESC(trydefaults, "Setting this to 'false' will disable
the"
>   		 " default scan of the KCS and SMIC interface at the
standard"
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
>   	/* We prefer devices with interrupts, but in the case of a
machine


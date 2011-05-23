Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1EWSuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:50:54 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:6055 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab1EWSuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:50:44 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver
 out of staging
Thread-Topic: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver
 out of staging
Thread-Index: AQHMGW2o73xBkI9IxkSJtOUc7B8Bm5SbLWoA//+MZnA=
Date: Mon, 23 May 2011 18:50:42 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481FC8D4@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1306170743-17797-1-git-send-email-kys@microsoft.com>
 <alpine.LFD.2.02.1105232010470.3078@ionos>
In-Reply-To: <alpine.LFD.2.02.1105232010470.3078@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Monday, May 23, 2011 2:16 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; johnstul@us.ibm.com; hch@infradead.org; Hank
> Janssen; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver out
> of staging
> 
> On Mon, 23 May 2011, K. Y. Srinivasan wrote:
> > +
> > +#include <linux/version.h>
> > +#include <linux/clocksource.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/dmi.h>
> > +#include <asm/hyperv.h>
> > +#include <asm/mshyperv.h>
> > +#include <asm/hypervisor.h>
> > +
> > +#define HV_CLOCK_SHIFT	22
> 
> Please do not use hard coded conversion factors. See below

I will fix this.
> 
> > +static cycle_t read_hv_clock(struct clocksource *arg)
> > +{
> > +	cycle_t current_tick;
> > +	/*
> > +	 * Read the partition counter to get the current tick count. This count
> > +	 * is set to 0 when the partition is created and is incremented in
> > +	 * 100 nanosecond units.
> > +	 */
> > +	rdmsrl(HV_X64_MSR_TIME_REF_COUNT, current_tick);
> > +	return current_tick;
> > +}
> > +
> > +static struct clocksource hyperv_cs = {
> > +	.name           = "hyperv_clocksource",
> > +	.rating         = 400, /* use this when running on Hyperv*/
> > +	.read           = read_hv_clock,
> > +	.mask           = CLOCKSOURCE_MASK(64),
> > +	/*
> > +	 * The time ref counter in HyperV is in 100ns units.
> > +	 * The definition of mult is:
> > +	 * mult/2^shift = ns/cyc = 100
> > +	 * mult = (100 << shift)
> > +	 */
> > +	.mult           = (100 << HV_CLOCK_SHIFT),
> > +	.shift          = HV_CLOCK_SHIFT,
> > +};
> > +
> > +static const struct dmi_system_id __initconst
> > +hv_timesource_dmi_table[] __maybe_unused  = {
> > +	{
> > +		.ident = "Hyper-V",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft
> Corporation"),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
> > +			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
> > +		},
> > +	},
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(dmi, hv_timesource_dmi_table);
> > +
> > +static const struct pci_device_id __initconst
> > +hv_timesource_pci_table[] __maybe_unused = {
> > +	{ PCI_DEVICE(0x1414, 0x5353) }, /* VGA compatible controller */
> > +	{ 0 }
> > +};
> > +MODULE_DEVICE_TABLE(pci, hv_timesource_pci_table);
> 
> This pci_id table is unused. What's the purpose ?

Both the PCI and DMI tables were defined to ensure autoloading
> 
> > +
> > +static int __init init_hv_clocksource(void)
> > +{
> > +	if ((x86_hyper != &x86_hyper_ms_hyperv) ||
> > +		!(ms_hyperv.features &
> HV_X64_MSR_TIME_REF_COUNT_AVAILABLE))
> > +		return -ENODEV;
> 
> Isn't this a sufficient indicator ?

This ensures we are running on Hyper-V and for that this check is sufficient.

> 
> > +	if (!dmi_check_system(hv_timesource_dmi_table))
> > +		return -ENODEV;
> 
> Do we really need this additional check? I'd say if x86_hyper ==
> x86_hyper_ms_hyperv then failing the DMI check would be more than
> silly.

Both the PCI and DMI tables were introduced by Greg to support autoloading.
I will see if I can clean this up.

> 
> > +	pr_info("Registering HyperV clock source\n");
> > +	return clocksource_register(&hyperv_cs);
> 
> Please use clocksource_register_hz/khz and get rid of the hard coded
> constants.

Will do.
> 
> > +}
> > +
> > +module_init(init_hv_clocksource);
> > +MODULE_DESCRIPTION("HyperV based clocksource");
> > +MODULE_AUTHOR("K. Y. Srinivasan <ksrinivasan@novell.com>");
> > +MODULE_LICENSE("GPL");
> 
> Why do we need to build this as a module?

No particular reason. This is the way, I had it in the staging directory.
Do you want me to build this as part of the kernel? I would then not have
to worry about auto-loading issues.

Regards,

K. Y 



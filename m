Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab1EWSQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:16:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:44471 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab1EWSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:16:03 -0400
Date: Mon, 23 May 2011 20:15:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        johnstul@us.ibm.com, hch@infradead.org,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver
 out of staging
In-Reply-To: <1306170743-17797-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LFD.2.02.1105232010470.3078@ionos>
References: <1306170743-17797-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, K. Y. Srinivasan wrote:
> +
> +#include <linux/version.h>
> +#include <linux/clocksource.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/dmi.h>
> +#include <asm/hyperv.h>
> +#include <asm/mshyperv.h>
> +#include <asm/hypervisor.h>
> +
> +#define HV_CLOCK_SHIFT	22

Please do not use hard coded conversion factors. See below

> +static cycle_t read_hv_clock(struct clocksource *arg)
> +{
> +	cycle_t current_tick;
> +	/*
> +	 * Read the partition counter to get the current tick count. This count
> +	 * is set to 0 when the partition is created and is incremented in
> +	 * 100 nanosecond units.
> +	 */
> +	rdmsrl(HV_X64_MSR_TIME_REF_COUNT, current_tick);
> +	return current_tick;
> +}
> +
> +static struct clocksource hyperv_cs = {
> +	.name           = "hyperv_clocksource",
> +	.rating         = 400, /* use this when running on Hyperv*/
> +	.read           = read_hv_clock,
> +	.mask           = CLOCKSOURCE_MASK(64),
> +	/*
> +	 * The time ref counter in HyperV is in 100ns units.
> +	 * The definition of mult is:
> +	 * mult/2^shift = ns/cyc = 100
> +	 * mult = (100 << shift)
> +	 */
> +	.mult           = (100 << HV_CLOCK_SHIFT),
> +	.shift          = HV_CLOCK_SHIFT,
> +};
> +
> +static const struct dmi_system_id __initconst
> +hv_timesource_dmi_table[] __maybe_unused  = {
> +	{
> +		.ident = "Hyper-V",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
> +			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
> +		},
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(dmi, hv_timesource_dmi_table);
> +
> +static const struct pci_device_id __initconst
> +hv_timesource_pci_table[] __maybe_unused = {
> +	{ PCI_DEVICE(0x1414, 0x5353) }, /* VGA compatible controller */
> +	{ 0 }
> +};
> +MODULE_DEVICE_TABLE(pci, hv_timesource_pci_table);

This pci_id table is unused. What's the purpose ?

> +
> +static int __init init_hv_clocksource(void)
> +{
> +	if ((x86_hyper != &x86_hyper_ms_hyperv) ||
> +		!(ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE))
> +		return -ENODEV;

Isn't this a sufficient indicator ?

> +	if (!dmi_check_system(hv_timesource_dmi_table))
> +		return -ENODEV;

Do we really need this additional check? I'd say if x86_hyper ==
x86_hyper_ms_hyperv then failing the DMI check would be more than
silly.

> +	pr_info("Registering HyperV clock source\n");
> +	return clocksource_register(&hyperv_cs);

Please use clocksource_register_hz/khz and get rid of the hard coded
constants.

> +}
> +
> +module_init(init_hv_clocksource);
> +MODULE_DESCRIPTION("HyperV based clocksource");
> +MODULE_AUTHOR("K. Y. Srinivasan <ksrinivasan@novell.com>");
> +MODULE_LICENSE("GPL");

Why do we need to build this as a module?

Thanks,

	tglx

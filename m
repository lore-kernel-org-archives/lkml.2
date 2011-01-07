Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1AGRDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:03:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab1AGRDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:03:19 -0500
Date: Fri, 7 Jan 2011 18:02:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com,
        Andreas Herrmann3 <Andreas.Herrmann3@amd.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Robert Richter <robert.richter@amd.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, tip] x86: use PCI method for enabling AMD extended
 config space before MSR method
Message-ID: <20110107170259.GA9552@elte.hu>
References: <4D274F58020000780002B11D@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D274F58020000780002B11D@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> --- tip/arch/x86/pci/amd_bus.c
> +++ tip-x86-amd-ecs/arch/x86/pci/amd_bus.c
> @@ -4,6 +4,7 @@
>  #include <linux/cpu.h>
>  #include <linux/range.h>
>  
> +#include <asm/amd_nb.h>
>  #include <asm/pci_x86.h>
>  
>  #include <asm/pci-direct.h>
> @@ -386,6 +387,35 @@ static int __init pci_io_ecs_init(void)
>          if (boot_cpu_data.x86 < 0x10)
>  		return 0;
>  
> +#ifdef CONFIG_AMD_NB
> +	/* Try the PCI method first. */
> +	if (early_pci_allowed()) {
> +		unsigned int i, n;
> +
> +		for (n = i = 0; !n && amd_nb_bus_dev_ranges[i].dev_limit; ++i) {
> +			u8 bus = amd_nb_bus_dev_ranges[i].bus;
> +			u8 slot = amd_nb_bus_dev_ranges[i].dev_base;
> +			u8 limit = amd_nb_bus_dev_ranges[i].dev_limit;
> +
> +			for (; slot < limit; ++slot) {
> +				u32 val = read_pci_config(bus, slot, 3, 0);
> +
> +				if (!early_is_amd_nb(val))
> +					continue;
> +
> +				val = read_pci_config(bus, slot, 3, 0x8c);
> +				if (!(val & (ENABLE_CF8_EXT_CFG >> 32))) {
> +					val |= ENABLE_CF8_EXT_CFG >> 32;
> +					write_pci_config(bus, slot, 3, 0x8c,
> +							 val);
> +				}
> +				++n;
> +			}
> +		}
> +		pr_info("Extended Config Space enabled on %u nodes\n", n);
> +	}
> +#endif

Please, instead of plopping such a big #ifdef-ed block of code into an existing 
function create a new helper function instead. That will make it less ugly and more 
readable.

Thanks,

	Ingo

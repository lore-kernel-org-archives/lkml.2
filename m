Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1AFRUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:20:21 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:25854
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753590Ab1AFRUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:20:18 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bh8275dhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEM2TE-02-0LB-02
X-M-MSG: 
Date: Thu, 6 Jan 2011 18:20:04 +0100
From: Robert Richter <robert.richter@amd.com>
To: Jan Beulich <JBeulich@novell.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use PCI method for enabling AMD extended config
	 space before MSR method
Message-ID: <20110106172004.GM4739@erda.amd.com>
References: <4D26028F020000780002AC8A@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D26028F020000780002AC8A@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.01.11 11:57:35, Jan Beulich wrote:
> While both methods should work equivalently well for the native case,
> the Xen Dom0 case can't reliably work with the MSR one, since there's
> no guarantee that the virtual CPUs it has available fully cover all
> necessary physical ones.
> 
> As per the suggestion of Robert Richter the patch only adds the PCI
> method, but leaves the MSR one as a fallback to cover new systems the
> PCI IDs of which may not have got added to the code base yet.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: Joerg Roedel <Joerg.Roedel@amd.com>
> Cc: Andreas Herrmann <Andreas.Herrmann3@amd.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> 
> ---
>  arch/x86/include/asm/amd_nb.h |    7 ++++++
>  arch/x86/kernel/amd_nb.c      |    7 ++++++
>  arch/x86/kernel/aperture_64.c |   44 +++++++++++++++---------------------------
>  arch/x86/pci/amd_bus.c        |   30 ++++++++++++++++++++++++++++
>  4 files changed, 60 insertions(+), 28 deletions(-)

> --- 2.6.37/arch/x86/pci/amd_bus.c
> +++ 2.6.37-x86-amd-ecs/arch/x86/pci/amd_bus.c
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
> +		for (n = i = 0; !n && amd_bus_dev_ranges[i].dev_limit; ++i) {
> +			u8 bus = amd_bus_dev_ranges[i].bus;
> +			u8 slot = amd_bus_dev_ranges[i].dev_base;
> +			u8 limit = amd_bus_dev_ranges[i].dev_limit;
> +
> +			for (; slot < limit; ++slot) {
> +				u32 val = read_pci_config(bus, slot, 3, 0);
> +
> +				if (!early_is_k8_nb(val))
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

Isn't i the number of nodes?

Otherwise the patch looks good.

-Robert

Acked-by: Robert Richter <robert.richter@amd.com>

> +	}
> +#endif
> +
>  	register_cpu_notifier(&amd_cpu_notifier);
>  	for_each_online_cpu(cpu)
>  		amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
> 
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0DONCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:02:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0DONCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:02:09 -0400
Subject: Re: [PATCH 10/12] perf, x86: setup NMI handler for IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271190201-25705-11-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <1271190201-25705-11-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 14:57:35 +0200
Message-ID: <1271336255.1674.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 22:23 +0200, Robert Richter wrote:
> This implements the perf nmi handler for ibs interrupts. The code was
> copied from oprofile and should be merged somewhen.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c     |   10 ++++
>  arch/x86/kernel/cpu/perf_event_amd.c |   87 ++++++++++++++++++++++++++++++++++
>  2 files changed, 97 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index a42d033..8f9674f 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c

> +static int init_ibs_nmi(void)
> +{
> +#define IBSCTL_LVTOFFSETVAL		(1 << 8)
> +#define IBSCTL				0x1cc
> +	struct pci_dev *cpu_cfg;
> +	int nodes;
> +	u32 value = 0;
> +
> +	/* per CPU setup */
> +	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1);
> +
> +	nodes = 0;
> +	cpu_cfg = NULL;
> +	do {
> +		cpu_cfg = pci_get_device(PCI_VENDOR_ID_AMD,
> +					 PCI_DEVICE_ID_AMD_10H_NB_MISC,
> +					 cpu_cfg);
> +		if (!cpu_cfg)
> +			break;
> +		++nodes;
> +		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
> +				       | IBSCTL_LVTOFFSETVAL);
> +		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
> +		if (value != (ibs_eilvt_off | IBSCTL_LVTOFFSETVAL)) {
> +			pci_dev_put(cpu_cfg);
> +			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
> +				"IBSCTL = 0x%08x", value);
> +			return 1;
> +		}
> +	} while (1);
> +
> +	if (!nodes) {
> +		printk(KERN_DEBUG "No CPU node configured for IBS");
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/* uninitialize the APIC for the IBS interrupts if needed */
> +static void clear_ibs_nmi(void)
> +{
> +	on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
> +}


That on_each_cpu() looks wonky, why isn't this in the hotplug hooks?


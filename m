Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0H3BrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:47:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:56586 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab0H3BrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:47:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,289,1280732400"; 
   d="scan'208";a="601684950"
Message-ID: <4C7B0DA6.2070204@intel.com>
Date: Mon, 30 Aug 2010 09:47:18 +0800
From: Weidong Han <weidong.han@intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [patch 1/3] x86, intr-remap: set redirection hint in the IRTE
References: <20100827181049.013051492@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <20100827181049.013051492@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> Currently the redirection hint in the interrupt-remapping table entry
> is set to 0, which means the remapped interrupt is directed to the
> processors listed in the destination. So in logical flat mode
> in the presence of intr-remapping, this results in a single
> interrupt multi-casted to multiple cpu's as specified by the destination
> bit mask. But what we really want is to send that interrupt to one of the cpus
> based on the lowest priority delivery mode.
>
> Set the redirection hint in the IRTE to '1' to indicate that we want
> the remapped interrupt to be directed to only one of the processors
> listed in the destination.
>
> This fixes the issue of same interrupt getting delivered to multiple cpu's
> in the logical flat mode in the presence of interrupt-remapping. While
> there is no functional issue observed with this behavior, this will
> impact performance of such configurations (<=8 cpu's using logical flat
> mode in the presence of interrupt-remapping)
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Weidong Han <weidong.han@intel.com>
> Cc: <stable@kernel.org> # [v2.6.32+]
> ---
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index f1efeba..90f8a75 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1392,6 +1392,7 @@ int setup_ioapic_entry(int apic_id, int irq,
>  		irte.dlvry_mode = apic->irq_delivery_mode;
>  		irte.vector = vector;
>  		irte.dest_id = IRTE_DEST(destination);
> +		irte.redir_hint = 1;
>  
>  		/* Set source-id of interrupt request */
>  		set_ioapic_sid(&irte, apic_id);
> @@ -3343,6 +3344,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
>  		irte.dlvry_mode = apic->irq_delivery_mode;
>  		irte.vector = cfg->vector;
>  		irte.dest_id = IRTE_DEST(dest);
> +		irte.redir_hint = 1;
>  
>  		/* Set source-id of interrupt request */
>  		if (pdev)
>
>
>   
hi Suresh,

I think it needs to set redir_hint only for lowest priority delivery 
mode. Why set it for all delivery modes?

Regards,
Weidong


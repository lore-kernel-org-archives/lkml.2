Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1EEItH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:49:07 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:28593 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1EEItF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:49:05 -0400
X-IronPort-AV: E=Sophos;i="4.64,318,1301875200"; 
   d="scan'208";a="5609753"
Subject: Re: [PATCH] x86: skip migrating percpu irq in fixup_irqs
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F327@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F327@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 5 May 2011 09:49:03 +0100
Message-ID: <1304585343.26692.71.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 09:15 +0100, Tian, Kevin wrote:
> x86: skip migrating percpu irq in fixup_irqs
> 
> IRQF_PER_CPU is used by Xen for a set of virtual interrupts binding to
> a specific vcpu, but it's not recognized in fixup_irqs which simply
> atempts to migrate it to other vcpus. In most cases this just works,
> because Xen event channel chip silently fails the set_affinity ops for
> irqs marked as IRQF_PER_CPU. But there's a special category (like used
> for pv spinlock) also adds a IRQ_DISABLED flag, used as polled only event
> channels which don't expect any instance injected. However fixup_irqs
> absolutely masks/unmasks irqs which makes such special type irq injected
> unexpectely while there's no handler for it.
> 
> This error is triggered on some box when doing reboot. The fix is to
> recognize IRQF_PER_CPU flag early before the affinity change, which
> actually matches the rationale of IRQF_PER_CPU.

Skipping affinity fixup for PER_CPU IRQs seems logical enough (so I
suspect this patch is good in its own right) but if the real issue you
are fixing is that IRQ_DISABLED IQRs are getting unmasked should that
issue be addressed directly rather than relying on it being a
side-effect of PER_CPU-ness?

Ian.

> Signed-off-by: Fengzhe Zhang <fengzhe.zhang@intel.com>
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Ian Campbell <Ian.Campbell@citrix.com>
> CC: Jan Beulich <JBeulich@novell.com>
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 1cb0b9f..544efe2 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -249,7 +249,7 @@ void fixup_irqs(void)
> 
>                 data = irq_desc_get_irq_data(desc);
>                 affinity = data->affinity;
> -               if (!irq_has_action(irq) ||
> +               if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
>                     cpumask_subset(affinity, cpu_online_mask)) {
>                         raw_spin_unlock(&desc->lock);
>                         continue;



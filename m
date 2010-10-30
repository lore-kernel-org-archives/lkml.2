Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab0J3IW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 04:22:28 -0400
Received: from www.tglx.de ([62.245.132.106]:51971 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab0J3IW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 04:22:27 -0400
Date: Sat, 30 Oct 2010 10:22:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russ Anderson <rja@sgi.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, uv: Fix uv with destroy_irq()
In-Reply-To: <4CCBD511.40607@kernel.org>
Message-ID: <alpine.LFD.2.00.1010301021150.2692@localhost6.localdomain6>
References: <20101029222227.GJ32456@sgi.com> <1288399062.2690.169.camel@sbsiddha-MOBL3.sc.intel.com> <20101030015050.GA9557@sgi.com> <AANLkTi=Ct+NXV_pvPNbn+j-j=hHXmUxaqa=XEaga=+Pq@mail.gmail.com> <20101030034804.GC9557@sgi.com> <4CCBD511.40607@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010, Yinghai Lu wrote:

> 
> Russ found that:
> 
> | There is a regression that is causing a NULL pointer dereference
> | in free_irte when shutting down xpc.  git bisect narrowed it down
> | to git commit d585d060b42bd36f6f0b23ff327d3b91f80c7139, which
> | changed free_irte().  Reverse applying the patch fixes the problem.
> 
> and he bisected to
> 
> | commit d585d060b42bd36f6f0b23ff327d3b91f80c7139
> | Author: Thomas Gleixner <tglx@linutronix.de>
> |Date:   Sun Oct 10 12:34:27 2010 +0200
> |
> |   intr_remap: Simplify the code further
> |
> |   Having irq_2_iommu in struct irq_cfg allows further simplifications.
> 
> We need to use irq_mapped() for every irq instead of intr_remapping_enabled
> overall
> 
> Reported-by: Russ Anderson <rja@sgi.com>
> Bisected-by: Russ Anderson <rja@sgi.com>
> Tested-by: Russ Anderson <rja@sgi.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/apic/io_apic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -3109,7 +3109,7 @@ void destroy_irq(unsigned int irq)
>  
>  	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
>  
> -	if (intr_remapping_enabled)
> +	if (irq_remapped(get_irq_chip_data(irq)))

No need for get_irq_chip_data(). We have cfg already. Will fix.

Thanks,

	tglx

>  		free_irte(irq);
>  	raw_spin_lock_irqsave(&vector_lock, flags);
>  	__clear_irq_vector(irq, cfg);
> 

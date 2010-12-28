Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0L1Rnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:43:45 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:36399 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0L1Rno (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 28 Dec 2010 12:43:44 -0500
Date: Tue, 28 Dec 2010 12:42:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, sparseirq: let nr_irqs equal to NR_IRQS
Message-ID: <20101228174204.GB13488@dumpdata.com>
References: <4CEB877D.9060709@kernel.org>
 <4CF75626.6000306@kernel.org>
 <alpine.LFD.2.00.1012021019060.2653@localhost6.localdomain6>
 <4CF7FA58.8070803@kernel.org>
 <alpine.LFD.2.00.1012022112400.2653@localhost6.localdomain6>
 <4CF7FF66.3010802@kernel.org>
 <alpine.LFD.2.00.1012022125401.2653@localhost6.localdomain6>
 <20101222125711.GI10809@elte.hu>
 <4D193533.6060103@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D193533.6060103@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 04:54:11PM -0800, Yinghai Lu wrote:
> 
> 
> For x86_64 system:
> when we have 128 cpus with 5 ioapics, will have nr_irqs = 3064
> 	120 + 8 * 128 + 120 * 16
> systems could take 20 pcie,  when intel 10g are used with
> sriov and ixgbevf, every vf will need 3 irqs, and one device
> have 64 vf. so will need 20 * 3 * 64 = 3840.
> some 6 ports Intel 10gb may need more.
> 
> Just remove that function for x86, and let nr_irqs to NR_IRQS
> because We already have radix-tree and bit_map for searching desc for irq.

Won't that make the arch_probe_nr_irqs be NR_IRQS_LEGACY?

I am looking at Linus's today tree, or is this patch based on some other tree?

> 
> Notes: long before same vresion cause one of Ingo's setup udev hang...
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/apic/io_apic.c |   22 ----------------------
>  1 file changed, 22 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -3637,28 +3637,6 @@ int get_nr_irqs_gsi(void)
>  	return nr_irqs_gsi;
>  }
>  
> -#ifdef CONFIG_SPARSE_IRQ
> -int __init arch_probe_nr_irqs(void)
> -{
> -	int nr;
> -
> -	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
> -		nr_irqs = NR_VECTORS * nr_cpu_ids;
> -
> -	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
> -#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
> -	/*
> -	 * for MSI and HT dyn irq
> -	 */
> -	nr += nr_irqs_gsi * 16;
> -#endif
> -	if (nr < nr_irqs)
> -		nr_irqs = nr;
> -
> -	return NR_IRQS_LEGACY;
> -}
> -#endif
> -
>  static int __io_apic_set_pci_routing(struct device *dev, int irq,
>  				struct io_apic_irq_attr *irq_attr)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

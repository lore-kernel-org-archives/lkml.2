Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284Ab2DKNxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 09:53:47 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:39717 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760176Ab2DKNxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 09:53:46 -0400
Date: Wed, 11 Apr 2012 09:53:04 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [RFC PATCH] xen: get correct nr_irqs_gsi value from hypervisor
Message-ID: <20120411135304.GC21703@andromeda.dapyr.net>
References: <1334069838.5865.130.camel@hp6530s>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334069838.5865.130.camel@hp6530s>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 10:57:18PM +0800, Lin Ming wrote:
> nr_irqs_gsi is set in probe_nr_irqs_gsi()
> 	nr_irqs_gsi = gsi_top + NR_IRQS_LEGACY;
> 
> gsi_top is set in mp_register_ioapic()
> 	gsi_top = gsi_cfg->gsi_end + 1;
> 
> mp_register_ioapic() calls io_apic_read, which don't have a Xen specific
> version. Actually, io_apic_read() always return -1 on Xen Dom0 kernel.
> 
> So currently, nr_irqs_gsi is always wrong on Xen Dom0 kernel.
> 
> This patch gets the correct nr_irqs_gsi value from Xen hypervisor with a
> hypercall.
> 
> Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
> --
>  arch/x86/include/asm/io_apic.h  |    2 ++
>  arch/x86/kernel/apic/io_apic.c  |    2 +-
>  arch/x86/xen/setup.c            |    9 +++++++++
>  include/xen/interface/physdev.h |    6 ++++++
>  4 files changed, 18 insertions(+), 1 deletions(-)
> 
> (I will send xen hypervisor patch in another mail)
> 
> Here comes the detail story.
> 
> Xen Dom0 kernel panics with 3.4-rc1. I took the panics picture at
> http://www.sendspace.com/file/12ob33
> 
> Bisected to below commit.

It is a bummer you went through all this trouble when I had
patches for this (and a workaround) since about three weeks ago.

The v3.4-rc2 should work fine for right now, with a work-around
against Suresh's patch.

Long-term, the two patches in my stable/for-ingo-3.4.v2 would
fix it, and if we use the existing IOAPIc hypercalls we can get
the exact count of GSI.


> 
> commit 73d63d038ee9f769f5e5b46792d227fe20e442c5
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Mon Mar 12 11:36:33 2012 -0700
> 
>     x86/ioapic: Add register level checks to detect bogus io-apic entries
> 
> But this commit itself has no problem.
> This commit just triggers the panic.
> 
> The panic happens at xen_irq_init(..)
> 
> pci_enable_device
> __pci_enable_device_flags
> do_pci_enable_device
> pcibios_enable_device
> acpi_pci_irq_enable
> acpi_register_gsi
> acpi_register_gsi_xen
> xen_register_gsi
> xen_register_pirq
> xen_bind_pirq_gsi_to_irq
> xen_allocate_irq_gsi:
>         irq = irq_alloc_desc_at(gsi, -1);
>         xen_irq_init(irq);
> 
> On my machine, when enable PCI root port, gsi 16 is passed into
> irq_alloc_desc_at, but it returns -17(-EEXIST) because irq 16 was
> already took by xen timer(see below). Then negative value -17 is passed
> into xen_irq_init --> irq_to_desc --> radix_tree_lookup, which causes
> the panic.
> 
> xen timer allocates the irq number "nr_irqs_gsi"
> nr_irqs_gsi is set in probe_nr_irqs_gsi()
> 	nr_irqs_gsi = gsi_top + NR_IRQS_LEGACY
> gsi_top is set in mp_register_ioapic()
> 	gsi_top = gsi_cfg->gsi_end + 1;
> 
> In 3.4-rc1 kernel:
> 
> mp_register_ioapic
>   bad_ioapic_register (added in 3.4-rc1)
>     <always return true(bad) on Xen Dom0 kernel>
> 
> So mp_register_ioapic exist and gsi_top was not set up. It is left as
> the initialized value(zero). So nr_irqs_gsi is 16(NR_IRQS_LEGACY).
> That's why Xen timer allocated irq 16.
> 
> 
> Actually, gsi_top was never setup correctly in mp_register_ioapic on Xen
> Dom0 kernel. Because mp_register_ioapic calls io_apic_read, which is not
> implemented with hypercall in Linux kernel. So io_apic_read() always
> return -1 on Xen Dom0 kernel.
> 
> For 3.3 kernel in Xen Dom0, the dmesg shows
> 
> IOAPIC[0]: apic_id 2, version 255, address 0xfec00000, GSI 0-255
> ......
> nr_irqs_gsi: 272
> 
> This is obviously wrong, "255" is actually -1(0xFFFF).
> 
> 
> diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> index 2c4943d..a8bf3b2 100644
> --- a/arch/x86/include/asm/io_apic.h
> +++ b/arch/x86/include/asm/io_apic.h
> @@ -115,6 +115,8 @@ struct IR_IO_APIC_route_entry {
>   */
>  extern int nr_ioapics;
>  
> +extern int nr_irqs_gsi;
> +
>  extern int mpc_ioapic_id(int ioapic);
>  extern unsigned int mpc_ioapic_addr(int ioapic);
>  extern struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic);
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index e88300d..8bff292 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -140,7 +140,7 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
>  int mp_irq_entries;
>  
>  /* GSI interrupts */
> -static int nr_irqs_gsi = NR_IRQS_LEGACY;
> +int nr_irqs_gsi = NR_IRQS_LEGACY;
>  
>  #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
>  int mp_bus_id_to_type[MAX_MP_BUSSES];
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 1ba8dff..9ce82bc 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -389,6 +389,9 @@ void __cpuinit xen_enable_syscall(void)
>  
>  void __init xen_arch_setup(void)
>  {
> +	struct physdev_nr_irqs_gsi irqs_gsi;
> +	int rc;
> +
>  	xen_panic_handler_init();
>  
>  	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_4gb_segments);
> @@ -424,4 +427,10 @@ void __init xen_arch_setup(void)
>  	disable_cpufreq();
>  	WARN_ON(set_pm_idle_to_default());
>  	fiddle_vdso();
> +
> +	rc = HYPERVISOR_physdev_op(PHYSDEVOP_nr_irqs_gsi, &irqs_gsi);
> +	if (rc)
> +		printk(KERN_ERR "Failed to init nr_irqs_gsi, err_code:%d\n", rc);
> +	else
> +		nr_irqs_gsi = irqs_gsi.nr_irqs_gsi;
>  }
> diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> index 9ce788d..180a0a3 100644
> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -258,6 +258,12 @@ struct physdev_pci_device {
>      uint8_t devfn;
>  };
>  
> +#define PHYSDEVOP_nr_irqs_gsi           29
> +struct physdev_nr_irqs_gsi {
> +    /* OUT */
> +    uint32_t nr_irqs_gsi;
> +};
> +
>  /*
>   * Notify that some PIRQ-bound event channels have been unmasked.
>   * ** This command is obsolete since interface version 0x00030202 and is **
> 
> 
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

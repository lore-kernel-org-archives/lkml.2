Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2IMRQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:16:39 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:32622 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab2IMRQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:16:37 -0400
X-IronPort-AV: E=Sophos;i="4.80,417,1344211200"; 
   d="scan'208";a="14527936"
Date: Thu, 13 Sep 2012 18:15:53 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 00/23] Introduce Xen support on ARM
In-Reply-To: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1209131809290.15568@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,
sorry for not CC'ing you on the entire patch series in the past, I'll do
it in the next iteration of the series (that TBH is nearly identical to
this one apart from being 3.6-rc5 based).

Are you happy with it? Given that the changes are entirely contained
within arch/arm/xen and arch/arm/include/asm/xen (apart from patch #21
that is a generic ARM fix), should this patch series go through you or
Arnd?

Thanks,

Stefano




On Thu, 16 Aug 2012, Stefano Stabellini wrote:
> Hi all,
> this patch series implements Xen support for ARMv7 with virtualization
> extensions.  It allows a Linux guest to boot as dom0 and
> as domU on Xen on ARM. PV console, disk and network frontends and
> backends are all working correctly.
> 
> It has been tested on a Versatile Express Cortex A15 emulator, using the
> latest Xen ARM developement branch
> (git://xenbits.xen.org/people/ianc/xen-unstable.git arm-for-4.3) plus
> the "ARM hypercall ABI: 64 bit ready" patch series
> (http://marc.info/?l=xen-devel&m=134426267205408), and a simple ad-hoc
> tool to build guest domains (marc.info/?l=xen-devel&m=134089788016546).
> 
> The patch marked with [HACK] shouldn't be applied and is part of the
> series only because it is needed to create domUs.
> 
> I am also attaching to this email the dts'es that I am currently using
> for dom0 and domU: vexpress-v2p-ca15-tc1.dts (that includes
> vexpress-v2m-rs1-rtsm.dtsi) is the dts used for dom0 and it is passed to
> Linux by Xen, while vexpress-virt.dts is the dts used for other domUs
> and it is appended in binary form to the guest kernel image. I am not
> sure where they are supposed to live yet, so I am just attaching them
> here so that people can actually try out this series if they want to.
> 
> Comments are very welcome!
> 
> 
> Changes in v3:
> - move patches that have been picked up by Konrad at the end of the
>   series;
> - improve comments;
> - add a doc to describe the Xen Device Tree format;
> - do not use xen_ulong_t for multicalls and apic_physbase;
> - add a patch at the end of the series to use the new __HVC macro;
> - add missing pvclock-abi.h include to ia64 header files;
> - do not use an anonymous union in struct xen_add_to_physmap.
> 
> 
> Changes in v2:
> - fix up many comments and commit messages;
> - remove the early_printk patches: rely on the emulated serial for now;
> - remove the xen_guest_init patch: without any PV early_printk, we don't
>   need any early call to xen_guest_init, we can rely on core_initcall
>   alone;
> - define an HYPERCALL macro for 5 arguments hypercall wrappers, even if
>   at the moment is unused;
> - use ldm instead of pop in the hypercall wrappers;
> - return -ENOSYS rather than -1 from the unimplemented grant_table
>   functions;
> - remove the pvclock ifdef in the Xen headers;
> - remove include linux/types.h from xen/interface/xen.h;
> - replace pr_info with pr_debug in xen_guest_init;
> - add a new patch to introduce xen_ulong_t and use it top replace all
>   the occurences of unsigned long in the public Xen interface;
> - explicitely size all the pointers to 64 bit on ARM, so that the
>   hypercall ABI is "64 bit ready";
> - clean up xenbus_init;
> - make pci.o depend on CONFIG_PCI and acpi.o depend on CONFIG_ACPI;
> - mark Xen guest support on ARM as EXPERIMENTAL;
> - introduce GRANT_TABLE_PHYSADDR;
> - remove unneeded initialization of boot_max_nr_grant_frames;
> - add a new patch to clear IRQ_NOAUTOEN and IRQ_NOREQUEST in events.c;
> - return -EINVAL from xen_remap_domain_mfn_range if
>   auto_translated_physmap;
> - retain binary compatibility in xen_add_to_physmap: use a union to
>   introduce foreign_domid.
> 
> 
> Ian Campbell (1):
>       [HACK] xen/arm: implement xen_remap_domain_mfn_range
> 
> Stefano Stabellini (24):
>       arm: initial Xen support
>       xen/arm: hypercalls
>       xen/arm: page.h definitions
>       xen/arm: sync_bitops
>       xen/arm: empty implementation of grant_table arch specific functions
>       docs: Xen ARM DT bindings
>       xen/arm: Xen detection and shared_info page mapping
>       xen/arm: Introduce xen_pfn_t for pfn and mfn types
>       xen/arm: Introduce xen_ulong_t for unsigned long
>       xen/arm: compile and run xenbus
>       xen: do not compile manage, balloon, pci, acpi and cpu_hotplug on ARM
>       xen/arm: introduce CONFIG_XEN on ARM
>       xen/arm: get privilege status
>       xen/arm: initialize grant_table on ARM
>       xen/arm: receive Xen events on ARM
>       xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
>       xen/arm: implement alloc/free_xenballooned_pages with alloc_pages/kfree
>       xen: allow privcmd for HVM guests
>       xen/arm: compile blkfront and blkback
>       xen/arm: compile netback
>       arm/v2m: initialize arch_timers even if v2m_timer is not present
>       xen/arm: use the __HVC macro
>       xen: missing includes
>       xen: update xen_add_to_physmap interface
> 
>  Documentation/devicetree/bindings/arm/xen.txt |   22 +++
>  arch/arm/Kconfig                              |   10 +
>  arch/arm/Makefile                             |    1 +
>  arch/arm/include/asm/hypervisor.h             |    6 +
>  arch/arm/include/asm/sync_bitops.h            |   27 +++
>  arch/arm/include/asm/xen/events.h             |   18 ++
>  arch/arm/include/asm/xen/hypercall.h          |   69 +++++++
>  arch/arm/include/asm/xen/hypervisor.h         |   19 ++
>  arch/arm/include/asm/xen/interface.h          |   73 ++++++++
>  arch/arm/include/asm/xen/page.h               |   82 ++++++++
>  arch/arm/mach-vexpress/v2m.c                  |   11 +-
>  arch/arm/xen/Makefile                         |    1 +
>  arch/arm/xen/enlighten.c                      |  245 +++++++++++++++++++++++++
>  arch/arm/xen/grant-table.c                    |   53 ++++++
>  arch/arm/xen/hypercall.S                      |  102 ++++++++++
>  arch/ia64/include/asm/xen/interface.h         |    8 +-
>  arch/x86/include/asm/xen/interface.h          |    8 +
>  arch/x86/xen/enlighten.c                      |    1 +
>  arch/x86/xen/irq.c                            |    1 +
>  arch/x86/xen/mmu.c                            |    3 +
>  arch/x86/xen/xen-ops.h                        |    1 -
>  drivers/block/xen-blkback/blkback.c           |    1 +
>  drivers/net/xen-netback/netback.c             |    1 +
>  drivers/net/xen-netfront.c                    |    1 +
>  drivers/tty/hvc/hvc_xen.c                     |    2 +
>  drivers/xen/Makefile                          |   11 +-
>  drivers/xen/events.c                          |   18 ++-
>  drivers/xen/grant-table.c                     |    1 +
>  drivers/xen/privcmd.c                         |   20 +-
>  drivers/xen/xenbus/xenbus_comms.c             |    2 +-
>  drivers/xen/xenbus/xenbus_probe.c             |   62 +++++--
>  drivers/xen/xenbus/xenbus_probe_frontend.c    |    1 +
>  drivers/xen/xenbus/xenbus_xs.c                |    1 +
>  drivers/xen/xenfs/super.c                     |    7 +
>  include/xen/events.h                          |    2 +
>  include/xen/interface/features.h              |    3 +
>  include/xen/interface/grant_table.h           |    4 +-
>  include/xen/interface/io/protocols.h          |    3 +
>  include/xen/interface/memory.h                |   32 ++-
>  include/xen/interface/physdev.h               |    2 +-
>  include/xen/interface/platform.h              |    4 +-
>  include/xen/interface/version.h               |    2 +-
>  include/xen/interface/xen.h                   |    7 +-
>  include/xen/privcmd.h                         |    3 +-
>  include/xen/xen.h                             |    2 +-
>  45 files changed, 885 insertions(+), 68 deletions(-)
> 
> 
> A branch based on 3.5-rc7 is available here (the __HVC patch is missing
> from this branch because it depends on "ARM: opcodes: Facilitate custom
> opcode injection" http://marc.info/?l=linux-arm-kernel&m=134442896128124):
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.5-rc7-arm-3
> 
> Cheers,
> 
> Stefano

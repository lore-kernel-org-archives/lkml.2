Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2INNcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:32:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16625 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab2INNcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:32:13 -0400
Date: Fri, 14 Sep 2012 09:21:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        linux@arm.linux.org.uk
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 00/24] Introduce Xen support on ARM (based on 3.6-rc5)
Message-ID: <20120914132108.GQ25249@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:12:59PM +0100, Stefano Stabellini wrote:
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
> The patch marked with [HACK] has been dropped from this series, however
> you can find it here:
> http://marc.info/?l=linux-kernel&m=134513277823527&w=2.
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

I already put in these

1)      xen/events: fix unmask_evtchn for PV on HVM guests
2)      xen: missing includes
3)      xen: update xen_add_to_physmap interface
4)      xen: Introduce xen_pfn_t for pfn and mfn types
5)      xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
6)      xen: allow privcmd for HVM guests

in my tree as they also impact/help the PVH domains which works for
x86 (Well, not all of them). They are in my stable/for-linus-3.7 git tree
(git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git)
and also in #linux-next.


If it would make reviewing easier, I would recommend you rebase
your tree on top of the stable/for-linus-3.7 and just post them
as it would make the number of patches smaller.

Or alternatively, if the ARM maintainer wishes - just give you
the OK and we can figure out how/who is going to do the git-fu.

> 
> 
> 
> Patch #21 "arm/v2m: initialize arch_timers even if v2m_timer is not
> present" touches generic ARM code and still needs to be acked/reviewed.
> 
> Arnd, Russell, what do you think about this series? If you are OK with
> it, to whom should I submit it?
> 
> 
> 
> Changes in v4:
> - rebase on 3.6-rc5;
> - devicetree: "xen,xen" should be last as it is less specific;
> - devicetree: use 2 address-cells and 2 size-cells in the reg property;
> - do not xs_reset_watches on dom0;
> - compile drivers/xen/pcpu.c only on x86;
> - use "+=" instead of ":=" for dom0- targets;
> - add a patch to update the MAINTAINERS file.
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
> Shortlog and diffstat:
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
>       xen: do not compile manage, balloon, pci, acpi, pcpu and cpu_hotplug on ARM
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
>       xen: missing includes
>       xen: update xen_add_to_physmap interface
>       MAINTAINERS: add myself as Xen ARM maintainer
> 
>  Documentation/devicetree/bindings/arm/xen.txt |   22 ++++
>  MAINTAINERS                                   |    7 +
>  arch/arm/Kconfig                              |   10 ++
>  arch/arm/Makefile                             |    1 +
>  arch/arm/include/asm/hypervisor.h             |    6 +
>  arch/arm/include/asm/sync_bitops.h            |   27 ++++
>  arch/arm/include/asm/xen/events.h             |   18 +++
>  arch/arm/include/asm/xen/hypercall.h          |   69 ++++++++++
>  arch/arm/include/asm/xen/hypervisor.h         |   19 +++
>  arch/arm/include/asm/xen/interface.h          |   73 +++++++++++
>  arch/arm/include/asm/xen/page.h               |   82 ++++++++++++
>  arch/arm/mach-vexpress/v2m.c                  |   11 +-
>  arch/arm/xen/Makefile                         |    1 +
>  arch/arm/xen/enlighten.c                      |  168 +++++++++++++++++++++++++
>  arch/arm/xen/grant-table.c                    |   53 ++++++++
>  arch/arm/xen/hypercall.S                      |  106 ++++++++++++++++
>  arch/ia64/include/asm/xen/interface.h         |    8 +-
>  arch/x86/include/asm/xen/interface.h          |    8 ++
>  arch/x86/xen/enlighten.c                      |    1 +
>  arch/x86/xen/irq.c                            |    1 +
>  arch/x86/xen/mmu.c                            |    3 +
>  arch/x86/xen/xen-ops.h                        |    1 -
>  drivers/block/xen-blkback/blkback.c           |    1 +
>  drivers/net/xen-netback/netback.c             |    1 +
>  drivers/net/xen-netfront.c                    |    1 +
>  drivers/tty/hvc/hvc_xen.c                     |    2 +
>  drivers/xen/Makefile                          |   13 ++-
>  drivers/xen/events.c                          |   18 +++-
>  drivers/xen/grant-table.c                     |    1 +
>  drivers/xen/privcmd.c                         |    4 -
>  drivers/xen/xenbus/xenbus_comms.c             |    2 +-
>  drivers/xen/xenbus/xenbus_probe.c             |   62 +++++++---
>  drivers/xen/xenbus/xenbus_probe_frontend.c    |    1 +
>  drivers/xen/xenbus/xenbus_xs.c                |    3 +-
>  include/xen/events.h                          |    2 +
>  include/xen/interface/features.h              |    3 +
>  include/xen/interface/grant_table.h           |    4 +-
>  include/xen/interface/io/protocols.h          |    3 +
>  include/xen/interface/memory.h                |   21 ++--
>  include/xen/interface/physdev.h               |    2 +-
>  include/xen/interface/platform.h              |    4 +-
>  include/xen/interface/version.h               |    2 +-
>  include/xen/interface/xen.h                   |    7 +-
>  include/xen/privcmd.h                         |    3 +-
>  include/xen/xen.h                             |    2 +-
>  45 files changed, 796 insertions(+), 61 deletions(-)
> 
> 
> 
> A branch based on 3.6-rc5 is available here:
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.6-rc5-arm-4
> 
> 
> Cheers,
> 
> Stefano

> /*
>  * ARM Ltd. Versatile Express
>  *
>  * Motherboard Express uATX
>  * V2M-P1
>  *
>  * HBI-0190D
>  *
>  * RS1 memory map ("ARM Cortex-A Series memory map" in the board's
>  * Technical Reference Manual)
>  *
>  * WARNING! The hardware described in this file is independent from the
>  * original variant (vexpress-v2m.dtsi), but there is a strong
>  * correspondence between the two configurations.
>  *
>  * TAKE CARE WHEN MAINTAINING THIS FILE TO PROPAGATE ANY RELEVANT
>  * CHANGES TO vexpress-v2m.dtsi!
>  */
> 
> / {
> 	aliases {
> 		arm,v2m_timer = &v2m_timer01;
> 	};
> 
> 	motherboard {
> 		compatible = "simple-bus";
> 		arm,v2m-memory-map = "rs1";
> 		#address-cells = <2>; /* SMB chipselect number and offset */
> 		#size-cells = <1>;
> 		#interrupt-cells = <1>;
> 
> 		flash@0,00000000 {
> 			compatible = "arm,vexpress-flash", "cfi-flash";
> 			reg = <0 0x00000000 0x04000000>,
> 			      <4 0x00000000 0x04000000>;
> 			bank-width = <4>;
> 		};
> 
> 		psram@1,00000000 {
> 			compatible = "arm,vexpress-psram", "mtd-ram";
> 			reg = <1 0x00000000 0x02000000>;
> 			bank-width = <4>;
> 		};
> 
> 		vram@2,00000000 {
> 			compatible = "arm,vexpress-vram";
> 			reg = <2 0x00000000 0x00800000>;
> 		};
> 
> 		ethernet@2,02000000 {
> 			compatible = "smsc,lan91c111";
> 			reg = <2 0x02000000 0x10000>;
> 			interrupts = <15>;
> 		};
> 
> 		usb@2,03000000 {
> 			compatible = "nxp,usb-isp1761";
> 			reg = <2 0x03000000 0x20000>;
> 			interrupts = <16>;
> 			port1-otg;
> 		};
> 
> 		iofpga@3,00000000 {
> 			compatible = "arm,amba-bus", "simple-bus";
> 			#address-cells = <1>;
> 			#size-cells = <1>;
> 			ranges = <0 3 0 0x200000>;
> 
> 			sysreg@010000 {
> 				compatible = "arm,vexpress-sysreg";
> 				reg = <0x010000 0x1000>;
> 			};
> 
> 			sysctl@020000 {
> 				compatible = "arm,sp810", "arm,primecell";
> 				reg = <0x020000 0x1000>;
> 			};
> 
> 			/* PCI-E I2C bus */
> 			v2m_i2c_pcie: i2c@030000 {
> 				compatible = "arm,versatile-i2c";
> 				reg = <0x030000 0x1000>;
> 
> 				#address-cells = <1>;
> 				#size-cells = <0>;
> 
> 				pcie-switch@60 {
> 					compatible = "idt,89hpes32h8";
> 					reg = <0x60>;
> 				};
> 			};
> 
> 			aaci@040000 {
> 				compatible = "arm,pl041", "arm,primecell";
> 				reg = <0x040000 0x1000>;
> 				interrupts = <11>;
> 			};
> 
> 			mmci@050000 {
> 				compatible = "arm,pl180", "arm,primecell";
> 				reg = <0x050000 0x1000>;
> 				interrupts = <9 10>;
> 			};
> 
> 			kmi@060000 {
> 				compatible = "arm,pl050", "arm,primecell";
> 				reg = <0x060000 0x1000>;
> 				interrupts = <12>;
> 			};
> 
> 			kmi@070000 {
> 				compatible = "arm,pl050", "arm,primecell";
> 				reg = <0x070000 0x1000>;
> 				interrupts = <13>;
> 			};
> 
> 			v2m_serial0: uart@090000 {
> 				compatible = "arm,pl011", "arm,primecell";
> 				reg = <0x090000 0x1000>;
> 				interrupts = <5>;
> 			};
> 
> 			v2m_serial1: uart@0a0000 {
> 				compatible = "arm,pl011", "arm,primecell";
> 				reg = <0x0a0000 0x1000>;
> 				interrupts = <6>;
> 			};
> 
> 			v2m_serial2: uart@0b0000 {
> 				compatible = "arm,pl011", "arm,primecell";
> 				reg = <0x0b0000 0x1000>;
> 				interrupts = <7>;
> 			};
> 
> 			v2m_serial3: uart@0c0000 {
> 				compatible = "arm,pl011", "arm,primecell";
> 				reg = <0x0c0000 0x1000>;
> 				interrupts = <8>;
> 			};
> 
> 			wdt@0f0000 {
> 				compatible = "arm,sp805", "arm,primecell";
> 				reg = <0x0f0000 0x1000>;
> 				interrupts = <0>;
> 			};
> 
> 			v2m_timer01: timer@110000 {
> 				compatible = "arm,sp804", "arm,primecell";
> 				reg = <0x110000 0x1000>;
> 				interrupts = <2>;
> 			};
> 
> 			v2m_timer23: timer@120000 {
> 				compatible = "arm,sp804", "arm,primecell";
> 				reg = <0x120000 0x1000>;
> 				interrupts = <3>;
> 			};
> 
> 			/* DVI I2C bus */
> 			v2m_i2c_dvi: i2c@160000 {
> 				compatible = "arm,versatile-i2c";
> 				reg = <0x160000 0x1000>;
> 
> 				#address-cells = <1>;
> 				#size-cells = <0>;
> 
> 				dvi-transmitter@39 {
> 					compatible = "sil,sii9022-tpi", "sil,sii9022";
> 					reg = <0x39>;
> 				};
> 
> 				dvi-transmitter@60 {
> 					compatible = "sil,sii9022-cpi", "sil,sii9022";
> 					reg = <0x60>;
> 				};
> 			};
> 
> 			rtc@170000 {
> 				compatible = "arm,pl031", "arm,primecell";
> 				reg = <0x170000 0x1000>;
> 				interrupts = <4>;
> 			};
> 
> 			compact-flash@1a0000 {
> 				compatible = "arm,vexpress-cf", "ata-generic";
> 				reg = <0x1a0000 0x100
> 				       0x1a0100 0xf00>;
> 				reg-shift = <2>;
> 			};
> 
> 			clcd@1f0000 {
> 				compatible = "arm,pl111", "arm,primecell";
> 				reg = <0x1f0000 0x1000>;
> 				interrupts = <14>;
> 			};
> 		};
> 
> 		v2m_fixed_3v3: fixedregulator@0 {
> 			compatible = "regulator-fixed";
> 			regulator-name = "3V3";
> 			regulator-min-microvolt = <3300000>;
> 			regulator-max-microvolt = <3300000>;
> 			regulator-always-on;
> 		};
> 	};
> };

> /*
>  * ARM Ltd. Versatile Express
>  *
>  * CoreTile Express A15x2 (version with Test Chip 1)
>  * Cortex-A15 MPCore (V2P-CA15)
>  *
>  * HBI-0237A
>  */
> 
> /dts-v1/;
> 
> / {
> 	model = "V2P-CA15";
> 	arm,hbi = <0x237>;
> 	compatible = "arm,vexpress,v2p-ca15,tc1", "arm,vexpress,v2p-ca15", "arm,vexpress";
> 	interrupt-parent = <&gic>;
> 	#address-cells = <2>;
> 	#size-cells = <2>;
> 
> 	chosen {
>                  bootargs = "dom0_mem=128M";
>                  xen,dom0-bootargs = "earlyprintk console=ttyAMA1 root=/dev/mmcblk0 debug rw";
> 	};
> 
> 	aliases {
> 		serial0 = &v2m_serial0;
> 		serial1 = &v2m_serial1;
> 		serial2 = &v2m_serial2;
> 		serial3 = &v2m_serial3;
> 		i2c0 = &v2m_i2c_dvi;
> 		i2c1 = &v2m_i2c_pcie;
> 	};
> 
> 	cpus {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		cpu@0 {
> 			device_type = "cpu";
> 			compatible = "arm,cortex-a15";
> 			reg = <0>;
> 		};
> 	};
> 
> 	memory@80000000 {
> 		device_type = "memory";
> 		reg = <0 0x80000000 0 0x80000000>;
> 	};
> 
> 	gic: interrupt-controller@2c001000 {
> 		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
> 		#interrupt-cells = <3>;
> 		#address-cells = <0>;
> 		interrupt-controller;
> 		reg = <0 0x2c001000 0 0x1000>,
> 		      <0 0x2c002000 0 0x1000>,
> 		      <0 0x2c004000 0 0x2000>,
> 		      <0 0x2c006000 0 0x2000>;
> 		interrupts = <1 9 0xf04>;
> 	};
> 
> 	timer {
> 		compatible = "arm,armv7-timer";
> 		interrupts = <1 13 0xf08>,
> 			     <1 14 0xf08>,
> 			     <1 11 0xf08>,
> 			     <1 10 0xf08>;
> 	};
> 
> 	pmu {
> 		compatible = "arm,cortex-a15-pmu", "arm,cortex-a9-pmu";
> 		interrupts = <0 68 4>,
> 			     <0 69 4>;
> 	};
> 
> 	hypervisor {
> 		compatible = "xen,xen-4.2", "xen,xen";
> 		reg = <0 0xb0000000 0 0x20000>;
> 		interrupts = <1 15 0xf08>;
> 	};
> 
> 	motherboard {
> 		ranges = <0 0 0 0x08000000 0x04000000>,
> 			 <1 0 0 0x14000000 0x04000000>,
> 			 <2 0 0 0x18000000 0x04000000>,
> 			 <3 0 0 0x1c000000 0x04000000>,
> 			 <4 0 0 0x0c000000 0x04000000>,
> 			 <5 0 0 0x10000000 0x04000000>;
> 
> 		interrupt-map-mask = <0 0 63>;
> 		interrupt-map = <0 0  0 &gic 0  0 4>,
> 				<0 0  1 &gic 0  1 4>,
> 				<0 0  2 &gic 0  2 4>,
> 				<0 0  3 &gic 0  3 4>,
> 				<0 0  4 &gic 0  4 4>,
> 				<0 0  5 &gic 0  5 4>,
> 				<0 0  6 &gic 0  6 4>,
> 				<0 0  7 &gic 0  7 4>,
> 				<0 0  8 &gic 0  8 4>,
> 				<0 0  9 &gic 0  9 4>,
> 				<0 0 10 &gic 0 10 4>,
> 				<0 0 11 &gic 0 11 4>,
> 				<0 0 12 &gic 0 12 4>,
> 				<0 0 13 &gic 0 13 4>,
> 				<0 0 14 &gic 0 14 4>,
> 				<0 0 15 &gic 0 15 4>,
> 				<0 0 16 &gic 0 16 4>,
> 				<0 0 17 &gic 0 17 4>,
> 				<0 0 18 &gic 0 18 4>,
> 				<0 0 19 &gic 0 19 4>,
> 				<0 0 20 &gic 0 20 4>,
> 				<0 0 21 &gic 0 21 4>,
> 				<0 0 22 &gic 0 22 4>,
> 				<0 0 23 &gic 0 23 4>,
> 				<0 0 24 &gic 0 24 4>,
> 				<0 0 25 &gic 0 25 4>,
> 				<0 0 26 &gic 0 26 4>,
> 				<0 0 27 &gic 0 27 4>,
> 				<0 0 28 &gic 0 28 4>,
> 				<0 0 29 &gic 0 29 4>,
> 				<0 0 30 &gic 0 30 4>,
> 				<0 0 31 &gic 0 31 4>,
> 				<0 0 32 &gic 0 32 4>,
> 				<0 0 33 &gic 0 33 4>,
> 				<0 0 34 &gic 0 34 4>,
> 				<0 0 35 &gic 0 35 4>,
> 				<0 0 36 &gic 0 36 4>,
> 				<0 0 37 &gic 0 37 4>,
> 				<0 0 38 &gic 0 38 4>,
> 				<0 0 39 &gic 0 39 4>,
> 				<0 0 40 &gic 0 40 4>,
> 				<0 0 41 &gic 0 41 4>,
> 				<0 0 42 &gic 0 42 4>;
> 	};
> };
> 
> /include/ "vexpress-v2m-rs1.dtsi"

> /*
>  * ARM Ltd. Versatile Express
>  *
>  * ARM Envelope Model v7A (single CPU).
>  */
> 
> /dts-v1/;
> 
> /include/ "skeleton.dtsi"
> 
> / {
> 	model = "V2P-AEMv7A";
> 	compatible = "arm,vexpress,v2p-aem,v7a", "arm,vexpress,v2p-aem", "arm,vexpress";
> 	interrupt-parent = <&gic>;
> 
>         chosen {
>                 bootargs = "earlyprintk debug loglevel=9 console=hvc0 root=/dev/xvda init=/sbin/init";
>         };
> 
> 	cpus {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		cpu@0 {
> 			device_type = "cpu";
> 			compatible = "arm,cortex-a15";
> 			reg = <0>;
> 		};
> 	};
> 
> 	memory {
> 		device_type = "memory";
> 		reg = <0x80000000 0x08000000>;
> 	};
> 
> 	gic: interrupt-controller@2c001000 {
> 		compatible = "arm,cortex-a9-gic";
> 		#interrupt-cells = <3>;
> 		#address-cells = <0>;
> 		interrupt-controller;
> 		reg = <0x2c001000 0x1000>,
> 		      <0x2c002000 0x100>;
> 	};
> 
> 	timer {
> 		compatible = "arm,armv7-timer";
> 		interrupts = <1 13 0xf08>,
> 			     <1 14 0xf08>,
> 			     <1 11 0xf08>,
> 			     <1 10 0xf08>;
> 	};
> 
> 	hypervisor {
> 		compatible = "xen,xen-4.2", "xen,xen";
> 		reg = <0xb0000000 0x20000>;
> 		interrupts = <1 15 0xf08>;
> 	};
> 
> 	motherboard {
> 		arm,v2m-memory-map = "rs1";
> 		ranges = <0 0 0x08000000 0x04000000>,
> 			 <1 0 0x14000000 0x04000000>,
> 			 <2 0 0x18000000 0x04000000>,
> 			 <3 0 0x1c000000 0x04000000>,
> 			 <4 0 0x0c000000 0x04000000>,
> 			 <5 0 0x10000000 0x04000000>;
> 
> 		interrupt-map-mask = <0 0 63>;
> 		interrupt-map = <0 0  0 &gic 0  0 4>,
> 				<0 0  1 &gic 0  1 4>,
> 				<0 0  2 &gic 0  2 4>,
> 				<0 0  3 &gic 0  3 4>,
> 				<0 0  4 &gic 0  4 4>,
> 				<0 0  5 &gic 0  5 4>,
> 				<0 0  6 &gic 0  6 4>,
> 				<0 0  7 &gic 0  7 4>,
> 				<0 0  8 &gic 0  8 4>,
> 				<0 0  9 &gic 0  9 4>,
> 				<0 0 10 &gic 0 10 4>,
> 				<0 0 11 &gic 0 11 4>,
> 				<0 0 12 &gic 0 12 4>,
> 				<0 0 13 &gic 0 13 4>,
> 				<0 0 14 &gic 0 14 4>,
> 				<0 0 15 &gic 0 15 4>,
> 				<0 0 16 &gic 0 16 4>,
> 				<0 0 17 &gic 0 17 4>,
> 				<0 0 18 &gic 0 18 4>,
> 				<0 0 19 &gic 0 19 4>,
> 				<0 0 20 &gic 0 20 4>,
> 				<0 0 21 &gic 0 21 4>,
> 				<0 0 22 &gic 0 22 4>,
> 				<0 0 23 &gic 0 23 4>,
> 				<0 0 24 &gic 0 24 4>,
> 				<0 0 25 &gic 0 25 4>,
> 				<0 0 26 &gic 0 26 4>,
> 				<0 0 27 &gic 0 27 4>,
> 				<0 0 28 &gic 0 28 4>,
> 				<0 0 29 &gic 0 29 4>,
> 				<0 0 30 &gic 0 30 4>,
> 				<0 0 31 &gic 0 31 4>,
> 				<0 0 32 &gic 0 32 4>,
> 				<0 0 33 &gic 0 33 4>,
> 				<0 0 34 &gic 0 34 4>,
> 				<0 0 35 &gic 0 35 4>,
> 				<0 0 36 &gic 0 36 4>,
> 				<0 0 37 &gic 0 37 4>,
> 				<0 0 38 &gic 0 38 4>,
> 				<0 0 39 &gic 0 39 4>,
> 				<0 0 40 &gic 0 40 4>,
> 				<0 0 41 &gic 0 41 4>,
> 				<0 0 42 &gic 0 42 4>;
> 	};
> };
> 
> /* /include/ "vexpress-v2m-rs1-rtsm.dtsi" */


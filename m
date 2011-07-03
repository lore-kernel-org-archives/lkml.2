Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1GCUvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 16:51:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44153 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1GCUvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 16:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <1309641352-18714-3-git-send-email-jonas@southpole.se>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se> <1309641352-18714-3-git-send-email-jonas@southpole.se>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 3 Jul 2011 14:51:10 -0600
X-Google-Sender-Auth: JAXlQDYjzVcD5Ph8d_NXCNgiPBM
Message-ID: <CACxGe6tFX=EQjaL-4EjSXquY5eh+bca29=d=cE5-YAVCUVRCvA@mail.gmail.com>
Subject: Re: [PATCH v2 02/19] OpenRISC: Device tree
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 3:15 PM, Jonas Bonn <jonas@southpole.se> wrote:
>
> The OpenRISC architecture uses the device tree infrastructure for the
> platform description.  This is currently limited to having a device tree
> built into the kernel, but work is underway within the OpenRISC project
> to define how this device tree blob should be passed into the kernel from
> an external resource.
>
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> Cc: devicetree-discuss@lists.ozlabs.org
> ---
>  arch/openrisc/boot/dts/atlys.dts   |   78 +++++++++++++++++++++++++
>  arch/openrisc/boot/dts/or1ksim.dts |   73 ++++++++++++++++++++++++
>  arch/openrisc/include/asm/prom.h   |   92 ++++++++++++++++++++++++++++++
>  arch/openrisc/kernel/prom.c        |  109 ++++++++++++++++++++++++++++++++++++
>  arch/openrisc/kernel/setup.c       |    3 +-
>  5 files changed, 353 insertions(+), 2 deletions(-)
>  create mode 100644 arch/openrisc/boot/dts/atlys.dts
>  create mode 100644 arch/openrisc/boot/dts/or1ksim.dts
>  create mode 100644 arch/openrisc/include/asm/prom.h
>  create mode 100644 arch/openrisc/kernel/prom.c
>
> diff --git a/arch/openrisc/boot/dts/atlys.dts b/arch/openrisc/boot/dts/atlys.dts
> new file mode 100644
> index 0000000..cd028b9
> --- /dev/null
> +++ b/arch/openrisc/boot/dts/atlys.dts
> @@ -0,0 +1,78 @@
> +/dts-v1/;
> +/ {
> +       compatible = "digilent,atlys";
> +       #size-cells = <1>;
> +       #address-cells = <1>;
> +
> +       chosen {
> +               bootargs = "console=tty0 console=uart,mmio,0x90000000,115200 debug video=ocfb:640x480-16@60";
> +       };
> +
> +       memory {

memory@0

> +               device_type = "memory";
> +               reg = <0x00000000 0x8000000>;
> +       };
> +
> +       cpus {
> +               cpu@0 {
> +                       compatible = "opencores,openrisc-1200";
> +                       clock-frequency = <50000000>;

As Segher metioned, the cpus node should have #address/size-cells and
the cpu@0 node should have "reg = <0>;".

> +               };
> +       };
> +
> +       /* The "soc" node */
> +
> +       soc {
> +               /* Every node with children must specify address-cells and
> +                  size-cells; they are not inherited */
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               device_type = "soc";

Drop device type.  device_type only makes sense for systems with real
OpenFirmware.  Always use a 'compatible' property to identify a
device.  In this case you probably want the compatible list to include
the name of the bus bridge plus "simple-bus".

Does it really make sense to have an SoC node for this board?  I
assume this is for a soft CPU system on a Diligent FPGA board.  It is
best if the device tree structure matches the actual bus layout of the
chip and/or FPGA design.  If the devices are directly on the CPU bus,
then it is better to do without an soc node entirely and just put
everything at the root.

> +
> +               /* This is also a 1:1 mapping but limits size of mappable
> +                  region to 0x40000000 */
> +               ranges = <0x80000000 0x80000000 0x40000000>;
> +
> +               /* An alternative is to specify an empty ranges here to
> +                  indicates 1:1 mapping of SOC addresses (device addresses)
> +                  to CPU addresses */
> +               /*ranges;*/

ranges is a well documented property.  You can drop the commented out
empty ranges, and the comments attached to it.

> +               /* This SOC has only a single, implicit PIC, so define it
> +                  early and put the interrupt-parent property in the 'soc'
> +                  node so that it's inherited by all the children using
> +                  interrupts.
> +               */
> +               interrupt-parent = <&pic>;

Put this at the root of the tree so that every node inherits it
(unless explicitly overridden).  You may very well end up with devices
at the root of the tree which are not children of the SoC node.

> +
> +               /* Devices with interrupts need a 'parent', so we need to
> +                  define a controller */
> +               pic: pic@0 {
> +                       compatible = "opencores,or1k-pic";
> +                       #interrupt-cells = <1>;
> +                       interrupt-controller;
> +               };
> +
> +               serial0: serial@90000000 {
> +                       /* FIXME: device_type is still needed here...
> +                          should remove requirement from of_serial driver */
> +                       device_type = "serial";

device_type should not be necessary at all any more in the current
kernel.  You can remove this now.

> +                       compatible = "opencores,uart", "ns16550a";
> +                       reg = <0x90000000 0x100>;
> +                       interrupts = <2>;
> +                       clock-frequency = <50000000>;
> +               };
> +
> +               enet0: ethoc@92000000 {
> +                       compatible = "opencores,ethoc", "ethoc";

"ethoc" is too generic.  Drop it.  Also, since this represents a soft
IP core, "opencores,ethoc" should probably include some indication of
which version of the core is instantiated (same goes for the other
"opencores,..." values in this file.

Finally, every new "compatible" value that is used in this device tree
needs to be documented.  Look in Documentation/devicetree/bindings.
The documentation is used to guard against "binding drift" where the
meaning of a compatible property is interpreted differently by
different people.

> +                       reg = <0x92000000 0x53>;
> +                       interrupts = <4>;
> +                       local-mac-address = [02 de ad be ef 02];

Don't do this.  If you don't have a valid Ethernet address, it is
probably better to leave the property out entirely, and let the kernel
randomly generate one.

> +               };
> +
> +               fb0: ocfb@97000000 {
> +                       compatible = "opencores,ocfb", "ocfb";

"ocfb" too generic.

> +                       reg = <0x97000000 0x1000>;
> +               };
> +       };
> +};
> diff --git a/arch/openrisc/boot/dts/or1ksim.dts b/arch/openrisc/boot/dts/or1ksim.dts
> new file mode 100644
> index 0000000..6a025ea
> --- /dev/null
> +++ b/arch/openrisc/boot/dts/or1ksim.dts
> @@ -0,0 +1,73 @@
> +/dts-v1/;
> +/ {
> +       compatible = "opencores,or1ksim";
> +       #size-cells = <1>;
> +       #address-cells = <1>;
> +
> +       chosen {
> +               bootargs = "console=uart,mmio,0x90000000,115200 debug";
> +       };
> +
> +       memory {
> +               device_type = "memory";
> +               reg = <0x00000000 0x2000000>;
> +       };
> +
> +       cpus {
> +               cpu@0 {
> +                       compatible = "opencores,openrisc-1200";
> +                       clock-frequency = <20000000>;
> +               };
> +       };
> +
> +       /* The "soc" node */
> +
> +       soc {
> +               /* Every node with children must specify address-cells and
> +                  size-cells; they are not inherited */
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               device_type = "soc";

Drop device_type, blah blah blah...  Most of my comments on the
previous file apply here too.

> +
> +               /* This is also a 1:1 mapping but limits size of mappable
> +                  region to 0x40000000 */
> +               ranges = <0x80000000 0x80000000 0x40000000>;
> +
> +               /* An alternative is to specify an empty ranges here to
> +                  indicates 1:1 mapping of SOC addresses (device addresses)
> +                  to CPU addresses */
> +               /*ranges;*/
> +
> +               /* This SOC has only a single, implicit PIC, so define it
> +                  early and put the interrupt-parent property in the 'soc'
> +                  node so that it's inherited by all the children using
> +                  interrupts.
> +               */
> +               interrupt-parent = <&pic>;
> +
> +               /* Devices with interrupts need a 'parent', so we need to
> +                  define a controller */
> +               pic: pic@0 {
> +                       compatible = "opencores,or1k-pic";
> +                       #interrupt-cells = <1>;
> +                       interrupt-controller;
> +               };
> +
> +               serial0: serial@90000000 {
> +                       /* FIXME: device_type is still needed here...
> +                          should remove requirement from of_serial driver */
> +                       device_type = "serial";
> +                       compatible = "opencores,uart", "ns16550a";
> +                       reg = <0x90000000 0x100>;
> +                       interrupts = <2>;
> +                       clock-frequency = <20000000>;
> +               };
> +
> +               enet0: ethoc@92000000 {
> +                       compatible = "opencores,ethoc", "ethoc";
> +                       reg = <0x92000000 0x53>;
> +                       interrupts = <4>;
> +                       local-mac-address = [02 de ad be ef 02];
> +               };
> +       };
> +};
> diff --git a/arch/openrisc/include/asm/prom.h b/arch/openrisc/include/asm/prom.h
> new file mode 100644
> index 0000000..3818902
> --- /dev/null
> +++ b/arch/openrisc/include/asm/prom.h
> @@ -0,0 +1,92 @@
> +/*
> + * OpenRISC Linux
> + *
> + * Linux architectural port borrowing liberally from similar works of
> + * others.  All original copyrights apply as per the original source
> + * declaration.
> + *
> + * OpenRISC implementation:
> + * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
> + * et al.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/of.h>  /* linux/of.h gets to determine #include ordering */
> +
> +#ifndef _ASM_OPENRISC_PROM_H
> +#define _ASM_OPENRISC_PROM_H
> +#ifdef __KERNEL__
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/types.h>
> +#include <asm/irq.h>
> +#include <asm/atomic.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_fdt.h>
> +#include <linux/of_address.h>
> +#include <linux/proc_fs.h>
> +#include <linux/platform_device.h>
> +#define HAVE_ARCH_DEVTREE_FIXUPS
> +
> +/* Other Prototypes */
> +extern int early_uartlite_console(void);
> +
> +#ifdef CONFIG_PCI
> +/*
> + * PCI <-> OF matching functions
> + * (XXX should these be here?)
> + */
> +struct pci_bus;
> +struct pci_dev;
> +extern int pci_device_from_OF_node(struct device_node *node,
> +                                       u8 *bus, u8 *devfn);
> +extern struct device_node *pci_busdev_to_OF_node(struct pci_bus *bus,
> +                                                       int devfn);
> +extern struct device_node *pci_device_to_OF_node(struct pci_dev *dev);
> +extern void pci_create_OF_bus_map(void);
> +#endif
> +
> +/* Parse the ibm,dma-window property of an OF node into the busno, phys and
> + * size parameters.
> + */
> +void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
> +               unsigned long *busno, unsigned long *phys, unsigned long *size);
> +
> +extern void kdump_move_device_tree(void);
> +
> +/* CPU OF node matching */
> +struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
> +
> +/* Get the MAC address */
> +extern const void *of_get_mac_address(struct device_node *np);
> +
> +/**
> + * of_irq_map_pci - Resolve the interrupt for a PCI device
> + * @pdev:      the device whose interrupt is to be resolved
> + * @out_irq:   structure of_irq filled by this function
> + *
> + * This function resolves the PCI interrupt for a given PCI device. If a
> + * device-node exists for a given pci_dev, it will use normal OF tree
> + * walking. If not, it will implement standard swizzling and walk up the
> + * PCI tree until an device-node is found, at which point it will finish
> + * resolving using the OF tree walking.
> + */
> +struct pci_dev;
> +extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
> +
> +/* This routine is here to provide compatibility with how powerpc
> + * handles IRQ mapping for OF device nodes.  We precompute and permanently
> + * register them in the platform_device objects, whereas powerpc computes them
> + * on request.
> + */
> +static inline void irq_dispose_mapping(unsigned int virq)
> +{
> +}

The need for this should hopefully go away in Linux v3.1 when I get
the irq_domain stuff merged.

> +
> +#endif /* __ASSEMBLY__ */
> +#endif /* __KERNEL__ */
> +#endif /* _ASM_OPENRISC_PROM_H */
> diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
> new file mode 100644
> index 0000000..2bb5a8c
> --- /dev/null
> +++ b/arch/openrisc/kernel/prom.c
> @@ -0,0 +1,109 @@
> +/*
> + * OpenRISC prom.c
> + *
> + * Linux architectural port borrowing liberally from similar works of
> + * others.  All original copyrights apply as per the original source
> + * declaration.
> + *
> + * Modifications for the OpenRISC architecture:
> + * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
> + *
> + *      This program is free software; you can redistribute it and/or
> + *      modify it under the terms of the GNU General Public License
> + *      as published by the Free Software Foundation; either version
> + *      2 of the License, or (at your option) any later version.
> + *
> + * Architecture specific procedures for creating, accessing and
> + * interpreting the device tree.
> + *
> + */
> +
> +#include <stdarg.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/init.h>
> +#include <linux/threads.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +#include <linux/pci.h>
> +#include <linux/stringify.h>
> +#include <linux/delay.h>
> +#include <linux/initrd.h>
> +#include <linux/bitops.h>
> +#include <linux/module.h>
> +#include <linux/kexec.h>
> +#include <linux/debugfs.h>
> +#include <linux/irq.h>
> +#include <linux/memblock.h>
> +#include <linux/of_fdt.h>
> +
> +#include <asm/prom.h>
> +#include <asm/page.h>
> +#include <asm/processor.h>
> +#include <asm/irq.h>
> +#include <linux/io.h>
> +#include <asm/system.h>
> +#include <asm/mmu.h>
> +#include <asm/pgtable.h>
> +#include <asm/sections.h>
> +#include <asm/setup.h>
> +
> +extern char cmd_line[COMMAND_LINE_SIZE];
> +
> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
> +{
> +       size &= PAGE_MASK;
> +       memblock_add(base, size);
> +}
> +
> +void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
> +{
> +       return __va(memblock_alloc(size, align));
> +}
> +
> +void __init early_init_devtree(void *params)
> +{
> +       u8 *alloc;
> +
> +       /* Setup flat device-tree pointer */
> +       initial_boot_params = params;
> +
> +
> +       /* Retrieve various informations from the /chosen node of the
> +        * device-tree, including the platform type, initrd location and
> +        * size, TCE reserve, and more ...
> +        */
> +       of_scan_flat_dt(early_init_dt_scan_chosen, cmd_line);
> +
> +       /* Scan memory nodes and rebuild MEMBLOCKs */
> +       memblock_init();
> +       of_scan_flat_dt(early_init_dt_scan_root, NULL);
> +       of_scan_flat_dt(early_init_dt_scan_memory, NULL);
> +
> +       /* Save command line for /proc/cmdline and then parse parameters */
> +       strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
> +//     parse_early_param();

This should just be removed?

> +
> +       memblock_analyze();
> +
> +       /* We must copy the flattend device tree from init memory to regular
> +        * memory because the device tree references the strings in it
> +        * directly.
> +        */
> +
> +       alloc = __va(memblock_alloc(initial_boot_params->totalsize, PAGE_SIZE));
> +
> +       memcpy(alloc, initial_boot_params, initial_boot_params->totalsize);
> +
> +       initial_boot_params = (void *) alloc;

If alloc gets declared as a 'void*', then this cast can be removed.

> +}
> +
> +#ifdef CONFIG_BLK_DEV_INITRD
> +void __init early_init_dt_setup_initrd_arch(unsigned long start,
> +               unsigned long end)
> +{
> +       initrd_start = (unsigned long)__va(start);
> +       initrd_end = (unsigned long)__va(end);
> +       initrd_below_start_ok = 1;
> +}
> +#endif
> diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
> index 49342e9..6ce6583 100644
> --- a/arch/openrisc/kernel/setup.c
> +++ b/arch/openrisc/kernel/setup.c
> @@ -173,8 +173,7 @@ void __init setup_cpuinfo(void)
>        unsigned long iccfgr,dccfgr;
>        unsigned long cache_set_size, cache_ways;;
>
> -       cpu = (struct device_node *) of_find_compatible_node(NULL,
> -                                       NULL, "opencores,openrisc-1200");
> +       cpu = of_find_compatible_node(NULL, NULL, "opencores,openrisc-1200");

This looks odd.  Is it a stale hunk from a previous patch version?

>        if (!cpu) {
>                panic("No compatible CPU found in device tree...\n");
>        }
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

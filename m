Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1AFID3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:03:29 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:40255 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1AFID2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:03:28 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
In-Reply-To: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
Subject: RE: [PATCHv1 0/8] unicore32 machine related files: summary
Date: Thu, 6 Jan 2011 16:03:28 +0800
Message-ID: <01e401cbad78$34125ad0$9c371070$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQD5q7uzdbzaRxzFKhxkjRMpQze/MJVnmLnA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCHv1 3/8] unicore32 machine related files: pci bus
From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 3 implements arch-specific pci bus driver.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/pci.h |   46 +++++
 arch/unicore32/kernel/pci.c      |  404 ++++++++++++++++++++++++++++++++++++++
 drivers/pci/Makefile             |    1 +
 3 files changed, 451 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/pci.h b/arch/unicore32/include/asm/pci.h
new file mode 100644
index 0000000..fa54e6f
--- /dev/null
+++ b/arch/unicore32/include/asm/pci.h
@@ -0,0 +1,46 @@
+/*
+ * linux/arch/unicore32/include/asm/pci.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_PCI_H__
+#define __UNICORE_PCI_H__
+
+#ifdef __KERNEL__
+#include <asm-generic/pci-dma-compat.h>
+#include <asm-generic/pci.h>
+#include <asm/mach/hardware.h> /* for PCIBIOS_MIN_* */
+
+static inline void pcibios_set_master(struct pci_dev *dev)
+{
+	/* No special bus mastering setup handling */
+}
+
+static inline void pcibios_penalize_isa_irq(int irq, int active)
+{
+	/* We don't do dynamic PCI IRQ allocation */
+}
+
+#ifdef CONFIG_PCI
+static inline void pci_dma_burst_advice(struct pci_dev *pdev,
+					enum pci_dma_burst_strategy *strat,
+					unsigned long *strategy_parameter)
+{
+	*strat = PCI_DMA_BURST_INFINITY;
+	*strategy_parameter = ~0UL;
+}
+#endif
+
+#define HAVE_PCI_MMAP
+extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
+	enum pci_mmap_state mmap_state, int write_combine);
+
+#endif /* __KERNEL__ */
+
+#endif
diff --git a/arch/unicore32/kernel/pci.c b/arch/unicore32/kernel/pci.c
new file mode 100644
index 0000000..d4e55e2
--- /dev/null
+++ b/arch/unicore32/kernel/pci.c
@@ -0,0 +1,404 @@
+/*
+ * linux/arch/unicore32/kernel/pci.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  PCI bios-type initialisation for PCI machines
+ *
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/io.h>
+
+static int debug_pci;
+static int use_firmware;
+
+#define CONFIG_CMD(bus, devfn, where)	\
+	(0x80000000 | (bus->number << 16) | (devfn << 8) | (where & ~3))
+
+static int
+puv3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
+			int size, u32 *value)
+{
+	PCICFG_ADDR = CONFIG_CMD(bus, devfn, where);
+	switch (size) {
+	case 1:
+		*value = (PCICFG_DATA >> ((where & 3) * 8)) & 0xFF;
+		break;
+	case 2:
+		*value = (PCICFG_DATA >> ((where & 2) * 8)) & 0xFFFF;
+		break;
+	case 4:
+		*value = PCICFG_DATA;
+		break;
+	}
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int
+puv3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
+			int size, u32 value)
+{
+	PCICFG_ADDR = CONFIG_CMD(bus, devfn, where);
+	switch (size) {
+	case 1:
+		PCICFG_DATA = (PCICFG_DATA & ~FMASK(8, (where&3)*8))
+			| FIELD(value, 8, (where&3)*8);
+		break;
+	case 2:
+		PCICFG_DATA = (PCICFG_DATA & ~FMASK(16, (where&2)*8))
+			| FIELD(value, 16, (where&2)*8);
+		break;
+	case 4:
+		PCICFG_DATA = value;
+		break;
+	}
+	return PCIBIOS_SUCCESSFUL;
+}
+
+struct pci_ops pci_puv3_ops = {
+	.read  = puv3_read_config,
+	.write = puv3_write_config,
+};
+
+void pci_puv3_preinit(void)
+{
+	printk(KERN_DEBUG "PCI: PKUnity PCI Controller Initializing ...\n");
+	/* config PCI bridge base */
+	PCICFG_BRIBASE = PKUNITY_PCIBRI_BASE;
+
+	PCIBRI_AHBCTL0 = 0;
+	PCIBRI_AHBBAR0 = PKUNITY_PCIBRI_BASE | PCIBRI_BARx_MEM;
+	PCIBRI_AHBAMR0 = 0xFFFF0000;
+	PCIBRI_AHBTAR0 = 0;
+
+	PCIBRI_AHBCTL1 = PCIBRI_CTLx_AT;
+	PCIBRI_AHBBAR1 = PKUNITY_PCILIO_BASE | PCIBRI_BARx_IO;
+	PCIBRI_AHBAMR1 = 0xFFFF0000;
+	PCIBRI_AHBTAR1 = 0x00000000;
+
+	PCIBRI_AHBCTL2 = PCIBRI_CTLx_PREF;
+	PCIBRI_AHBBAR2 = PKUNITY_PCIMEM_BASE | PCIBRI_BARx_MEM;
+	PCIBRI_AHBAMR2 = 0xF8000000;
+	PCIBRI_AHBTAR2 = 0;
+
+	PCIBRI_BAR1 = PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM;
+
+	PCIBRI_PCICTL0 = PCIBRI_CTLx_AT | PCIBRI_CTLx_PREF;
+	PCIBRI_PCIBAR0 = PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM;
+	PCIBRI_PCIAMR0 = 0xF8000000;
+	PCIBRI_PCITAR0 = PKUNITY_SDRAM_BASE;
+
+	PCIBRI_CMD = PCIBRI_CMD | PCIBRI_CMD_IO | PCIBRI_CMD_MEM;
+}
+
+static int __init pci_puv3_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+{
+	if (dev->bus->number == 0) {
+#ifdef CONFIG_ARCH_FPGA /* 4 pci slots */
+		if      (dev->devfn == 0x00)
+			return IRQ_PCIINTA;
+		else if (dev->devfn == 0x08)
+			return IRQ_PCIINTB;
+		else if (dev->devfn == 0x10)
+			return IRQ_PCIINTC;
+		else if (dev->devfn == 0x18)
+			return IRQ_PCIINTD;
+#endif
+#ifdef CONFIG_PUV3_DB0913 /* 3 pci slots */
+		if      (dev->devfn == 0x30)
+			return IRQ_PCIINTB;
+		else if (dev->devfn == 0x60)
+			return IRQ_PCIINTC;
+		else if (dev->devfn == 0x58)
+			return IRQ_PCIINTD;
+#endif
+#if	defined(CONFIG_PUV3_NB0916) || defined(CONFIG_PUV3_SMW0919)
+		/* only support 2 pci devices */
+		if      (dev->devfn == 0x00)
+			return IRQ_PCIINTC; /* sata */
+#endif
+	}
+	return -1;
+}
+
+/*
+ * Only first 128MB of memory can be accessed via PCI.
+ * We use GFP_DMA to allocate safe buffers to do map/unmap.
+ * This is really ugly and we need a better way of specifying
+ * DMA-capable regions of memory.
+ */
+void __init puv3_pci_adjust_zones(unsigned long *zone_size,
+	unsigned long *zhole_size)
+{
+	unsigned int sz = SZ_128M >> PAGE_SHIFT;
+
+	/*
+	 * Only adjust if > 128M on current system
+	 */
+	if (zone_size[0] <= sz)
+		return;
+
+	zone_size[1] = zone_size[0] - sz;
+	zone_size[0] = sz;
+	zhole_size[1] = zhole_size[0];
+	zhole_size[0] = 0;
+}
+
+void __devinit pcibios_update_irq(struct pci_dev *dev, int irq)
+{
+	if (debug_pci)
+		printk(KERN_DEBUG "PCI: Assigning IRQ %02d to %s\n",
+				irq, pci_name(dev));
+	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
+}
+
+/*
+ * If the bus contains any of these devices, then we must not turn on
+ * parity checking of any kind.
+ */
+static inline int pdev_bad_for_parity(struct pci_dev *dev)
+{
+	return 0;
+}
+
+/*
+ * pcibios_fixup_bus - Called after each bus is probed,
+ * but before its children are examined.
+ */
+void __devinit pcibios_fixup_bus(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+	u16 features = PCI_COMMAND_SERR
+		| PCI_COMMAND_PARITY
+		| PCI_COMMAND_FAST_BACK;
+
+	bus->resource[0] = &ioport_resource;
+	bus->resource[1] = &iomem_resource;
+
+	/*
+	 * Walk the devices on this bus, working out what we can
+	 * and can't support.
+	 */
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		u16 status;
+
+		pci_read_config_word(dev, PCI_STATUS, &status);
+
+		/*
+		 * If any device on this bus does not support fast back
+		 * to back transfers, then the bus as a whole is not able
+		 * to support them.  Having fast back to back transfers
+		 * on saves us one PCI cycle per transaction.
+		 */
+		if (!(status & PCI_STATUS_FAST_BACK))
+			features &= ~PCI_COMMAND_FAST_BACK;
+
+		if (pdev_bad_for_parity(dev))
+			features &= ~(PCI_COMMAND_SERR
+					| PCI_COMMAND_PARITY);
+
+		switch (dev->class >> 8) {
+		case PCI_CLASS_BRIDGE_PCI:
+			pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &status);
+			status |= PCI_BRIDGE_CTL_PARITY
+				| PCI_BRIDGE_CTL_MASTER_ABORT;
+			status &= ~(PCI_BRIDGE_CTL_BUS_RESET
+				| PCI_BRIDGE_CTL_FAST_BACK);
+			pci_write_config_word(dev, PCI_BRIDGE_CONTROL, status);
+			break;
+
+		case PCI_CLASS_BRIDGE_CARDBUS:
+			pci_read_config_word(dev, PCI_CB_BRIDGE_CONTROL,
+					&status);
+			status |= PCI_CB_BRIDGE_CTL_PARITY
+				| PCI_CB_BRIDGE_CTL_MASTER_ABORT;
+			pci_write_config_word(dev, PCI_CB_BRIDGE_CONTROL,
+					status);
+			break;
+		}
+	}
+
+	/*
+	 * Now walk the devices again, this time setting them up.
+	 */
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		u16 cmd;
+
+		pci_read_config_word(dev, PCI_COMMAND, &cmd);
+		cmd |= features;
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+
+		pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE,
+				      L1_CACHE_BYTES >> 2);
+	}
+
+	/*
+	 * Propagate the flags to the PCI bridge.
+	 */
+	if (bus->self && bus->self->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
+		if (features & PCI_COMMAND_FAST_BACK)
+			bus->bridge_ctl |= PCI_BRIDGE_CTL_FAST_BACK;
+		if (features & PCI_COMMAND_PARITY)
+			bus->bridge_ctl |= PCI_BRIDGE_CTL_PARITY;
+	}
+
+	/*
+	 * Report what we did for this bus
+	 */
+	printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
+		bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
+}
+#ifdef CONFIG_HOTPLUG
+EXPORT_SYMBOL(pcibios_fixup_bus);
+#endif
+
+static int __init pci_common_init(void)
+{
+	struct pci_bus *puv3_bus;
+
+	pci_puv3_preinit();
+
+	puv3_bus = pci_scan_bus(0, &pci_puv3_ops, NULL);
+
+	if (!puv3_bus)
+		panic("PCI: unable to scan bus!");
+
+	pci_fixup_irqs(pci_common_swizzle, pci_puv3_map_irq);
+
+	if (!use_firmware) {
+		/*
+		 * Size the bridge windows.
+		 */
+		pci_bus_size_bridges(puv3_bus);
+
+		/*
+		 * Assign resources.
+		 */
+		pci_bus_assign_resources(puv3_bus);
+	}
+
+	/*
+	 * Tell drivers about devices found.
+	 */
+	pci_bus_add_devices(puv3_bus);
+
+	return 0;
+}
+subsys_initcall(pci_common_init);
+
+char * __devinit pcibios_setup(char *str)
+{
+	if (!strcmp(str, "debug")) {
+		debug_pci = 1;
+		return NULL;
+	} else if (!strcmp(str, "firmware")) {
+		use_firmware = 1;
+		return NULL;
+	}
+	return str;
+}
+
+/*
+ * From arch/i386/kernel/pci-i386.c:
+ *
+ * We need to avoid collisions with `mirrored' VGA ports
+ * and other strange ISA hardware, so we always want the
+ * addresses to be allocated in the 0x000-0x0ff region
+ * modulo 0x400.
+ *
+ * Why? Because some silly external IO cards only decode
+ * the low 10 bits of the IO address. The 0x00-0xff region
+ * is reserved for motherboard devices that decode all 16
+ * bits, so it's ok to allocate at, say, 0x2800-0x28ff,
+ * but we want to try to avoid allocating at 0x2900-0x2bff
+ * which might be mirrored at 0x0100-0x03ff..
+ */
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
+				resource_size_t size, resource_size_t align)
+{
+	resource_size_t start = res->start;
+
+	if (res->flags & IORESOURCE_IO && start & 0x300)
+		start = (start + 0x3ff) & ~0x3ff;
+
+	start = (start + align - 1) & ~(align - 1);
+
+	return start;
+}
+
+/**
+ * pcibios_enable_device - Enable I/O and memory.
+ * @dev: PCI device to be enabled
+ */
+int pcibios_enable_device(struct pci_dev *dev, int mask)
+{
+	u16 cmd, old_cmd;
+	int idx;
+	struct resource *r;
+
+	pci_read_config_word(dev, PCI_COMMAND, &cmd);
+	old_cmd = cmd;
+	for (idx = 0; idx < 6; idx++) {
+		/* Only set up the requested stuff */
+		if (!(mask & (1 << idx)))
+			continue;
+
+		r = dev->resource + idx;
+		if (!r->start && r->end) {
+			printk(KERN_ERR "PCI: Device %s not available because"
+			       " of resource collisions\n", pci_name(dev));
+			return -EINVAL;
+		}
+		if (r->flags & IORESOURCE_IO)
+			cmd |= PCI_COMMAND_IO;
+		if (r->flags & IORESOURCE_MEM)
+			cmd |= PCI_COMMAND_MEMORY;
+	}
+
+	/*
+	 * Bridges (eg, cardbus bridges) need to be fully enabled
+	 */
+	if ((dev->class >> 16) == PCI_BASE_CLASS_BRIDGE)
+		cmd |= PCI_COMMAND_IO | PCI_COMMAND_MEMORY;
+
+	if (cmd != old_cmd) {
+		printk("PCI: enabling device %s (%04x -> %04x)\n",
+		       pci_name(dev), old_cmd, cmd);
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+	}
+	return 0;
+}
+
+int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
+			enum pci_mmap_state mmap_state, int write_combine)
+{
+	unsigned long phys;
+
+	if (mmap_state == pci_mmap_io)
+		return -EINVAL;
+
+	phys = vma->vm_pgoff;
+
+	/*
+	 * Mark this as IO
+	 */
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	if (remap_pfn_range(vma, vma->vm_start, phys,
+			     vma->vm_end - vma->vm_start,
+			     vma->vm_page_prot))
+		return -EAGAIN;
+
+	return 0;
+}
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 98e6fdf..77cf813 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_PCI_IOV) += iov.o
 obj-$(CONFIG_X86) += setup-bus.o
 obj-$(CONFIG_ALPHA) += setup-bus.o setup-irq.o
 obj-$(CONFIG_ARM) += setup-bus.o setup-irq.o
+obj-$(CONFIG_UNICORE32) += setup-bus.o setup-irq.o
 obj-$(CONFIG_PARISC) += setup-bus.o
 obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
 obj-$(CONFIG_PPC) += setup-bus.o

> -----Original Message-----
> From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-owner@vger.kernel.org] On Behalf Of Guan Xuetao
> Sent: Thursday, January 06, 2011 3:57 PM
> To: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCHv1 0/8] unicore32 machine related files: summary
> 
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> The whole patch could be fetched from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/epip/unicore32.git
>   with branch name: unicore32.
> And it is divided into  three patch sets: core architecture files,
>   additional architecture files, and machine related files.
> 
> This patch set adds the machine related files for UniCore32 ISA and PKUnity SoC.
> 
> Patch 1 adds machine related  core files, also including build infrastructure.
> 
> Patch 2 add all hardware registers definitions, which are not split and inserted into
>  different drivers.
> 
> Patch 3 implements arch-specific pci bus driver.
> 
> Patch 4 implements arch-specific ps2 dirver.
> 
> Patch 5 implements frame buffer driver.
> 
> Patch 6 implements ac97 driver.
> 
> Patch 7 implements arch-specific i2c bus driver.
> 
> Patch 8 implements network driver.
> 
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> ---
>  arch/unicore32/include/asm/mach/PKUnity.h     |  104 ++
>  arch/unicore32/include/asm/mach/bitfield.h    |   24 +
>  arch/unicore32/include/asm/mach/hardware.h    |   45 +
>  arch/unicore32/include/asm/mach/regs-ac97.h   |   32 +
>  arch/unicore32/include/asm/mach/regs-dmac.h   |   81 +
>  arch/unicore32/include/asm/mach/regs-gpio.h   |   70 +
>  arch/unicore32/include/asm/mach/regs-i2c.h    |   63 +
>  arch/unicore32/include/asm/mach/regs-intc.h   |   28 +
>  arch/unicore32/include/asm/mach/regs-nand.h   |   79 +
>  arch/unicore32/include/asm/mach/regs-ost.h    |   92 ++
>  arch/unicore32/include/asm/mach/regs-pci.h    |   94 ++
>  arch/unicore32/include/asm/mach/regs-pm.h     |  126 ++
>  arch/unicore32/include/asm/mach/regs-ps2.h    |   20 +
>  arch/unicore32/include/asm/mach/regs-resetc.h |   34 +
>  arch/unicore32/include/asm/mach/regs-rtc.h    |   37 +
>  arch/unicore32/include/asm/mach/regs-sdc.h    |  156 ++
>  arch/unicore32/include/asm/mach/regs-spi.h    |   98 ++
>  arch/unicore32/include/asm/mach/regs-uart.h   |    3 +
>  arch/unicore32/include/asm/mach/regs-umal.h   |  229 +++
>  arch/unicore32/include/asm/mach/regs-unigfx.h |  200 +++
>  arch/unicore32/include/asm/pci.h              |   46 +
>  arch/unicore32/kernel/pci.c                   |  404 +++++
>  arch/unicore32/kernel/puv3-core.c             |  266 ++++
>  arch/unicore32/kernel/puv3-nb0916.c           |  183 +++
>  arch/unicore32/kernel/puv3-smw0919.c          |  120 ++
>  drivers/input/keyboard/Kconfig                |   11 +
>  drivers/input/keyboard/atkbd.c                |    4 +
>  drivers/input/mouse/psmouse-base.c            |   41 +
>  drivers/input/serio/i8042.h                   |    2 +
>  drivers/pci/Makefile                          |    1 +
>  drivers/staging/puv3/Kconfig                  |  142 ++
>  drivers/staging/puv3/Makefile                 |   27 +
>  drivers/staging/puv3/TODO                     |    7 +
>  drivers/staging/puv3/i8042-ucio.h             |   96 ++
>  drivers/staging/puv3/nb0916-atkbd.h           |   43 +
>  drivers/staging/puv3/puv3_ac97.c              |  383 +++++
>  drivers/staging/puv3/puv3_i2c.c               |  325 ++++
>  drivers/staging/puv3/puv3_pcm.c               |  449 ++++++
>  drivers/staging/puv3/puv3_pcm.h               |   33 +
>  drivers/staging/puv3/puv3_umal.c              | 2082 +++++++++++++++++++++++++
>  drivers/staging/puv3/puv3_unifb.c             |  972 ++++++++++++
>  include/linux/fb.h                            |    2 +
>  42 files changed, 7254 insertions(+), 0 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


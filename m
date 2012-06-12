Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2FLKb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:31:59 -0400
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:42539 "HELO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751561Ab2FLKb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:31:57 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2012 06:31:57 EDT
From: Vinh Huu Tuong Nguyen <vhtnguyen@apm.com>
References: <1336362768-31326-1-git-send-email-vhtnguyen@apm.com>
In-Reply-To: <1336362768-31326-1-git-send-email-vhtnguyen@apm.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0sBPN6GOHBoxD8R7S3u7U56V/sNAcf3fSg
Date: Tue, 12 Jun 2012 17:26:25 +0700
Message-ID: <da2d8ae5f5008c4695d1898b9e121c1f@mail.gmail.com>
Subject: RE: [PATCH] powerpc/44x: Support OCM(On Chip Memory) for APM821xx SoC
 and Bluestone board
To: Vinh Huu Tuong Nguyen <vhtnguyen@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Duc Dang <dhdang@apm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kumar Gala <galak@kernel.crashing.org>, Li Yang <leoli@freescale.com>,
        Ashish Kalra <ashish.kalra@freescale.com>,
        Anatolij Gustschin <agust@denx.de>, Liu Gang <Gang.Liu@freescale.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Vinh Nguyen Huu Tuong [mailto:vhtnguyen@apm.com]
> Sent: Monday, May 07, 2012 10:53 AM
> To: Benjamin Herrenschmidt; Paul Mackerras; Josh Boyer; Matt Porter;
> Grant Likely; Rob Herring; Duc Dang; David S. Miller; Kumar Gala; Li
> Yang; Ashish Kalra; Anatolij Gustschin; Liu Gang; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org
> Cc: Vinh Nguyen Huu Tuong
> Subject: [PATCH] powerpc/44x: Support OCM(On Chip Memory) for APM821xx
> SoC and Bluestone board
>
> This patch consists of:
> - Add driver for OCM component
> - Export OCM Information at /sys/class/ocm/ocminfo
>
> Signed-off-by: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
> ---
>  arch/powerpc/boot/dts/bluestone.dts   |    8 +
>  arch/powerpc/include/asm/ppc4xx_ocm.h |   47 ++++
>  arch/powerpc/platforms/44x/Kconfig    |    8 +
>  arch/powerpc/sysdev/Makefile          |    1 +
>  arch/powerpc/sysdev/ppc4xx_ocm.c      |  420
> +++++++++++++++++++++++++++++++++
>  5 files changed, 484 insertions(+), 0 deletions(-)  create mode 100644
> arch/powerpc/include/asm/ppc4xx_ocm.h
>  create mode 100644 arch/powerpc/sysdev/ppc4xx_ocm.c
>
> diff --git a/arch/powerpc/boot/dts/bluestone.dts
> b/arch/powerpc/boot/dts/bluestone.dts
> index 7bda373..2687c11 100644
> --- a/arch/powerpc/boot/dts/bluestone.dts
> +++ b/arch/powerpc/boot/dts/bluestone.dts
> @@ -107,6 +107,14 @@
>  		interrupt-parent = <&UIC0>;
>  	};
>
> +	OCM1: ocm@400040000 {
> +		compatible = "ibm,ocm";
> +		status = "ok";
> +		cell-index = <1>;
> +		/* configured in U-Boot */
> +		reg = <4 0x00040000 0x8000>; /* 32K */
> +	};
> +
>  	SDR0: sdr {
>  		compatible = "ibm,sdr-apm821xx";
>  		dcr-reg = <0x00e 0x002>;
> diff --git a/arch/powerpc/include/asm/ppc4xx_ocm.h
> b/arch/powerpc/include/asm/ppc4xx_ocm.h
> new file mode 100644
> index 0000000..ff7f386
> --- /dev/null
> +++ b/arch/powerpc/include/asm/ppc4xx_ocm.h
> @@ -0,0 +1,47 @@
> +/*
> + * PowerPC 4xx OCM memory allocation support
> + *
> + * (C) Copyright 2009, Applied Micro Circuits Corporation
> + * Victor Gallardo (vgallardo@amcc.com)
> + *
> + * See file CREDITS for list of people who contributed to this
> + * project.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> + * MA 02111-1307 USA
> + */
> +
> +#ifndef __ASM_POWERPC_PPC4xx_OCM_H__
> +#define __ASM_POWERPC_PPC4xx_OCM_H__
> +
> +#include <linux/types.h>
> +
> +#define OCM_NON_CACHED 0
> +#define OCM_CACHED     1
> +
> +#if defined(CONFIG_PPC4xx_OCM)
> +
> +void *ocm_alloc(phys_addr_t *phys, int size, int align,
> +		  int flags, const char *owner);
> +void ocm_free(const void *virt);
> +
> +#else
> +
> +#define ocm_alloc(phys, size, align, flags, owner)	NULL
> +#define ocm_free(addr)	((void)0)
> +
> +#endif /* CONFIG_PPC4xx_OCM */
> +
> +#endif  /* __ASM_POWERPC_PPC4xx_OCM_H__ */
> diff --git a/arch/powerpc/platforms/44x/Kconfig
> b/arch/powerpc/platforms/44x/Kconfig
> index 2e4e64a..6b1a64e 100644
> --- a/arch/powerpc/platforms/44x/Kconfig
> +++ b/arch/powerpc/platforms/44x/Kconfig
> @@ -250,6 +250,14 @@ config PPC4xx_GPIO
>  	help
>  	  Enable gpiolib support for ppc440 based boards
>
> +config PPC4xx_OCM
> +	bool "PPC4xx On Chip Memory (OCM) support"
> +	depends on 4xx
> +	select PPC_LIB_RHEAP
> +	help
> +	  Enable OCM support for PowerPC 4xx platforms with on chip
> memory,
> +	  OCM provides the fast place for memory access to improve
> performance.
> +
>  # 44x specific CPU modules, selected based on the board above.
>  config 440EP
>  	bool
> diff --git a/arch/powerpc/sysdev/Makefile
> b/arch/powerpc/sysdev/Makefile index 1bd7ecb..6f768e2 100644
> --- a/arch/powerpc/sysdev/Makefile
> +++ b/arch/powerpc/sysdev/Makefile
> @@ -37,6 +37,7 @@ obj-$(CONFIG_PPC_INDIRECT_PCI)	+= indirect_pci.o
>  obj-$(CONFIG_PPC_I8259)		+= i8259.o
>  obj-$(CONFIG_IPIC)		+= ipic.o
>  obj-$(CONFIG_4xx)		+= uic.o
> +obj-$(CONFIG_PPC4xx_OCM)	+= ppc4xx_ocm.o
>  obj-$(CONFIG_4xx_SOC)		+= ppc4xx_soc.o
>  obj-$(CONFIG_XILINX_VIRTEX)	+= xilinx_intc.o
>  obj-$(CONFIG_XILINX_PCI)	+= xilinx_pci.o
> diff --git a/arch/powerpc/sysdev/ppc4xx_ocm.c
> b/arch/powerpc/sysdev/ppc4xx_ocm.c
> new file mode 100644
> index 0000000..ba3e450
> --- /dev/null
> +++ b/arch/powerpc/sysdev/ppc4xx_ocm.c
> @@ -0,0 +1,420 @@
> +/*
> + * PowerPC 4xx OCM memory allocation support
> + *
> + * (C) Copyright 2009, Applied Micro Circuits Corporation
> + * Victor Gallardo (vgallardo@amcc.com)
> + *
> + * See file CREDITS for list of people who contributed to this
> + * project.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> + * MA 02111-1307 USA
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
> +#include <linux/spinlock.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/list.h>
> +#include <asm/uaccess.h>
> +#include <asm/prom.h>
> +#include <asm/dcr.h>
> +#include <asm/rheap.h>
> +#include <asm/mmu.h>
> +#include <asm/ppc4xx_ocm.h>
> +#include <linux/export.h>
> +
> +#define OCM_DISABLED	0
> +#define OCM_ENABLED		1
> +
> +struct ocm_block {
> +	struct list_head	list;
> +	void __iomem		*addr;
> +	int					size;
> +	const char			*owner;
> +};
> +
> +/* non-cached or cached region */
> +struct ocm_region {
> +	phys_addr_t			phys;
> +	void __iomem		*virt;
> +
> +	int					memtotal;
> +	int					memfree;
> +
> +	rh_info_t			*rh;
> +	struct list_head	list;
> +};
> +
> +struct ocm_info {
> +	int			index;
> +	int			status;
> +	int			ready;
> +
> +	phys_addr_t		phys;
> +
> +	int			alignment;
> +	int			memtotal;
> +	int			cache_size;
> +
> +	struct ocm_region	nc;	/* non-cached region */
> +	struct ocm_region	c;	/* cached region */
> +};
> +
> +static struct ocm_info *ocm_nodes;
> +static int ocm_count;
> +
> +static struct ocm_info *ocm_get_node(unsigned int index) {
> +	if (index >= ocm_count) {
> +		printk(KERN_ERR "OCM: invalid index");
> +		return NULL;
> +	}
> +
> +	return &ocm_nodes[index];
> +}
> +
> +void *ocm_alloc(phys_addr_t *phys, int size, int align,
> +		  int flags, const char *owner)
> +{
> +	void __iomem *addr = NULL;
> +	unsigned long offset;
> +	struct ocm_info *ocm;
> +	struct ocm_region *ocm_reg;
> +	struct ocm_block *ocm_blk;
> +	int i;
> +
> +	for (i = 0; i < ocm_count; i++) {
> +		ocm = ocm_get_node(i);
> +
> +		if (!ocm || !ocm->ready)
> +			continue;
> +
> +		if (flags == OCM_NON_CACHED)
> +			ocm_reg = &ocm->nc;
> +		else
> +			ocm_reg = &ocm->c;
> +
> +		if (!ocm_reg->virt)
> +			continue;
> +
> +		if (align < ocm->alignment)
> +			align = ocm->alignment;
> +
> +		offset = rh_alloc_align(ocm_reg->rh, size, align, NULL);
> +
> +		if (IS_ERR_VALUE(offset))
> +			continue;
> +
> +		ocm_blk = kzalloc(sizeof(struct ocm_block *), GFP_KERNEL);
> +		if (!ocm_blk) {
> +			printk(KERN_ERR "OCM: could not allocate ocm
block");
> +			rh_free(ocm_reg->rh, offset);
> +			break;
> +		}
> +
> +		*phys = ocm_reg->phys + offset;
> +		addr = ocm_reg->virt + offset;
> +		size = ALIGN(size, align);
> +
> +		ocm_blk->addr = addr;
> +		ocm_blk->size = size;
> +		ocm_blk->owner = owner;
> +		list_add_tail(&ocm_blk->list, &ocm_reg->list);
> +
> +		ocm_reg->memfree -= size;
> +
> +		break;
> +	}
> +
> +	return addr;
> +}
> +
> +static int ocm_free_region(struct ocm_region *ocm_reg, const void
> +*addr) {
> +	struct ocm_block *blk, *tmp;
> +	unsigned long offset;
> +
> +	if (!ocm_reg->virt)
> +		return 0;
> +
> +	list_for_each_entry_safe(blk, tmp, &ocm_reg->list, list) {
> +		if (blk->addr == addr) {
> +			offset = addr - ocm_reg->virt;
> +			ocm_reg->memfree += blk->size;
> +			rh_free(ocm_reg->rh, offset);
> +			list_del(&blk->list);
> +			kfree(blk);
> +			return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +void ocm_free(const void *addr)
> +{
> +	int i;
> +
> +	if (!addr)
> +		return;
> +
> +	for (i = 0; i < ocm_count; i++) {
> +		struct ocm_info *ocm = ocm_get_node(i);
> +
> +		if (!ocm || !ocm->ready)
> +			continue;
> +
> +		if (ocm_free_region(&ocm->nc, addr) ||
> +		    ocm_free_region(&ocm->c, addr))
> +			return;
> +	}
> +}
> +
> +static void __init ocm_init_node(int count, struct device_node *node)
> {
> +	struct ocm_info *ocm;
> +
> +	const unsigned int *cell_index;
> +	const unsigned int *cache_size;
> +	int len;
> +
> +	struct resource rsrc;
> +	int ioflags;
> +
> +	ocm = ocm_get_node(count);
> +
> +	cell_index = of_get_property(node, "cell-index", &len);
> +	if (!cell_index) {
> +		printk(KERN_ERR "OCM: missing cell-index property");
> +		return;
> +	}
> +	ocm->index = *cell_index;
> +
> +	if (of_device_is_available(node))
> +		ocm->status = OCM_ENABLED;
> +
> +	cache_size = of_get_property(node, "cached-region-size", &len);
> +	if (cache_size)
> +		ocm->cache_size = *cache_size;
> +
> +	if (of_address_to_resource(node, 0, &rsrc)) {
> +		printk(KERN_ERR "OCM%d: could not get resource address\n",
> +			ocm->index);
> +		return;
> +	}
> +
> +	ocm->phys = rsrc.start;
> +	ocm->memtotal = (rsrc.end - rsrc.start + 1);
> +
> +	printk(KERN_INFO "OCM%d: %d Bytes (%s)\n",
> +		ocm->index, ocm->memtotal,
> +		(ocm->status == OCM_DISABLED) ? "disabled" : "enabled");
> +
> +	if (ocm->status == OCM_DISABLED)
> +		return;
> +
> +	/* request region */
> +
> +	if (!request_mem_region(ocm->phys, ocm->memtotal, "ppc4xx_ocm"))
> {
> +		printk(KERN_ERR "OCM%d: could not request region\n",
> +			ocm->index);
> +		return;
> +	}
> +
> +	/* Configure non-cached and cached regions */
> +
> +	ocm->nc.phys = ocm->phys;
> +	ocm->nc.memtotal = ocm->memtotal - ocm->cache_size;
> +	ocm->nc.memfree = ocm->nc.memtotal;
> +
> +	ocm->c.phys = ocm->phys + ocm->nc.memtotal;
> +	ocm->c.memtotal = ocm->cache_size;
> +	ocm->c.memfree = ocm->c.memtotal;
> +
> +	if (ocm->nc.memtotal == 0)
> +		ocm->nc.phys = 0;
> +
> +	if (ocm->c.memtotal == 0)
> +		ocm->c.phys = 0;
> +
> +	printk(KERN_INFO "OCM%d: %d Bytes (non-cached)\n",
> +		ocm->index, ocm->nc.memtotal);
> +
> +	printk(KERN_INFO "OCM%d: %d Bytes (cached)\n",
> +		ocm->index, ocm->c.memtotal);
> +
> +	/* ioremap the non-cached region */
> +	if (ocm->nc.memtotal) {
> +		ioflags = _PAGE_NO_CACHE | _PAGE_GUARDED | _PAGE_EXEC;
> +		ocm->nc.virt = __ioremap(ocm->nc.phys, ocm->nc.memtotal,
> +					  ioflags);
> +
> +		if (!ocm->nc.virt) {
> +			printk(KERN_ERR
> +			       "OCM%d: failed to ioremap non-cached
> memory\n",
> +			       ocm->index);
> +			ocm->nc.memfree = 0;
> +			return;
> +		}
> +	}
> +
> +	/* ioremap the cached region */
> +
> +	if (ocm->c.memtotal) {
> +		ioflags = _PAGE_EXEC;
> +		ocm->c.virt = __ioremap(ocm->c.phys, ocm->c.memtotal,
> +					 ioflags);
> +
> +		if (!ocm->c.virt) {
> +			printk(KERN_ERR
> +			       "OCM%d: failed to ioremap cached memory\n",
> +			       ocm->index);
> +			ocm->c.memfree = 0;
> +			return;
> +		}
> +	}
> +
> +	/* Create Remote Heaps */
> +
> +	ocm->alignment = 4; /* default 4 byte alignment */
> +
> +	if (ocm->nc.virt) {
> +		ocm->nc.rh = rh_create(ocm->alignment);
> +		rh_attach_region(ocm->nc.rh, 0, ocm->nc.memtotal);
> +	}
> +
> +	if (ocm->c.virt) {
> +		ocm->c.rh = rh_create(ocm->alignment);
> +		rh_attach_region(ocm->c.rh, 0, ocm->c.memtotal);
> +	}
> +
> +	INIT_LIST_HEAD(&ocm->nc.list);
> +	INIT_LIST_HEAD(&ocm->c.list);
> +
> +	ocm->ready = 1;
> +
> +	return;
> +}
> +
> +static ssize_t ocm_sysfs_show(struct class *class,
> +			struct class_attribute *attr, char *buf) {
> +	struct ocm_block *blk, *tmp;
> +	unsigned int count, i;
> +
> +	count = 0;
> +	for (i = 0; i < ocm_count; i++) {
> +		struct ocm_info *ocm = ocm_get_node(i);
> +
> +		if (!ocm || !ocm->ready)
> +			continue;
> +
> +		count += sprintf(buf + count, "OCM          : %d\n",
> +							ocm->index);
> +		count += sprintf(buf + count, "PhysAddr     : 0x%llx\n",
> +							ocm->phys);
> +		count += sprintf(buf + count, "MemTotal     : %d Bytes\n",
> +							ocm->memtotal);
> +		count += sprintf(buf + count, "MemTotal(NC) : %d Bytes\n",
> +							ocm->nc.memtotal);
> +		count += sprintf(buf + count, "MemTotal(C)  : %d Bytes\n",
> +							ocm->c.memtotal);
> +
> +		count += sprintf(buf + count, "\n");
> +
> +		count += sprintf(buf + count, "NC.PhysAddr  : 0x%llx\n",
> +							ocm->nc.phys);
> +		count += sprintf(buf + count, "NC.VirtAddr  : 0x%p\n",
> +							ocm->nc.virt);
> +		count += sprintf(buf + count, "NC.MemTotal  : %d Bytes\n",
> +							ocm->nc.memtotal);
> +		count += sprintf(buf + count, "NC.MemFree   : %d Bytes\n",
> +							ocm->nc.memfree);
> +
> +		list_for_each_entry_safe(blk, tmp, &ocm->nc.list, list) {
> +			count += sprintf(buf + count, "NC.MemUsed   : %d
> Bytes (%s)\n",
> +							blk->size,
blk->owner);
> +		}
> +
> +		count += sprintf(buf + count, "\n");
> +
> +		count += sprintf(buf + count, "C.PhysAddr   : 0x%llx\n",
> +							ocm->c.phys);
> +		count += sprintf(buf + count, "C.VirtAddr   : 0x%p\n",
> +							ocm->c.virt);
> +		count += sprintf(buf + count, "C.MemTotal   : %d Bytes\n",
> +							ocm->c.memtotal);
> +		count += sprintf(buf + count, "C.MemFree    : %d Bytes\n",
> +							ocm->c.memfree);
> +
> +		list_for_each_entry_safe(blk, tmp, &ocm->c.list, list) {
> +			count += sprintf(buf + count, "C.MemUsed    : %d
> Bytes (%s)\n",
> +					blk->size, blk->owner);
> +		}
> +
> +		count += sprintf(buf + count, "\n");
> +	}
> +
> +	return count;
> +}
> +
> +static struct class *mem_class;
> +
> +static CLASS_ATTR(ocminfo, S_IRUGO, ocm_sysfs_show, NULL);
> +
> +static int ocm_sysfs_init(void)
> +{
> +	mem_class = class_create(THIS_MODULE, "ocm");
> +	if (IS_ERR(mem_class))
> +		return PTR_ERR(mem_class);
> +
> +	return class_create_file(mem_class, &class_attr_ocminfo); }
> +
> +static int __init ocm_init(void)
> +{
> +	struct device_node *np;
> +	int count;
> +
> +	count = 0;
> +	for_each_compatible_node(np, NULL, "ibm,ocm")
> +		count++;
> +
> +	if (!count)
> +		return 0;
> +
> +	ocm_nodes = kzalloc((count * sizeof(struct ocm_info)),
> GFP_KERNEL);
> +	if (!ocm_nodes) {
> +		printk(KERN_ERR "OCM: failed to allocate OCM nodes!\n");
> +		return -ENOMEM;
> +	}
> +
> +	ocm_count = count;
> +	count = 0;
> +
> +	for_each_compatible_node(np, NULL, "ibm,ocm") {
> +		ocm_init_node(count, np);
> +		count++;
> +	}
> +
> +	ocm_sysfs_init();
> +
> +	return 0;
> +}
> +
> +arch_initcall(ocm_init);
> --
> 1.7.2.5

Hi all reviewers,
One month pass from the day I sent out this patch, but I didn't receive
any comments from you. Could you please do me a favor to take a look on it
and give me your advices?

Best regards,
Vinh Nguyen.

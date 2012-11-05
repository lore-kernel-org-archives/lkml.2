Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811Ab2KEXEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:04:24 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:58199
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab2KEXEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:04:22 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z551biz98dI1432Ic8kzz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
Message-ID: <509845ED.2060904@freescale.com>
Date: Mon, 5 Nov 2012 17:04:13 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Firefox/16.0 SeaMonkey/2.13.1
MIME-Version: 1.0
To: Varun Sethi <Varun.Sethi@freescale.com>
CC: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>
Subject: Re: [PATCH 4/4 v4] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
References: <1352114361-25192-1-git-send-email-Varun.Sethi@freescale.com> <1352114361-25192-2-git-send-email-Varun.Sethi@freescale.com> <1352114361-25192-3-git-send-email-Varun.Sethi@freescale.com> <1352114361-25192-4-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1352114361-25192-4-git-send-email-Varun.Sethi@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Varun Sethi wrote:
> Following is a brief description of the PAMU hardware:
> PAMU determines what action to take and whether to authorize the action on
> the basis of the memory address, a Logical IO Device Number (LIODN), and
> PAACT table (logically) indexed by LIODN and address. Hardware devices which
> need to access memory must provide an LIODN in addition to the memory address.
> 
> Peripheral Access Authorization and Control Tables (PAACTs) are the primary
> data structures used by PAMU. A PAACT is a table of peripheral access
> authorization and control entries (PAACE).Each PAACE defines the range of
> I/O bus address space that is accessible by the LIOD and the associated access
> capabilities.
> 
> There are two types of PAACTs: primary PAACT (PPAACT) and secondary PAACT 
> (SPAACT).A given physical I/O device may be able to act as one or more
> independent logical I/O devices (LIODs). Each such logical I/O device is
> assigned an identifier called logical I/O device number (LIODN). A LIODN is
> allocated a contiguous portion of the I/O bus address space called the DSA window
> for performing DSA operations. The DSA window may optionally be divided into
> multiple sub-windows, each of which may be used to map to a region in system
> storage space. The first sub-window is referred to as the primary sub-window
> and the remaining are called secondary sub-windows.
> 
> This patch provides the PAMU driver (fsl_pamu.c) and the corresponding IOMMU
> API implementation (fsl_pamu_domain.c). The PAMU hardware driver (fsl_pamu.c)
> has been derived from the work done by Ashish Kalra and Timur Tabi
> (timur@freescale.com).
> 
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>

A good chunk of this code was written by me, so please add my
signed-off-by line.

> ---
> changes in v4:
> - Addressed comments from Timur and Scott.
> changes in v3:
> - Addressed comments by Kumar Gala
> - dynamic fspi allocation
> - fixed alignment check in map and unmap
>  drivers/iommu/Kconfig           |    8 +
>  drivers/iommu/Makefile          |    1 +
>  drivers/iommu/fsl_pamu.c        | 1116 +++++++++++++++++++++++++++++++++++++++
>  drivers/iommu/fsl_pamu.h        |  400 ++++++++++++++
>  drivers/iommu/fsl_pamu_domain.c | 1010 +++++++++++++++++++++++++++++++++++
>  drivers/iommu/fsl_pamu_domain.h |  102 ++++

Please document the functions in the .c files.  You have dozens of
non-trivial functions that have no comments whatsoever.

>  6 files changed, 2637 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/iommu/fsl_pamu.c
>  create mode 100644 drivers/iommu/fsl_pamu.h
>  create mode 100644 drivers/iommu/fsl_pamu_domain.c
>  create mode 100644 drivers/iommu/fsl_pamu_domain.h



> +/** 
> + * pamu_disable_liodn() - Clears valid bit of PACCE
> + * @liodn: liodn PAACT index for desired PAACE
> + *
> + * Returns 0 upon success else error code < 0 returned
> + */
> +int pamu_disable_liodn(int liodn)
> +{
> +	paace_t *ppaace;
> +
> +	ppaace = pamu_get_ppaace(liodn);
> +	if (!ppaace) {
> +		pr_err("Invalid primary paace entry\n");
> +		return -ENOENT;
> +	}
> +
> +	set_bf(ppaace->addr_bitfields, PAACE_AF_V, PAACE_V_INVALID);
> +	mb();
> +
> +	return 0;
> +}
> +
> +
> +static unsigned int map_addrspace_size_to_wse(phys_addr_t addrspace_size)
> +{
> +	BUG_ON((addrspace_size & (addrspace_size - 1)));

Add a comment to indicate that you are testing to make sure that
addrspace_size is an even power of 2.

Also, I would just call the variable "size".

> +static int __init fsl_pamu_probe(struct platform_device *pdev)
> +{
> +	void __iomem *pamu_regs = NULL;
> +	struct ccsr_guts __iomem *guts_regs = NULL;
> +	u32 pamubypenr, pamu_counter;
> +	unsigned long pamu_reg_off;
> +	unsigned long pamu_reg_base;
> +	struct device_node *guts_node;
> +	u64 size;
> +	struct page *p;
> +	int ret = 0;
> +	int irq;
> +	phys_addr_t ppaact_phys;
> +	phys_addr_t spaact_phys;
> +	phys_addr_t omt_phys;
> +	size_t mem_size = 0;
> +	unsigned int order = 0;
> +	u32 csd_port_id = 0;
> +	unsigned i;
> +	/*
> +	 * enumerate all PAMUs and allocate and setup PAMU tables
> +	 * for each of them,
> +	 * NOTE : All PAMUs share the same LIODN tables.
> +	 */
> +
> +	pamu_regs = of_iomap(pdev->dev.of_node, 0);
> +	if (!pamu_regs) {
> +		dev_err(&pdev->dev, "ioremap of PAMU node failed\n");
> +		return -ENOMEM;
> +	}
> +	of_get_address(pdev->dev.of_node, 0, &size, NULL);
> +
> +	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> +	if (irq == NO_IRQ) {
> +		dev_warn(&pdev->dev, "no interrupts listed in PAMU node\n");
> +		goto error;
> +	}
> +
> +	ret = request_irq(irq, pamu_av_isr, IRQF_DISABLED, "pamu", NULL);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "error %i installing ISR for irq %i\n",
> +			ret, irq);
> +		goto error;
> +	}
> +
> +	guts_node = of_find_compatible_node(NULL, NULL,
> +			"fsl,qoriq-device-config-1.0");
> +	if (!guts_node) {
> +		dev_err(&pdev->dev, "could not find GUTS node %s\n",
> +			pdev->dev.of_node->full_name);
> +		ret = -ENODEV;
> +		goto error;
> +	}
> +
> +	guts_regs = of_iomap(guts_node, 0);
> +	of_node_put(guts_node);
> +	if (!guts_regs) {
> +		dev_err(&pdev->dev, "ioremap of GUTS node failed\n");
> +		ret = -ENODEV;
> +		goto error;
> +	}
> +
> +	/*
> +	 * To simplify the allocation of a coherency domain, we allocate the
> +	 * PAACT and the OMT in the same memory buffer.  Unfortunately, this
> +	 * wastes more memory compared to allocating the buffers separately.
> +	 */
> +
> +	/* Determine how much memory we need */
> +	mem_size = (PAGE_SIZE << get_order(PAACT_SIZE)) +
> +		(PAGE_SIZE << get_order(SPAACT_SIZE)) +
> +		(PAGE_SIZE << get_order(OMT_SIZE));
> +	order = get_order(mem_size);
> +
> +	p = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
> +	if (!p) {
> +		dev_err(&pdev->dev, "unable to allocate PAACT/SPAACT/OMT block\n");
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +
> +	ppaact = page_address(p);
> +	ppaact_phys = page_to_phys(p);
> +
> +	/* Make sure the memory is naturally aligned */
> +	if (ppaact_phys & ((PAGE_SIZE << order) - 1)) {
> +		dev_err(&pdev->dev, "PAACT/OMT block is unaligned\n");
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +
> +	spaact = (void *)ppaact + (PAGE_SIZE << get_order(PAACT_SIZE));
> +	omt = (void *)spaact + (PAGE_SIZE << get_order(SPAACT_SIZE));
> +
> +	dev_dbg(&pdev->dev, "ppaact virt=%p phys=0x%llx\n", ppaact,
> +		(unsigned long long) ppaact_phys);
> +
> +	/* Check to see if we need to implement the work-around on this SOC */
> +
> +	/* Determine the Port ID for our coherence subdomain */
> +	for (i = 0; i < ARRAY_SIZE(port_id_map); i++) {
> +		if (port_id_map[i].svr == (mfspr(SPRN_SVR) & ~SVR_SECURITY)) {
> +			csd_port_id = port_id_map[i].port_id;
> +			dev_dbg(&pdev->dev, "found matching SVR %08x\n",
> +				port_id_map[i].svr);
> +			break;
> +		}
> +	}
> +
> +	if (csd_port_id) {
> +		dev_dbg(&pdev->dev, "creating coherency subdomain at address "
> +			"0x%llx, size %zu, port id 0x%08x", ppaact_phys,
> +			mem_size, csd_port_id);
> +
> +		ret = create_csd(ppaact_phys, mem_size, csd_port_id);
> +		if (ret) {
> +			dev_err(&pdev->dev, "could not create coherence "
> +				"subdomain\n");
> +			return ret;
> +		}
> +	}
> +
> +	spaact_phys = virt_to_phys(spaact);
> +	omt_phys = virt_to_phys(omt);
> +
> +	spaace_pool = gen_pool_create(ilog2(sizeof(paace_t)), -1);
> +	if (!spaace_pool) {
> +		ret = -ENOMEM;
> +		pr_err("PAMU : failed to allocate spaace gen pool\n");

dev_err

> diff --git a/drivers/iommu/fsl_pamu.h b/drivers/iommu/fsl_pamu.h
> new file mode 100644
> index 0000000..5f15b35
> --- /dev/null
> +++ b/drivers/iommu/fsl_pamu.h
> @@ -0,0 +1,400 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License, version 2, as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + *
> + * Copyright (C) 2012 Freescale Semiconductor, Inc.

Don't use "(C)", it's redundant.

> + *
> + */
> +
> +#ifndef __FSL_PAMU_H
> +#define __FSL_PAMU_H
> +
> +/* Bit Field macros
> + * 	v = bit field variable; m = mask, m##_SHIFT = shift, x = value to load
> + */
> +#define set_bf(v, m, x)		(v = ((v) & ~(m)) | (((x) << (m##_SHIFT)) & (m)))
> +#define get_bf(v, m)		(((v) & (m)) >> (m##_SHIFT))
> +
> +/* PAMU CCSR space */
> +#define PAMU_PGC 0x00000000     /* Allows all peripheral accesses */
> +#define PAMU_PE 0x40000000      /* enable PAMU                    */
> +
> +/* PAMU_OFFSET to the next pamu space in ccsr */
> +#define PAMU_OFFSET 0x1000
> +
> +#define PAMU_MMAP_REGS_BASE 0
> +
> +struct pamu_mmap_regs {
> +	u32 ppbah;
> +	u32 ppbal;
> +	u32 pplah;
> +	u32 pplal;
> +	u32 spbah;
> +	u32 spbal;
> +	u32 splah;
> +	u32 splal;
> +	u32 obah;
> +	u32 obal;
> +	u32 olah;
> +	u32 olal;
> +};
> +
> +/* PAMU Error Registers */
> +#define PAMU_POES1 0x0040
> +#define PAMU_POES2 0x0044
> +#define PAMU_POEAH 0x0048
> +#define PAMU_POEAL 0x004C
> +#define PAMU_AVS1  0x0050
> +#define PAMU_AVS1_AV    0x1
> +#define PAMU_AVS1_OTV   0x6
> +#define PAMU_AVS1_APV   0x78
> +#define PAMU_AVS1_WAV   0x380
> +#define PAMU_AVS1_LAV   0x1c00
> +#define PAMU_AVS1_GCV   0x2000
> +#define PAMU_AVS1_PDV   0x4000
> +#define PAMU_AV_MASK    (PAMU_AVS1_AV | PAMU_AVS1_OTV | PAMU_AVS1_APV | PAMU_AVS1_WAV \
> +			| PAMU_AVS1_LAV | PAMU_AVS1_GCV | PAMU_AVS1_PDV)
> +#define PAMU_AVS1_LIODN_SHIFT 16
> +#define PAMU_LAV_LIODN_NOT_IN_PPAACT 0x400
> +
> +#define PAMU_AVS2  0x0054
> +#define PAMU_AVAH  0x0058
> +#define PAMU_AVAL  0x005C
> +#define PAMU_EECTL 0x0060
> +#define PAMU_EEDIS 0x0064
> +#define PAMU_EEINTEN 0x0068
> +#define PAMU_EEDET 0x006C
> +#define PAMU_EEATTR 0x0070
> +#define PAMU_EEAHI 0x0074
> +#define PAMU_EEALO 0x0078
> +#define PAMU_EEDHI 0X007C
> +#define PAMU_EEDLO 0x0080
> +#define PAMU_EECC  0x0084
> +
> +/* PAMU Revision Registers */
> +#define PAMU_PR1 0x0BF8
> +#define PAMU_PR2 0x0BFC
> +
> +/* PAMU Capabilities Registers */
> +#define PAMU_PC1 0x0C00
> +#define PAMU_PC2 0x0C04
> +#define PAMU_PC3 0x0C08
> +#define PAMU_PC4 0x0C0C
> +
> +/* PAMU Control Register */
> +#define PAMU_PC 0x0C10
> +
> +/* PAMU control defs */
> +#define PAMU_CONTROL 0x0C10
> +#define PAMU_PC_PGC 0x80000000 /* 1 = PAMU Gate Closed : block all
> +peripheral access, 0 : may allow peripheral access */

This is not a proper multi-line comment.  Also, it does not match the
value of the the macro.

> +
> +#define PAMU_PC_PE   0x40000000 /* 0 = PAMU disabled, 1 = PAMU enabled */

This comment does not match the value of the the macro.

> +#define PAMU_PC_SPCC 0x00000010 /* sPAACE cache enable */
> +#define PAMU_PC_PPCC 0x00000001 /* pPAACE cache enable */
> +#define PAMU_PC_OCE  0x00001000 /* OMT cache enable */
> +
> +#define PAMU_PFA1 0x0C14
> +#define PAMU_PFA2 0x0C18
> +
> +#define PAMU_PC3_MWCE(X) (((X) >> 21) & 0xf)
> +
> +/* PAMU Interrupt control and Status Register */
> +#define PAMU_PICS 0x0C1C
> +#define PAMU_ACCESS_VIOLATION_STAT   0x8
> +#define PAMU_ACCESS_VIOLATION_ENABLE 0x4
> +
> +/* PAMU Debug Registers */
> +#define PAMU_PD1 0x0F00
> +#define PAMU_PD2 0x0F04
> +#define PAMU_PD3 0x0F08
> +#define PAMU_PD4 0x0F0C
> +
> +#define PAACE_AP_PERMS_DENIED  0x0
> +#define PAACE_AP_PERMS_QUERY   0x1
> +#define PAACE_AP_PERMS_UPDATE  0x2
> +#define PAACE_AP_PERMS_ALL     0x3
> +
> +#define PAACE_DD_TO_HOST       0x0
> +#define PAACE_DD_TO_IO         0x1
> +#define PAACE_PT_PRIMARY       0x0
> +#define PAACE_PT_SECONDARY     0x1
> +#define PAACE_V_INVALID        0x0
> +#define PAACE_V_VALID          0x1
> +#define PAACE_MW_SUBWINDOWS    0x1
> +
> +#define PAACE_WSE_4K           0xB
> +#define PAACE_WSE_8K           0xC
> +#define PAACE_WSE_16K          0xD
> +#define PAACE_WSE_32K          0xE
> +#define PAACE_WSE_64K          0xF
> +#define PAACE_WSE_128K         0x10
> +#define PAACE_WSE_256K         0x11
> +#define PAACE_WSE_512K         0x12
> +#define PAACE_WSE_1M           0x13
> +#define PAACE_WSE_2M           0x14
> +#define PAACE_WSE_4M           0x15
> +#define PAACE_WSE_8M           0x16
> +#define PAACE_WSE_16M          0x17
> +#define PAACE_WSE_32M          0x18
> +#define PAACE_WSE_64M          0x19
> +#define PAACE_WSE_128M         0x1A
> +#define PAACE_WSE_256M         0x1B
> +#define PAACE_WSE_512M         0x1C
> +#define PAACE_WSE_1G           0x1D
> +#define PAACE_WSE_2G           0x1E
> +#define PAACE_WSE_4G           0x1F
> +
> +#define PAACE_DID_PCI_EXPRESS_1 0x00
> +#define PAACE_DID_PCI_EXPRESS_2 0x01
> +#define PAACE_DID_PCI_EXPRESS_3 0x02
> +#define PAACE_DID_PCI_EXPRESS_4 0x03
> +#define PAACE_DID_LOCAL_BUS     0x04
> +#define PAACE_DID_SRIO          0x0C
> +#define PAACE_DID_MEM_1         0x10
> +#define PAACE_DID_MEM_2         0x11
> +#define PAACE_DID_MEM_3         0x12
> +#define PAACE_DID_MEM_4         0x13
> +#define PAACE_DID_MEM_1_2       0x14
> +#define PAACE_DID_MEM_3_4       0x15
> +#define PAACE_DID_MEM_1_4       0x16
> +#define PAACE_DID_BM_SW_PORTAL  0x18
> +#define PAACE_DID_PAMU          0x1C
> +#define PAACE_DID_CAAM          0x21
> +#define PAACE_DID_QM_SW_PORTAL  0x3C
> +#define PAACE_DID_CORE0_INST    0x80
> +#define PAACE_DID_CORE0_DATA    0x81
> +#define PAACE_DID_CORE1_INST    0x82
> +#define PAACE_DID_CORE1_DATA    0x83
> +#define PAACE_DID_CORE2_INST    0x84
> +#define PAACE_DID_CORE2_DATA    0x85
> +#define PAACE_DID_CORE3_INST    0x86
> +#define PAACE_DID_CORE3_DATA    0x87
> +#define PAACE_DID_CORE4_INST    0x88
> +#define PAACE_DID_CORE4_DATA    0x89
> +#define PAACE_DID_CORE5_INST    0x8A
> +#define PAACE_DID_CORE5_DATA    0x8B
> +#define PAACE_DID_CORE6_INST    0x8C
> +#define PAACE_DID_CORE6_DATA    0x8D
> +#define PAACE_DID_CORE7_INST    0x8E
> +#define PAACE_DID_CORE7_DATA    0x8F
> +#define PAACE_DID_BROADCAST     0xFF
> +
> +#define PAACE_ATM_NO_XLATE      0x00
> +#define PAACE_ATM_WINDOW_XLATE  0x01
> +#define PAACE_ATM_PAGE_XLATE    0x02
> +#define PAACE_ATM_WIN_PG_XLATE  \
> +                ( PAACE_ATM_WINDOW_XLATE | PAACE_ATM_PAGE_XLATE )
> +#define PAACE_OTM_NO_XLATE      0x00
> +#define PAACE_OTM_IMMEDIATE     0x01
> +#define PAACE_OTM_INDEXED       0x02
> +#define PAACE_OTM_RESERVED      0x03
> +
> +#define PAACE_M_COHERENCE_REQ   0x01
> +
> +#define PAACE_PID_0             0x0
> +#define PAACE_PID_1             0x1
> +#define PAACE_PID_2             0x2
> +#define PAACE_PID_3             0x3
> +#define PAACE_PID_4             0x4
> +#define PAACE_PID_5             0x5
> +#define PAACE_PID_6             0x6
> +#define PAACE_PID_7             0x7
> +
> +#define PAACE_TCEF_FORMAT0_8B   0x00
> +#define PAACE_TCEF_FORMAT1_RSVD 0x01
> +
> +#define PAACE_NUMBER_ENTRIES    0xFF
> +
> +#define	OME_NUMBER_ENTRIES      16
> +
> +#define SPAACE_NUMBER_ENTRIES   0x8000
> +
> +/* PAACE Bit Field Defines */
> +#define PPAACE_AF_WBAL			0xfffff000
> +#define PPAACE_AF_WBAL_SHIFT		12
> +#define PPAACE_AF_WSE			0x00000fc0
> +#define PPAACE_AF_WSE_SHIFT		6
> +#define PPAACE_AF_MW			0x00000020
> +#define PPAACE_AF_MW_SHIFT		5
> +
> +#define SPAACE_AF_LIODN			0xffff0000
> +#define SPAACE_AF_LIODN_SHIFT		16
> +
> +#define PAACE_AF_AP			0x00000018
> +#define PAACE_AF_AP_SHIFT		3
> +#define PAACE_AF_DD			0x00000004
> +#define PAACE_AF_DD_SHIFT		2
> +#define PAACE_AF_PT			0x00000002
> +#define PAACE_AF_PT_SHIFT		1
> +#define PAACE_AF_V			0x00000001
> +#define PAACE_AF_V_SHIFT		0
> +
> +#define PAACE_DA_HOST_CR		0x80
> +#define PAACE_DA_HOST_CR_SHIFT		7
> +
> +#define PAACE_IA_CID			0x00FF0000
> +#define PAACE_IA_CID_SHIFT		16
> +#define PAACE_IA_WCE			0x000000F0
> +#define PAACE_IA_WCE_SHIFT		4
> +#define PAACE_IA_ATM			0x0000000C
> +#define PAACE_IA_ATM_SHIFT		2
> +#define PAACE_IA_OTM			0x00000003
> +#define PAACE_IA_OTM_SHIFT		0
> +
> +#define PAACE_WIN_TWBAL			0xfffff000
> +#define PAACE_WIN_TWBAL_SHIFT		12
> +#define PAACE_WIN_SWSE			0x00000fc0
> +#define PAACE_WIN_SWSE_SHIFT		6
> +
> +/* PAMU Data Structures */
> +/* primary / secondary paact structure */
> +typedef struct paace_t {

No typedefs for new structures in kernel code.

> +	/* PAACE Offset 0x00 */
> +	u32 wbah;				/* only valid for Primary PAACE */
> +	u32 addr_bitfields;		/* See P/S PAACE_AF_* */
> +
> +	/* PAACE Offset 0x08 */
> +	/* Interpretation of first 32 bits dependent on DD above */
> +	union {
> +		struct {
> +			/* Destination ID, see PAACE_DID_* defines */
> +			u8 did;
> +			/* Partition ID */
> +			u8 pid;
> +			/* Snoop ID */
> +			u8 snpid;
> +			/* coherency_required : 1 reserved : 7 */

Please use this format, which is easier to read:

			/* 1 == coherency required, 7 == reserved */

Every time I look at this comment, I think you are using bitfields.

> +			u8 coherency_required; /* See PAACE_DA_* */
> +		} to_host;
> +		struct {
> +			/* Destination ID, see PAACE_DID_* defines */
> +			u8  did;
> +			u8  reserved1;
> +			u16 reserved2;
> +		} to_io;
> +	} domain_attr;
> +
> +	/* Implementation attributes + window count + address & operation translation modes */
> +	u32 impl_attr;			/* See PAACE_IA_* */
> +
> +	/* PAACE Offset 0x10 */
> +	/* Translated window base address */
> +	u32 twbah;
> +	u32 win_bitfields;			/* See PAACE_WIN_* */
> +
> +	/* PAACE Offset 0x18 */
> +	/* first secondary paace entry */
> +	u32 fspi;				/* only valid for Primary PAACE */
> +	union {
> +		struct {
> +			u8 ioea;
> +			u8 moea;
> +			u8 ioeb;
> +			u8 moeb;
> +		} immed_ot;
> +		struct {
> +			u16 reserved;
> +			u16 omi;
> +		} index_ot;
> +	} op_encode;
> +
> +	/* PAACE Offsets 0x20-0x38 */
> +	u32 reserved[8];			/* not currently implemented */
> +} paace_t;
> +
> +/* OME : Operation mapping entry
> + * MOE : Mapped Operation Encodings
> + * The operation mapping table is table containing operation mapping entries (OME).
> + * The index of a particular OME is programmed in the PAACE entry for translation
> + * in bound I/O operations corresponding to an LIODN. The OMT is used for translation
> + * specifically in case of the indexed translation mode. Each OME contains a 128
> + * byte mapped operation encoding (MOE), where each byte represents an MOE. 
> + */
> +#define NUM_MOE 128
> +struct ome {
> +	u8 moe[NUM_MOE];
> +} __attribute__((packed));
> +
> +#define PAACT_SIZE              (sizeof(paace_t) * PAACE_NUMBER_ENTRIES)
> +#define OMT_SIZE                (sizeof(struct ome) * OME_NUMBER_ENTRIES)
> +#define SPAACT_SIZE             (sizeof(paace_t) * SPAACE_NUMBER_ENTRIES)
> +
> +#define PAMU_PAGE_SHIFT 12
> +#define PAMU_PAGE_SIZE  4096ULL
> +
> +#define IOE_READ        0x00
> +#define IOE_READ_IDX    0x00
> +#define IOE_WRITE       0x81
> +#define IOE_WRITE_IDX   0x01
> +#define IOE_EREAD0      0x82    /* Enhanced read type 0 */
> +#define IOE_EREAD0_IDX  0x02    /* Enhanced read type 0 */
> +#define IOE_EWRITE0     0x83    /* Enhanced write type 0 */
> +#define IOE_EWRITE0_IDX 0x03    /* Enhanced write type 0 */
> +#define IOE_DIRECT0     0x84    /* Directive type 0 */
> +#define IOE_DIRECT0_IDX 0x04    /* Directive type 0 */
> +#define IOE_EREAD1      0x85    /* Enhanced read type 1 */
> +#define IOE_EREAD1_IDX  0x05    /* Enhanced read type 1 */
> +#define IOE_EWRITE1     0x86    /* Enhanced write type 1 */
> +#define IOE_EWRITE1_IDX 0x06    /* Enhanced write type 1 */
> +#define IOE_DIRECT1     0x87    /* Directive type 1 */
> +#define IOE_DIRECT1_IDX 0x07    /* Directive type 1 */
> +#define IOE_RAC         0x8c    /* Read with Atomic clear */
> +#define IOE_RAC_IDX     0x0c    /* Read with Atomic clear */
> +#define IOE_RAS         0x8d    /* Read with Atomic set */
> +#define IOE_RAS_IDX     0x0d    /* Read with Atomic set */
> +#define IOE_RAD         0x8e    /* Read with Atomic decrement */
> +#define IOE_RAD_IDX     0x0e    /* Read with Atomic decrement */
> +#define IOE_RAI         0x8f    /* Read with Atomic increment */
> +#define IOE_RAI_IDX     0x0f    /* Read with Atomic increment */
> +
> +#define EOE_READ        0x00
> +#define EOE_WRITE       0x01
> +#define EOE_RAC         0x0c    /* Read with Atomic clear */
> +#define EOE_RAS         0x0d    /* Read with Atomic set */
> +#define EOE_RAD         0x0e    /* Read with Atomic decrement */
> +#define EOE_RAI         0x0f    /* Read with Atomic increment */
> +#define EOE_LDEC        0x10    /* Load external cache */
> +#define EOE_LDECL       0x11    /* Load external cache with stash lock */
> +#define EOE_LDECPE      0x12    /* Load external cache with preferred exclusive */
> +#define EOE_LDECPEL     0x13    /* Load external cache with preferred exclusive and lock */
> +#define EOE_LDECFE      0x14    /* Load external cache with forced exclusive */
> +#define EOE_LDECFEL     0x15    /* Load external cache with forced exclusive and lock */
> +#define EOE_RSA         0x16    /* Read with stash allocate */
> +#define EOE_RSAU        0x17    /* Read with stash allocate and unlock */
> +#define EOE_READI       0x18    /* Read with invalidate */
> +#define EOE_RWNITC      0x19    /* Read with no intention to cache */
> +#define EOE_WCI         0x1a    /* Write cache inhibited */
> +#define EOE_WWSA        0x1b    /* Write with stash allocate */
> +#define EOE_WWSAL       0x1c    /* Write with stash allocate and lock */
> +#define EOE_WWSAO       0x1d    /* Write with stash allocate only */
> +#define EOE_WWSAOL      0x1e    /* Write with stash allocate only and lock */
> +#define EOE_VALID       0x80

Do you need to define all of these macros in this header file?  Can't you
define them in the .c file that uses them?  Please try to move as many
macros as you can into .c files.

> +
> +/* Function prototypes */
> +int pamu_domain_init(void);
> +int pamu_enable_liodn(int liodn);
> +int pamu_disable_liodn(int liodn);
> +void pamu_free_subwins(int liodn);
> +int pamu_config_ppaace(int liodn, phys_addr_t win_addr, phys_addr_t win_size,
> +		       u32 omi, unsigned long rpn, u32 snoopid, uint32_t stashid,
> +		       u32 subwin_cnt, int prot);
> +int pamu_config_spaace(int liodn, u32 subwin_cnt, u32 subwin_addr,
> +		       phys_addr_t subwin_size, u32 omi, unsigned long rpn,
> +		       uint32_t snoopid, u32 stashid, int enable, int prot);
> +
> +u32 get_stash_id(u32 stash_dest_hint, u32 vcpu);
> +void get_ome_index(u32 *omi_index, struct device *dev);
> +int  pamu_update_paace_stash(int liodn, u32 subwin, u32 value);
> +
> +#endif  /* __FSL_PAMU_H */
> diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
> new file mode 100644
> index 0000000..b8bc983
> --- /dev/null
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -0,0 +1,1010 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License, version 2, as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + *
> + * Copyright (C) 2012 Freescale Semiconductor, Inc.
> + * Author: Varun Sethi <varun.sethi@freescale.com>
> + *
> + */
> +
> +#define pr_fmt(fmt)    "fsl-pamu-domain: %s: " fmt, __func__

You don't actually use this macro.

> +
> +#include <linux/init.h>
> +#include <linux/iommu.h>
> +#include <linux/notifier.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/mm.h>
> +#include <linux/interrupt.h>
> +#include <linux/device.h>
> +#include <linux/of_platform.h>
> +#include <linux/bootmem.h>
> +#include <linux/err.h>
> +#include <asm/io.h>
> +#include <asm/bitops.h>
> +
> +#include "fsl_pamu_domain.h"
> +
> +/* This bitmap advertises the page sizes supported by PAMU hardware
> + * to the IOMMU API.
> + */
> +#define FSL_PAMU_PGSIZES	(~0xFFFUL)
> +
> +/* global spinlock that needs to be held while
> + * configuring PAMU.
> + */
> +DEFINE_SPINLOCK(iommu_lock);

static?

> +
> +struct kmem_cache *fsl_pamu_domain_cache;
> +struct kmem_cache *iommu_devinfo_cache;
> +DEFINE_SPINLOCK(device_domain_lock);

static?

> +
> +static inline void free_devinfo_mem(void *vaddr)
> +{
> +	kmem_cache_free(iommu_devinfo_cache, vaddr);
> +}

This function is only called once, and it only has one line in it, so just
delete it, and call kmem_cache_free directly instead.

> +
> +static inline int iommu_devinfo_cache_init(void)
> +{
> +	int ret = 0;
> +
> +	iommu_devinfo_cache = kmem_cache_create("iommu_devinfo",
> +					 sizeof(struct device_domain_info),
> +					 0,
> +					 SLAB_HWCACHE_ALIGN,
> +					 NULL);
> +	if (!iommu_devinfo_cache) {
> +		pr_err("Couldn't create devinfo cache\n");
> +		ret = -ENOMEM;
> +	}
> +
> +	return ret;
> +}
> +
> +static inline int iommu_domain_cache_init(void)
> +{
> +	int ret = 0;
> +
> +	fsl_pamu_domain_cache = kmem_cache_create("fsl_pamu_domain",
> +					 sizeof(struct fsl_dma_domain),
> +					 0,
> +					 SLAB_HWCACHE_ALIGN,
> +
> +					 NULL);
> +	if (!fsl_pamu_domain_cache) {
> +		pr_err("Couldn't create fsl iommu_domain cache\n");
> +		ret = -ENOMEM;
> +	}
> +
> +	return ret;
> +}

Same thing with these two functions. Just merge them into
iommu_init_mempool().



> +static void destroy_domain(struct fsl_dma_domain *dma_domain)
> +{
> +	struct device_domain_info *info;
> +
> +	while (!list_empty(&dma_domain->devices)) {
> +		info = list_entry(dma_domain->devices.next,
> +			struct device_domain_info, link);
> +		remove_domain_ref(info, dma_domain->subwin_cnt);
> +	}
> +}
> +
> +static void detach_domain(struct device *dev, struct fsl_dma_domain *dma_domain)
> +{
> +	struct device_domain_info *info;
> +	struct list_head *entry, *tmp;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dma_domain->domain_lock, flags);
> +	if (!list_empty(&dma_domain->devices)) {
> +		list_for_each_safe(entry, tmp, &dma_domain->devices) {
> +			info = list_entry(entry, struct device_domain_info, link);
> +			if (info->dev == dev)
> +				remove_domain_ref(info, dma_domain->subwin_cnt);
> +		}
> +	}
> +	spin_unlock_irqrestore(&dma_domain->domain_lock, flags);
> +}

These two functions use two different methods to delete a linked list.
Can you pick one method and use it for both functions?

> +
> +static void attach_domain(struct fsl_dma_domain *dma_domain, int liodn, struct device *dev)
> +{
> +	struct device_domain_info *info;
> +	struct fsl_dma_domain *old_domain;
> +
> +	spin_lock(&device_domain_lock);
> +	/* Check here if the device is already attached to domain or not.
> +	 * If the device is already attached to a domain detach it.
> +	 */

Multi-line comment style is wrong.  Please check all comments and fix.

> +	old_domain = find_domain(dev);
> +	if (old_domain && old_domain != dma_domain) {
> +		spin_unlock(&device_domain_lock);
> +		detach_domain(dev, old_domain);
> +		spin_lock(&device_domain_lock);
> +	}
> +
> +	info = kmem_cache_zalloc(iommu_devinfo_cache, GFP_KERNEL);
> +
> +	info->dev = dev;
> +	info->liodn = liodn;
> +	info->domain = dma_domain;
> +
> +	list_add(&info->link, &dma_domain->devices);
> +	/* In case of devices with multiple LIODNs just store
> +	 * the info for the first LIODN as all
> +	 * LIODNs share the same domain
> +	 */
> +	if (old_domain && old_domain != dma_domain)
> +		dev->archdata.iommu_domain = info;

Can you merge this into the identical if-statement above?

> +	spin_unlock(&device_domain_lock);
> +
> +}
> +
> +static phys_addr_t fsl_pamu_iova_to_phys(struct iommu_domain *domain,
> +					    unsigned long iova)
> +{
> +	struct fsl_dma_domain *dma_domain = domain->priv;
> +
> +	if ((iova < domain->geometry.aperture_start) ||
> +		iova > (domain->geometry.aperture_end))
> +		return 0;
> +
> +	return get_phys_addr(dma_domain, iova);
> +}
> +
> +static int fsl_pamu_domain_has_cap(struct iommu_domain *domain,
> +				      unsigned long cap)
> +{
> +	if (cap == IOMMU_CAP_CACHE_COHERENCY)
> +		return 1;
> +
> +	return 0;
> +}

	return cap == IOMMU_CAP_CACHE_COHERENCY;


-- 
Timur Tabi
Linux kernel developer at Freescale


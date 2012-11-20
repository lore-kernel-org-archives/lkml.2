Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab2KTWxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:53:04 -0500
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:31321
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430Ab2KTWxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:53:01 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z551biz98dI1432Ic8kzz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
Message-ID: <50AC09C5.3030402@freescale.com>
Date: Tue, 20 Nov 2012 16:52:53 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Firefox/16.0 SeaMonkey/2.13.1
MIME-Version: 1.0
To: Varun Sethi <Varun.Sethi@freescale.com>
CC: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>
Subject: Re: [PATCH 4/4 v5] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
References: <1353419697-31269-1-git-send-email-Varun.Sethi@freescale.com> <1353419697-31269-5-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1353419697-31269-5-git-send-email-Varun.Sethi@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Varun Sethi wrote:


> diff --git a/drivers/iommu/fsl_pamu.h b/drivers/iommu/fsl_pamu.h
> new file mode 100644
> index 0000000..6d32fb5
> --- /dev/null
> +++ b/drivers/iommu/fsl_pamu.h
> @@ -0,0 +1,398 @@
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

I think you can move most of macros in this .h file into one of the .c files.

> diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
> new file mode 100644
> index 0000000..d473447
> --- /dev/null
> +++ b/drivers/iommu/fsl_pamu_domain.c

The code in this file is generally hard to read because you

1) have very few comments
2) you have a lot of expressions that span several lines, like this one:

		if ((iova >= geom_attr->aperture_start &&
			iova < geom_attr->aperture_end - 1 &&
			size <= geom_size) &&
			!align_check) {

Try adding a few more comments (e.g. each function should be commented)
and maybe try to break up a few of these lines.

> @@ -0,0 +1,978 @@
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

You don't use this macro.

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
> +static DEFINE_SPINLOCK(iommu_lock);
> +
> +static struct kmem_cache *fsl_pamu_domain_cache;
> +static struct kmem_cache *iommu_devinfo_cache;
> +static DEFINE_SPINLOCK(device_domain_lock);
> +
> +int __init iommu_init_mempool(void)
> +{
> +
> +	fsl_pamu_domain_cache = kmem_cache_create("fsl_pamu_domain",
> +					 sizeof(struct fsl_dma_domain),
> +					 0,
> +					 SLAB_HWCACHE_ALIGN,
> +
> +					 NULL);
> +	if (!fsl_pamu_domain_cache) {
> +		pr_err("Couldn't create fsl iommu_domain cache\n");

ALL of these pr_xxx functions (in the entire file) need to have a
"fsl-pamu-domain:" prefix.  Maybe that's why you created pr_fmt(), but you
forgot to use it.

The above message should look like this:

	pr_err("fsl-pamu-domain: could not create iommu domain cache\n");

> +		return -ENOMEM;
> +	}
> +
> +	iommu_devinfo_cache = kmem_cache_create("iommu_devinfo",
> +					 sizeof(struct device_domain_info),
> +					 0,
> +					 SLAB_HWCACHE_ALIGN,
> +					 NULL);
> +	if (!iommu_devinfo_cache) {
> +		pr_err("Couldn't create devinfo cache\n");
> +		kmem_cache_destroy(fsl_pamu_domain_cache);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static int reconfig_win(int liodn, struct fsl_dma_domain *domain)
> +{
> +	int ret;
> +
> +	spin_lock(&iommu_lock);
> +	ret = pamu_config_ppaace(liodn, domain->mapped_iova,
> +				 domain->mapped_size,
> +				 ~(u32)0,
> +				 domain->paddr >> PAMU_PAGE_SHIFT,
> +				 domain->snoop_id, domain->stash_id,
> +				 0, domain->prot);
> +	spin_unlock(&iommu_lock);
> +	if (ret) {
> +		pr_err("PAMU PAACE configuration failed for liodn %d\n",
> +			 liodn);
> +	}
> +	return ret;
> +}
> +
> +static void update_domain_subwin(struct fsl_dma_domain *dma_domain,
> +				unsigned long iova, size_t size,
> +				phys_addr_t paddr, int prot, int status)
> +{
> +	struct iommu_domain *domain = dma_domain->iommu_domain;
> +	u32 subwin_cnt = dma_domain->subwin_cnt;
> +	dma_addr_t geom_size = dma_domain->geom_size;
> +	u32 subwin_size;
> +	u32 mapped_subwin;
> +	u32 mapped_subwin_cnt;
> +	struct dma_subwindow *sub_win_ptr;
> +	int i;
> +
> +	subwin_size = geom_size >> ilog2(subwin_cnt);
> +	mapped_subwin = (iova - domain->geometry.aperture_start)
> +				 >> ilog2(subwin_size);
> +	sub_win_ptr = &dma_domain->sub_win_arr[mapped_subwin];
> +	mapped_subwin_cnt = (size < subwin_size) ? 1 :
> +				size >> ilog2(subwin_size);
> +	for (i = 0; i < mapped_subwin_cnt; i++) {
> +		if (status) {
> +			sub_win_ptr[i].paddr = paddr;
> +			sub_win_ptr[i].size = (size < subwin_size) ?
> +						 size : subwin_size;
> +			paddr += subwin_size;
> +			sub_win_ptr[i].iova = iova;
> +			iova += subwin_size;
> +		}
> +		sub_win_ptr[i].valid = status;
> +		sub_win_ptr[i].prot = prot;
> +	}
> +
> +	dma_domain->mapped_subwin = mapped_subwin;
> +	dma_domain->mapped_subwin_cnt =  mapped_subwin_cnt;
> +}
> +
> +static int reconfig_subwin(int liodn, struct fsl_dma_domain *dma_domain)
> +{
> +	u32 subwin_cnt = dma_domain->subwin_cnt;
> +	int ret = 0;
> +	u32 mapped_subwin;
> +	u32 mapped_subwin_cnt;
> +	struct dma_subwindow *sub_win_ptr;
> +	unsigned long rpn;
> +	int i;
> +
> +	mapped_subwin = dma_domain->mapped_subwin;
> +	mapped_subwin_cnt = dma_domain->mapped_subwin_cnt;
> +	sub_win_ptr = &dma_domain->sub_win_arr[mapped_subwin];
> +
> +	for (i = 0; i < mapped_subwin_cnt; i++) {
> +		rpn = sub_win_ptr[i].paddr >> PAMU_PAGE_SHIFT,
> +	
> +		spin_lock(&iommu_lock);
> +		ret = pamu_config_spaace(liodn, subwin_cnt, mapped_subwin,
> +					 sub_win_ptr[i].size,
> +					 ~(u32)0, 
> +					 rpn, dma_domain->snoop_id,
> +					 dma_domain->stash_id, 
> +					 (mapped_subwin == 0 &&
> +					 !dma_domain->enabled) ?
> +					 0 : sub_win_ptr[i].valid,

Break out this expression into another variable.  This code is illegible.

	int enabled = 0;
	
	for (...
		if (mapped_subwin || dma_domain->enabled)
			enabled = sub_win_ptr[i].valid;

> +					 sub_win_ptr[i].prot);
> +		spin_unlock(&iommu_lock);
> +		if (ret) {
> +			pr_err("PAMU SPAACE configuration failed for liodn %d\n",liodn);
> +			return ret;
> +		}
> +		mapped_subwin++;
> +	}
> +
> +	return ret;
> +}
> +
> +static phys_addr_t get_phys_addr(struct fsl_dma_domain *dma_domain, unsigned long iova)
> +{
> +	u32 subwin_cnt = dma_domain->subwin_cnt;
> +
> +	if (subwin_cnt) {
> +		int i;
> +		struct dma_subwindow *sub_win_ptr = 
> +					&dma_domain->sub_win_arr[0];
> +
> +		for (i = 0; i < subwin_cnt; i++) {
> +			if (sub_win_ptr[i].valid &&
> +			    iova >= sub_win_ptr[i].iova &&
> +			    iova < (sub_win_ptr[i].iova +
> +			    sub_win_ptr[i].size - 1))
> +				return (sub_win_ptr[i].paddr + (iova &
> +					(sub_win_ptr[i].size - 1)));
> +		}
> +	} else {
> +		return (dma_domain->paddr + (iova & (dma_domain->mapped_size - 1)));
> +	}
> +
> +	return 0;
> +}
> +
> +static int map_liodn_subwins(int liodn, struct fsl_dma_domain *dma_domain, u32 subwin_cnt)
> +{
> +	struct dma_subwindow *sub_win_ptr = 
> +				&dma_domain->sub_win_arr[0];
> +	int i, ret;
> +	unsigned long rpn;
> +
> +	for (i = 0; i < subwin_cnt; i++) {
> +		if (sub_win_ptr[i].valid) {
> +			rpn = sub_win_ptr[i].paddr >>
> +				 PAMU_PAGE_SHIFT,
> +			spin_lock(&iommu_lock);
> +			ret = pamu_config_spaace(liodn, subwin_cnt, i,
> +						 sub_win_ptr[i].size,
> +						 ~(u32)0,
> +						 rpn,
> +						 dma_domain->snoop_id,
> +						 dma_domain->stash_id,
> +						 (i > 0) ? 1 : 0,
> +						 sub_win_ptr[i].prot);
> +			spin_unlock(&iommu_lock);
> +			if (ret) {
> +				pr_err("PAMU SPAACE configuration failed for liodn %d\n",
> +					 liodn);
> +				return ret;
> +			}
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int map_liodn_win(int liodn, struct fsl_dma_domain *dma_domain)
> +{
> +	unsigned long rpn;
> +	int ret;
> +
> +	rpn = dma_domain->paddr >> PAMU_PAGE_SHIFT;
> +	spin_lock(&iommu_lock);
> +	ret = pamu_config_ppaace(liodn, dma_domain->mapped_iova,
> +				 dma_domain->mapped_size,
> +				 ~(u32)0,
> +				 rpn,
> +				dma_domain->snoop_id, dma_domain->stash_id,
> +				0, dma_domain->prot);

Indentation problem

> +	spin_unlock(&iommu_lock);
> +	if (ret)
> +		pr_err("PAMU PAACE configuration failed for liodn %d\n",
> +			liodn);
> +
> +	return ret;
> +}
> +
> +static int map_liodn(int liodn, struct fsl_dma_domain *dma_domain)
> +{
> +	u32 subwin_cnt = dma_domain->subwin_cnt;
> +
> +	if (subwin_cnt)
> +		return map_liodn_subwins(liodn, dma_domain, subwin_cnt);
> +	else
> +		return map_liodn_win(liodn, dma_domain);
> +
> +}
> +
> +static int update_liodn(int liodn, struct fsl_dma_domain *dma_domain)
> +{
> +	int ret;
> +
> +	if (dma_domain->subwin_cnt) {
> +		ret = reconfig_subwin(liodn, dma_domain);
> +		if (ret)
> +			pr_err("Subwindow reconfiguration failed for liodn %d\n", liodn);
> +	} else {
> +		ret = reconfig_win(liodn, dma_domain);
> +		if (ret)
> +			pr_err("Window reconfiguration failed for liodn %d\n", liodn);
> +	}
> +
> +	return ret;
> +}
> +
> +static int update_liodn_stash(int liodn, struct fsl_dma_domain *dma_domain,
> +				 u32 val)
> +{
> +	int ret = 0, i;
> +
> +	spin_lock(&iommu_lock);
> +	if (!dma_domain->subwin_cnt) {
> +		ret = pamu_update_paace_stash(liodn, 0, val);
> +		if (ret) {
> +			pr_err("Failed to update PAACE field for liodn %d\n ", liodn);
> +			spin_unlock(&iommu_lock);
> +			return ret;
> +		}
> +	} else {
> +		for (i = 0; i < dma_domain->subwin_cnt; i++) {
> +			ret = pamu_update_paace_stash(liodn, i, val);
> +			if (ret) {
> +				pr_err("Failed to update SPAACE %d field for liodn %d\n ", i, liodn);
> +				spin_unlock(&iommu_lock);
> +				return ret;
> +			}
> +		}
> +	}
> +	spin_unlock(&iommu_lock);
> +
> +	return ret;
> +}
> +
> +static int configure_liodn(int liodn, struct device *dev,
> +			   struct fsl_dma_domain *dma_domain,
> +			   struct iommu_domain_geometry *geom_attr,
> +			   u32 subwin_cnt)
> +{
> +	phys_addr_t window_addr, window_size;
> +	phys_addr_t subwin_size;
> +	int ret = 0, i;
> +	u32 omi_index = ~(u32)0;
> +
> +	/* Configure the omi_index at the geometry setup time.
> +	 * This is a static value which depends on the type of
> +	 * device and would not change thereafter.
> +	 */

	/*
	 * multi-line comments
	 * look like this
	 */

-- 
Timur Tabi
Linux kernel developer at Freescale


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3AGSKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:10:24 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43161 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3AGSKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:10:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: Re: [PATCH v5 1/4] iommu/shmobile: Add iommu driver for Renesas IPMMU modules
Date: Mon, 07 Jan 2013 19:11:58 +0100
Message-ID: <1586668.MmWlG9A4gq@avalon>
User-Agent: KMail/4.9.2 (Linux/3.6.11-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1356434355-3279-2-git-send-email-hdk@igel.co.jp>
References: <1356434355-3279-1-git-send-email-hdk@igel.co.jp> <1356434355-3279-2-git-send-email-hdk@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eiraku-san,

Thank you for the patch. This version is definitely better than the previous 
one, but I still have a couple of comments.

On Tuesday 25 December 2012 20:19:12 Hideki EIRAKU wrote:
> This is the Renesas IPMMU driver and IOMMU API implementation.
> 
> The IPMMU module supports the MMU function and the PMB function.  The
> MMU function provides address translation by pagetable compatible with
> ARMv6.  The PMB function provides address translation including
> tile-linear translation.  This patch implements the MMU function.
> 
> The iommu driver does not register a platform driver directly because:
> - the register space of the MMU function and the PMB function
>   have a common register (used for settings flush), so they should ideally
>   have a way to appropriately share this register.
> - the MMU function uses the IOMMU API while the PMB function does not.
> - the two functions may be used independently.
> 
> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
> ---
>  drivers/iommu/Kconfig                  |  74 +++++++
>  drivers/iommu/Makefile                 |   2 +
>  drivers/iommu/shmobile-iommu.c         | 341 ++++++++++++++++++++++++++++++
>  drivers/iommu/shmobile-ipmmu.c         | 136 +++++++++++++
>  drivers/iommu/shmobile-ipmmu.h         |  37 ++++
>  include/linux/platform_data/sh_ipmmu.h |  18 ++
>  6 files changed, 608 insertions(+)
>  create mode 100644 drivers/iommu/shmobile-iommu.c
>  create mode 100644 drivers/iommu/shmobile-ipmmu.c
>  create mode 100644 drivers/iommu/shmobile-ipmmu.h
>  create mode 100644 include/linux/platform_data/sh_ipmmu.h
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index e39f9db..d364494 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -187,4 +187,78 @@ config EXYNOS_IOMMU_DEBUG
> 
>  	  Say N unless you need kernel log message for IOMMU debugging
> 
> +config SHMOBILE_IPMMU
> +	bool
> +
> +config SHMOBILE_IPMMU_TLB
> +	bool
> +
> +config SHMOBILE_IOMMU
> +	bool "IOMMU for Renesas IPMMU/IPMMUI"
> +	default n
> +	depends on (ARM && ARCH_SHMOBILE)
> +	select IOMMU_API
> +	select ARM_DMA_USE_IOMMU
> +	select SHMOBILE_IPMMU
> +	select SHMOBILE_IPMMU_TLB
> +	help
> +	  Support for Renesas IPMMU/IPMMUI. This option enables
> +	  remapping of DMA memory accesses from all of the IP blocks
> +	  on the ICB.
> +
> +	  Warning: Drivers (including userspace drivers of UIO
> +	  devices) of the IP blocks on the ICB *must* use addresses
> +	  allocated from the IPMMU (iova) for DMA with this option
> +	  enabled.
> +
> +	  If unsure, say N.
> +
> +choice
> +	prompt "IPMMU/IPMMUI address space size"
> +	default SHMOBILE_IOMMU_ADDRSIZE_2048MB
> +	depends on SHMOBILE_IOMMU
> +	help
> +	  This option sets IPMMU/IPMMUI address space size by
> +	  adjusting the 1st level page table size. The page table size
> +	  is calculated as follows:
> +
> +	      page table size = number of page table entries * 4 bytes
> +	      number of page table entries = address space size / 1 MiB
> +
> +	  For example, when the address space size is 2048 MiB, the
> +	  1st level page table size is 8192 bytes.
> +
> +	config SHMOBILE_IOMMU_ADDRSIZE_2048MB
> +		bool "2 GiB"
> +
> +	config SHMOBILE_IOMMU_ADDRSIZE_1024MB
> +		bool "1 GiB"
> +
> +	config SHMOBILE_IOMMU_ADDRSIZE_512MB
> +		bool "512 MiB"
> +
> +	config SHMOBILE_IOMMU_ADDRSIZE_256MB
> +		bool "256 MiB"
> +
> +	config SHMOBILE_IOMMU_ADDRSIZE_128MB
> +		bool "128 MiB"
> +
> +	config SHMOBILE_IOMMU_ADDRSIZE_64MB
> +		bool "64 MiB"
> +
> +	config SHMOBILE_IOMMU_ADDRSIZE_32MB
> +		bool "32 MiB"
> +
> +endchoice
> +
> +config SHMOBILE_IOMMU_L1SIZE
> +	int
> +	default 8192 if SHMOBILE_IOMMU_ADDRSIZE_2048MB
> +	default 4096 if SHMOBILE_IOMMU_ADDRSIZE_1024MB
> +	default 2048 if SHMOBILE_IOMMU_ADDRSIZE_512MB
> +	default 1024 if SHMOBILE_IOMMU_ADDRSIZE_256MB
> +	default 512 if SHMOBILE_IOMMU_ADDRSIZE_128MB
> +	default 256 if SHMOBILE_IOMMU_ADDRSIZE_64MB
> +	default 128 if SHMOBILE_IOMMU_ADDRSIZE_32MB
> +
>  endif # IOMMU_SUPPORT
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index f66b816..ef0e520 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -13,3 +13,5 @@ obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
>  obj-$(CONFIG_TEGRA_IOMMU_GART) += tegra-gart.o
>  obj-$(CONFIG_TEGRA_IOMMU_SMMU) += tegra-smmu.o
>  obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
> +obj-$(CONFIG_SHMOBILE_IOMMU) += shmobile-iommu.o
> +obj-$(CONFIG_SHMOBILE_IPMMU) += shmobile-ipmmu.o
> diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
> new file mode 100644
> index 0000000..360a06f
> --- /dev/null
> +++ b/drivers/iommu/shmobile-iommu.c
> @@ -0,0 +1,341 @@
> +/*
> + * IOMMU for IPMMU/IPMMUI
> + * Copyright (C) 2012  Hideki EIRAKU
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + */
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/dmapool.h>
> +#include <linux/io.h>
> +#include <linux/iommu.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <asm/dma-iommu.h>
> +#include "shmobile-ipmmu.h"
> +
> +#define L1_SIZE CONFIG_SHMOBILE_IOMMU_L1SIZE
> +#define L1_LEN (L1_SIZE / 4)
> +#define L1_ALIGN L1_SIZE
> +#define L2_SIZE 0x400
> +#define L2_LEN (L2_SIZE / 4)
> +#define L2_ALIGN L2_SIZE
> +
> +struct shmobile_iommu_domain_pgtable {
> +	uint32_t *pgtable;
> +	dma_addr_t handle;
> +};
> +
> +struct shmobile_iommu_domain {
> +	struct shmobile_ipmmu *ipmmu;
> +	struct shmobile_iommu_domain_pgtable l1, l2[L1_LEN];
> +	spinlock_t map_lock;
> +	atomic_t active;
> +};
> +
> +static struct shmobile_ipmmu *platform_bus_ipmmu;
> +static struct dma_pool *l1pool, *l2pool;
> +static spinlock_t lock;
> +static struct shmobile_iommu_domain *attached;
> +static int num_attached_devices;

We need to get rid of those global variables. Most of them could probably be 
stored in the shmobile_ipmmu structure (or another IOMMU-specific structure 
emebdded in shmobile_ipmmu, or referenced from shmobile_ipmmu). Otherwise it 
won't be possible to instantiate more than on IPMMU in the system.

platform_bus_ipmmu will need special care, the driver will need to be 
restructured in such a way that no global IPMMU pointer is needed. Feel free 
to discuss your ideas on the mailing list before implementing them (and please 
CC me in that case).

> +static int shmobile_iommu_domain_init(struct iommu_domain *domain)
> +{
> +	struct shmobile_iommu_domain *sh_domain;
> +	int i;
> +
> +	sh_domain = kmalloc(sizeof(*sh_domain), GFP_KERNEL);
> +	if (!sh_domain)
> +		return -ENOMEM;
> +	sh_domain->l1.pgtable = dma_pool_alloc(l1pool, GFP_KERNEL,
> +					       &sh_domain->l1.handle);
> +	if (!sh_domain->l1.pgtable) {
> +		kfree(sh_domain);
> +		return -ENOMEM;
> +	}
> +	for (i = 0; i < L1_LEN; i++)
> +		sh_domain->l2[i].pgtable = NULL;
> +	memset(sh_domain->l1.pgtable, 0, L1_SIZE);
> +	spin_lock_init(&sh_domain->map_lock);
> +	atomic_set(&sh_domain->active, 0);
> +	domain->priv = sh_domain;
> +	return 0;
> +}
> +
> +static void shmobile_iommu_domain_destroy(struct iommu_domain *domain)
> +{
> +	struct shmobile_iommu_domain *sh_domain = domain->priv;
> +	int i;
> +
> +	for (i = 0; i < L1_LEN; i++) {
> +		if (sh_domain->l2[i].pgtable)
> +			dma_pool_free(l2pool, sh_domain->l2[i].pgtable,
> +				      sh_domain->l2[i].handle);
> +	}
> +	dma_pool_free(l1pool, sh_domain->l1.pgtable, sh_domain->l1.handle);
> +	kfree(sh_domain);
> +	domain->priv = NULL;
> +}
> +
> +static int shmobile_iommu_attach_device(struct iommu_domain *domain,
> +					struct device *dev)
> +{
> +	struct shmobile_iommu_domain *sh_domain = domain->priv;
> +	struct shmobile_ipmmu *ipmmu = platform_bus_ipmmu;
> +	int ret = -EBUSY;
> +
> +	spin_lock(&lock);
> +	if (attached != sh_domain) {
> +		if (attached)
> +			goto err;
> +		atomic_set(&sh_domain->active, 1);
> +		ipmmu_tlb_set(ipmmu, sh_domain->l1.handle, L1_SIZE, 0);
> +		wmb();
> +		ipmmu_tlb_flush(ipmmu);
> +		attached = sh_domain;
> +		num_attached_devices = 0;
> +		sh_domain->ipmmu = ipmmu;
> +	}
> +	num_attached_devices++;
> +	ret = 0;
> +err:
> +	spin_unlock(&lock);
> +	return ret;
> +}
> +
> +static void shmobile_iommu_detach_device(struct iommu_domain *domain,
> +					 struct device *dev)
> +{
> +	struct shmobile_iommu_domain *sh_domain = domain->priv;
> +	struct shmobile_ipmmu *ipmmu = platform_bus_ipmmu;
> +
> +	spin_lock(&lock);
> +	atomic_set(&sh_domain->active, 0);
> +	num_attached_devices--;
> +	if (!num_attached_devices) {
> +		ipmmu_tlb_set(ipmmu, 0, 0, 0);
> +		ipmmu_tlb_flush(ipmmu);
> +		attached = NULL;
> +		sh_domain->ipmmu = NULL;
> +	}
> +	spin_unlock(&lock);
> +}
> +
> +static int
> +l2alloc(struct shmobile_iommu_domain *sh_domain, unsigned int l1index)
> +{
> +	if (!sh_domain->l2[l1index].pgtable) {
> +		sh_domain->l2[l1index].pgtable = dma_pool_alloc(l2pool,
> +						GFP_KERNEL,
> +						&sh_domain->l2[l1index].handle);
> +		if (!sh_domain->l2[l1index].pgtable)
> +			return -ENOMEM;
> +		memset(sh_domain->l2[l1index].pgtable, 0, L2_SIZE);
> +	}
> +	sh_domain->l1.pgtable[l1index] = sh_domain->l2[l1index].handle | 0x1;
> +	return 0;
> +}
> +
> +static void
> +l2realfree(struct shmobile_iommu_domain_pgtable *l2)
> +{
> +	if (l2->pgtable)
> +		dma_pool_free(l2pool, l2->pgtable, l2->handle);
> +}
> +
> +static int
> +l2free(struct shmobile_iommu_domain *sh_domain, unsigned int l1index,
> +	struct shmobile_iommu_domain_pgtable *l2)
> +{
> +	sh_domain->l1.pgtable[l1index] = 0;
> +	if (sh_domain->l2[l1index].pgtable) {
> +		*l2 = sh_domain->l2[l1index];
> +		sh_domain->l2[l1index].pgtable = NULL;
> +	}
> +	return 0;
> +}
> +
> +static int shmobile_iommu_map(struct iommu_domain *domain, unsigned long
> iova,
> +			      phys_addr_t paddr, size_t size, int prot)
> +{
> +	struct shmobile_iommu_domain_pgtable l2 = { .pgtable = NULL };
> +	struct shmobile_iommu_domain *sh_domain = domain->priv;
> +	unsigned int l1index, l2index, i;
> +	int ret;
> +
> +	l1index = iova >> 20;
> +	switch (size) {
> +	case 0x1000:

Could you please use the macros defines in include/linux/sizes.h ? They make 
the code easier to read.

> +		l2index = (iova >> 12) & 0xff;
> +		spin_lock(&sh_domain->map_lock);
> +		ret = l2alloc(sh_domain, l1index);

l2alloc calls dma_pool_alloc(GFP_KERNEL), that not safe in a non-sleepable 
context. Do we need a spinlock here, or could a mutex do ?

> +		if (!ret)
> +			sh_domain->l2[l1index].pgtable[l2index] = paddr | 0xff2;
> +		spin_unlock(&sh_domain->map_lock);
> +		break;
> +	case 0x10000:
> +		l2index = (iova >> 12) & 0xf0;
> +		spin_lock(&sh_domain->map_lock);
> +		ret = l2alloc(sh_domain, l1index);
> +		if (!ret) {
> +			for (i = 0; i < 0x10; i++)
> +				sh_domain->l2[l1index].pgtable[l2index + i] =
> +					paddr | 0xff1;
> +		}
> +		spin_unlock(&sh_domain->map_lock);
> +		break;
> +	case 0x100000:
> +		spin_lock(&sh_domain->map_lock);
> +		l2free(sh_domain, l1index, &l2);
> +		sh_domain->l1.pgtable[l1index] = paddr | 0xc02;
> +		spin_unlock(&sh_domain->map_lock);
> +		ret = 0;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +	if (!ret && atomic_read(&sh_domain->active)) {
> +		wmb();
> +		ipmmu_tlb_flush(sh_domain->ipmmu);
> +		l2realfree(&l2);

Does l2realfree() need locking ?

> +	}
> +	return ret;
> +}
> +
> +static size_t shmobile_iommu_unmap(struct iommu_domain *domain,
> +				   unsigned long iova, size_t size)
> +{
> +	struct shmobile_iommu_domain_pgtable l2 = { .pgtable = NULL };
> +	struct shmobile_iommu_domain *sh_domain = domain->priv;
> +	unsigned int l1index, l2index, i;
> +	uint32_t l2entry = 0;
> +	size_t ret = 0;
> +
> +	l1index = iova >> 20;
> +	if (!(iova & 0xFFFFF) && size >= 0x100000) {

Hex constants usually use lower-case in the kernel.

Could you please use SZ_* for the size here (and below, as applicable) as well 
?

> +		spin_lock(&sh_domain->map_lock);
> +		l2free(sh_domain, l1index, &l2);
> +		spin_unlock(&sh_domain->map_lock);
> +		ret = 0x100000;
> +		goto done;
> +	}
> +	l2index = (iova >> 12) & 0xff;
> +	spin_lock(&sh_domain->map_lock);
> +	if (sh_domain->l2[l1index].pgtable)
> +		l2entry = sh_domain->l2[l1index].pgtable[l2index];
> +	switch (l2entry & 3) {
> +	case 1:
> +		if (l2index & 0xf)
> +			break;
> +		for (i = 0; i < 0x10; i++)
> +			sh_domain->l2[l1index].pgtable[l2index + i] = 0;
> +		ret = 0x10000;
> +		break;
> +	case 2:
> +		sh_domain->l2[l1index].pgtable[l2index] = 0;
> +		ret = 0x1000;
> +		break;
> +	}
> +	spin_unlock(&sh_domain->map_lock);
> +done:
> +	if (ret && atomic_read(&sh_domain->active)) {
> +		wmb();
> +		ipmmu_tlb_flush(sh_domain->ipmmu);
> +		l2realfree(&l2);
> +	}
> +	return ret;
> +}
> +
> +static phys_addr_t shmobile_iommu_iova_to_phys(struct iommu_domain *domain,
> +					       unsigned long iova)
> +{
> +	struct shmobile_iommu_domain *sh_domain = domain->priv;
> +	uint32_t l1entry = 0, l2entry = 0;
> +	unsigned int l1index, l2index;
> +
> +	l1index = iova >> 20;
> +	l2index = (iova >> 12) & 0xff;
> +	spin_lock(&sh_domain->map_lock);
> +	if (sh_domain->l2[l1index].pgtable)
> +		l2entry = sh_domain->l2[l1index].pgtable[l2index];
> +	else
> +		l1entry = sh_domain->l1.pgtable[l1index];
> +	spin_unlock(&sh_domain->map_lock);
> +	switch (l2entry & 3) {
> +	case 1:
> +		return (l2entry & ~0xffff) | (iova & 0xffff);
> +	case 2:
> +		return (l2entry & ~0xfff) | (iova & 0xfff);
> +	default:
> +		if ((l1entry & 3) == 2)
> +			return (l1entry & ~0xfffff) | (iova & 0xfffff);
> +		return 0;
> +	}
> +}
> +
> +static int find_dev_name(struct shmobile_ipmmu *ipmmu, const char
> *dev_name) +{
> +	unsigned int i, n = ipmmu->num_dev_names;
> +
> +	for (i = 0; i < n; i++) {
> +		if (strcmp(ipmmu->dev_names[i], dev_name) == 0)
> +			return 1;
> +	}
> +	return 0;
> +}
> +
> +static int shmobile_iommu_add_device(struct device *dev)
> +{
> +	struct shmobile_ipmmu *ipmmu = platform_bus_ipmmu;
> +	struct dma_iommu_mapping *mapping;
> +
> +	if (!find_dev_name(ipmmu, dev_name(dev)))
> +		return 0;
> +	mapping = ipmmu->iommu_mapping;
> +	if (!mapping) {
> +		mapping = arm_iommu_create_mapping(&platform_bus_type, 0,
> +						   L1_LEN << 20, 0);
> +		if (IS_ERR(mapping))
> +			return PTR_ERR(mapping);
> +		ipmmu->iommu_mapping = mapping;
> +	}
> +	if (arm_iommu_attach_device(dev, mapping))
> +		pr_err("arm_iommu_attach_device failed\n");

This assumes that the IPMMU is registered before the device using it. I don't 
think that will hold true with DT.

As stated in my previous e-mail, I really think you should continue the 
discussion started by patch http://patchwork.ozlabs.org/patch/203717/ on the 
mailing lists (please CC me).

> +	return 0;
> +}
> +
> +static struct iommu_ops shmobile_iommu_ops = {
> +	.domain_init = shmobile_iommu_domain_init,
> +	.domain_destroy = shmobile_iommu_domain_destroy,
> +	.attach_dev = shmobile_iommu_attach_device,
> +	.detach_dev = shmobile_iommu_detach_device,
> +	.map = shmobile_iommu_map,
> +	.unmap = shmobile_iommu_unmap,
> +	.iova_to_phys = shmobile_iommu_iova_to_phys,
> +	.add_device = shmobile_iommu_add_device,
> +	.pgsize_bitmap = 0x111000,
> +};
> +
> +int ipmmu_iommu_init(struct shmobile_ipmmu *ipmmu)
> +{
> +	dma_set_coherent_mask(ipmmu->dev, DMA_BIT_MASK(32));
> +	l1pool = dma_pool_create("shmobile-iommu-pgtable1", ipmmu->dev,
> +				 L1_SIZE, L1_ALIGN, 0);
> +	if (!l1pool)
> +		goto nomem_pool1;

You can return -ENOMEM directly here.

> +	l2pool = dma_pool_create("shmobile-iommu-pgtable2", ipmmu->dev,
> +				 L2_SIZE, L2_ALIGN, 0);
> +	if (!l2pool)
> +		goto nomem_pool2;

And you can call dma_pool_destroy() and return -ENOMEM directly here too, as 
there no other user of the error code path.

> +	spin_lock_init(&lock);
> +	attached = NULL;
> +	platform_bus_ipmmu = ipmmu;
> +	bus_set_iommu(&platform_bus_type, &shmobile_iommu_ops);
> +	return 0;
> +nomem_pool2:
> +	dma_pool_destroy(l1pool);
> +nomem_pool1:
> +	return -ENOMEM;
> +}
> diff --git a/drivers/iommu/shmobile-ipmmu.c b/drivers/iommu/shmobile-ipmmu.c
> new file mode 100644
> index 0000000..8321f89
> --- /dev/null
> +++ b/drivers/iommu/shmobile-ipmmu.c
> @@ -0,0 +1,136 @@
> +/*
> + * IPMMU/IPMMUI
> + * Copyright (C) 2012  Hideki EIRAKU
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/export.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/platform_data/sh_ipmmu.h>
> +#include "shmobile-ipmmu.h"
> +
> +#define IMCTR1 0x000
> +#define IMCTR2 0x004
> +#define IMASID 0x010
> +#define IMTTBR 0x014
> +#define IMTTBCR 0x018
> +
> +#define IMCTR1_TLBEN (1 << 0)
> +#define IMCTR1_FLUSH (1 << 1)
> +
> +static void ipmmu_reg_write(struct shmobile_ipmmu *ipmmu, unsigned long
> reg_off,
> +			    unsigned long data)
> +{
> +	iowrite32(data, ipmmu->ipmmu_base + reg_off);
> +}
> +
> +void ipmmu_tlb_flush(struct shmobile_ipmmu *ipmmu)
> +{
> +	if (!ipmmu)
> +		return;
> +
> +	mutex_lock(&ipmmu->flush_lock);
> +	if (ipmmu->tlb_enabled)
> +		ipmmu_reg_write(ipmmu, IMCTR1, IMCTR1_FLUSH | IMCTR1_TLBEN);
> +	else
> +		ipmmu_reg_write(ipmmu, IMCTR1, IMCTR1_FLUSH);
> +	mutex_unlock(&ipmmu->flush_lock);
> +}
> +
> +void ipmmu_tlb_set(struct shmobile_ipmmu *ipmmu, unsigned long phys, int
> size,
> +		   int asid)
> +{
> +	if (!ipmmu)
> +		return;
> +
> +	mutex_lock(&ipmmu->flush_lock);
> +	switch (size) {
> +	default:
> +		ipmmu->tlb_enabled = 0;
> +		break;
> +	case 0x2000:
> +		ipmmu_reg_write(ipmmu, IMTTBCR, 1);
> +		ipmmu->tlb_enabled = 1;
> +		break;
> +	case 0x1000:
> +		ipmmu_reg_write(ipmmu, IMTTBCR, 2);
> +		ipmmu->tlb_enabled = 1;
> +		break;
> +	case 0x800:
> +		ipmmu_reg_write(ipmmu, IMTTBCR, 3);
> +		ipmmu->tlb_enabled = 1;
> +		break;
> +	case 0x400:
> +		ipmmu_reg_write(ipmmu, IMTTBCR, 4);
> +		ipmmu->tlb_enabled = 1;
> +		break;
> +	case 0x200:
> +		ipmmu_reg_write(ipmmu, IMTTBCR, 5);
> +		ipmmu->tlb_enabled = 1;
> +		break;
> +	case 0x100:
> +		ipmmu_reg_write(ipmmu, IMTTBCR, 6);
> +		ipmmu->tlb_enabled = 1;
> +		break;
> +	case 0x80:
> +		ipmmu_reg_write(ipmmu, IMTTBCR, 7);
> +		ipmmu->tlb_enabled = 1;
> +		break;
> +	}
> +	ipmmu_reg_write(ipmmu, IMTTBR, phys);
> +	ipmmu_reg_write(ipmmu, IMASID, asid);
> +	mutex_unlock(&ipmmu->flush_lock);
> +}
> +
> +static int ipmmu_probe(struct platform_device *pdev)
> +{
> +	struct shmobile_ipmmu *ipmmu;
> +	struct resource *res;
> +	struct shmobile_ipmmu_platform_data *pdata = pdev->dev.platform_data;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "cannot get platform resources\n");
> +		return -ENOENT;
> +	}
> +	ipmmu = devm_kzalloc(&pdev->dev, sizeof(*ipmmu), GFP_KERNEL);
> +	if (!ipmmu) {
> +		dev_err(&pdev->dev, "cannot allocate device data\n");
> +		return -ENOMEM;
> +	}
> +	mutex_init(&ipmmu->flush_lock);
> +	ipmmu->dev = &pdev->dev;
> +	ipmmu->ipmmu_base = devm_ioremap_nocache(&pdev->dev, res->start,
> +						resource_size(res));
> +	if (!ipmmu->ipmmu_base) {
> +		dev_err(&pdev->dev, "ioremap_nocache failed\n");
> +		return -ENOMEM;
> +	}
> +	ipmmu->dev_names = pdata->dev_names;
> +	ipmmu->num_dev_names = pdata->num_dev_names;
> +	platform_set_drvdata(pdev, ipmmu);
> +	ipmmu_reg_write(ipmmu, IMCTR1, 0x0); /* disable TLB */
> +	ipmmu_reg_write(ipmmu, IMCTR2, 0x0); /* disable PMB */
> +	ipmmu_iommu_init(ipmmu);
> +	return 0;
> +}
> +
> +static struct platform_driver ipmmu_driver = {
> +	.probe = ipmmu_probe,
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = "ipmmu",
> +	},
> +};
> +
> +static int __init ipmmu_init(void)
> +{
> +	return platform_driver_register(&ipmmu_driver);
> +}
> +subsys_initcall(ipmmu_init);
> diff --git a/drivers/iommu/shmobile-ipmmu.h b/drivers/iommu/shmobile-ipmmu.h
> new file mode 100644
> index 0000000..6270e7c
> --- /dev/null
> +++ b/drivers/iommu/shmobile-ipmmu.h
> @@ -0,0 +1,37 @@
> +/* shmobile-ipmmu.h
> + *
> + * Copyright (C) 2012  Hideki EIRAKU
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + */
> +
> +#ifndef __SHMOBILE_IPMMU_H__
> +#define __SHMOBILE_IPMMU_H__
> +
> +struct dma_iommu_mapping;
> +
> +struct shmobile_ipmmu {
> +	struct device *dev;
> +	void __iomem *ipmmu_base;
> +	int tlb_enabled;
> +	struct mutex flush_lock;
> +	struct dma_iommu_mapping *iommu_mapping;
> +	const char * const *dev_names;
> +	unsigned int num_dev_names;
> +};
> +
> +#ifdef CONFIG_SHMOBILE_IPMMU_TLB
> +void ipmmu_tlb_flush(struct shmobile_ipmmu *ipmmu);
> +void ipmmu_tlb_set(struct shmobile_ipmmu *ipmmu, unsigned long phys, int
> size, +		   int asid);
> +int ipmmu_iommu_init(struct shmobile_ipmmu *ipmmu);
> +#else
> +static int ipmmu_iommu_init(struct shmobile_ipmmu *ipmmu)
> +{
> +	return -EINVAL;
> +}
> +#endif
> +
> +#endif /* __SHMOBILE_IPMMU_H__ */
> diff --git a/include/linux/platform_data/sh_ipmmu.h
> b/include/linux/platform_data/sh_ipmmu.h new file mode 100644
> index 0000000..39f7405
> --- /dev/null
> +++ b/include/linux/platform_data/sh_ipmmu.h
> @@ -0,0 +1,18 @@
> +/* sh_ipmmu.h
> + *
> + * Copyright (C) 2012  Hideki EIRAKU
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + */
> +
> +#ifndef __SH_IPMMU_H__
> +#define __SH_IPMMU_H__
> +
> +struct shmobile_ipmmu_platform_data {
> +	const char * const *dev_names;
> +	unsigned int num_dev_names;
> +};
> +
> +#endif /* __SH_IPMMU_H__ */
-- 
Regards,

Laurent Pinchart


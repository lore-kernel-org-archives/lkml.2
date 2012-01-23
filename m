Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2AWO1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:27:11 -0500
Received: from 8bytes.org ([88.198.83.132]:46011 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab2AWO1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:27:08 -0500
Date: Mon, 23 Jan 2012 15:27:06 +0100
From: "'Joerg Roedel'" <joro@8bytes.org>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>
Subject: Re: [PATCH v8 2/2] iommu/exynos: Add iommu driver for Exynos
	Platforms
Message-ID: <20120123142706.GA6269@8bytes.org>
References: <001001ccc625$0afa7ee0$20ef7ca0$%cho@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001001ccc625$0afa7ee0$20ef7ca0$%cho@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

please also get and inclue Acks from the Exynos maintainer for the next
post.
Since I have a compiling config for exynos now I will merge the patches
when you have the Acks and addressed or explained the issues I pointed
out below.

On Thu, Dec 29, 2011 at 09:26:08PM +0900, KyongHo Cho wrote:
> +static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> +{
> +	struct exynos_iommu_domain *priv = domain->priv;
> +	struct list_head *pos, *n;
> +	unsigned long flags;
> +	int i;
> +
> +	WARN_ON(!list_empty(&priv->clients));

This isn't really a problem. We allow destroying a domain with devices
attached. So this WARN_ON is not necessary.

> +static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
> +			 phys_addr_t paddr, size_t size, int prot)
> +{
> +	struct exynos_iommu_domain *priv = domain->priv;
> +	unsigned long *entry;
> +	unsigned long flags;
> +	int ret = -ENOMEM;
> +
> +	BUG_ON(priv->pgtable == NULL);
> +
> +	spin_lock_irqsave(&priv->pgtablelock, flags);
> +
> +	entry = section_entry(priv->pgtable, iova);
> +
> +	if (size >= SECT_SIZE) {
> +		ret = lv1set_section(entry, paddr, size >> SECT_ORDER,
> +					&priv->lv2entcnt[lv1ent_offset(iova)]);

This looks like you are partially re-implementing behavior of generic
code because you are mapping multiple sections at once. The generic map
code already splits up the address range correctly, so no need to do
this in the driver (unless there is some benefit in the hardware, like
an IOTLB entry that can cover multiple sections or something similar).

> +static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> +					       unsigned long iova, size_t size)
> +{
> +	struct exynos_iommu_domain *priv = domain->priv;
> +	struct iommu_client *client;
> +	unsigned long flags;
> +
> +	BUG_ON(priv->pgtable == NULL);
> +
> +	spin_lock_irqsave(&priv->pgtablelock, flags);
> +
> +	while (size != 0) {
> +		int i, nent, order;
> +		unsigned long *pent, *sent;

Same with this while-loop. This looks like it re-implements behavior
from the generic code.

Regards,

	Joerg


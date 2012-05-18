Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab2ERPPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:15:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33809 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2ERPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:15:39 -0400
Message-ID: <4FB66796.1030007@wwwdotorg.org>
Date: Fri, 18 May 2012 09:15:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: joerg.roedel@amd.com, iommu@lists.linux-foundation.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/1] iommu/tegra: smmu: Add DMA window parser
References: <20120518085051.4a0fca863c5ab37cf8d42cb1@nvidia.com> <1337323393-1035-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1337323393-1035-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 12:43 AM, Hiroshi DOYU wrote:
> This code was based on:
>     "arch/microblaze/kernel/prom_parse.c"
>     "arch/powerpc/kernel/prom_parse.c"
> 
> Can be promoted as a global function for general use.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>

Hiroshi,

Once this is accepted, it might be worth following up on the original
of_get_dma_window thread and noting that once it's approved, an updated
version of the patch will be needed to remove this code at the same time.

A couple comments below though:

> +static int of_get_dma_window(struct device_node *dn,
> +			const char *propname, int index,
> +			unsigned long *busno,
> +			dma_addr_t *addr, size_t *size)
> +{
> +	const __be32 *dma_window, *end;
> +	int bytes, cur_index = 0;

Since bytes is an out parameter from of_get_property, do you need to
wrap the declaration in uninitialized_var() to prevent a compile warning
like the other patch you sent me downstream?

> +	if (!dn || !addr || !size)
> +		return -EINVAL;
> +
> +	if (!propname)
> +		propname = "dma-window";
> +
> +	dma_window = of_get_property(dn, propname, &bytes);
> +	if (!dma_window)
> +		return -ENODEV;
> +	end = dma_window + bytes / sizeof(*dma_window);
> +
> +	while (dma_window < end) {
> +		u32 cells;
> +		const void *prop;
> +
> +		/* busno is always one cell */
> +		if (busno)
> +			*busno = be32_to_cpup(dma_window++);

Shouldn't the ++ happen even if (!busno)?

Once those are fixed, in the interests of fixing the compile error,

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

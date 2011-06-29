Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1F2IUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:20:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:58873 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab1F2IUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:20:20 -0400
Date: Wed, 29 Jun 2011 17:19:50 +0900
To: nacc@us.ibm.com
Cc: miltonm@bga.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        vinod.koul@intel.com, dan.j.williams@intel.com
Subject: Re: [PATCH 2/4] dma-mapping: add get_required_mask if arch
 overrides default
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1308942325-4813-3-git-send-email-nacc@us.ibm.com>
References: <1308942325-4813-1-git-send-email-nacc@us.ibm.com>
	<1308942325-4813-3-git-send-email-nacc@us.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110629171304B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 29 Jun 2011 17:19:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 12:05:23 -0700
Nishanth Aravamudan <nacc@us.ibm.com> wrote:

> From: Milton Miller <miltonm@bga.com>
> 
> If an architecture sets ARCH_HAS_DMA_GET_REQUIRED_MASK and has settable
> dma_map_ops, the required mask may change by the ops implementation.
> For example, a system that always has an mmu inline may only require 32
> bits while a swiotlb would desire bits to cover all of memory.
> 
> Therefore add the field if the architecture does not use the generic
> definition of dma_get_required_mask. The first use will by by powerpc.
> Note that this does add some dependency on the order in which files are
> visible here.
> 
> Signed-off-by:  Milton Miller <miltonm@bga.com>
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Cc: benh@kernel.crashing.org
> ---
>  include/linux/dma-mapping.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index ba8319a..d0e023b 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -49,6 +49,9 @@ struct dma_map_ops {
>  	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
>  	int (*dma_supported)(struct device *dev, u64 mask);
>  	int (*set_dma_mask)(struct device *dev, u64 mask);
> +#ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
> +	u64 (*get_required_mask)(struct device *dev);
> +#endif
>  	int is_phys;
>  };

If you add get_required_mask to dma_map_ops, we should clean up ia64
too and implement the generic proper version in
dma-mapping-common.h. Then we kill ARCH_HAS_DMA_GET_REQUIRED_MASK
ifdef hack. Otherwise, I don't think it makes sense to add this to
dma_map_ops.

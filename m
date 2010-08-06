Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962Ab0HFHeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:34:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51400 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696Ab0HFHd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:33:57 -0400
Date: Fri, 6 Aug 2010 08:33:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: msm: Add MSM IOMMU support.
Message-ID: <20100806073333.GA14965@n2100.arm.linux.org.uk>
References: <1281062204-21880-1-git-send-email-stepanm@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281062204-21880-1-git-send-email-stepanm@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 07:36:44PM -0700, Stepan Moskovchenko wrote:
> +/**
> + * struct msm_iommu_dev - a single IOMMU hardware instance
> + * name		Human-readable name given to this IOMMU HW instance
> + * clk		Name of the AXI clock used for the config space of this IOMMU
> + * clk_rate	Rate to set for the AXI clock. 0 means don't set a rate
> + * num_ctx	Number of context banks on this IOMMU device
> + *
> + */
> +struct msm_iommu_dev {
> +	char *name;

const?

> +	char *clk;

const?  Any reason you can't have some kind of struct device instead?

> +	unsigned long clk_rate;
> +	unsigned int num_ctx;
> +};
> +
> +/**
> + * struct msm_iommu_ctx_dev - an IOMMU context bank instance
> + * name		Human-readable name given to this context bank
> + * num		Index of this context bank within the hardware
> + * mids		List of Machine IDs that are to be mapped into this context
> + *		bank, terminated by -1. The MID is a set of signals on the
> + *		AXI bus that identifies the function associated with a specific
> + *		memory request. (See ARM spec).
> + */
> +struct msm_iommu_ctx_dev {
> +	char *name;

const?

> +	int num;
> +	int mids[MAX_NUM_MIDS];
> +};
> +
...
> +int v7_flush_kern_cache_all(void);

No - don't use internal functions directly.  Use flush_cache_all()
instead.

> +#ifndef __ARCH_ARM_MACH_MSM_IOMMU_HW_8XXX_H
> +#define __ARCH_ARM_MACH_MSM_IOMMU_HW_8XXX_H
> +
> +#define CTX_SHIFT 12
> +
> +#define GET_GLOBAL_REG(reg, base) (readl((base)|(reg)))
> +#define GET_CTX_REG(reg, base, ctx)	(readl((base)|(reg)|((ctx)<<CTX_SHIFT)))

This doesn't work if 'base' is correctly typed.  Use addition please.
Spacces around operators please.

> +
> +#define SET_GLOBAL_REG(reg, base, val)	(writel((val), (base) | (reg)))
> +
> +#define SET_CTX_REG(reg, base, ctx, val) \
> +			(writel((val), (base) | (reg) | ((ctx)<<CTX_SHIFT)))

Addition.

> +
> +/* Wrappers for numbered registers */
> +#define SET_GLOBAL_REG_N(b, n, r, v) SET_GLOBAL_REG(b, ((r)|(n<<2)), (v))
> +#define GET_GLOBAL_REG_N(b, n, r)    GET_GLOBAL_REG(b, ((r)|(n<<2)))
> +
> +/* Field wrappers */
> +#define GET_GLOBAL_FIELD(b, r, F)    GET_FIELD(((b)|(r)), F##_MASK, F##_SHIFT)
> +#define GET_CONTEXT_FIELD(b, c, r, F)	\
> +	GET_FIELD(((b)|(r)|((c)<<CTX_SHIFT)), F##_MASK, F##_SHIFT)
> +
> +#define SET_GLOBAL_FIELD(b, r, F, v) \
> +	SET_FIELD(((b)|(r)), F##_MASK, F##_SHIFT, (v))
> +#define SET_CONTEXT_FIELD(b, c, r, F, v)	\
> +	SET_FIELD(((b)|(r)|((c)<<CTX_SHIFT)), F##_MASK, F##_SHIFT, (v))
> +
> +#define GET_FIELD(addr, mask, shift)  ((readl(addr) >> (shift) & (mask)))
> +
> +#define SET_FIELD(addr, mask, shift, v) \
> +do { \
> +	int t = readl(addr); mb(); \
> +	writel((t & ~((mask)<<(shift))) | (((v) & (mask)) << (shift)), addr);\
> +	mb();\

readl/writel have barriers now, so these probably aren't required.  Please
check.

...
> +	if (len == SZ_16M) {
> +		int i = 0;
> +		for (i = 0; i < 16; i++)
> +			*(fl_pte+i) = (pa & 0xFF000000) | PMD_SECT_SUPER |
> +				PMD_SECT_AP_READ | PMD_SECT_AP_WRITE |
> +				PMD_TYPE_SECT | PMD_SECT_S;

Don't reuse the kernel's definitions for its own page tables for IOMMU
page tables.

> +	}
> +
> +	if (len == SZ_1M)
> +		*fl_pte = (pa & 0xFFF00000) | PMD_SECT_AP_READ |
> +			PMD_SECT_AP_WRITE | PMD_TYPE_SECT |
> +			PMD_SECT_S;

Ditto.

> +
> +	/* Need a 2nd level table */
> +	if ((len == SZ_4K || len == SZ_64K) && (*fl_pte) == 0) {
> +		unsigned long *sl;
> +		sl = (unsigned long *) __get_free_pages(GFP_KERNEL, 0);
> +
> +		if (!sl) {
> +			pr_err("could not allocate second level table\n");
> +			goto fail_nomem;
> +		}
> +
> +		memset(sl, 0, SZ_4K);
> +		*fl_pte = ((((int)__pa(sl)) & 0xFFFFFC00) | PMD_TYPE_TABLE);

Ditto.

> +	}
> +
> +	sl_table = (unsigned long *) __va(((*fl_pte) & 0xFFFFFC00));
> +	sl_offset = SL_OFFSET(va);
> +	sl_pte = sl_table + sl_offset;
> +
> +
> +	if (len == SZ_4K)
> +		*sl_pte = (pa & 0xFFFFF000) | PTE_EXT_AP0 | PTE_EXT_AP1 |
> +			PTE_EXT_SHARED | PTE_TYPE_SMALL;

Ditto.

> +
> +	if (len == SZ_64K) {
> +		int i;
> +
> +		for (i = 0; i < 16; i++)
> +			*(sl_pte+i) = (pa & 0xFFFF0000) | PTE_EXT_AP0 |
> +				PTE_EXT_AP1 | PTE_EXT_SHARED | PTE_TYPE_LARGE;

Ditto.

> +	}
> +
> +#ifndef CONFIG_IOMMU_PGTABLES_L2
> +	v7_flush_kern_cache_all();
> +#endif

What has L2 got to do with whether you flush the L1 cache?

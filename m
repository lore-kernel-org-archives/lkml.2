Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796Ab0HFIRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:17:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42828 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0HFIRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:17:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6065"; a="49961787"
Message-ID: <93bd044b61aed19a3571bc019af0252a.squirrel@www.codeaurora.org>
In-Reply-To: <20100806073333.GA14965@n2100.arm.linux.org.uk>
References: <1281062204-21880-1-git-send-email-stepanm@codeaurora.org>
    <20100806073333.GA14965@n2100.arm.linux.org.uk>
Date: Fri, 6 Aug 2010 01:17:46 -0700 (PDT)
Subject: Re: [PATCH] arm: msm: Add MSM IOMMU support.
From: stepanm@codeaurora.org
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Stepan Moskovchenko" <stepanm@codeaurora.org>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Aug 05, 2010 at 07:36:44PM -0700, Stepan Moskovchenko wrote:
>> +/**
>> + * struct msm_iommu_dev - a single IOMMU hardware instance
>> + * name		Human-readable name given to this IOMMU HW instance
>> + * clk		Name of the AXI clock used for the config space of this IOMMU
>> + * clk_rate	Rate to set for the AXI clock. 0 means don't set a rate
>> + * num_ctx	Number of context banks on this IOMMU device
>> + *
>> + */
>> +struct msm_iommu_dev {
>> +	char *name;
>
> const?
>
>> +	char *clk;
>
> const?  Any reason you can't have some kind of struct device instead?
>
>> +	unsigned long clk_rate;
>> +	unsigned int num_ctx;
>> +};
>> +
>> +/**
>> + * struct msm_iommu_ctx_dev - an IOMMU context bank instance
>> + * name		Human-readable name given to this context bank
>> + * num		Index of this context bank within the hardware
>> + * mids		List of Machine IDs that are to be mapped into this context
>> + *		bank, terminated by -1. The MID is a set of signals on the
>> + *		AXI bus that identifies the function associated with a specific
>> + *		memory request. (See ARM spec).
>> + */
>> +struct msm_iommu_ctx_dev {
>> +	char *name;
>
> const?
>
>> +	int num;
>> +	int mids[MAX_NUM_MIDS];
>> +};
>> +
> ...
>> +int v7_flush_kern_cache_all(void);
>
> No - don't use internal functions directly.  Use flush_cache_all()
> instead.
>
>> +#ifndef __ARCH_ARM_MACH_MSM_IOMMU_HW_8XXX_H
>> +#define __ARCH_ARM_MACH_MSM_IOMMU_HW_8XXX_H
>> +
>> +#define CTX_SHIFT 12
>> +
>> +#define GET_GLOBAL_REG(reg, base) (readl((base)|(reg)))
>> +#define GET_CTX_REG(reg, base,
>> ctx)	(readl((base)|(reg)|((ctx)<<CTX_SHIFT)))
>
> This doesn't work if 'base' is correctly typed.  Use addition please.
> Spacces around operators please.
>
>> +
>> +#define SET_GLOBAL_REG(reg, base, val)	(writel((val), (base) | (reg)))
>> +
>> +#define SET_CTX_REG(reg, base, ctx, val) \
>> +			(writel((val), (base) | (reg) | ((ctx)<<CTX_SHIFT)))
>
> Addition.
>
>> +
>> +/* Wrappers for numbered registers */
>> +#define SET_GLOBAL_REG_N(b, n, r, v) SET_GLOBAL_REG(b, ((r)|(n<<2)),
>> (v))
>> +#define GET_GLOBAL_REG_N(b, n, r)    GET_GLOBAL_REG(b, ((r)|(n<<2)))
>> +
>> +/* Field wrappers */
>> +#define GET_GLOBAL_FIELD(b, r, F)    GET_FIELD(((b)|(r)), F##_MASK,
>> F##_SHIFT)
>> +#define GET_CONTEXT_FIELD(b, c, r, F)	\
>> +	GET_FIELD(((b)|(r)|((c)<<CTX_SHIFT)), F##_MASK, F##_SHIFT)
>> +
>> +#define SET_GLOBAL_FIELD(b, r, F, v) \
>> +	SET_FIELD(((b)|(r)), F##_MASK, F##_SHIFT, (v))
>> +#define SET_CONTEXT_FIELD(b, c, r, F, v)	\
>> +	SET_FIELD(((b)|(r)|((c)<<CTX_SHIFT)), F##_MASK, F##_SHIFT, (v))
>> +
>> +#define GET_FIELD(addr, mask, shift)  ((readl(addr) >> (shift) &
>> (mask)))
>> +
>> +#define SET_FIELD(addr, mask, shift, v) \
>> +do { \
>> +	int t = readl(addr); mb(); \
>> +	writel((t & ~((mask)<<(shift))) | (((v) & (mask)) << (shift)), addr);\
>> +	mb();\
>
> readl/writel have barriers now, so these probably aren't required.  Please
> check.
>
> ...
>> +	if (len == SZ_16M) {
>> +		int i = 0;
>> +		for (i = 0; i < 16; i++)
>> +			*(fl_pte+i) = (pa & 0xFF000000) | PMD_SECT_SUPER |
>> +				PMD_SECT_AP_READ | PMD_SECT_AP_WRITE |
>> +				PMD_TYPE_SECT | PMD_SECT_S;
>
> Don't reuse the kernel's definitions for its own page tables for IOMMU
> page tables.
>
>> +	}
>> +
>> +	if (len == SZ_1M)
>> +		*fl_pte = (pa & 0xFFF00000) | PMD_SECT_AP_READ |
>> +			PMD_SECT_AP_WRITE | PMD_TYPE_SECT |
>> +			PMD_SECT_S;
>
> Ditto.
>
>> +
>> +	/* Need a 2nd level table */
>> +	if ((len == SZ_4K || len == SZ_64K) && (*fl_pte) == 0) {
>> +		unsigned long *sl;
>> +		sl = (unsigned long *) __get_free_pages(GFP_KERNEL, 0);
>> +
>> +		if (!sl) {
>> +			pr_err("could not allocate second level table\n");
>> +			goto fail_nomem;
>> +		}
>> +
>> +		memset(sl, 0, SZ_4K);
>> +		*fl_pte = ((((int)__pa(sl)) & 0xFFFFFC00) | PMD_TYPE_TABLE);
>
> Ditto.
>
>> +	}
>> +
>> +	sl_table = (unsigned long *) __va(((*fl_pte) & 0xFFFFFC00));
>> +	sl_offset = SL_OFFSET(va);
>> +	sl_pte = sl_table + sl_offset;
>> +
>> +
>> +	if (len == SZ_4K)
>> +		*sl_pte = (pa & 0xFFFFF000) | PTE_EXT_AP0 | PTE_EXT_AP1 |
>> +			PTE_EXT_SHARED | PTE_TYPE_SMALL;
>
> Ditto.
>
>> +
>> +	if (len == SZ_64K) {
>> +		int i;
>> +
>> +		for (i = 0; i < 16; i++)
>> +			*(sl_pte+i) = (pa & 0xFFFF0000) | PTE_EXT_AP0 |
>> +				PTE_EXT_AP1 | PTE_EXT_SHARED | PTE_TYPE_LARGE;
>
> Ditto.
>
>> +	}
>> +
>> +#ifndef CONFIG_IOMMU_PGTABLES_L2
>> +	v7_flush_kern_cache_all();
>> +#endif
>
> What has L2 got to do with whether you flush the L1 cache?

Hello

Thank you for your comments. I will apply the fixes you have mentioned. I
am flushing the cache when I update the page table because the page table
lives in regular RAM that is mapped as cacheable on the CPU side, and in
the default configuration the IOMMU reads the page table from RAM. So, I
have put in the flush call to give the IOMMU a coherent view of the page
tables. I realize it is more efficient to just flush that specific part of
L2, but this is just the basic version of the driver and that optimization
will be eventually put in. The hardware is actually capable of reading the
IOMMU page table straight out of the L2 cache, but I haven't figured out
how much control the API should give over this feature... initially I was
thinking of a Kconfig "sub-option" for it but maybe more fine-grained
control is in order, depending on the access pattern of each IOMMU. I can
add this functionality in a subsequent patch, once the basic driver is in.
If flushing the cache in this manner is not the right way to handle IOMMU
page tables, can you please suggest what would be more appropriate?

What did you mean by:
> Any reason you can't have some kind of struct device instead?

Are you referring to the clock line? As far as I understand it, the kernel
tracks the clocks by a string name, but I can look into it further. Only a
few of the IOMMUs even have clocks that I need to control in this manner,
and these are only accessed at init time. From what I remember, it is
possible to "get" a clock device, but I am not sure these can be
statically added to the struct like that.

I will make the changes you suggested and post another version soon.

Thanks
Steve


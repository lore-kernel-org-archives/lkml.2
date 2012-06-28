Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2F1ErB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 00:47:01 -0400
Received: from plane.gmane.org ([80.91.229.3]:35896 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab2F1ErA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 00:47:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] [RESEND] arm: limit memblock base address for early_pte_alloc
Date: Thu, 28 Jun 2012 13:46:58 +0900
Message-ID: <4FEBE1C2.9080201@kernel.org>
References: <1338880312-17561-1-git-send-email-minchan@kernel.org> <20120627161224.GB2310@linaro.org> <alpine.LFD.2.02.1206280019160.31003@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 121.50.20.41
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
In-Reply-To: <alpine.LFD.2.02.1206280019160.31003@xanadu.home>
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

종성 선임님.

제가 장비가 없는 문제로 아래의 패치를 테스트 할 수 없는데, 시간 되시면
테스트 후 Nicolas에게 feedback좀 부탁드리겠습니다. 문제는 posting해놓고,
follow up하지 않게 되면,,,, 신뢰의 문제라서요. -_-;;

러쎌이 어떻게 나올지 모르겠네요. 계속 그냥 1M로 해서 쓰라고 할지...

감사합니다.

On 06/28/2012 01:33 PM, Nicolas Pitre wrote:

> On Wed, 27 Jun 2012, Dave Martin wrote:
> 
>> On Tue, Jun 05, 2012 at 04:11:52PM +0900, Minchan Kim wrote:
>>> If we do arm_memblock_steal with a page which is not aligned with section size,
>>> panic can happen during boot by page fault in map_lowmem.
>>>
>>> Detail:
>>>
>>> 1) mdesc->reserve can steal a page which is allocated at 0x1ffff000 by memblock
>>>    which prefers tail pages of regions.
>>> 2) map_lowmem maps 0x00000000 - 0x1fe00000
>>> 3) map_lowmem try to map 0x1fe00000 but it's not aligned by section due to 1.
>>> 4) calling alloc_init_pte allocates a new page for new pte by memblock_alloc
>>> 5) allocated memory for pte is 0x1fffe000 -> it's not mapped yet.
>>> 6) memset(ptr, 0, sz) in early_alloc_aligned got PANICed!
>>>
>>> This patch fix it by limiting memblock to mapped memory range.
>>>
>>> Reported-by: Jongsung Kim <neidhard.kim@lge.com>
>>> Suggested-by: Chanho Min <chanho.min@lge.com>
>>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>>> ---
>>>  arch/arm/mm/mmu.c |   37 ++++++++++++++++++++++---------------
>>>  1 file changed, 22 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
>>> index e5dad60..a15aafe 100644
>>> --- a/arch/arm/mm/mmu.c
>>> +++ b/arch/arm/mm/mmu.c
>>> @@ -594,7 +594,7 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
>>>  
>>>  static void __init alloc_init_section(pud_t *pud, unsigned long addr,
>>>  				      unsigned long end, phys_addr_t phys,
>>> -				      const struct mem_type *type)
>>> +				      const struct mem_type *type, bool lowmem)
>>>  {
>>>  	pmd_t *pmd = pmd_offset(pud, addr);
>>>  
>>> @@ -619,6 +619,8 @@ static void __init alloc_init_section(pud_t *pud, unsigned long addr,
>>>  
>>>  		flush_pmd_entry(p);
>>>  	} else {
>>> +		if (lowmem)
>>> +			memblock_set_current_limit(__pa(addr));
>>
>> I thought of doing something similar to this.  A concern I have is that
>> when mapping the first few sections, is it guaranteed that there will be
>> enough memory available below memblock.current_limit to allocate extra
>> page tables, in general?  I think we could get failures here even though
>> there is spare (unmapped) memory above the limit.
>>
>> An alternative approach would be to install temporary section mappings
>> to cover all of lowmem before starting to create the real mappings.
>> The memblock allocator still knows which regions are reserved, so we
>> shouldn't end up scribbling on pages which are really not supposed to
>> be mapped in lowmem.
>>
>> That feels like it should work, but would involve extra overheads, more
>> flushing etc. to purge all those temporary section mappings from the TLB.
> 
> This is all rather fragile and inelegant.
> 
> I propose the following two patches instead -- both patches are included 
> inline not to break the email thread.  What do you think?
> 
> ---------- >8
> 
> From: Nicolas Pitre <nicolas.pitre@linaro.org>
> Date: Wed, 27 Jun 2012 23:02:31 -0400
> Subject: [PATCH] ARM: head.S: simplify initial page table mapping
> 
> Let's map the initial RAM up to the end of the kernel.bss plus 64MB
> instead of the strict kernel image area.  This simplifies the code
> as the kernel image only needs to be handled specially in the XIP case.
> This also give some room for the early memory allocator to use before
> the real mapping is finally installed with the actual amount of memory.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> 
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 835898e7d7..cc3103fb66 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -55,14 +55,6 @@
>  	add	\rd, \phys, #TEXT_OFFSET - PG_DIR_SIZE
>  	.endm
>  
> -#ifdef CONFIG_XIP_KERNEL
> -#define KERNEL_START	XIP_VIRT_ADDR(CONFIG_XIP_PHYS_ADDR)
> -#define KERNEL_END	_edata_loc
> -#else
> -#define KERNEL_START	KERNEL_RAM_VADDR
> -#define KERNEL_END	_end
> -#endif
> -
>  /*
>   * Kernel startup entry point.
>   * ---------------------------
> @@ -218,51 +210,50 @@ __create_page_tables:
>  	blo	1b
>  
>  	/*
> -	 * Now setup the pagetables for our kernel direct
> -	 * mapped region.
> +	 * Map some RAM to cover the kernel image and its .bss section.
> +	 * Push some additional 64MB to give the early memory allocator
> +	 * some initial room (beware: real RAM might or might not be there
> +	 * across the whole area). The real memory map will be established
> +	 * (extended or shrunk) later.
>  	 */
> -	mov	r3, pc
> -	mov	r3, r3, lsr #SECTION_SHIFT
> -	orr	r3, r7, r3, lsl #SECTION_SHIFT
> -	add	r0, r4,  #(KERNEL_START & 0xff000000) >> (SECTION_SHIFT - PMD_ORDER)
> -	str	r3, [r0, #((KERNEL_START & 0x00f00000) >> SECTION_SHIFT) << PMD_ORDER]!
> -	ldr	r6, =(KERNEL_END - 1)
> -	add	r0, r0, #1 << PMD_ORDER
> +	add	r0, r4, #PAGE_OFFSET >> (SECTION_SHIFT - PMD_ORDER)
> +	ldr	r6, =(_end + 64 * 1024 * 1024)
> +	orr	r3, r8, r7
>  	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ORDER)
> -1:	cmp	r0, r6
> +1:	str	r3, [r0], #1 << PMD_ORDER
>  	add	r3, r3, #1 << SECTION_SHIFT
> -	strls	r3, [r0], #1 << PMD_ORDER
> +	cmp	r0, r6
>  	bls	1b
>  
>  #ifdef CONFIG_XIP_KERNEL
>  	/*
> -	 * Map some ram to cover our .data and .bss areas.
> +	 * Map the kernel image separately as it is not located in RAM.
>  	 */
> -	add	r3, r8, #TEXT_OFFSET
> -	orr	r3, r3, r7
> -	add	r0, r4,  #(KERNEL_RAM_VADDR & 0xff000000) >> (SECTION_SHIFT - PMD_ORDER)
> -	str	r3, [r0, #(KERNEL_RAM_VADDR & 0x00f00000) >> (SECTION_SHIFT - PMD_ORDER)]!
> -	ldr	r6, =(_end - 1)
> -	add	r0, r0, #4
> +#define XIP_START XIP_VIRT_ADDR(CONFIG_XIP_PHYS_ADDR)
> +	mov	r3, pc
> +	mov	r3, r3, lsr #SECTION_SHIFT
> +	orr	r3, r7, r3, lsl #SECTION_SHIFT
> +	add	r0, r4,  #(XIP_START & 0xff000000) >> (SECTION_SHIFT - PMD_ORDER)
> +	str	r3, [r0, #((XIP_START & 0x00f00000) >> SECTION_SHIFT) << PMD_ORDER]!
> +	ldr	r6, =(_edata_loc - 1)
> +	add	r0, r0, #1 << PMD_ORDER
>  	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ORDER)
>  1:	cmp	r0, r6
> -	add	r3, r3, #1 << 20
> -	strls	r3, [r0], #4
> +	add	r3, r3, #1 << SECTION_SHIFT
> +	strls	r3, [r0], #1 << PMD_ORDER
>  	bls	1b
>  #endif
>  
>  	/*
> -	 * Then map boot params address in r2 or the first 1MB (2MB with LPAE)
> -	 * of ram if boot params address is not specified.
> +	 * Then map boot params address in r2 if specified.
>  	 */
>  	mov	r0, r2, lsr #SECTION_SHIFT
>  	movs	r0, r0, lsl #SECTION_SHIFT
> -	moveq	r0, r8
> -	sub	r3, r0, r8
> -	add	r3, r3, #PAGE_OFFSET
> -	add	r3, r4, r3, lsr #(SECTION_SHIFT - PMD_ORDER)
> -	orr	r6, r7, r0
> -	str	r6, [r3]
> +	subne	r3, r0, r8
> +	addne	r3, r3, #PAGE_OFFSET
> +	addne	r3, r4, r3, lsr #(SECTION_SHIFT - PMD_ORDER)
> +	orrne	r6, r7, r0
> +	strne	r6, [r3]
>  
>  #ifdef CONFIG_DEBUG_LL
>  #if !defined(CONFIG_DEBUG_ICEDCC) && !defined(CONFIG_DEBUG_SEMIHOSTING)
> 
> ---------- >8
> 
> From: Nicolas Pitre <nicolas.pitre@linaro.org>
> Date: Wed, 27 Jun 2012 23:58:39 -0400
> Subject: [PATCH] ARM: adjust the memblock limit according to the available memory mapping
> 
> Early on the only accessible memory comes from the initial mapping
> performed in head.S, minus those page table entries cleared in
> prepare_page_table().  Eventually the full lowmem is available once
> map_lowmem() has mapped it.  Let's have this properly reflected in the
> memblock allocator limit.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index e5dad60b55..7260e98dd4 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -932,7 +932,6 @@ void __init sanity_check_meminfo(void)
>  #endif
>  	meminfo.nr_banks = j;
>  	high_memory = __va(arm_lowmem_limit - 1) + 1;
> -	memblock_set_current_limit(arm_lowmem_limit);
>  }
>  
>  static inline void prepare_page_table(void)
> @@ -967,6 +966,13 @@ static inline void prepare_page_table(void)
>  	for (addr = __phys_to_virt(end);
>  	     addr < VMALLOC_START; addr += PMD_SIZE)
>  		pmd_clear(pmd_off_k(addr));
> +
> +	/*
> +	 * The code in head.S has set a mapping up to _end + 64MB.
> +	 * The code above has cleared any mapping from 'end' upwards.
> +	 * Let's have this reflected in the available memory from memblock.
> +	 */ 
> +	memblock_set_current_limit(min(end, virt_to_phys(_end) + SZ_64M));
>  }
>  
>  #ifdef CONFIG_ARM_LPAE
> @@ -1113,6 +1119,8 @@ static void __init map_lowmem(void)
>  
>  		create_mapping(&map);
>  	}
> +
> +	memblock_set_current_limit(arm_lowmem_limit);
>  }
>  
>  /*
> @@ -1123,8 +1131,6 @@ void __init paging_init(struct machine_desc *mdesc)
>  {
>  	void *zero_page;
>  
> -	memblock_set_current_limit(arm_lowmem_limit);
> -
>  	build_mem_type_table();
>  	prepare_page_table();
>  	map_lowmem();
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 



-- 
Kind regards,
Minchan Kim


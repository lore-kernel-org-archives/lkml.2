Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1JNFq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:46:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:54218 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab1JNFq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:46:56 -0400
Message-ID: <4E97CC6D.5060508@oracle.com>
Date: Thu, 13 Oct 2011 22:45:17 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/1] x86, e820: Remove direct mapping of reserved space
 for HT hole around 1TB
References: <1318370975-10817-1-git-send-email-jacob.shin@amd.com> <20111013110410.GB16748@alberich.amd.com>
In-Reply-To: <20111013110410.GB16748@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E97CC85.012D:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 04:04 AM, Andreas Herrmann wrote:

> CC-ing Yinghai Lu <yinghai.lu@oracle.com> as yinghai@kernel.org still
> doesn't seem to work.
> 
> 
> Andreas
> 
> On Tue, Oct 11, 2011 at 05:09:35PM -0500, Jacob Shin wrote:
>> The entire HT hole and also the unused address range before that hole
>> need to be excluded from direct mapping. Otherwise speculative
>> accesses to that reserved region can happen which cause machine
>> checks.


Great, now AMD platform could support 8T ram?

>>
>> Cc: stable@kernel.org   # > 2.6.32
>> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
>> ---
>>  arch/x86/include/asm/e820.h           |    1 +
>>  arch/x86/include/asm/hypertransport.h |    7 +++++
>>  arch/x86/include/asm/processor.h      |   16 +++++++++++++
>>  arch/x86/kernel/cpu/amd.c             |   40 +++++++++++++++++++++++++++++++++
>>  arch/x86/kernel/e820.c                |    6 +++++
>>  arch/x86/kernel/setup.c               |    8 +++++-
>>  6 files changed, 76 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
>> index 908b969..7e4d417 100644
>> --- a/arch/x86/include/asm/e820.h
>> +++ b/arch/x86/include/asm/e820.h
>> @@ -117,6 +117,7 @@ static inline void early_memtest(unsigned long start, unsigned long end)
>>  
>>  extern unsigned long e820_end_of_ram_pfn(void);
>>  extern unsigned long e820_end_of_low_ram_pfn(void);
>> +extern unsigned long e820_end_of_ram_under_ht_pfn(void);
>>  extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
>>  
>>  void memblock_x86_fill(void);
>> diff --git a/arch/x86/include/asm/hypertransport.h b/arch/x86/include/asm/hypertransport.h
>> index 334b1a8..c1d5a08 100644
>> --- a/arch/x86/include/asm/hypertransport.h
>> +++ b/arch/x86/include/asm/hypertransport.h
>> @@ -42,4 +42,11 @@
>>  #define HT_IRQ_HIGH_DEST_ID(v)						\
>>  	((((v) >> 8) << HT_IRQ_HIGH_DEST_ID_SHIFT) & HT_IRQ_HIGH_DEST_ID_MASK)
>>  
>> +/*
>> + * Memory Region Reserved for HyperTransport
>> + */
>> +
>> +#define HT_RESERVED_MEM_START           0xfd00000000ULL
>> +#define HT_RESERVED_MEM_END             0x10000000000ULL
>> +
>>  #endif /* _ASM_X86_HYPERTRANSPORT_H */
>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>> index 0d1171c..73ae54f 100644
>> --- a/arch/x86/include/asm/processor.h
>> +++ b/arch/x86/include/asm/processor.h
>> @@ -970,6 +970,22 @@ extern int set_tsc_mode(unsigned int val);
>>  
>>  extern int amd_get_nb_id(int cpu);
>>  
>> +#if defined(CONFIG_CPU_SUP_AMD) && defined(CONFIG_X86_64)
>> +extern int amd_with_ram_above_ht(void);
>> +extern unsigned long amd_init_high_memory_mapping(void);
>> +#else
>> +static inline int amd_with_ram_above_ht(void)
>> +{
>> +	return 0;
>> +}
>> +
>> +static inline unsigned long amd_init_high_memory_mapping(void)
>> +{
>> +	BUG();
>> +	return 0;
>> +}
>> +#endif
>> +
>>  struct aperfmperf {
>>  	u64 aperf, mperf;
>>  };
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index b13ed39..a57b010 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -7,6 +7,7 @@
>>  #include <asm/apic.h>
>>  #include <asm/cpu.h>
>>  #include <asm/pci-direct.h>
>> +#include <asm/hypertransport.h>
>>  
>>  #ifdef CONFIG_X86_64
>>  # include <asm/numa_64.h>
>> @@ -755,3 +756,42 @@ bool cpu_has_amd_erratum(const int *erratum)
>>  }
>>  
>>  EXPORT_SYMBOL_GPL(cpu_has_amd_erratum);
>> +
>> +#if defined(CONFIG_CPU_SUP_AMD) && defined(CONFIG_X86_64)
>> +int __cpuinit amd_with_ram_above_ht(void)
>> +{
>> +	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
>> +	    max_pfn << PAGE_SHIFT >= HT_RESERVED_MEM_START)
>> +		return 1;
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * On AMD systems, memory region 0xfd_0000_0000 ~ 0xff_ffff_ffff is reserved by
>> + * HyperTransport and cannot be used by the processor. On systems with more than
>> + * 1TB of RAM, BIOS may take memory immediately below the HT region and "hoist"
>> + * it up above the HT region, leaving a hole.
>> + */
>> +unsigned long __cpuinit amd_init_high_memory_mapping(void)
>> +{
>> +	unsigned long ret;
>> +
>> +	/* remove HT region from the e820 map, if it's declared as usable */
>> +	e820_remove_range(HT_RESERVED_MEM_START,
>> +			  HT_RESERVED_MEM_END - HT_RESERVED_MEM_START,
>> +			  E820_RAM, 1);
>> +	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
>> +
>> +	/* direct mapping of high memory under HT */
>> +	ret = init_memory_mapping(1UL << 32,
>> +		e820_end_of_ram_under_ht_pfn() << PAGE_SHIFT);
>> +
>> +	/* skip HT region, direct mapping of high memory above HT */
>> +	if (max_pfn << PAGE_SHIFT >= HT_RESERVED_MEM_END)
>> +		ret = init_memory_mapping(HT_RESERVED_MEM_END,
>> +					  max_pfn << PAGE_SHIFT);
>> +
>> +	return ret;
>> +}
>> +#endif
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index 3e2ef84..c0ba036 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -22,6 +22,7 @@
>>  #include <asm/e820.h>
>>  #include <asm/proto.h>
>>  #include <asm/setup.h>
>> +#include <asm/hypertransport.h>
>>  
>>  /*
>>   * The e820 map is the map that gets modified e.g. with command line parameters
>> @@ -826,6 +827,11 @@ unsigned long __init e820_end_of_low_ram_pfn(void)
>>  	return e820_end_pfn(1UL<<(32 - PAGE_SHIFT), E820_RAM);
>>  }
>>  
>> +unsigned long __init e820_end_of_ram_under_ht_pfn(void)
>> +{
>> +	return e820_end_pfn(HT_RESERVED_MEM_START >> PAGE_SHIFT, E820_RAM);
>> +}
>> +
>>  static void early_panic(char *msg)
>>  {
>>  	early_printk(msg);
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index afaf384..84d0968 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -937,8 +937,12 @@ void __init setup_arch(char **cmdline_p)
>>  
>>  #ifdef CONFIG_X86_64
>>  	if (max_pfn > max_low_pfn) {
>> -		max_pfn_mapped = init_memory_mapping(1UL<<32,
>> -						     max_pfn<<PAGE_SHIFT);
>> +		if (amd_with_ram_above_ht())
>> +			max_pfn_mapped = amd_init_high_memory_mapping();
>> +		else
>> +			max_pfn_mapped = init_memory_mapping(1UL << 32,
>> +				max_pfn << PAGE_SHIFT);
>> +
>>  		/* can we preseve max_low_pfn ?*/
>>  		max_low_pfn = max_pfn;
>>  	}


that is too late to change e820 here.

You need to update e820 map before
memblock_x86_fill()

like the place of: trim_bios_range() or early_gart_iommu_check()

BTW:
BIOS should put that range in reserved, right?

about mapping for hole above 4g, if you do think that is problem, we can unmap them later
if that does not cause any TLB stress.

Thanks

Yinghai Lu



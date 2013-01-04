Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3ADRTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:19:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:39140 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab3ADRTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:19:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,411,1355126400"; 
   d="scan'208";a="272924609"
From: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7u1 07/31] x86, realmode: Separate real_mode reserve
 and setup
Thread-Topic: [PATCH v7u1 07/31] x86, realmode: Separate real_mode reserve
 and setup
Thread-Index: AQHN6hVROSxw6ix2V0+Zyi7YQSmN5Jg5apCA
Date: Fri, 4 Jan 2013 17:18:39 +0000
Message-ID: <1357319845.7763.0.camel@jsakkine-mobl1>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	 <1357260531-11115-8-git-send-email-yinghai@kernel.org>
In-Reply-To: <1357260531-11115-8-git-send-email-yinghai@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.14.29]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F4751BF38A11D4F894118FB0F464C6F@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r04HJnu9015610

On Thu, 2013-01-03 at 16:48 -0800, Yinghai Lu wrote:
> After we switch to use #PF handler help to set page table, init_level4_pgt
> will only have entries set after init_mem_mapping.
> We need to move copying init_level4_pgt to trampoline_pgd after that.
> 
> So split reserve and setup, and move the setup after init_mem_mapping()
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

> ---
>  arch/x86/include/asm/realmode.h |    3 ++-
>  arch/x86/kernel/setup.c         |    4 +++-
>  arch/x86/realmode/init.c        |   30 +++++++++++++++++++-----------
>  3 files changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
> index fe1ec5b..9c6b890 100644
> --- a/arch/x86/include/asm/realmode.h
> +++ b/arch/x86/include/asm/realmode.h
> @@ -58,6 +58,7 @@ extern unsigned char boot_gdt[];
>  extern unsigned char secondary_startup_64[];
>  #endif
>  
> -extern void __init setup_real_mode(void);
> +void reserve_real_mode(void);
> +void setup_real_mode(void);
>  
>  #endif /* _ARCH_X86_REALMODE_H */
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 81ea5a5..01b22d0 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -913,10 +913,12 @@ void __init setup_arch(char **cmdline_p)
>  	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
>  			(max_pfn_mapped<<PAGE_SHIFT) - 1);
>  
> -	setup_real_mode();
> +	reserve_real_mode();
>  
>  	init_mem_mapping();
>  
> +	setup_real_mode();
> +
>  	memblock.current_limit = get_max_mapped();
>  	dma_contiguous_reserve(0);
>  
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index 384b3f4..3baae96 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -8,9 +8,26 @@
>  struct real_mode_header *real_mode_header;
>  u32 *trampoline_cr4_features;
>  
> -void __init setup_real_mode(void)
> +void __init reserve_real_mode(void)
>  {
>  	phys_addr_t mem;
> +	unsigned char *base;
> +	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
> +
> +	/* Has to be in very low memory so we can execute real-mode AP code. */
> +	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
> +	if (!mem)
> +		panic("Cannot allocate trampoline\n");
> +
> +	base = __va(mem);
> +	memblock_reserve(mem, size);
> +	real_mode_header = (struct real_mode_header *) base;
> +	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
> +	       base, (unsigned long long)mem, size);
> +}
> +
> +void __init setup_real_mode(void)
> +{
>  	u16 real_mode_seg;
>  	u32 *rel;
>  	u32 count;
> @@ -25,16 +42,7 @@ void __init setup_real_mode(void)
>  	u64 efer;
>  #endif
>  
> -	/* Has to be in very low memory so we can execute real-mode AP code. */
> -	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
> -	if (!mem)
> -		panic("Cannot allocate trampoline\n");
> -
> -	base = __va(mem);
> -	memblock_reserve(mem, size);
> -	real_mode_header = (struct real_mode_header *) base;
> -	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
> -	       base, (unsigned long long)mem, size);
> +	base = (unsigned char *)real_mode_header;
>  
>  	memcpy(base, real_mode_blob, size);
>  

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

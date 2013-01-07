Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3AGPzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:55:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33288 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab3AGPzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:55:00 -0500
Date: Mon, 7 Jan 2013 16:54:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: [PATCH v7u1 07/31] x86, realmode: Separate real_mode reserve and
 setup
Message-ID: <20130107155457.GC29449@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org,
	Jarkko Sakkinen <jarkko.sakkinen@intel.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-8-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-8-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:27PM -0800, Yinghai Lu wrote:
> After we switch to use #PF handler help to set page table, init_level4_pgt
> will only have entries set after init_mem_mapping.
> We need to move copying init_level4_pgt to trampoline_pgd after that.
> 
> So split reserve and setup, and move the setup after init_mem_mapping()
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
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

While we're at it, can we change the comment to say "has to be in the
first megabyte..." to be more precise. "very low" is not very telling
:-).

Thanks.

-- 
Regards/Gruss,
Boris.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3ADLiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:38:07 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59804 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab3ADLiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:38:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v7u1 31/31] x86, 64bit, mm: hibernate use generic mapping_init
Date: Fri, 04 Jan 2013 12:43:39 +0100
Message-ID: <61708402.lBGARq0J34@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1357260531-11115-32-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <1357260531-11115-32-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 03, 2013 04:48:51 PM Yinghai Lu wrote:
> Make it only map range in pfn_mapped array.

Can you please explain why that should be sufficient?

Have you tested it?

> and it has kernel mapping with EXEC.

That's because it needs to execute code from one of those pages and it
doesn't know in advance which one that's going to be.

Thanks,
Rafael


> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-pm@vger.kernel.org
> ---
>  arch/x86/power/hibernate_64.c |   66 ++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
> index 460f314..a0fde91 100644
> --- a/arch/x86/power/hibernate_64.c
> +++ b/arch/x86/power/hibernate_64.c
> @@ -11,6 +11,8 @@
>  #include <linux/gfp.h>
>  #include <linux/smp.h>
>  #include <linux/suspend.h>
> +
> +#include <asm/init.h>
>  #include <asm/proto.h>
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
> @@ -39,41 +41,21 @@ pgd_t *temp_level4_pgt;
>  
>  void *relocated_restore_code;
>  
> -static int res_phys_pud_init(pud_t *pud, unsigned long address, unsigned long end)
> +static void *alloc_pgt_page(void *context)
>  {
> -	long i, j;
> -
> -	i = pud_index(address);
> -	pud = pud + i;
> -	for (; i < PTRS_PER_PUD; pud++, i++) {
> -		unsigned long paddr;
> -		pmd_t *pmd;
> -
> -		paddr = address + i*PUD_SIZE;
> -		if (paddr >= end)
> -			break;
> -
> -		pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
> -		if (!pmd)
> -			return -ENOMEM;
> -		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
> -		for (j = 0; j < PTRS_PER_PMD; pmd++, j++, paddr += PMD_SIZE) {
> -			unsigned long pe;
> -
> -			if (paddr >= end)
> -				break;
> -			pe = __PAGE_KERNEL_LARGE_EXEC | paddr;
> -			pe &= __supported_pte_mask;
> -			set_pmd(pmd, __pmd(pe));
> -		}
> -	}
> -	return 0;
> +	return (void *)get_safe_page(GFP_ATOMIC);
>  }
>
>  static int set_up_temporary_mappings(void)
>  {
> -	unsigned long start, end, next;
> -	int error;
> +	struct x86_mapping_info info = {
> +		.alloc_pgt_page	= alloc_pgt_page,
> +		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
> +		.kernel_mapping = true,
> +	};
> +	unsigned long mstart, mend;
> +	int result;
> +	int i;
>  
>  	temp_level4_pgt = (pgd_t *)get_safe_page(GFP_ATOMIC);
>  	if (!temp_level4_pgt)
> @@ -84,21 +66,17 @@ static int set_up_temporary_mappings(void)
>  		init_level4_pgt[pgd_index(__START_KERNEL_map)]);
>  
>  	/* Set up the direct mapping from scratch */
> -	start = (unsigned long)pfn_to_kaddr(0);
> -	end = (unsigned long)pfn_to_kaddr(max_pfn);
> -
> -	for (; start < end; start = next) {
> -		pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
> -		if (!pud)
> -			return -ENOMEM;
> -		next = start + PGDIR_SIZE;
> -		if (next > end)
> -			next = end;
> -		if ((error = res_phys_pud_init(pud, __pa(start), __pa(next))))
> -			return error;
> -		set_pgd(temp_level4_pgt + pgd_index(start),
> -			mk_kernel_pgd(__pa(pud)));
> +	for (i = 0; i < nr_pfn_mapped; i++) {
> +		mstart = pfn_mapped[i].start << PAGE_SHIFT;
> +		mend   = pfn_mapped[i].end << PAGE_SHIFT;
> +
> +		result = kernel_ident_mapping_init(&info, temp_level4_pgt,
> +						   mstart, mend);
> +
> +		if (result)
> +			return result;
>  	}
> +
>  	return 0;
>  }
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

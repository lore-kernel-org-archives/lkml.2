Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2K1UmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:42:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43450 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab2K1UmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:42:02 -0500
Date: Wed, 28 Nov 2012 21:41:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
Message-ID: <20121128204158.GC14635@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mario Gzuk <mariogzuk@technikz.de>
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
 <1354132230-21854-9-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354132230-21854-9-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 11:50:30AM -0800, H. Peter Anvin wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> Simplify the implementation of sync_core() for the case where we may
> not have the CPUID instruction available.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/include/asm/processor.h | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 9a4ee46..b381df7 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -673,17 +673,24 @@ static inline void sync_core(void)
>  	int tmp;
>  
>  #ifdef CONFIG_M486
> -	if (boot_cpu_data.x86 < 5)
> -		/* There is no speculative execution.
> -		 * jmp is a barrier to prefetching. */
> -		asm volatile("jmp 1f\n1:\n" ::: "memory");
> -	else
> +	/*
> +	 * Do a CPUID if available, otherwise do a jump.  The jump
> +	 * can conveniently enough be the jump around CPUID.
> +	 */
> +	asm volatile("cmpl %2,%1\n\t"
> +		     "jl 1f\n\t"
> +		     "cpuid\n"
> +		     "1:"
> +		     : "=a" (tmp)
> +		     : "rm" (boot_cpu_data.cpuid_level), "ri" (0), "0" (1)
> +		     : "ebx", "ecx", "edx", "memory");
> +#else
> +	/* cpuid is a barrier to speculative execution.
> +	 * Prefetched instructions are automatically
> +	 * invalidated when modified. */

While at it, you could correct this comment to adhere to kernel coding
style:

	/*
	 * cpuid is a barrier...
	 * ...
	 */

> +	asm volatile("cpuid" : "=a" (tmp) : "0" (1)
> +		     : "ebx", "ecx", "edx", "memory");

... and then write this in its shorter form:

	tmp = cpuid_eax(1);

to have it a bit easier on the eyes.

Thanks.

-- 
Regards/Gruss,
    Boris.

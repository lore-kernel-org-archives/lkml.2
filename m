Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1CWKIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:08:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49154 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab1CWKII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:08:08 -0400
Date: Wed, 23 Mar 2011 11:07:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Maksym Planeta <mcsim.planeta@gmail.com>
Cc: tglx@linutronix.de, kernel-janitors@vger.kernel.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: page: get_order() optimization
Message-ID: <20110323100757.GA14245@elte.hu>
References: <1300551947-22279-1-git-send-email-mcsim.planeta@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300551947-22279-1-git-send-email-mcsim.planeta@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maksym Planeta <mcsim.planeta@gmail.com> wrote:

> For x86 architecture get_order function can be optimized due to
> assembler instruction bsr.
> 
> I'm sorry. I've forgot about Signed-off, so the same, but with the sign.
> 
> Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>
> ---
>  arch/x86/include/asm/page.h |   20 +++++++++++++++++++-
>  1 files changed, 19 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
> index 8ca8283..339ae26 100644
> --- a/arch/x86/include/asm/page.h
> +++ b/arch/x86/include/asm/page.h
> @@ -60,10 +60,28 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
>  extern bool __virt_addr_valid(unsigned long kaddr);
>  #define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
>  
> +/* Pure 2^n version of get_order */
> +static inline __attribute_const__ int get_order(unsigned long size)
> +{
> +	int order;
> +
> +	size = (size - 1) >> (PAGE_SHIFT - 1);
> +#ifdef CONFIG_X86_CMOV
> +	asm("bsr %1,%0\n\t"
> +	    "cmovzl %2,%0"
> +	    : "=&r" (order) : "rm" (size), "rm" (0));
> +#else
> +	asm("bsr %1,%0\n\t"
> +	    "jnz 1f\n\t"
> +	    "movl $0,%0\n"
> +	    "1:" : "=r" (order) : "rm" (size));
> +#endif
> +	return order;
> +}

Ok, that's certainly a nice optimization.

One detail: in many cases 'size' is a constant. Have you checked recent GCC, 
does it turn the generic version of get_order() into a loop even for constants, 
or is it able does it perhaps recognize the pattern and precompute the result?

If it recognizes the pattern then this optmization needs to be made dependent 
on whether the expression is constant or not - see bitops.h of how to do that.

Furthermore, a cleanliness observation it would be nicer to encapsulate the 
CMOVZL/jump pattern into a macro, something like ASM_CMOVZL(2,0) to express 
'cmovzl %2,%0'. In the !CONFIG_X86_CMOV case it gets turned into the jnz/movl 
instructions. The assembly code here would be much cleaner that way:

	asm("bsr %1,%0\n"
	    ASM_CMOVZL(2,0)
	    : "=&r" (order) : "rm" (size), "rm" (0));

With no #ifdefs in get_order().

Thanks,

	Ingo

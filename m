Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1C0Lde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 07:33:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab1C0Ldd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 07:33:33 -0400
Date: Sun, 27 Mar 2011 13:33:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Maksym Planeta <mcsim.planeta@gmail.com>
Cc: mingo@redhat.com, kernel-janitors@vger.kernel.org, namhyung@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: page: get_order() optimization
Message-ID: <20110327113323.GA27825@elte.hu>
References: <1301215556-8898-1-git-send-email-mcsim.planeta@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301215556-8898-1-git-send-email-mcsim.planeta@gmail.com>
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
> This is second version of patch where for constants gcc precompute the
> result.
> 
> Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>
> ---
>  arch/x86/include/asm/getorder.h |   48 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/page.h     |    2 +-
>  2 files changed, 49 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/getorder.h
> 
> diff --git a/arch/x86/include/asm/getorder.h b/arch/x86/include/asm/getorder.h
> new file mode 100644
> index 0000000..b0c6f57
> --- /dev/null
> +++ b/arch/x86/include/asm/getorder.h
> @@ -0,0 +1,48 @@
> +#ifndef __ASM_GENERIC_GETORDER_H
> +#define __ASM_GENERIC_GETORDER_H
> +
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/compiler.h>
> +
> +#ifdef CONFIG_X86_CMOV
> +#define ASM_CMOVZ(op, dest) \
> +		"cmovzl %" #op ",%" #dest ";\n\t"
> +#else
> +#define ASM_CMOVZ(op, dest) \
> +		"jnz 1f;\n\t" \
> +		"movl %" #op ", %" #dest ";\n\t" \
> +		"1: "
> +#endif
> +
> +static __always_inline int __get_order(unsigned long size)
> +{
> +	int order;
> +
> +	size = (size - 1) >> (PAGE_SHIFT - 1);
> +	asm("bsr %1, %0\n\t"
> +		ASM_CMOVZ(2, 0)
> +		: "=&r" (order) : "rm" (size), "rm" (0));
> +	return order;
> +}
> +
> +/* Pure 2^n version of get_order */
> +static inline __attribute_const__  int get_order(unsigned long size)
> +{
> +	int order;
> +
> +	if (__builtin_constant_p(size)) {
> +		size = (size - 1) >> (PAGE_SHIFT - 1);
> +		order = -1;
> +		do {
> +			size >>= 1;
> +			order++;
> +		} while (size);
> +		return order;
> +	}
> +	return __get_order(size);
> +}
> +
> +#endif	/* __ASSEMBLY__ */
> +
> +#endif	/* __ASM_GENERIC_GETORDER_H */
> diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
> index 8ca8283..10e4c45 100644
> --- a/arch/x86/include/asm/page.h
> +++ b/arch/x86/include/asm/page.h
> @@ -63,7 +63,7 @@ extern bool __virt_addr_valid(unsigned long kaddr);
>  #endif	/* __ASSEMBLY__ */
>  
>  #include <asm-generic/memory_model.h>
> -#include <asm-generic/getorder.h>
> +#include <asm/getorder.h>

Just wondering, what's the before/after 'size vmlinux' effect on a 'make 
defconfig' x86 kernel? Does the optimization make the kernel smaller as well, 
besides making it faster?

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2FFVWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:22:10 -0400
Received: from smp.if.uj.edu.pl ([149.156.82.206]:46850 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab2FFVWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:22:07 -0400
Date: Wed, 6 Jun 2012 23:22:01 +0200
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
Message-ID: <20120606212201.GH5511@smp.if.uj.edu.pl>
References: <1338991542-23000-1-git-send-email-dzickus@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1338991542-23000-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-06 10:05, Don Zickus wrote:
> It was reported that compiling for 32-bit caused a bunch of section
> mismatch warnings:
> 
>  VDSOSYM arch/x86/vdso/vdso32-syms.lds
>   LD      arch/x86/vdso/built-in.o
>   LD      arch/x86/built-in.o
> WARNING: arch/x86/built-in.o(.data+0x5af0): Section mismatch in reference from the variable
> test_nmi_ipi_callback_na.10451 to the function .init.text:test_nmi_ipi_callback()
> The variable test_nmi_ipi_callback_na.10451 references
> the function __init test_nmi_ipi_callback()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> WARNING: arch/x86/built-in.o(.data+0x5b04): Section mismatch in reference from the variable
> nmi_unk_cb_na.10399 to the function .init.text:nmi_unk_cb()
> The variable nmi_unk_cb_na.10399 references
> the function __init nmi_unk_cb()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> Both of these are attributed to the internal representation of the nmiaction
> struct created during register_nmi_handler.  The reason for this is that those
> structs are not defined in the init section whereas the rest of the code in
> nmi_selftest.c is.
> 
> To resolve this, I created a new #define, register_nmi_handler_initonly, that
> tags the struct as __initdata to resolve the mismatch.  This #define should
> only be used in rare situations where the register/unregister is called during
> init of the kernel.
> 
> Big thanks to Jan Beulich for decoding this for me as I didn't have a clue
> what was going on.
> 
> Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
> Cc: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/include/asm/nmi.h     |   14 ++++++++++++++
>  arch/x86/kernel/nmi_selftest.c |    4 ++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
> index 0e3793b..dc580c4 100644
> --- a/arch/x86/include/asm/nmi.h
> +++ b/arch/x86/include/asm/nmi.h
> @@ -54,6 +54,20 @@ struct nmiaction {
>  	__register_nmi_handler((t), &fn##_na);	\
>  })
>  
> +/*
> + * For special handlers that register/unregister in the
> + * init section only.  This should be considered rare.
> + */
> +#define register_nmi_handler_initonly(t, fn, fg, n)		\
> +({							\
> +	static struct nmiaction fn##_na __initdata = {		\
> +		.handler = (fn),			\
> +		.name = (n),				\
> +		.flags = (fg),				\
> +	};						\
> +	__register_nmi_handler((t), &fn##_na);	\
> +})
> +
>  int __register_nmi_handler(unsigned int, struct nmiaction *);
>  
>  void unregister_nmi_handler(unsigned int, const char *);
> diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
> index e31bf8d..149b8d9 100644
> --- a/arch/x86/kernel/nmi_selftest.c
> +++ b/arch/x86/kernel/nmi_selftest.c
> @@ -42,7 +42,7 @@ static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
>  static void __init init_nmi_testsuite(void)
>  {
>  	/* trap all the unknown NMIs we may generate */
> -	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
> +	register_nmi_handler_initonly(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
>  }
>  
>  static void __init cleanup_nmi_testsuite(void)
> @@ -64,7 +64,7 @@ static void __init test_nmi_ipi(struct cpumask *mask)
>  {
>  	unsigned long timeout;
>  
> -	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
> +	if (register_nmi_handler_initonly(NMI_LOCAL, test_nmi_ipi_callback,
>  				 NMI_FLAG_FIRST, "nmi_selftest")) {
>  		nmi_fail = FAILURE;
>  		return;
> -- 
> 1.7.7.6
> 

Works for me.

Tested-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>


-- 
Witold Baryluk

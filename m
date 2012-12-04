Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab2LDNnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:43:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55366 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2LDNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:43:07 -0500
Date: Tue, 4 Dec 2012 11:42:58 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Yang Wei <wei.yang@windriver.com>,
        Robert Richter <robert.richter@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jun Zhang <jun.zhang@intel.com>
Subject: Re: [ 06/37] x86-32: Fix invalid stack address while in softirq
Message-ID: <20121204134257.GD2984@herton-Z68MA-D2H-B3>
References: <20121130183857.166228045@linuxfoundation.org>
 <20121130183857.883260247@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130183857.883260247@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 10:45:53AM -0800, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Robert Richter <robert.richter@amd.com>
> 
> commit 1022623842cb72ee4d0dbf02f6937f38c92c3f41 upstream.
> 
> In 32 bit the stack address provided by kernel_stack_pointer() may
> point to an invalid range causing NULL pointer access or page faults
> while in NMI (see trace below). This happens if called in softirq
> context and if the stack is empty. The address at &regs->sp is then
> out of range.
> 
> Fixing this by checking if regs and &regs->sp are in the same stack
> context. Otherwise return the previous stack pointer stored in struct
> thread_info. If that address is invalid too, return address of regs.
> 
[...]

Hi, this makes build fail with oprofile on i386 on 3.0.54:
ERROR: "kernel_stack_pointer" [arch/x86/oprofile/oprofile.ko] undefined!

The following commit should address this failure:

commit cb57a2b4cff7edf2a4e32c0163200e9434807e0a
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Tue Nov 20 22:21:02 2012 -0800

    x86-32: Export kernel_stack_pointer() for modules
    
    Modules, in particular oprofile (and possibly other similar tools)
    need kernel_stack_pointer(), so export it using EXPORT_SYMBOL_GPL().

> 
> --- a/arch/x86/include/asm/ptrace.h
> +++ b/arch/x86/include/asm/ptrace.h
> @@ -187,21 +187,14 @@ static inline int v8086_mode(struct pt_r
>  #endif
>  }
>  
> -/*
> - * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
> - * when it traps.  The previous stack will be directly underneath the saved
> - * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
> - *
> - * This is valid only for kernel mode traps.
> - */
> -static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> -{
>  #ifdef CONFIG_X86_32
> -	return (unsigned long)(&regs->sp);
> +extern unsigned long kernel_stack_pointer(struct pt_regs *regs);
>  #else
> +static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> +{
>  	return regs->sp;
> -#endif
>  }
> +#endif
>  
>  #define GET_IP(regs) ((regs)->ip)
>  #define GET_FP(regs) ((regs)->bp)
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -164,6 +164,34 @@ static inline bool invalid_selector(u16
>  
>  #define FLAG_MASK		FLAG_MASK_32
>  
> +/*
> + * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
> + * when it traps.  The previous stack will be directly underneath the saved
> + * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
> + *
> + * Now, if the stack is empty, '&regs->sp' is out of range. In this
> + * case we try to take the previous stack. To always return a non-null
> + * stack pointer we fall back to regs as stack if no previous stack
> + * exists.
> + *
> + * This is valid only for kernel mode traps.
> + */
> +unsigned long kernel_stack_pointer(struct pt_regs *regs)
> +{
> +	unsigned long context = (unsigned long)regs & ~(THREAD_SIZE - 1);
> +	unsigned long sp = (unsigned long)&regs->sp;
> +	struct thread_info *tinfo;
> +
> +	if (context == (sp & ~(THREAD_SIZE - 1)))
> +		return sp;
> +
> +	tinfo = (struct thread_info *)context;
> +	if (tinfo->previous_esp)
> +		return tinfo->previous_esp;
> +
> +	return (unsigned long)regs;
> +}
> +
>  static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
>  {
>  	BUILD_BUG_ON(offsetof(struct pt_regs, bx) != 0);
> 

-- 
[]'s
Herton

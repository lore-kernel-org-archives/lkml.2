Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2KEN3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:29:19 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33293 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337Ab2KEN3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:29:16 -0500
Date: Mon, 5 Nov 2012 13:29:07 +0000
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Will Drewry <wad@chromium.org>,
        Geremy Condra <gcondra@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH 1/4] arch/arm: add syscall_get_arch
Message-ID: <20121105132907.GL3351@mudshark.cambridge.arm.com>
References: <1351815300-28627-1-git-send-email-keescook@chromium.org>
 <1351815300-28627-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351815300-28627-2-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 12:14:57AM +0000, Kees Cook wrote:
> From: Will Drewry <wad@chromium.org>
> 
> Provide an ARM implementation of syscall_get_arch. This is a pre-requisite
> for CONFIG_HAVE_ARCH_SECCOMP_FILTER.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm/include/asm/syscall.h |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
> index 9fdded6..803f433 100644
> --- a/arch/arm/include/asm/syscall.h
> +++ b/arch/arm/include/asm/syscall.h
> @@ -7,6 +7,8 @@
>  #ifndef _ASM_ARM_SYSCALL_H
>  #define _ASM_ARM_SYSCALL_H
>  
> +#include <linux/audit.h> /* for AUDIT_ARCH_* */
> +#include <linux/elf.h> /* for ELF_EM */
>  #include <linux/err.h>
>  #include <linux/sched.h>
>  
> @@ -95,4 +97,15 @@ static inline void syscall_set_arguments(struct task_struct *task,
>  	memcpy(&regs->ARM_r0 + i, args, n * sizeof(args[0]));
>  }
>  
> +static inline int syscall_get_arch(struct task_struct *task,
> +				   struct pt_regs *regs)
> +{
> +	/* ARM tasks don't change audit architectures on the fly. */
> +#ifdef __ARMEB__
> +	return AUDIT_ARCH_ARMEB;
> +#else
> +	return AUDIT_ARCH_ARM;
> +#endif
> +}

I think you can just use AUDIT_ARCH_ARM unconditionally here as the syscall
ABI is not related to the endianness of the CPU. I believe AUDIT_ARCH_ARMEB
was added accidentally because somebody incorrectly thought the -EB suffix
signified EABI.

If it wasn't in a user-header I'd be all for deleting the old definition...

Will

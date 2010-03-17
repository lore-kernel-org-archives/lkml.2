Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0CQTLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:11:38 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:40743 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0CQTLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V9JEbSIAbw/iJvhAJJVIeDP2s756YbmJ88rz2mxhy4xVYn5LAbVlfTqof2F4m2U6E7
         7lWfWfKmJEBtnS02a4o9/ct+35mF9nRHfAJ9w+qCYgIdpsqWAAkLhksQ2NKLcKDLwmjg
         3kj6scUuTxzCatu3by+LO3Nyq5BNn/peV83aY=
Date: Wed, 17 Mar 2010 20:11:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com, heiko.carstens@de.ibm.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 02/14] x86: add arch_compat_syscall_addr()
Message-ID: <20100317191136.GB5059@nowhere>
References: <cover.1268749695.git.jbaron@redhat.com> <371f973b778391a685e63986193b54f87a8c64b3.1268749695.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <371f973b778391a685e63986193b54f87a8c64b3.1268749695.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 01:46:17PM -0400, Jason Baron wrote:
> Add arch_compat_syscall_addr(int nr) for x86_64. This is in preparation for adding
> compat syscall support to the event tracer.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  arch/x86/include/asm/syscall.h |    5 +++++
>  arch/x86/kernel/ftrace.c       |    8 ++++++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
> index c4a348f..4e462cc 100644
> --- a/arch/x86/include/asm/syscall.h
> +++ b/arch/x86/include/asm/syscall.h
> @@ -16,7 +16,12 @@
>  #include <linux/sched.h>
>  #include <linux/err.h>
>  
> +#if defined(CONFIG_COMPAT) && defined(CONFIG_FTRACE_SYSCALLS)
> + #define __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
> +#endif
> +



A config would be better:

arch/Kconfig:

	config HAVE_COMPAT_FTRACE_SYSCALLS
		bool

	config COMPAT_FTRACE_SYSCALLS
		def_bool y
		depends on COMPAT && FTRACE_SYSCALLS && HAVE_COMPAT_FTRACE_SYSCALLS

arch/x86/Kconfig:

	config X86
		[...]
		select HAVE_COMPAT_FTRACE_SYSCALLS
		[...]

So that we centralize the definition of COMPAT_FTRACE_SYSCALLS and
we don't need every archs to redefine the dependency and to stay sync
with potential dependency changes.

Thanks.



>  extern const unsigned long sys_call_table[];
> +extern const unsigned long *ia32_sys_call_table;
>  
>  /*
>   * Only the low 32 bits of orig_ax are meaningful, so we return int.
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index cd37469..4b36a0b 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -26,6 +26,7 @@
>  #include <asm/ftrace.h>
>  #include <asm/nops.h>
>  #include <asm/nmi.h>
> +#include <asm/syscall.h>
>  
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> @@ -510,3 +511,10 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
>  	}
>  }
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> +
> +#ifdef __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
> +unsigned long __init arch_compat_syscall_addr(int nr)
> +{
> +	return (unsigned long)(&ia32_sys_call_table)[nr];
> +}
> +#endif
> -- 
> 1.6.5.1
> 


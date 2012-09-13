Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2IMBPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 21:15:53 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37346 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab2IMBPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 21:15:51 -0400
X-AuditID: b753bd60-95de8ba00000739e-95-505133c506fe
X-AuditID: b753bd60-95de8ba00000739e-95-505133c506fe
Message-ID: <505133C5.5080402@hitachi.com>
Date: Thu, 13 Sep 2012 10:15:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/3] tracing,x86: add a TSC trace_clock
References: <1347417671-22998-1-git-send-email-dhsharp@google.com> <1347492720-26078-1-git-send-email-dhsharp@google.com> <1347492720-26078-3-git-send-email-dhsharp@google.com>
In-Reply-To: <1347492720-26078-3-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/13 8:31), David Sharp wrote:
> In order to promote interoperability between userspace tracers and ftrace,
> add a trace_clock that reports raw TSC values which will then be recorded
> in the ring buffer. Userspace tracers that also record TSCs are then on
> exactly the same time base as the kernel and events can be unambiguously
> interlaced.
> 
> Tested: Enabled a tracepoint and the "tsc" trace_clock and saw very large
> timestamp values.

Yeah, this is what I need!

BTW, could you add your signed-off-by signature to your patches?

Thank you,

> 
> v2:
> Move arch-specific bits out of generic code.
> 
> Google-Bug-Id: 6980623
> ---
>  arch/x86/include/asm/trace_clock.h |   16 ++++++++++++++++
>  arch/x86/kernel/Makefile           |    1 +
>  arch/x86/kernel/trace_clock.c      |   20 ++++++++++++++++++++
>  include/asm-generic/trace_clock.h  |   15 +++++++++++++++
>  include/linux/trace_clock.h        |    2 ++
>  kernel/trace/trace.c               |    1 +
>  6 files changed, 55 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/include/asm/trace_clock.h
>  create mode 100644 arch/x86/kernel/trace_clock.c
>  create mode 100644 include/asm-generic/trace_clock.h
> 
> diff --git a/arch/x86/include/asm/trace_clock.h b/arch/x86/include/asm/trace_clock.h
> new file mode 100644
> index 0000000..0b1f391
> --- /dev/null
> +++ b/arch/x86/include/asm/trace_clock.h
> @@ -0,0 +1,16 @@
> +#ifndef _ASM_X86_TRACE_CLOCK_H
> +#define _ASM_X86_TRACE_CLOCK_H
> +
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_X86_TSC
> +
> +extern u64 notrace trace_clock_x86_tsc(void);
> +
> +# define ARCH_TRACE_CLOCKS \
> +	{ trace_clock_x86_tsc,	"tsc" },
> +
> +#endif
> +
> +#endif  /* _ASM_X86_TRACE_CLOCK_H */
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 8215e56..0ee9344 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -62,6 +62,7 @@ obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
>  obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
> +obj-$(CONFIG_X86_TSC)		+= trace_clock.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
>  obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
>  obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
> diff --git a/arch/x86/kernel/trace_clock.c b/arch/x86/kernel/trace_clock.c
> new file mode 100644
> index 0000000..b8959f8
> --- /dev/null
> +++ b/arch/x86/kernel/trace_clock.c
> @@ -0,0 +1,20 @@
> +/*
> + * X86 trace clocks
> + */
> +#include <asm/trace_clock.h>
> +#include <asm/barrier.h>
> +#include <asm/msr.h>
> +
> +/*
> + * trace_clock_x86_tsc(): A clock that is just the cycle counter.
> + *
> + * Unlike the other clocks, this is not in nanoseconds.
> + */
> +u64 notrace trace_clock_x86_tsc(void)
> +{
> +	u64 ret;
> +	rdtsc_barrier();
> +	rdtscll(ret);
> +
> +	return ret;
> +}
> diff --git a/include/asm-generic/trace_clock.h b/include/asm-generic/trace_clock.h
> new file mode 100644
> index 0000000..648cdcd
> --- /dev/null
> +++ b/include/asm-generic/trace_clock.h
> @@ -0,0 +1,15 @@
> +/*
> + * Arch-specific trace clocks.
> + */
> +#ifndef _ASM_GENERIC_TRACE_CLOCK_H
> +#define _ASM_GENERIC_TRACE_CLOCK_H
> +
> +/*
> + * Additional trace clocks added to the trace_clocks
> + * array in kernel/trace/trace.c
> + */
> +#ifndef ARCH_TRACE_CLOCKS
> +# define ARCH_TRACE_CLOCKS
> +#endif
> +
> +#endif  /* _ASM_GENERIC_TRACE_CLOCK_H */
> diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
> index 4eb4902..d563f37 100644
> --- a/include/linux/trace_clock.h
> +++ b/include/linux/trace_clock.h
> @@ -12,6 +12,8 @@
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>  
> +#include <asm/trace_clock.h>
> +
>  extern u64 notrace trace_clock_local(void);
>  extern u64 notrace trace_clock(void);
>  extern u64 notrace trace_clock_global(void);
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 5c38c81..92fb08e 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -480,6 +480,7 @@ static struct {
>  	{ trace_clock_local,	"local" },
>  	{ trace_clock_global,	"global" },
>  	{ trace_clock_counter,	"counter" },
> +	ARCH_TRACE_CLOCKS
>  };
>  
>  int trace_clock_id;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



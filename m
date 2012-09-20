Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2ITIzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:55:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56991 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2ITIzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:55:51 -0400
Date: Thu, 20 Sep 2012 10:55:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v2 1/3] tracing,x86: add a TSC trace_clock
Message-ID: <20120920085545.GA3497@gmail.com>
References: <1347499439.10751.78.camel@gandalf.local.home>
 <1348004227-23575-1-git-send-email-dhsharp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348004227-23575-1-git-send-email-dhsharp@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Sharp <dhsharp@google.com> wrote:

> In order to promote interoperability between userspace tracers and ftrace,
> add a trace_clock that reports raw TSC values which will then be recorded
> in the ring buffer. Userspace tracers that also record TSCs are then on
> exactly the same time base as the kernel and events can be unambiguously
> interlaced.
> 
> Tested: Enabled a tracepoint and the "tsc" trace_clock and saw very large
> timestamp values.
> 
> v2:
> Move arch-specific bits out of generic code.
> 
> Google-Bug-Id: 6980623
> Signed-off-by: David Sharp <dhsharp@google.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@linux.intel.com>
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

I'd name it "x86-tsc", to make sure the naming is unique. That 
will also enable the addition of other hw clocks, should the 
need arise.

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

Missing newline.

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

We typically put header guards to the first and last lines of 
the file, that way it can be ignored easily.

> +
> +/*
> + * Additional trace clocks added to the trace_clocks
> + * array in kernel/trace/trace.c

I'd add: "None if the architecture has not defined it."

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

Looks useful and good otherwise:

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab0IUSa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:30:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51407 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0IUSa5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Sep 2010 14:30:57 -0400
Date: Tue, 21 Sep 2010 14:30:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com
Subject: Re: [PATCH 08/10] jump label v11: x86 support
Message-ID: <20100921183003.GB22088@dumpdata.com>
References: <cover.1284733808.git.jbaron@redhat.com>
 <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 11:09:22AM -0400, Jason Baron wrote:
> add x86 support for jump label. I'm keeping this patch separate so its clear to
> arch maintainers what was required for x86 support this new feature. hopefully,
> it wouldn't be too painful for other arches.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  arch/x86/Kconfig                  |    1 +
>  arch/x86/include/asm/jump_label.h |   47 +++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/Makefile          |    2 +-
>  arch/x86/kernel/jump_label.c      |   49 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/module.c          |    3 ++
>  5 files changed, 101 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/jump_label.h
>  create mode 100644 arch/x86/kernel/jump_label.c
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 0c14369..a986079 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -60,6 +60,7 @@ config X86
>  	select ANON_INODES
>  	select HAVE_ARCH_KMEMCHECK
>  	select HAVE_USER_RETURN_NOTIFIER
> +	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
>  
>  config INSTRUCTION_DECODER
>  	def_bool (KPROBES || PERF_EVENTS)
> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> new file mode 100644
> index 0000000..b4a2cb4
> --- /dev/null
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -0,0 +1,47 @@
> +#ifndef _ASM_X86_JUMP_LABEL_H
> +#define _ASM_X86_JUMP_LABEL_H
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/types.h>
> +#include <asm/nops.h>
> +
> +#define JUMP_LABEL_NOP_SIZE 5
> +
> +# define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
> +
> +# define JUMP_LABEL(key, label)					\
> +	do {							\
> +		asm goto("1:"					\
> +			JUMP_LABEL_INITIAL_NOP			\
> +			".pushsection __jump_table,  \"a\" \n\t"\
> +			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
> +			".popsection \n\t"			\
> +			: :  "i" (key) :  : label);		\
> +	} while (0)
> +
> +#endif /* __KERNEL__ */
> +
> +#ifdef CONFIG_X86_64
> +
> +typedef u64 jump_label_t;
> +
> +struct jump_entry {
> +	jump_label_t code;
> +	jump_label_t target;
> +	jump_label_t key;
> +};
> +
> +#else
> +
> +typedef u32 jump_label_t;
> +
> +struct jump_entry {
> +	jump_label_t code;
> +	jump_label_t target;
> +	jump_label_t key;

The format is the same, why not just put the typedef
within the #ifdef?

> +};
> +
> +#endif
> +
> +#endif
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 11a9925..dfa1443 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -32,7 +32,7 @@ GCOV_PROFILE_paravirt.o		:= n
>  obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
>  obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
>  obj-y			+= time.o ioport.o ldt.o dumpstack.o
> -obj-y			+= setup.o x86_init.o i8259.o irqinit.o
> +obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
>  obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
>  obj-$(CONFIG_X86_32)	+= probe_roms_32.o
>  obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> new file mode 100644
> index 0000000..b3c0f37
> --- /dev/null
> +++ b/arch/x86/kernel/jump_label.c
> @@ -0,0 +1,49 @@
> +/*
> + * jump label x86 support
> + *
> + * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>

Year.


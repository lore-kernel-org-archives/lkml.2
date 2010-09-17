Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0IQP2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:28:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55542 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab0IQP2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:28:47 -0400
X-Authority-Analysis: v=1.1 cv=2ipXt8Ao/PPbK329gQN1nC6XU/V8QMABDttguNTIlb0= c=1 sm=0 a=9nV7qiHO8IIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5koX4MaKYlLvq6bZrWwA:9 a=Kmke6y2lVEhZaD4X1BsA:7 a=peicfVW20tDoGQ5-uu-roB0-7s0A:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 01/10] jump label v11: make dynamic no-op selection
 available outside of ftrace
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
In-Reply-To: <96259ae74172dcac99c0020c249743c523a92e18.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
	 <96259ae74172dcac99c0020c249743c523a92e18.1284733808.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 17 Sep 2010 11:28:44 -0400
Message-ID: <1284737324.23787.79.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 11:08 -0400, Jason Baron wrote:
> Move Steve's code for finding the best 5-byte no-op from ftrace.c to alternative.c.
> The idea is that other consumers (in this case jump label) want to make use of
> that code.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  arch/x86/include/asm/alternative.h |    8 ++++
>  arch/x86/kernel/alternative.c      |   64 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/ftrace.c           |   63 +----------------------------------
>  arch/x86/kernel/setup.c            |    6 +++
>  4 files changed, 79 insertions(+), 62 deletions(-)
> 
> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> index bc6abb7..27a35b6 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -180,4 +180,12 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
>  extern void *text_poke(void *addr, const void *opcode, size_t len);
>  extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
>  
> +#if defined(CONFIG_DYNAMIC_FTRACE)
> +#define IDEAL_NOP_SIZE_5 5
> +extern unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
> +extern void arch_init_ideal_nop5(void);
> +#else
> +static inline void arch_init_ideal_nop5(void) {}
> +#endif
> +
>  #endif /* _ASM_X86_ALTERNATIVE_H */
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index f65ab8b..1849d80 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -641,3 +641,67 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
>  	return addr;
>  }
>  
> +#if defined(CONFIG_DYNAMIC_FTRACE)
> +
> +unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
> +
> +void __init arch_init_ideal_nop5(void)
> +{
> +	extern const unsigned char ftrace_test_p6nop[];
> +	extern const unsigned char ftrace_test_nop5[];
> +	extern const unsigned char ftrace_test_jmp[];
> +	int faulted = 0;
> +
> +	/*
> +	 * There is no good nop for all x86 archs.
> +	 * We will default to using the P6_NOP5, but first we
> +	 * will test to make sure that the nop will actually
> +	 * work on this CPU. If it faults, we will then
> +	 * go to a lesser efficient 5 byte nop. If that fails
> +	 * we then just use a jmp as our nop. This isn't the most
> +	 * efficient nop, but we can not use a multi part nop
> +	 * since we would then risk being preempted in the middle
> +	 * of that nop, and if we enabled tracing then, it might
> +	 * cause a system crash.
> +	 *
> +	 * TODO: check the cpuid to determine the best nop.
> +	 */
> +	asm volatile (
> +		"ftrace_test_jmp:"
> +		"jmp ftrace_test_p6nop\n"
> +		"nop\n"
> +		"nop\n"
> +		"nop\n"  /* 2 byte jmp + 3 bytes */
> +		"ftrace_test_p6nop:"
> +		P6_NOP5
> +		"jmp 1f\n"
> +		"ftrace_test_nop5:"
> +		".byte 0x66,0x66,0x66,0x66,0x90\n"
> +		"1:"
> +		".section .fixup, \"ax\"\n"
> +		"2:	movl $1, %0\n"
> +		"	jmp ftrace_test_nop5\n"
> +		"3:	movl $2, %0\n"
> +		"	jmp 1b\n"
> +		".previous\n"
> +		_ASM_EXTABLE(ftrace_test_p6nop, 2b)
> +		_ASM_EXTABLE(ftrace_test_nop5, 3b)
> +		: "=r"(faulted) : "0" (faulted));
> +
> +	switch (faulted) {
> +	case 0:
> +		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
> +		memcpy(ideal_nop5, ftrace_test_p6nop, IDEAL_NOP_SIZE_5);
> +		break;
> +	case 1:
> +		pr_info("converting mcount calls to 66 66 66 66 90\n");
> +		memcpy(ideal_nop5, ftrace_test_nop5, IDEAL_NOP_SIZE_5);
> +		break;
> +	case 2:
> +		pr_info("converting mcount calls to jmp . + 5\n");
> +		memcpy(ideal_nop5, ftrace_test_jmp, IDEAL_NOP_SIZE_5);
> +		break;
> +	}
> +
> +}
> +#endif
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index cd37469..3afb33f 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -257,14 +257,9 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
>  	return mod_code_status;
>  }
>  
> -
> -
> -
> -static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
> -
>  static unsigned char *ftrace_nop_replace(void)
>  {
> -	return ftrace_nop;
> +	return ideal_nop5;
>  }
>  
>  static int
> @@ -338,62 +333,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
>  
>  int __init ftrace_dyn_arch_init(void *data)
>  {
> -	extern const unsigned char ftrace_test_p6nop[];
> -	extern const unsigned char ftrace_test_nop5[];
> -	extern const unsigned char ftrace_test_jmp[];
> -	int faulted = 0;
> -
> -	/*
> -	 * There is no good nop for all x86 archs.
> -	 * We will default to using the P6_NOP5, but first we
> -	 * will test to make sure that the nop will actually
> -	 * work on this CPU. If it faults, we will then
> -	 * go to a lesser efficient 5 byte nop. If that fails
> -	 * we then just use a jmp as our nop. This isn't the most
> -	 * efficient nop, but we can not use a multi part nop
> -	 * since we would then risk being preempted in the middle
> -	 * of that nop, and if we enabled tracing then, it might
> -	 * cause a system crash.
> -	 *
> -	 * TODO: check the cpuid to determine the best nop.
> -	 */
> -	asm volatile (
> -		"ftrace_test_jmp:"
> -		"jmp ftrace_test_p6nop\n"
> -		"nop\n"
> -		"nop\n"
> -		"nop\n"  /* 2 byte jmp + 3 bytes */
> -		"ftrace_test_p6nop:"
> -		P6_NOP5
> -		"jmp 1f\n"
> -		"ftrace_test_nop5:"
> -		".byte 0x66,0x66,0x66,0x66,0x90\n"
> -		"1:"
> -		".section .fixup, \"ax\"\n"
> -		"2:	movl $1, %0\n"
> -		"	jmp ftrace_test_nop5\n"
> -		"3:	movl $2, %0\n"
> -		"	jmp 1b\n"
> -		".previous\n"
> -		_ASM_EXTABLE(ftrace_test_p6nop, 2b)
> -		_ASM_EXTABLE(ftrace_test_nop5, 3b)
> -		: "=r"(faulted) : "0" (faulted));
> -
> -	switch (faulted) {
> -	case 0:
> -		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
> -		memcpy(ftrace_nop, ftrace_test_p6nop, MCOUNT_INSN_SIZE);
> -		break;
> -	case 1:
> -		pr_info("converting mcount calls to 66 66 66 66 90\n");
> -		memcpy(ftrace_nop, ftrace_test_nop5, MCOUNT_INSN_SIZE);
> -		break;
> -	case 2:
> -		pr_info("converting mcount calls to jmp . + 5\n");
> -		memcpy(ftrace_nop, ftrace_test_jmp, MCOUNT_INSN_SIZE);
> -		break;
> -	}
> -
>  	/* The return code is retured via data */
>  	*(unsigned long *)data = 0;
>  
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 1427c36..fb37842 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -112,6 +112,7 @@
>  #include <asm/numa_64.h>
>  #endif
>  #include <asm/mce.h>
> +#include <asm/alternative.h>
>  
>  /*
>   * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
> @@ -689,6 +690,7 @@ void __init setup_arch(char **cmdline_p)
>  {
>  	int acpi = 0;
>  	int k8 = 0;
> +	unsigned long flags;
>  
>  #ifdef CONFIG_X86_32
>  	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
> @@ -1036,6 +1038,10 @@ void __init setup_arch(char **cmdline_p)
>  	x86_init.oem.banner();
>  
>  	mcheck_init();
> +
> +	local_irq_save(flags);
> +	arch_init_ideal_nop5();
> +	local_irq_restore(flags);
>  }
>  
>  #ifdef CONFIG_X86_32



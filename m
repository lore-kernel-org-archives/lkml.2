Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab2GSCUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:20:18 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57045 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2GSCUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:20:15 -0400
X-AuditID: b753bd60-9f483ba000000655-99-50076edc1585
X-AuditID: b753bd60-9f483ba000000655-99-50076edc1585
Message-ID: <50076ED9.3000100@hitachi.com>
Date: Thu, 19 Jul 2012 11:20:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386
 function calls
References: <20120711195048.885039013@goodmis.org>  <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com>  <1342205273.30075.19.camel@gandalf.stny.rr.com> <1342627145.11900.7.camel@gandalf.stny.rr.com>
In-Reply-To: <1342627145.11900.7.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/19 0:59), Steven Rostedt wrote:
> On Fri, 2012-07-13 at 14:47 -0400, Steven Rostedt wrote:
> 
> Masami, can you give your Reviewed-by tag for this version? Or is there
> something else needing to be fixed?

No, that is OK for me. I've just missed that...

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Thanks!
> 
> -- Steve
> 
>> From: Steven Rostedt <srostedt@redhat.com>
>> Date: Tue, 5 Jun 2012 20:00:11 -0400
>> Subject: [PATCH] ftrace/x86: Add save_regs for i386 function calls
>>
>> Add saving full regs for function tracing on i386.
>> The saving of regs was influenced by patches sent out by
>> Masami Hiramatsu.
>>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>  arch/x86/include/asm/ftrace.h |    2 -
>>  arch/x86/kernel/entry_32.S    |   68 +++++++++++++++++++++++++++++++++++++++++
>>  arch/x86/kernel/ftrace.c      |    4 --
>>  3 files changed, 68 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
>> index a847501..a6cae0c 100644
>> --- a/arch/x86/include/asm/ftrace.h
>> +++ b/arch/x86/include/asm/ftrace.h
>> @@ -40,10 +40,8 @@
>>  
>>  #ifdef CONFIG_DYNAMIC_FTRACE
>>  #define ARCH_SUPPORTS_FTRACE_OPS 1
>> -#ifdef CONFIG_X86_64
>>  #define ARCH_SUPPORTS_FTRACE_SAVE_REGS
>>  #endif
>> -#endif
>>  
>>  #ifndef __ASSEMBLY__
>>  extern void mcount(void);
>> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
>> index 5da11d1..46caa56 100644
>> --- a/arch/x86/kernel/entry_32.S
>> +++ b/arch/x86/kernel/entry_32.S
>> @@ -1123,6 +1123,7 @@ ftrace_call:
>>  	popl %edx
>>  	popl %ecx
>>  	popl %eax
>> +ftrace_ret:
>>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>  .globl ftrace_graph_call
>>  ftrace_graph_call:
>> @@ -1134,6 +1135,73 @@ ftrace_stub:
>>  	ret
>>  END(ftrace_caller)
>>  
>> +ENTRY(ftrace_regs_caller)
>> +	pushf	/* push flags before compare (in cs location) */
>> +	cmpl $0, function_trace_stop
>> +	jne ftrace_restore_flags
>> +
>> +	/*
>> +	 * i386 does not save SS and ESP when coming from kernel.
>> +	 * Instead, to get sp, &regs->sp is used (see ptrace.h).
>> +	 * Unfortunately, that means eflags must be at the same location
>> +	 * as the current return ip is. We move the return ip into the
>> +	 * ip location, and move flags into the return ip location.
>> +	 */
>> +	pushl 4(%esp)	/* save return ip into ip slot */
>> +	subl $MCOUNT_INSN_SIZE, (%esp)	/* Adjust ip */
>> +
>> +	pushl $0	/* Load 0 into orig_ax */
>> +	pushl %gs
>> +	pushl %fs
>> +	pushl %es
>> +	pushl %ds
>> +	pushl %eax
>> +	pushl %ebp
>> +	pushl %edi
>> +	pushl %esi
>> +	pushl %edx
>> +	pushl %ecx
>> +	pushl %ebx
>> +
>> +	movl 13*4(%esp), %eax	/* Get the saved flags */
>> +	movl %eax, 14*4(%esp)	/* Move saved flags into regs->flags location */
>> +				/* clobbering return ip */
>> +	movl $__KERNEL_CS,13*4(%esp)
>> +
>> +	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
>> +	movl 0x4(%ebp), %edx	/* Load parent ip (2cd parameter) */
>> +	lea  (%esp), %ecx
>> +	pushl %ecx		/* Save pt_regs as 4th parameter */
>> +	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
>> +
>> +GLOBAL(ftrace_regs_call)
>> +	call ftrace_stub
>> +
>> +	addl $4, %esp		/* Skip pt_regs */
>> +	movl 14*4(%esp), %eax	/* Move flags back into cs */
>> +	movl %eax, 13*4(%esp)	/* Needed to keep addl from modifying flags */
>> +	movl 12*4(%esp), %eax	/* Get return ip from regs->ip */
>> +	addl $MCOUNT_INSN_SIZE, %eax
>> +	movl %eax, 14*4(%esp)	/* Put return ip back for ret */
>> +
>> +	popl %ebx
>> +	popl %ecx
>> +	popl %edx
>> +	popl %esi
>> +	popl %edi
>> +	popl %ebp
>> +	popl %eax
>> +	popl %ds
>> +	popl %es
>> +	popl %fs
>> +	popl %gs
>> +	addl $8, %esp		/* Skip orig_ax and ip */
>> +	popf			/* Pop flags at end (no addl to corrupt flags) */
>> +	jmp ftrace_ret
>> +
>> +ftrace_restore_flags:
>> +	popf
>> +	jmp  ftrace_stub
>>  #else /* ! CONFIG_DYNAMIC_FTRACE */
>>  
>>  ENTRY(mcount)
>> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
>> index b90eb1a..1d41402 100644
>> --- a/arch/x86/kernel/ftrace.c
>> +++ b/arch/x86/kernel/ftrace.c
>> @@ -206,7 +206,6 @@ static int
>>  ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
>>  		   unsigned const char *new_code);
>>  
>> -#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
>>  /*
>>   * Should never be called:
>>   *  As it is only called by __ftrace_replace_code() which is called by
>> @@ -221,7 +220,6 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
>>  	WARN_ON(1);
>>  	return -EINVAL;
>>  }
>> -#endif
>>  
>>  int ftrace_update_ftrace_func(ftrace_func_t func)
>>  {
>> @@ -237,7 +235,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
>>  
>>  	ret = ftrace_modify_code(ip, old, new);
>>  
>> -#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
>>  	/* Also update the regs callback function */
>>  	if (!ret) {
>>  		ip = (unsigned long)(&ftrace_regs_call);
>> @@ -245,7 +242,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
>>  		new = ftrace_call_replace(ip, (unsigned long)func);
>>  		ret = ftrace_modify_code(ip, old, new);
>>  	}
>> -#endif
>>  
>>  	atomic_dec(&modifying_ftrace_code);
>>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



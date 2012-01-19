Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2ASOlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:41:46 -0500
Received: from mail.openrapids.net ([64.15.138.104]:34772 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751437Ab2ASOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:41:44 -0500
Date: Thu, 19 Jan 2012 09:41:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 2/2] jump labels/x86: Use etiher 5 byte or 2 byte jumps
Message-ID: <20120119144141.GA547@Krystal>
References: <20120118195340.767928915@goodmis.org> <20120118195926.797694014@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118195926.797694014@goodmis.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:03:57 up 421 days, 19:07,  3 users,  load average: 0.07, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Have the jump labels add a "jmp" in the assembly instead
> of a default nop. This will cause the assembler to put in
> either a 2 byte or 5 byte jmp depending on where the target
> lable is.
> 
> Then at compile time, the update_jump_label code will replace
> the jmps with either 2 or 5 byte nops.
> 
> On boot up, the code can be examined to see if the jump label
> uses either a 2 or 5 byte nop and replace it.
> 
> By allowing the jump labels to be 2 bytes, it speeds up the
> nops, not only 2 byte nops are faster than 5 byte nops, but also
> because it saves on cache foot print.
> 
>    text    data     bss     dec     hex filename
> 13403667 3666856 2998272 20068795 13239bb ../nobackup/mxtest/vmlinux-old
> 13398536 3666856 2998272 20063664 13225b0 ../nobackup/mxtest/vmlinux-new
> 
> Converting the current v3.2 trace points saved 5,131 bytes.
> As more places use jump labels, this will have a bigger savings.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/Kconfig                  |    1 +
>  arch/x86/include/asm/jump_label.h |    2 +-
>  arch/x86/kernel/jump_label.c      |   86 ++++++++++++++++++++++++++++++++++---
>  3 files changed, 81 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index efb4294..b5004c1 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -61,6 +61,7 @@ config X86
>  	select HAVE_ARCH_KMEMCHECK
>  	select HAVE_USER_RETURN_NOTIFIER
>  	select HAVE_ARCH_JUMP_LABEL
> +	select HAVE_BUILD_TIME_JUMP_LABEL
>  	select HAVE_TEXT_POKE_SMP
>  	select HAVE_GENERIC_HARDIRQS
>  	select HAVE_SPARSE_IRQ
> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> index a32b18c..872b3e1 100644
> --- a/arch/x86/include/asm/jump_label.h
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -14,7 +14,7 @@
>  static __always_inline bool arch_static_branch(struct jump_label_key *key)
>  {
>  	asm goto("1:"
> -		JUMP_LABEL_INITIAL_NOP
> +		"jmp %l[l_yes]\n"

Is it possible that the compiler choose a jump that is not 2 or 5-byte ?
e.g. a jmp rel16 (e9 opcode) on 32-bit x86, or any of the other
instruction listed under the JMP-Jump instruction in the Intel insn
manual ?

>  		".pushsection __jump_table,  \"aw\" \n\t"
>  		_ASM_ALIGN "\n\t"
>  		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index ea9d5f2f..d5b84de 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -16,12 +16,27 @@
>  
>  #ifdef HAVE_JUMP_LABEL
>  
> +static unsigned char nop_short[] = { P6_NOP2 };
> +
> +/* These are the nops added at compile time */
> +#ifdef CONFIG_X86_32
> +static unsigned char default_nop[5] = { 0x3e, 0x8d, 0x74, 0x26, 0x00 };
> +#else
> +static unsigned char default_nop[5] = { 0x0f, 0x1f, 0x44, 0x00, 0x00 };
> +#endif
> +
> +static int update_nops;
> +
>  union jump_code_union {
>  	char code[JUMP_LABEL_NOP_SIZE];
>  	struct {
>  		char jump;
>  		int offset;
> -	} __attribute__((packed));
> +	} __packed;
> +	struct {
> +		char jump_short;
> +		char offset_short;
> +	} __packed;
>  };
>  
>  static void __jump_label_transform(struct jump_entry *entry,
> @@ -29,20 +44,70 @@ static void __jump_label_transform(struct jump_entry *entry,
>  				   void *(*poker)(void *, const void *, size_t))
>  {
>  	union jump_code_union code;
> +	unsigned char nop;
> +	unsigned char op;
> +	unsigned size;
> +	void *ip = (void *)entry->code;
> +	void *ideal = (void *)ideal_nops[NOP_ATOMIC5];

"void *" should possibly be "unsigned char *" here to respect the nop
place-holder typing.

> +
> +	/* Use probe_kernel_read()? */
> +	op = *(unsigned char *)ip;
> +	nop = ideal_nops[NOP_ATOMIC5][0];
>  
>  	if (type == JUMP_LABEL_ENABLE) {
> -		code.jump = 0xe9;
> -		code.offset = entry->target -
> -				(entry->code + JUMP_LABEL_NOP_SIZE);
> -	} else
> -		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
> +		if (op == 0xe9 || op == 0xeb)
> +			/* Already enabled. Warn? */

This could be caused by failure to run the link-time script, or running
the transform twice. A warning would indeed be welcome, as this should
never happen.

> +			return;
> +
> +		if (memcmp(ip, nop_short, 2) == 0) {
> +			size = 2;
> +			code.jump_short = 0xeb;
> +			code.offset = entry->target -
> +				(entry->code + 2);
> +			/* Check for overflow ? */
> +		} else if (memcmp(ip, ideal, 5) == 0 ||
> +			   memcmp(ip, default_nop, 5)) {
> +			size = JUMP_LABEL_NOP_SIZE;
> +			code.jump = 0xe9;
> +			code.offset = entry->target - (entry->code + size);
> +		} else
> +			BUG();
>  
> -	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
> +	} else {
> +		/* Check if already disabled */
> +		if (memcmp(ip, nop_short, 2) == 0)
> +			return;
> +
> +		if (memcmp(ip, ideal, 5) == 0)
> +			return;
> +
> +		/* This may need to update from default to ideal */
> +		if (update_nops && memcmp(ip, default_nop, 5) == 0) {
> +			/* Set to the ideal nop */
> +			size = JUMP_LABEL_NOP_SIZE;
> +			memcpy(&code, ideal_nops[NOP_ATOMIC5], size);

whiteline.

> +
> +		} else if (op == 0xe9) {
> +			/* Replace a 5 byte jmp */
> +			size = JUMP_LABEL_NOP_SIZE;
> +			memcpy(&code, ideal_nops[NOP_ATOMIC5], size);
> +		} else if (op == 0xeb) {
> +			/* Replace a 2 byte jmp */
> +			size = 2;
> +			memcpy(&code, nop_short, size);
> +		} else
> +			BUG();
> +	}

Thanks,

Mathieu

> +
> +	(*poker)((void *)entry->code, &code, size);
>  }
>  
>  void arch_jump_label_transform(struct jump_entry *entry,
>  			       enum jump_label_type type)
>  {
> +	/* All nops should be updated to the ideal nop by now */
> +	update_nops = 0;
> +
>  	get_online_cpus();
>  	mutex_lock(&text_mutex);
>  	__jump_label_transform(entry, type, text_poke_smp);
> @@ -53,6 +118,13 @@ void arch_jump_label_transform(struct jump_entry *entry,
>  void arch_jump_label_transform_static(struct jump_entry *entry,
>  				      enum jump_label_type type)
>  {
> +	/*
> +	 * If the default nop does not equal the ideal nop, then
> +	 * update them.
> +	 */
> +	if (memcmp(default_nop, ideal_nops[NOP_ATOMIC5], 5) != 0)
> +		update_nops = 1;
> +
>  	__jump_label_transform(entry, type, text_poke_early);
>  }
>  
> -- 
> 1.7.8.3
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

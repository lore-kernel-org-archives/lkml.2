Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0ICK0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:26:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54283 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab0ICK0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:26:08 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv11 2.6.36-rc2-tip 4/15]  4: uprobes: x86 specific functions for user space breakpointing.
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	<20100825134210.5447.10126.sendpatchset@localhost6.localdomain6>
Date: Fri, 03 Sep 2010 12:26:02 +0200
In-Reply-To: <20100825134210.5447.10126.sendpatchset@localhost6.localdomain6>
	(Srikar Dronamraju's message of "Wed, 25 Aug 2010 19:12:10 +0530")
Message-ID: <87pqwvm8cl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju <srikar@linux.vnet.ibm.com> writes:

Quick high level review. I did not attempt to validate the basic
algorithm, more the kernel interface.

> Provides x86 specific functions for instruction analysis and
> instruction validation and x86 specific pre-processing and
> post-processing of singlestep especially for RIP relative
> instructions. Uses "x86: instruction decoder API" for validation and
> analysis of user space instructions. This analysis is used at the time
> of post-processing of breakpoint hit to do the necessary fix-ups.
> There is support for breakpointing RIP relative instructions. However
> there are still few instructions that cannot be singlestepped.

One general comment here: since with uprobes the instruction
decoder becomes security critical did you do any fuzz tests
on it (e.g. like using it on crashme or on code that has 
been corrupted with a few bitflips) ?

> +typedef u8 user_bkpt_opcode_t;

Maybe it's me, but I would prefer breakpoint instead of bkpt
> +#ifdef CONFIG_X86_32
> +#define is_32bit_app(tsk) 1
> +#else
> +#define is_32bit_app(tsk) (test_tsk_thread_flag(tsk, TIF_IA32))
> +#endif

This probably should be elsewhere.

> +
> +#define UPROBES_FIX_RIP_AX	0x8000
> +#define UPROBES_FIX_RIP_CX	0x4000
> +
> +/* Adaptations for mhiramat x86 decoder v14. */
> +#define OPCODE1(insn) ((insn)->opcode.bytes[0])
> +#define OPCODE2(insn) ((insn)->opcode.bytes[1])
> +#define OPCODE3(insn) ((insn)->opcode.bytes[2])
> +#define MODRM_REG(insn) X86_MODRM_REG(insn->modrm.value)
> +
> +/*
> + * @reg: reflects the saved state of the task
> + * @vaddr: the virtual address to jump to.
> + * Return 0 on success or a -ve number on error.
> + */
> +void set_ip(struct pt_regs *regs, unsigned long vaddr)
> +{
> +	regs->ip = vaddr;
> +}
> +
> +#ifdef CONFIG_X86_64
> +static bool is_riprel_insn(struct user_bkpt *user_bkpt)
> +{
> +	return ((user_bkpt->fixups &
> +			(UPROBES_FIX_RIP_AX | UPROBES_FIX_RIP_CX)) != 0);
> +}
> +

Shouldn't all this stuff be in the instruction decoder? 

It seems weird to have the knowledge spread over multiple files.

> +
> +static void report_bad_prefix(void)
> +{
> +	printk(KERN_ERR "uprobes does not currently support probing "
> +		"instructions with any of the following prefixes: "
> +		"cs:, ds:, es:, ss:, lock:\n");
> +}
> +
> +static void report_bad_1byte_opcode(int mode, user_bkpt_opcode_t op)
> +{
> +	printk(KERN_ERR "In %d-bit apps, "
> +		"uprobes does not currently support probing "
> +		"instructions whose first byte is 0x%2.2x\n", mode, op);
> +}
> +
> +static void report_bad_2byte_opcode(user_bkpt_opcode_t op)
> +{
> +	printk(KERN_ERR "uprobes does not currently support probing "
> +		"instructions with the 2-byte opcode 0x0f 0x%2.2x\n", op);
> +}

These functions that just do a single printk seem weird. I would
do that in the caller. Also the message could be shortened I guess
and should just dump the bytes.

> +
> +/**
> + * analyze_insn - instruction analysis including validity and fixups.
> + * @tsk: the probed task.
> + * @user_bkpt: the probepoint information.
> + * Return 0 on success or a -ve number on error.
> + */
> +int analyze_insn(struct task_struct *tsk, struct user_bkpt *user_bkpt)
> +{
> +	int ret;
> +	struct insn insn;
> +
> +	user_bkpt->fixups = 0;
> +#ifdef CONFIG_X86_64
> +	user_bkpt->arch_info.rip_target_address = 0x0;
> +#endif
> +
> +	if (is_32bit_app(tsk))

This check is not fully correct because it's valid to have
32bit code in 64bit programs and vice versa.  The only good
way to check that is to look at the code segment at runtime
though (and it gets complicated if you want to handle LDTs,
but that could be optional). May be difficult to do though.

Also the compat bit is not necessarily set if no system call is
executing. You would rather need to check the exec_domain.
> + */
> +static int adjust_ret_addr(struct task_struct *tsk, unsigned long sp,
> +							long correction)
> +{
> +	int rasize, ncopied;
> +	long ra = 0;
> +
> +	if (is_32bit_app(tsk))
> +		rasize = 4;
> +	else
> +		rasize = 8;
> +	ncopied = uprobes_read_vm(tsk, (void __user *) sp, &ra, rasize);
> +	if (unlikely(ncopied != rasize))
> +		goto fail;

goto is automatically unlikely and unlikely is deprecated anyways.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

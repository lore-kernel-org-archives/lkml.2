Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab0ICRy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:54:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56590 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846Ab0ICRyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:54:25 -0400
Date: Fri, 3 Sep 2010 23:18:32 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
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
Subject: Re: [PATCHv11 2.6.36-rc2-tip 4/15]  4: uprobes: x86 specific
 functions for user space breakpointing.
Message-ID: <20100903174832.GB14891@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134210.5447.10126.sendpatchset@localhost6.localdomain6>
 <87pqwvm8cl.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <87pqwvm8cl.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> One general comment here: since with uprobes the instruction
> decoder becomes security critical did you do any fuzz tests
> on it (e.g. like using it on crashme or on code that has 
> been corrupted with a few bitflips) ?

I havent tried any fuzz tests with the instruction decoder. But I am
not sure if Masami has tried that out some of these. 
One question: Do you want to test uprobes with crashme or test
instruction decoder with crashme.

> 
> > +typedef u8 user_bkpt_opcode_t;
> 
> Maybe it's me, but I would prefer breakpoint instead of bkpt

Even Peter wasnt comfortable with user_bkpt. How about user_bp?
i.e the above field would be user_bp_opcode_t. I felt 
user_breakpoint_opcode_t might look long. Also we would have to
rename other structures accordingly like user_bkpt_task_arch_info
would become user_breakpoint_task_arch_info. Do let me know your
choice.


> > +#ifdef CONFIG_X86_32
> > +#define is_32bit_app(tsk) 1
> > +#else
> > +#define is_32bit_app(tsk) (test_tsk_thread_flag(tsk, TIF_IA32))
> > +#endif
> 
> This probably should be elsewhere.

Would this fit in x86 Instruction decoder?

> 
> > +
> > +#define UPROBES_FIX_RIP_AX	0x8000
> > +#define UPROBES_FIX_RIP_CX	0x4000
> > +
> > +/* Adaptations for mhiramat x86 decoder v14. */
> > +#define OPCODE1(insn) ((insn)->opcode.bytes[0])
> > +#define OPCODE2(insn) ((insn)->opcode.bytes[1])
> > +#define OPCODE3(insn) ((insn)->opcode.bytes[2])
> > +#define MODRM_REG(insn) X86_MODRM_REG(insn->modrm.value)
> > +
> > +/*
> > + * @reg: reflects the saved state of the task
> > + * @vaddr: the virtual address to jump to.
> > + * Return 0 on success or a -ve number on error.
> > + */
> > +void set_ip(struct pt_regs *regs, unsigned long vaddr)
> > +{
> > +	regs->ip = vaddr;
> > +}
> > +
> > +#ifdef CONFIG_X86_64
> > +static bool is_riprel_insn(struct user_bkpt *user_bkpt)
> > +{
> > +	return ((user_bkpt->fixups &
> > +			(UPROBES_FIX_RIP_AX | UPROBES_FIX_RIP_CX)) != 0);
> > +}
> > +
> 
> Shouldn't all this stuff be in the instruction decoder? 
> 
> It seems weird to have the knowledge spread over multiple files.

Agree,  Shall move it to instruction decoder.

> 
> > +
> > +static void report_bad_prefix(void)
> > +{
> > +	printk(KERN_ERR "uprobes does not currently support probing "
> > +		"instructions with any of the following prefixes: "
> > +		"cs:, ds:, es:, ss:, lock:\n");
> > +}
> > +
> > +static void report_bad_1byte_opcode(int mode, user_bkpt_opcode_t op)
> > +{
> > +	printk(KERN_ERR "In %d-bit apps, "
> > +		"uprobes does not currently support probing "
> > +		"instructions whose first byte is 0x%2.2x\n", mode, op);
> > +}
> > +
> > +static void report_bad_2byte_opcode(user_bkpt_opcode_t op)
> > +{
> > +	printk(KERN_ERR "uprobes does not currently support probing "
> > +		"instructions with the 2-byte opcode 0x0f 0x%2.2x\n", op);
> > +}
> 
> These functions that just do a single printk seem weird. I would
> do that in the caller. Also the message could be shortened I guess
> and should just dump the bytes.
> 

Okay, I can move the printk to the caller, I will try to shorten the
message, Would something like "uprobes: no support for 2-byte
opcode 0x0f 0x%2" look fine?

> > +
> > +/**
> > + * analyze_insn - instruction analysis including validity and fixups.
> > + * @tsk: the probed task.
> > + * @user_bkpt: the probepoint information.
> > + * Return 0 on success or a -ve number on error.
> > + */
> > +int analyze_insn(struct task_struct *tsk, struct user_bkpt *user_bkpt)
> > +{
> > +	int ret;
> > +	struct insn insn;
> > +
> > +	user_bkpt->fixups = 0;
> > +#ifdef CONFIG_X86_64
> > +	user_bkpt->arch_info.rip_target_address = 0x0;
> > +#endif
> > +
> > +	if (is_32bit_app(tsk))
> 
> This check is not fully correct because it's valid to have
> 32bit code in 64bit programs and vice versa.  The only good
> way to check that is to look at the code segment at runtime
> though (and it gets complicated if you want to handle LDTs,
> but that could be optional). May be difficult to do though.

validate_insn_32bit is able to identify all valid instructions in a 32
bit app and validate_insn_64bits is a superset of
validate_insn_32bits; i.e it considers valid 32 bit codes as valid too.

Did you get a chance to look at
validate_insn_32bit/validate_insn_64bits? If you feel that
validate_insn_32bit/validate_insn_64bits? are unable to detect
valid codes, then I will certainly rework.

> 
> Also the compat bit is not necessarily set if no system call is
> executing. You would rather need to check the exec_domain.

Okay, I shall check and revert on this.

> > + */
> > +static int adjust_ret_addr(struct task_struct *tsk, unsigned long sp,
> > +							long correction)
> > +{
> > +	int rasize, ncopied;
> > +	long ra = 0;
> > +
> > +	if (is_32bit_app(tsk))
> > +		rasize = 4;
> > +	else
> > +		rasize = 8;
> > +	ncopied = uprobes_read_vm(tsk, (void __user *) sp, &ra, rasize);
> > +	if (unlikely(ncopied != rasize))
> > +		goto fail;
> 
> goto is automatically unlikely and unlikely is deprecated anyways.

Okay, shall remove unlikely from the above.

--
Thanks and Regards
Srikar

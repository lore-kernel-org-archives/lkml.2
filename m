Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1JUSDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 14:03:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab1JUSDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 14:03:54 -0400
Date: Fri, 21 Oct 2011 19:59:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: test-case (Was: [PATCH 12/X] uprobes: x86: introduce abort_xol())
Message-ID: <20111021175915.GA1705@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111019215139.GA16395@redhat.com> <20111019215326.GF16395@redhat.com> <20111021144207.GN11831@linux.vnet.ibm.com> <20111021162631.GB2552@in.ibm.com> <20111021164221.GA30770@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021164221.GA30770@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21, Oleg Nesterov wrote:
>
> On 10/21, Ananth N Mavinakayanahalli wrote:
> >
> > On Fri, Oct 21, 2011 at 08:12:07PM +0530, Srikar Dronamraju wrote:
> >
> > > > +void abort_xol(struct pt_regs *regs)
> > > > +{
> > > > +	// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> > > > +	// !!! Dear Srikar and Ananth, please implement me !!!
> > > > +	// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> > > > +	struct uprobe_task *utask = current->utask;
> > > > +	regs->ip = utask->vaddr;
> > >
> > > nit:
> > > Shouldnt we be setting the ip to the next instruction after this
> > > instruction?
> >
> > No, since we should re-execute the original instruction
>
> Yes,

In case it was not clear, I meant "agree with your 'No'".

> > after removing
> > the breakpoint.
>
> No? we should not remove this uprobe?
>
> > Also, wrt ip being set to the next instruction on a breakpoint hit,
> > that's arch specific.
>
> Probably yes, I am not sure. But:
>
> > For instance, on x86, it points to the next
> > instruction,
>
> No?
>
> 	/**
> 	 * get_uprobe_bkpt_addr - compute address of bkpt given post-bkpt regs
> 	 * @regs: Reflects the saved state of the task after it has hit a breakpoint
> 	 * instruction.
> 	 * Return the address of the breakpoint instruction.
> 	 */
> 	unsigned long __weak get_uprobe_bkpt_addr(struct pt_regs *regs)
> 	{
> 		return instruction_pointer(regs) - UPROBES_BKPT_INSN_SIZE;
> 	}
>
> Yes, initially regs->ip points to the next insn after int3, but
> utask->vaddr == get_uprobe_bkpt_addr() == addr of int3.

Ananth, Srikar, I'd suggest this test-case:

	#include <stdio.h>
	#include <signal.h>
	#include <ucontext.h>

	void *fault_insn;

	static inline void *uc_ip(struct ucontext *ctxt)
	{
		return (void*)ctxt->uc_mcontext.gregs[16];
	}

	void segv(int sig, siginfo_t *info, void *ctxt)
	{
		static int cnt;

		printf("SIGSEGV! ip=%p addr=%p\n", uc_ip(ctxt), info->si_addr);

		if (uc_ip(ctxt) != fault_insn)
			printf("ERR!! wrong ip\n");
		if (info->si_addr != (void*)0x12345678)
			printf("ERR!! wrong addr\n");

		if (++cnt == 3)
			signal(SIGSEGV, SIG_DFL);
	}

	int main(void)
	{
		struct sigaction sa = {
			.sa_sigaction	= segv,
			.sa_flags	= SA_SIGINFO,
		};

		sigaction(SIGSEGV, &sa, NULL);

		fault_insn = &&label;

	label:
		asm volatile ("movl $0x0,0x12345678");

		return 0;
	}

result:

	$ ulimit -c unlimited

	$ ./segv
	SIGSEGV! ip=0x4006eb addr=0x12345678
	SIGSEGV! ip=0x4006eb addr=0x12345678
	SIGSEGV! ip=0x4006eb addr=0x12345678
	Segmentation fault (core dumped)

	$ gdb -c ./core.1826
	...
	Program terminated with signal 11, Segmentation fault.
	#0  0x00000000004006eb in ?? ()

Now. If you insert uprobe at asm("movl") insn, result should be the same
or the patches I sent are wrong. In particular, the addr in the coredump
should be correct too. And consumer->handler() should be called 3 times
too. This insn is really executed 3 times.

I have no idea how can I test this.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1JYOfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:35:54 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44011 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1JYOfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:35:53 -0400
Date: Tue, 25 Oct 2011 19:36:13 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
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
Subject: Re: test-case (Was: [PATCH 12/X] uprobes: x86: introduce
 abort_xol())
Message-ID: <20111025140613.GA17914@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20111015190007.GA30243@redhat.com>
 <20111019215139.GA16395@redhat.com>
 <20111019215326.GF16395@redhat.com>
 <20111021144207.GN11831@linux.vnet.ibm.com>
 <20111021162631.GB2552@in.ibm.com>
 <20111021164221.GA30770@redhat.com>
 <20111021175915.GA1705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111021175915.GA1705@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11102514-3534-0000-0000-000000E49601
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Ananth, Srikar, I'd suggest this test-case:
> 
> 	#include <stdio.h>
> 	#include <signal.h>
> 	#include <ucontext.h>
> 
> 	void *fault_insn;
> 
> 	static inline void *uc_ip(struct ucontext *ctxt)
> 	{
> 		return (void*)ctxt->uc_mcontext.gregs[16];
> 	}
> 
> 	void segv(int sig, siginfo_t *info, void *ctxt)
> 	{
> 		static int cnt;
> 
> 		printf("SIGSEGV! ip=%p addr=%p\n", uc_ip(ctxt), info->si_addr);
> 
> 		if (uc_ip(ctxt) != fault_insn)
> 			printf("ERR!! wrong ip\n");
> 		if (info->si_addr != (void*)0x12345678)
> 			printf("ERR!! wrong addr\n");
> 
> 		if (++cnt == 3)
> 			signal(SIGSEGV, SIG_DFL);
> 	}
> 
> 	int main(void)
> 	{
> 		struct sigaction sa = {
> 			.sa_sigaction	= segv,
> 			.sa_flags	= SA_SIGINFO,
> 		};
> 
> 		sigaction(SIGSEGV, &sa, NULL);
> 
> 		fault_insn = &&label;
> 
> 	label:
> 		asm volatile ("movl $0x0,0x12345678");
> 
> 		return 0;
> 	}
> 
> result:
> 
> 	$ ulimit -c unlimited
> 
> 	$ ./segv
> 	SIGSEGV! ip=0x4006eb addr=0x12345678
> 	SIGSEGV! ip=0x4006eb addr=0x12345678
> 	SIGSEGV! ip=0x4006eb addr=0x12345678
> 	Segmentation fault (core dumped)
> 
> 	$ gdb -c ./core.1826
> 	...
> 	Program terminated with signal 11, Segmentation fault.
> 	#0  0x00000000004006eb in ?? ()
> 
> Now. If you insert uprobe at asm("movl") insn, result should be the same
> or the patches I sent are wrong. In particular, the addr in the coredump
> should be correct too. And consumer->handler() should be called 3 times
> too. This insn is really executed 3 times.
> 
> I have no idea how can I test this.
> 

I have tested this on both x86_32 and x86_64 and can confirm that the
behaviour is same with or without uprobes placed at that instruction.
This is on the uprobes code with your changes.

However on x86_32; the output is different from x86_64. 

On x86_32 (I have additionally printed the uc_ip and fault_insn.

SIGSEGV! ip=0x10246 addr=0x12345678
ERR!! wrong ip uc_ip(ctxt) = 10246 fault_insn = 804856c
SIGSEGV! ip=0x10246 addr=0x12345678
ERR!! wrong ip uc_ip(ctxt) = 10246 fault_insn = 804856c
SIGSEGV! ip=0x10246 addr=0x12345678
ERR!! wrong ip uc_ip(ctxt) = 10246 fault_insn = 804856c
Segmentation fault

the fault_insn matches the address shown in disassemble of gdb.
I still trying to dig up what uc_ip is and why its different on x86_32.

On x86_64 the result is what you pasted above.


Also I was thinking on your suggestion of making abort_xol a weak
function.  In which case we could have architecture independent function
in kernel/uprobes.c which is just a wrapper for set_instruction_pointer. 

void __weak abort_xol(struct pt_regs *regs, struct uprobe_task *utask)
{
	set_instruction_pointer(regs, utask->vaddr);	
}

where it would called  from uprobe_notify_resume() as 

	abort_xol(regs, utask);

If other archs would want to do something else, they could override
abort_xol definition.

-- 
Thanks and Regards
Srikar


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1JUQ1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:27:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab1JUQ1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:27:09 -0400
Date: Fri, 21 Oct 2011 18:22:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/X] uprobes: x86: introduce abort_xol()
Message-ID: <20111021162219.GA29753@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111019215139.GA16395@redhat.com> <20111019215326.GF16395@redhat.com> <20111021144207.GN11831@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021144207.GN11831@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21, Srikar Dronamraju wrote:
>
> > If it is not clear, abort_xol() is needed when we should
> > re-execute the original insn (replaced with int3), see the
> > next patch.
>
> We should be removing the breakpoint in abort_xol().

Why? See also below.

> Otherwise if we just set the instruction pointer to int3 and signal a
> sigill, then the user may be confused why a breakpoint is generating
> SIGILL.

Which user?

gdb? Of course it can be confused. But it can be confused in any case.

> > +void abort_xol(struct pt_regs *regs)
> > +{
> > +	// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> > +	// !!! Dear Srikar and Ananth, please implement me !!!
> > +	// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> > +	struct uprobe_task *utask = current->utask;
> > +	regs->ip = utask->vaddr;
>
> nit:
> Shouldnt we be setting the ip to the next instruction after this
> instruction?

Not sure...

We should restart the same insn. Say, if the probed insn
was "*(int*)0 = 0", it should be executed again after SIGSEGV. Unless
the task was killed by this signal.

And in this case we should call uprobe_consumer()->handler() again,
we shouldn't remove "int3".

> I have applied all your patches and ran tests, the tests are all
> passing.
>
> I will fold them into my patches and send them out.

Great, thanks.

Oleg.


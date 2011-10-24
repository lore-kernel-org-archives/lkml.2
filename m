Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab1JXOq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:46:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752Ab1JXOqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:46:48 -0400
Date: Mon, 24 Oct 2011 16:41:27 +0200
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
Subject: Re: [PATCH 13/X] uprobes: introduce UTASK_SSTEP_TRAPPED logic
Message-ID: <20111024144127.GA14975@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111019215139.GA16395@redhat.com> <20111019215344.GG16395@redhat.com> <20111022072030.GB24475@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111022072030.GB24475@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22, Ananth N Mavinakayanahalli wrote:
>
> On Wed, Oct 19, 2011 at 11:53:44PM +0200, Oleg Nesterov wrote:
> > Finally, add UTASK_SSTEP_TRAPPED state/code to handle the case when
> > xol insn itself triggers the signal.
> >
> > In this case we should restart the original insn even if the task is
> > already SIGKILL'ed (say, the coredump should report the correct ip).
> > This is even more important if the task has a handler for SIGSEGV/etc,
> > The _same_ instruction should be repeated again after return from the
> > signal handler, and SSTEP can never finish in this case.
>
> Oleg,
>
> Not sure I understand this completely...

I hope you do not think I do ;)

> When you say 'correct ip' you mean the original vaddr where we now have
> a uprobe breakpoint and not the xol copy, right?

Yes,

> Coredump needs to report the correct ip, but should it also not report
> correctly the instruction that caused the signal? Ergo, shouldn't we
> put the original instruction back at the uprobed vaddr?

OK, now I see what you mean. I was confused by the "restore the original
instruction before _restart_" suggestion.

Agreed! it would be nice to "hide" these int3's if we dump the core, but
I think this is a bit off-topic. It makes sense to do this in any case,
even if the core-dumping was triggered by another thread/insn. It makes
sense to remove all int3's, not only at regs->ip location. But how can
we do this? This is nontrivial.

And. Even worse. Suppose that you do "gdb probed_application". Now you
see int3's in the disassemble output. What can we do?

I think we can do nothing, at least currently. This just reflects the
fact that uprobe connects to inode, not to process/mm/etc.

What do you think?

Oleg.


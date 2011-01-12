Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab1ALMf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:35:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33955 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab1ALMf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:35:58 -0500
Date: Wed, 12 Jan 2011 12:35:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@kernel.dk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Soren Sandmann <ssp@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, kernel@pengutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: BUG: spinlock recursion (sys_chdir, user_path_at,
	do_path_lookup ...)
Message-ID: <20110112123508.GZ11039@n2100.arm.linux.org.uk>
References: <20110111110539.GP24920@pengutronix.de> <20110112075229.GZ24920@pengutronix.de> <alpine.LFD.2.00.1101121153370.12146@localhost6.localdomain6> <20110112120349.GH24920@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110112120349.GH24920@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 01:03:49PM +0100, Uwe Kleine-König wrote:
> On Wed, Jan 12, 2011 at 11:57:50AM +0100, Thomas Gleixner wrote:
> > On Wed, 12 Jan 2011, Uwe Kleine-König wrote:
> > > > [   75.280000]  r5:be961ee4 r4:00063015
> > > > 
> > > > I started to bisect, but already the first test case showed a different
> > > > error (my getty dying every few seconds).
> > > I bisected this one now, the first bad commit is
> > > 
> > > 	9c0729d (x86: Eliminate bp argument from the stack tracing routines)
> > > 
> > > .  It made a x86 specific change to include/linux/stacktrace.h.
> > 
> > As I said on IRC already, that's complete nonsense. The commit changes
> > a function prototype which is only relevant for x86. So how should
> > that affect ARM ?
> hmm, the conversion that you probably mean is:
> 
> 	22:26 < ukleinek> hmm, 9c0729dc8062bed96189bd14ac6d4920f3958743 is the first bad commit
> 	22:26 < tglx> lol
> 	22:26  * ukleinek goes to bed
> 	22:27 < ukleinek> then it can only be about include/linux/stacktrace.h
> 	22:27  * ukleinek goes to bed anyhow
> 	22:28 < rostedt> ukleinek: btw, you could do the bisect automated with ktest.pl :-)
> 	22:30 < tglx> ukleinek: right, a change to include/linux/stacktrace.h which is x86 specific
> 	22:33 < tglx> makes arm explode
> 	22:33 < tglx> rotfl
> 
> I admit I didn't look what was changed there and I understood your
> statement as "the change to include/linux/stacktrace.h was x86 specific
> and so broke ARM".

This commit has nothing to do with ARM and couldn't possibly be
responsible for your breakage.  The diffstat for that commit is:

 arch/x86/include/asm/kdebug.h     |    2 +-
 arch/x86/include/asm/stacktrace.h |   33 ++++++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   12 ++++++------
 arch/x86/kernel/dumpstack_32.c    |   25 +++++++------------------
 arch/x86/kernel/dumpstack_64.c    |   24 +++++++-----------------
 arch/x86/kernel/process.c         |    3 +--
 arch/x86/kernel/stacktrace.c      |    8 ++++----
 arch/x86/mm/kmemcheck/error.c     |    2 +-
 arch/x86/oprofile/backtrace.c     |    2 +-
 include/linux/stacktrace.h        |    4 +++-
 11 files changed, 62 insertions(+), 55 deletions(-)

and the only file which could affect ARM is include/linux/stacktrace.h.
That change adds a declaration of struct pt_regs and then does:

-extern void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp);
+extern void save_stack_trace_regs(struct stack_trace *trace,
+                                 struct pt_regs *regs);

ARM doesn't implement save_stack_trace_regs() nor save_stack_trace_bp()
so if the compiler referenced these, you'd have a kernel which doesn't
link.  The only places that this symbol appears is:

arch/x86/kernel/stacktrace.c:void save_stack_trace_regs(struct stack_trace *trac
arch/x86/mm/kmemcheck/error.c:  save_stack_trace_regs(&e->trace, regs);
include/linux/stacktrace.h:extern void save_stack_trace_regs(struct stack_trace

So, if this is where your bisect decided was the problem, your bisect
was faulty.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab1ALM5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:57:03 -0500
Received: from www.tglx.de ([62.245.132.106]:41364 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab1ALM5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:57:02 -0500
Date: Wed, 12 Jan 2011 13:56:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Nick Piggin <npiggin@kernel.dk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Soren Sandmann <ssp@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, kernel@pengutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: BUG: spinlock recursion (sys_chdir, user_path_at, do_path_lookup
 ...)
In-Reply-To: <20110112124844.GA4415@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1101121354570.12146@localhost6.localdomain6>
References: <20110111110539.GP24920@pengutronix.de> <20110112075229.GZ24920@pengutronix.de> <alpine.LFD.2.00.1101121153370.12146@localhost6.localdomain6> <20110112120349.GH24920@pengutronix.de> <20110112123508.GZ11039@n2100.arm.linux.org.uk>
 <20110112124844.GA4415@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011, Russell King - ARM Linux wrote:
> On Wed, Jan 12, 2011 at 12:35:08PM +0000, Russell King - ARM Linux wrote:
> > ARM doesn't implement save_stack_trace_regs() nor save_stack_trace_bp()
> > so if the compiler referenced these, you'd have a kernel which doesn't
> > link.  The only places that this symbol appears is:
> > 
> > arch/x86/kernel/stacktrace.c:void save_stack_trace_regs(struct stack_trace *trac
> > arch/x86/mm/kmemcheck/error.c:  save_stack_trace_regs(&e->trace, regs);
> > include/linux/stacktrace.h:extern void save_stack_trace_regs(struct stack_trace
> > 
> > So, if this is where your bisect decided was the problem, your bisect
> > was faulty.
> 
> BTW, a useful thing to do after a bisect is to return to the point in
> the history where you first noticed the regression (so Linus' tip,
> your tip, or whatever).  Then try reverting the commit which git bisect
> _thinks_ is the cause of your problem and re-test that.
> 
> If the problem is fixed, you have greater confidence that the commit is
> the problem.
> 
> If it made no difference, then you know that something else (maybe in
> combination) is causing the problem.
> 
> If you couldn't revert it because of other dependencies then you have
> to rely on analysis (such as what I did) and maybe try again with a
> slightly different strategy - maybe the problem only _occasionally_
> occurs, making the 'git bisect good' points unreliable, so maybe you
> need to do more testing when the problem doesn't immediately appear?
> 
> Lastly, it is worth bearing in mind that GCC is really finicky with its
> optimization.  It may be hard to believe, but unrelated function
> definitions in headers can (and do) affect the code generation in
> completely unrelated functions causing them to be optimized
> differently [*].  Maybe this applies to prototypes too?

Yes, it does. Also adding an inline or define can change the
behaviour.

> So it _could_ be that the prototype change in include/linux/stacktrace.h
> is tickling a GCC code generation bug.
> 
> * - ISTR, this behaviour was raised as a bug with GCC folk, which I
> believe was closed down as wontfix as its a result of the way the
> optimizer works.

Right, they just fixed the problem where this effect generated buggy
code on x86 in some cases.

Thanks,

	tglx


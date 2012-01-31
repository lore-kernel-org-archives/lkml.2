Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2AaMxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:53:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48009 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2AaMxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:53:48 -0500
Date: Tue, 31 Jan 2012 13:53:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, arjanvandeven@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: clean up smpboot.c's use of udelay+schedule
Message-ID: <20120131125331.GE4408@elte.hu>
References: <20120130205304.0e10b05e@infradead.org>
 <20120131124341.GC4408@elte.hu>
 <1328014076.2446.210.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328014076.2446.210.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2012-01-31 at 13:43 +0100, Ingo Molnar wrote:
> > * Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > > >From 9f8dd2b15ff19ad73ee0eb235b4fdde9277185e8 Mon Sep 17 00:00:00 2001
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > Date: Mon, 30 Jan 2012 20:38:09 -0800
> > > Subject: [PATCH] x86: clean up smpboot.c's use of udelay+schedule
> > > 
> > > smpboot.c does a udelay() followed by a schedule(); to yield
> > > the CPU to other threads. This comes from the time when the kernel
> > > did not yet have usleep_*() style APIs...
> > > 
> > > ... nowadays, the kernel can do better than this, and this
> > > patch replaces this code sequence with a usleep_range(),
> > > so that the CPU is actually yielded for some real time.
> > > 
> > > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > > ---
> > >  arch/x86/kernel/smpboot.c |    3 +--
> > >  1 files changed, 1 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > > index 66d250c..0b794c6 100644
> > > --- a/arch/x86/kernel/smpboot.c
> > > +++ b/arch/x86/kernel/smpboot.c
> > > @@ -781,14 +781,13 @@ do_rest:
> > >  		for (timeout = 0; timeout < 50000; timeout++) {
> > >  			if (cpumask_test_cpu(cpu, cpu_callin_mask))
> > >  				break;	/* It has booted */
> > > -			udelay(100);
> > >  			/*
> > >  			 * Allow other tasks to run while we wait for the
> > >  			 * AP to come online. This also gives a chance
> > >  			 * for the MTRR work(triggered by the AP coming online)
> > >  			 * to be completed in the stop machine context.
> > >  			 */
> > > -			schedule();
> > > +			usleep_range(100, 200);
> > 
> > I'm wondering whether we could shorten this delay to say 10 
> > usecs and thus save 0.1 msecs (or more) from a typical SMP 
> > bootup?
> 
> wait_on_completion_timeout() and have the fresh cpu do a 
> wakeup when its done. That way there's no need for a minimal 
> wait time.

Yeah.

> Anyway, all the cpu hotplug code is a friggin trainwreck and 
> needs a complete rewrite across all archs.

Wanna give a short TODO list to anyone wanting to work on that?

Thanks,

	Ingo

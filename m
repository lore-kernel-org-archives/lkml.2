Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2AaMsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:48:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:51088 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2AaMsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:48:09 -0500
Message-ID: <1328014076.2446.210.camel@twins>
Subject: Re: x86: clean up smpboot.c's use of udelay+schedule
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, arjanvandeven@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 31 Jan 2012 13:47:56 +0100
In-Reply-To: <20120131124341.GC4408@elte.hu>
References: <20120130205304.0e10b05e@infradead.org>
	 <20120131124341.GC4408@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 13:43 +0100, Ingo Molnar wrote:
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > >From 9f8dd2b15ff19ad73ee0eb235b4fdde9277185e8 Mon Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Mon, 30 Jan 2012 20:38:09 -0800
> > Subject: [PATCH] x86: clean up smpboot.c's use of udelay+schedule
> > 
> > smpboot.c does a udelay() followed by a schedule(); to yield
> > the CPU to other threads. This comes from the time when the kernel
> > did not yet have usleep_*() style APIs...
> > 
> > ... nowadays, the kernel can do better than this, and this
> > patch replaces this code sequence with a usleep_range(),
> > so that the CPU is actually yielded for some real time.
> > 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > ---
> >  arch/x86/kernel/smpboot.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index 66d250c..0b794c6 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -781,14 +781,13 @@ do_rest:
> >  		for (timeout = 0; timeout < 50000; timeout++) {
> >  			if (cpumask_test_cpu(cpu, cpu_callin_mask))
> >  				break;	/* It has booted */
> > -			udelay(100);
> >  			/*
> >  			 * Allow other tasks to run while we wait for the
> >  			 * AP to come online. This also gives a chance
> >  			 * for the MTRR work(triggered by the AP coming online)
> >  			 * to be completed in the stop machine context.
> >  			 */
> > -			schedule();
> > +			usleep_range(100, 200);
> 
> I'm wondering whether we could shorten this delay to say 10 
> usecs and thus save 0.1 msecs (or more) from a typical SMP 
> bootup?

wait_on_completion_timeout() and have the fresh cpu do a wakeup when its
done. That way there's no need for a minimal wait time.

Anyway, all the cpu hotplug code is a friggin trainwreck and needs a
complete rewrite across all archs.

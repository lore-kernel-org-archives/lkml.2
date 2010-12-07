Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0LGOHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:07:53 -0500
Received: from www.tglx.de ([62.245.132.106]:37709 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0LGOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:07:52 -0500
Date: Tue, 7 Dec 2010 15:07:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] "perf top" results in "NOHZ: local_softirq_pending 100"
In-Reply-To: <1291729867.2032.534.camel@laptop>
Message-ID: <alpine.LFD.2.00.1012071507180.2653@localhost6.localdomain6>
References: <20101207124448.GA10927@osiris.boeblingen.de.ibm.com>  <20101207132951.GB10927@osiris.boeblingen.de.ibm.com> <1291729867.2032.534.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Peter Zijlstra wrote:
> On Tue, 2010-12-07 at 14:29 +0100, Heiko Carstens wrote:
> > > As far as I could see this function gets called from process context with
> > > a spinlock held and hence we don't have any guarantee that this pending
> > > softirq get executed before the idle task gets scheduled and tries to
> > > disable the tick.
> > > 
> > > The easiest fix would be to set wakeup to one (see patch below), but I guess
> > > there is a reason why its zero. Anybody?
> 
> We can start that hrtimer from within the scheduler function while
> holding the rq->lock, doing a wakeup from there is not sane.
> 
> The best solution would be to fix the hrtimer_start*() interface,
> something Thomas and I have wanted to do for ages but because we've
> procrastinated is now a much larger job than it was :/
> 
> The whole HRTIMER_SOFTIRQ thing should die.. but for that to happen its
> only use-case today must first go.
> 
> The problem is trying to start a timer with already elapsed time.
> Preferably hrtimer_start*() would simply return -ETIME and let the
> caller sort it, sadly the current behaviour is to 'fix' it for the
> caller by enqueueing the timer onto the softirq list and raising the
> softirq.
> 
> I guess we could make hrtimer_start*(.wakeup=false) return the -ENOTIME
> thing and audit those few use-cases.

That would be sensible anyway.
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab1BNSxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:53:53 -0500
Received: from www.tglx.de ([62.245.132.106]:53879 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab1BNSxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:53:51 -0500
Date: Mon, 14 Feb 2011 19:53:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lockdep: possible reason: unannotated irqs-off. (was: Re: Linux
 2.6.38-rc4)
In-Reply-To: <20110214145125.GA2937@zhy>
Message-ID: <alpine.LFD.2.00.1102141950180.26192@localhost6.localdomain6>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com> <20110208101730.GB7020@liondog.tnic> <1297161712.13327.100.camel@laptop> <20110208121108.GA4824@zhy> <20110208133457.GA5813@zhy> <1297172906.13327.104.camel@laptop>
 <1297174680.13327.107.camel@laptop> <20110214145125.GA2937@zhy>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Yong Zhang wrote:

> On Tue, Feb 08, 2011 at 03:18:00PM +0100, Peter Zijlstra wrote:
> > Subject: lockdep, timer: Revert the del_timer_sync() annotation
> > 
> > Both attempts at trying to allow softirq usage failed, revert for this
> > release and try again later.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/timer.c |    8 +++-----
> >  1 files changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/timer.c b/kernel/timer.c
> > index 343ff27..c848cd8 100644
> > --- a/kernel/timer.c
> > +++ b/kernel/timer.c
> > @@ -959,7 +959,7 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
> >   *
> >   * Synchronization rules: Callers must prevent restarting of the timer,
> >   * otherwise this function is meaningless. It must not be called from
> > - * hardirq contexts. The caller must not hold locks which would prevent
> > + * interrupt contexts. The caller must not hold locks which would prevent
> 
> I think we don't need to revert this comment.

That does not matter. It breaks stuff left and right and we need to go
back to the old (maybe less broken) state in that phase of -rc. It's
that simple.
 
> >   * completion of the timer's handler. The timer's handler must not call
> >   * add_timer_on(). Upon exit the timer is not queued and the handler is
> >   * not running on any CPU.
> > @@ -971,12 +971,10 @@ int del_timer_sync(struct timer_list *timer)
> >  #ifdef CONFIG_LOCKDEP
> >  	unsigned long flags;
> >  
> > -	raw_local_irq_save(flags);
> > -	local_bh_disable();
> > +	local_irq_save(flags);
> 
> Going back to local_irq_save()/local_irq_restore() doesn't prevent
> it from using in softirq context.

That does not matter. It goes back to status quo and does not
introduce new problems. As the changelog says:

> > Both attempts at trying to allow softirq usage failed, revert for this
> > release and try again later.

So it's not forgotten. It's just not fixable right now.

Thanks,

	tglx

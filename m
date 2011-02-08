Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1BHNrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:47:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:57724 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1BHNrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:47:20 -0500
Subject: Re: lockdep: possible reason: unannotated irqs-off. (was: Re:
 Linux 2.6.38-rc4)
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, tglx <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110208133457.GA5813@zhy>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	 <20110208101730.GB7020@liondog.tnic> <1297161712.13327.100.camel@laptop>
	 <20110208121108.GA4824@zhy>  <20110208133457.GA5813@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 14:48:26 +0100
Message-ID: <1297172906.13327.104.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 21:34 +0800, Yong Zhang wrote:
> On Tue, Feb 08, 2011 at 08:11:08PM +0800, Yong Zhang wrote:
> > From: Yong Zhang <yong.zhang0@gmail.com>
> > Subject: [PATCH 1/2] softirq: introduce loacal_bh_enable_force_wake()
> > 
> > If there is pending softirq, don't handle it in the caller's
> > context, invoke ksoftirqd directly instead.
> > 
> > del_timer_sync() will be the first caller.
> > 
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  include/linux/bottom_half.h |    1 +
> >  kernel/softirq.c            |   21 +++++++++++++++------
> >  2 files changed, 16 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/bottom_half.h b/include/linux/bottom_half.h
> > index 27b1bcf..665d697 100644
> > --- a/include/linux/bottom_half.h
> > +++ b/include/linux/bottom_half.h
> > @@ -5,5 +5,6 @@ extern void local_bh_disable(void);
> >  extern void _local_bh_enable(void);
> >  extern void local_bh_enable(void);
> >  extern void local_bh_enable_ip(unsigned long ip);
> > +extern void local_bh_enable_force_wake(void);
> >  
> >  #endif /* _LINUX_BH_H */
> > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > index 68eb5ef..3c05dfa 100644
> > --- a/kernel/softirq.c
> > +++ b/kernel/softirq.c
> > @@ -154,9 +154,9 @@ void _local_bh_enable(void)
> >  
> >  EXPORT_SYMBOL(_local_bh_enable);
> >  
> > -static inline void _local_bh_enable_ip(unsigned long ip)
> > +static inline void _local_bh_enable_ip(unsigned long ip, bool force_wake)
> >  {
> > -	WARN_ON_ONCE(in_irq() || irqs_disabled());
> > +	WARN_ON_ONCE(in_irq() || (!force_wake && irqs_disabled()));
> 
> Only suppressing the warning is not enough here :(
> 
> >  #ifdef CONFIG_TRACE_IRQFLAGS
> >  	local_irq_disable();
> 
> 
> The semantic "called with irqs_disabled" is showed on several place
> of _local_bh_enable_ip().
> 
> Need more thinking about it...

Well that and modifying softirq bits for a lockdep annotation really
feels wrong.


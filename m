Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1DNULi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab1DNULh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:11:37 -0400
Date: Thu, 14 Apr 2011 22:10:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] signal: sigprocmask() should do
	retarget_shared_pending()
Message-ID: <20110414201045.GB25828@redhat.com>
References: <20110411171957.GA32469@redhat.com> <20110411172137.GE32469@redhat.com> <20110412183314.GA16342@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412183314.GA16342@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Mon, Apr 11, 2011 at 07:21:37PM +0200, Oleg Nesterov wrote:
> > --- sigprocmask/include/linux/signal.h~4_sigprocmask_retarget	2011-04-06 21:33:50.000000000 +0200
> > +++ sigprocmask/include/linux/signal.h	2011-04-11 18:16:51.000000000 +0200
> > @@ -126,10 +126,14 @@ _SIG_SET_BINOP(sigandsets, _sig_and)
> >  #define _sig_nand(x,y)	((x) & ~(y))
> >  _SIG_SET_BINOP(signandsets, _sig_nand)
> >
> > +#define _sig_nor(x,y)	((x) | ~(y))
> > +_SIG_SET_BINOP(signorsets, _sig_nor)
> > +
> >  #undef _SIG_SET_BINOP
> >  #undef _sig_or
> >  #undef _sig_and
> >  #undef _sig_nand
> > +#undef _sig_nor
>
> I'm confused.  Isn't nand ^(A&B) and nor ^(A|B)?

Well, I don't know the common definition... But please note that
signandsets() does ((x) & ~(y)), so I defined nor as (x | ~y) by analogy.

> >  #define _SIG_SET_OP(name, op)						\
> >  static inline void name(sigset_t *set)					\
> > --- sigprocmask/kernel/signal.c~4_sigprocmask_retarget	2011-04-10 21:57:42.000000000 +0200
> > +++ sigprocmask/kernel/signal.c	2011-04-11 18:02:22.000000000 +0200
> > @@ -2131,6 +2131,11 @@ int sigprocmask(int how, sigset_t *set, 
> >  	}
> >
> >  	spin_lock_irq(&tsk->sighand->siglock);
> > +	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
> > +		sigset_t not_newblocked;
> > +		signorsets(&not_newblocked, &current->blocked, &newset);
> > +		retarget_shared_pending(tsk, &not_newblocked);
>
> I think it would be much easier to follow the logic if
> retarget_shared_pending() took target mask instead of blocked

Indeed.  But currently we only have has_pending_signals() which needs
blocked, not mask.

> but I think we
> really need to do retargeting (and the initial targeting too) more
> efficiently as you noted in the earlier commit message.

Yes, will do. And to do this we need the mask, not blocked.

But I'd prefer to do this after this series to make the first patches
simpler.

The main optimization is the first has_pending_signals() check which
can likely avoid while_each_thread() altogether. Once we start looping
we already lost. But anyway I agree, we should do this. Perhaps we can
add more optimizations later... say, perhaps we can add something like
TIF_SIGPENDING_SHARED, I am not sure.

Oleg.


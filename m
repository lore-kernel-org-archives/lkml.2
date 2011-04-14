Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab1DNThT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:37:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244Ab1DNThR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:37:17 -0400
Date: Thu, 14 Apr 2011 21:36:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] signal: sigprocmask() should do
	retarget_shared_pending()
Message-ID: <20110414193627.GA25828@redhat.com>
References: <20110411171957.GA32469@redhat.com> <20110411172137.GE32469@redhat.com> <BANLkTin6t7fSuyxw4Nipj1DGy8w9XE3+ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin6t7fSuyxw4Nipj1DGy8w9XE3+ug@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Linus Torvalds wrote:
>
> On Mon, Apr 11, 2011 at 10:21 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > I am not sure this is bug, but at least this looks strange imho. T1 should
> > not sleep forever, there is a signal which should wake it up.
>
> Hmm. I worry about the overhead of this, and I'm not 100% convinced we need it.

Indeed. That is why RFC.

I simply do not know if this is buggy or not. I reported this oddity a long
ago, but I can't recall the result of discussion (or it was ignored ?).

And I do not like the fact we need a lot of changes, albeit trivial. We should
convert almost every code which changes current->blocked. Otoh, perhaps this
makes sense by itself...

> > --- sigprocmask/include/linux/signal.h~4_sigprocmask_retarget   2011-04-06 21:33:50.000000000 +0200
> > +++ sigprocmask/include/linux/signal.h  2011-04-11 18:16:51.000000000 +0200
> > @@ -2131,6 +2131,11 @@ int sigprocmask(int how, sigset_t *set,
> >        }
> >
> >        spin_lock_irq(&tsk->sighand->siglock);
> > +       if (signal_pending(tsk) && !thread_group_empty(tsk)) {
> > +               sigset_t not_newblocked;
> > +               signorsets(&not_newblocked, &current->blocked, &newset);
> > +               retarget_shared_pending(tsk, &not_newblocked);
> > +       }
> >        tsk->blocked = newset;
> >        recalc_sigpending();
> >        spin_unlock_irq(&tsk->sighand->siglock);
>
> I absolutely detest how you made "sigprocmask()" the main interface to
> do this all, and then add new callers.
>
> It's a horrid interface with that crazy "how" argument, and comes out
> of the user-space system call interface. If we make kernel users do
> this, especially critical ones like the signal handling code, please
> just extract out just the actual "set new signal mask" part.
>
> So please just introduce a "sig_set_blocked()" or something, without
> the crazy "switch (how)" crud, and make sigprocmask() and everybody
> else use _that_ instead.

You know, initially I did exactly this. set_current_blocked() was its
name. But then I noticed that handle_signal() can naturally use SIG_BLOCK,
sigtimedwait() could use SIG_UNBLOCK...

Nevermind,

> That would make me much happier about the patch series, I suspect.

OK. I'll redo and resend.

Oleg.


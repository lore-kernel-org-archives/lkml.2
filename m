Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab1DNTBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:01:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1DNTBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:01:00 -0400
Date: Thu, 14 Apr 2011 21:00:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 2/5] signals: Introduce per-thread siglock and
	action rwlock
Message-ID: <20110414190012.GA23517@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-3-git-send-email-matt@console-pimps.org> <20110413194231.GA15330@redhat.com> <20110414113456.5182a582@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414113456.5182a582@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Matt Fleming wrote:
>
> Well, it's not really that signals are slow (though that might be
> true!), it's more that they don't scale. So, this patch series was not
> designed to speed up signals in a single-threaded app, but rather to
> make signals scale better in multithreaded apps. We do that by
> reducing the contention on the shared siglock. Signal delivery isn't
> getting any faster with these patches, they just try to stop it getting
> slower when you add more threads ;-)

Yes, I understand. Even the private signal needs the "global" per-process
lock bit it is rwlock.

> > > @@ -142,7 +142,9 @@ static void __exit_signal(struct task_struct *tsk)
> > >  	 * Do this under ->siglock, we can race with another thread
> > >  	 * doing sigqueue_free() if we have SIGQUEUE_PREALLOC signals.
> > >  	 */
> > > +	spin_lock(&tsk->siglock);
> > >  	flush_sigqueue(&tsk->pending);
> > > +	spin_unlock(&tsk->siglock);
> >
> > This only protects flush_sigqueue(), but this is not enough.
> >
> > tkill() can run without ->siglock held, how can it ensure the target
> > can't exit before we take task->siglock?
>
> And by "target can't exit" you mean, how can we ensure that the target
> doesn't execute __exit_signal() and set tsk->signal to NULL

No, tsk->signal can't go away, ->sighand can. This means that
prepare_signal()->sig_ignored() is not safe.

Another problem is, __send_signal() shouldn't add the new sigqueue to
tsk->pending if this tsk has already passed __exit_signal()->flush_sigqueue().

> While we're discussing the technique for stopping tasks from exiting...
>
> Is there a reason that a short-term reference counter isn't used to
> prevent this, instead of taking the siglock?

Well, sighand->count is the reference counter. The problem is, ->sighand
is not per-process, we can share it with abother CLONE_SIGHAND process
and de_thread() can change ->sighand during exec.

Also. We have the code which checks ->sighand != NULL to check if this
thread was released or not.

I was going to try to add some cleanups here after the scope of ->signal
was changed, but right now I can't recall what I had in mind. Anyway,
everything in sighand_struct needs ->siglock anyway, a lockless access
doesn't buy too much currently.

> > > @@ -1666,7 +1779,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
> > >   	}
> > >
> > >  	sighand = parent->sighand;
> > > -	spin_lock_irqsave(&sighand->siglock, flags);
> > > +	read_lock_irqsave(&sighand->action_lock, flags);
> > > +	spin_lock(&sighand->siglock);
> >
> > Why do we need both? (the same for do_notify_parent)
>
> We need action_lock because we're reading sighand->action and making
> decisions based upon its value, so we need it to not change. Also,
> __send_signal()

Ah, indeed, thanks. Somehow I misread the code as if it takes task->siglock,
not sighand->siglock. But anyway I was wrong, I forgot we are going to send
the signal.

Oleg.


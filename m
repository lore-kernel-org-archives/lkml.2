Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab1DNKfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:35:04 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38303 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758701Ab1DNKfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:35:01 -0400
Date: Thu, 14 Apr 2011 11:34:56 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 2/5] signals: Introduce per-thread siglock and
 action rwlock
Message-ID: <20110414113456.5182a582@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110413194231.GA15330@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
	<1302031310-1765-3-git-send-email-matt@console-pimps.org>
	<20110413194231.GA15330@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 21:42:31 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Matt, sorry for huge delay.

No problem. Thanks for the review!
 
> So. This complicates the locking enormously. I must admit, I dislike
> this very much. Yes, the signals are slow... But this returns us to the
> original question: do we really care? Of course, it is always nice to
> makes the things faster, but I am not sure the added complexity worth
> the trouble.

Well, it's not really that signals are slow (though that might be
true!), it's more that they don't scale. So, this patch series was not
designed to speed up signals in a single-threaded app, but rather to
make signals scale better in multithreaded apps. We do that by
reducing the contention on the shared siglock. Signal delivery isn't
getting any faster with these patches, they just try to stop it getting
slower when you add more threads ;-)

As for the complexity... OK, point taken. Since we've already
established that the patch series doesn't work as-is because the first
patch is bogus, I'll treat the rest of the review as an academic
exercise in helping to highlight any of my misunderstandings about the
signal code. If/when I respin this series I'll certainly try to keep it
simpler.

> Random example,
> 
> 	int
> 	force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
> 	{
> 		unsigned long int flags;
> 		int ret, blocked, ignored;
> 		struct k_sigaction *action;
> 		int shared_siglock;
> 
> 		write_lock_irqsave(&t->sighand->action_lock, flags);
> 		spin_lock(&t->sighand->siglock);
> 		action = &t->sighand->action[sig-1];
> 		ignored = action->sa.sa_handler == SIG_IGN;
> 		blocked = sigismember(&t->blocked, sig);
> 		if (blocked || ignored) {
> 			action->sa.sa_handler = SIG_DFL;
> 			if (blocked) {
> 				sigdelset(&t->blocked, sig);
> 				recalc_sigpending_and_wake(t);
> 			}
> 		}
> 		if (action->sa.sa_handler == SIG_DFL)
> 			t->signal->flags &= ~SIGNAL_UNKILLABLE;
> 
> 		shared_siglock = sig_shared(sig) || sig_fatal(t, sig);
> 		if (!shared_siglock) {
> 			spin_unlock(&t->sighand->siglock);
> 			spin_lock(&t->siglock);
> 		}
> 
> 		ret = specific_send_sig_info(sig, info, t);
> 
> 		if (!shared_siglock)
> 			spin_unlock(&t->siglock);
> 		else
> 			spin_unlock(&t->sighand->siglock);
> 
> 		write_unlock_irqrestore(&t->sighand->action_lock, flags);
> 		return ret;
> 	}
> 
> This doesn't look very nice ;)

Yeah, not my finest work ;-)

But seriously, you're not wrong. This code was written this way as a
result of the locking design, which suggests I need to go back to the
drawing board and come up with something simpler.

> To me personally, the only "real" performance problem is kill-from-irq
> (posix timers is the worst case), this should be solved somehow but
> these changes can't help...

True.

> > @@ -142,7 +142,9 @@ static void __exit_signal(struct task_struct *tsk)
> >  	 * Do this under ->siglock, we can race with another thread
> >  	 * doing sigqueue_free() if we have SIGQUEUE_PREALLOC signals.
> >  	 */
> > +	spin_lock(&tsk->siglock);
> >  	flush_sigqueue(&tsk->pending);
> > +	spin_unlock(&tsk->siglock);
> 
> This only protects flush_sigqueue(), but this is not enough.
> 
> tkill() can run without ->siglock held, how can it ensure the target
> can't exit before we take task->siglock?

And by "target can't exit" you mean, how can we ensure that the target
doesn't execute __exit_signal() and set tsk->signal to NULL if we're
not holding the shared siglock in the tkill() path? Good point, that's
totally a bug.

While we're discussing the technique for stopping tasks from exiting...

Is there a reason that a short-term reference counter isn't used to
prevent this, instead of taking the siglock? Obviously, the siglock
already exists and we would have to add a new atomic_t to sighand for
the short-term ref, but is there any other fundamental reason why the
siglock acquiring method is better? Maybe a short-term ref would make
things more complicated? I dunno. siglock does seem to be used for a
few different things at the moment though, so currently things are
already quite complicated.

Of course, the reason I'm asking is that this entire series relies on
avoiding acquiring the shared siglock wherever possible. As you've
pointed out above, by not acquiring the shared siglock in the tkill()
path we can race with the task exiting, and somehow I need to fix that.
Though note that I don't think it's just the tkill() path that is the
problem here, it's signal generation in general, i.e. anybody who
calls send_signal() without the shared siglock held.

> > @@ -976,7 +1022,12 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
> >  	 * (and therefore avoid the locking that would be necessary to
> >  	 * do that safely).
> >  	 */
> > -	if (group || sig_kernel_stop(sig) || sig == SIGCONT)
> > +	if (group || sig_shared(sig) || sig_fatal(t, sig))
> > +		assert_spin_locked(&t->sighand->siglock);
> > +	else
> > +		assert_spin_locked(&t->siglock);
> > +
> > +	if (group || sig_shared(sig))
> >  		pending = &t->signal->shared_pending;
> >  	else
> >  		pending = &t->pending;
> 
> Well. But later then we call complete_signal()->signal_wake_up(). And this
> needs ->siglock. Now I recall why it is needed. Obviously, to serialize with
> recalc_sigpending().

Ah, it's the set_tsk_thread_flag(t, TIF_SIGPENDING) that we need to do
atomically. Right, damn, that's a race.

> Note also that if you use task->siglock for sigaddset(t->pending), then
> recalc_sigpending() should take this lock as well.

Right.

> > @@ -1123,11 +1175,34 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
> >  	unsigned long flags;
> >  	int ret = -ESRCH;
> >
> > -	if (lock_task_sighand(p, &flags)) {
> > +	read_lock_irqsave(&p->sighand->action_lock, flags);
> 
> How so? This is unsafe, p can exit, ->sighand can be NULL. Or exec can
> change ->sighand, we can take the wrong lock.
> 
> And there are more wrong changes like this...

Yeah, this is a fundamental problem with this series.
 
> > @@ -1485,14 +1580,24 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
> >  {
> >  	int sig = q->info.si_signo;
> >  	struct sigpending *pending;
> > -	unsigned long flags;
> > +	unsigned long flags, _flags;
> > +	int shared_siglock;
> >  	int ret;
> >
> >  	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
> >
> >  	ret = -1;
> > -	if (!likely(lock_task_sighand(t, &flags)))
> > -		goto ret;
> > +	read_lock_irqsave(&t->sighand->action_lock, flags);
> > +	shared_siglock = group || sig_shared(sig) || sig_fatal(t, sig);
> > +	if (!shared_siglock) {
> > +		spin_lock(&t->siglock);
> > +		pending = &t->pending;
> > +	} else {
> > +		if (!likely(lock_task_sighand(t, &_flags)))
> > +			goto ret;
> > +
> > +		pending = &t->signal->shared_pending;
> 
> This looks wrong wrong. We shouldn't do s/pending/shared_pending/ if
> sig_fatal(). The signal can be blocked the this task can be ptraced.

D'oh, yes, my bad. I've compounded the case of picking the pending
queue with picking the siglock, that's wrong. OK, maybe this new
locking is complicated ;-)
 
> > @@ -1666,7 +1779,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
> >   	}
> >
> >  	sighand = parent->sighand;
> > -	spin_lock_irqsave(&sighand->siglock, flags);
> > +	read_lock_irqsave(&sighand->action_lock, flags);
> > +	spin_lock(&sighand->siglock);
> 
> Why do we need both? (the same for do_notify_parent)

We need action_lock because we're reading sighand->action and making
decisions based upon its value, so we need it to not change. Also,
__send_signal() needs us to have the action_lock at least for reading
because we call sig_fatal() in complete_signal(), which checks tsk's
action handlers, so again, we need to prevent the handlers from being
modified.

We need sighand->siglock because we're sending a group signal, and
therefore modifying signal->shared_pending.

The answer also applies to do_notify_parent().

Thanks for the review!

-- 
Matt Fleming, Intel Open Source Technology Center

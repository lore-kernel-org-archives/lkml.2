Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab1DMTnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:43:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab1DMTnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:43:22 -0400
Date: Wed, 13 Apr 2011 21:42:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 2/5] signals: Introduce per-thread siglock and
	action rwlock
Message-ID: <20110413194231.GA15330@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-3-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302031310-1765-3-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt, sorry for huge delay.

On 04/05, Matt Fleming wrote:
>
> Try to reduce the amount of time we hold the shared siglock by
> introducing a per-thread siglock that protects each thread's 'pending'
> queue. Currently, the shared siglock protects both the shared and
> private signal queues. As such, it is a huge point of contention when
> generating and delivering signals to single threads in a multithreaded
> process. For example, even if a thread is delivering a signal to
> itself (thereby putting a signal on its private signal queue) it must
> acquire the shared siglock.
>
> To improve signal generation scalability we only acquire the shared
> siglock when generating a shared signal. If we're generating a private
> signal which will be delivered to a specific thread (and that signal
> does not affect an entire thread group) then we can optimise that case
> by only taking the per-thread siglock. However, the case where we're
> sending a fatal signal to a specific thread is special because we need
> to modify tsk->signal->flags, so we need to be holding the shared
> siglock.
>
> Note that we now hold both the shared and per-thread siglock when
> delivering a private signal. That will be fixed in the next patch so
> that signal delivery scales with signal generation.
>
> Also, because we now run signal code paths without holding the shared
> siglock at all, it can no longer be used to protect tsk->sighand->action.
> So we introduce a rwlock for protecting tsk->sighand->action. A rwlock
> is better than a spinlock in this case because there are many more
> readers than writers and a rwlock allows us to scale much better than
> a spinlock.

So. This complicates the locking enormously. I must admit, I dislike
this very much. Yes, the signals are slow... But this returns us to the
original question: do we really care? Of course, it is always nice to
makes the things faster, but I am not sure the added complexity worth
the trouble.

Random example,

	int
	force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
	{
		unsigned long int flags;
		int ret, blocked, ignored;
		struct k_sigaction *action;
		int shared_siglock;

		write_lock_irqsave(&t->sighand->action_lock, flags);
		spin_lock(&t->sighand->siglock);
		action = &t->sighand->action[sig-1];
		ignored = action->sa.sa_handler == SIG_IGN;
		blocked = sigismember(&t->blocked, sig);
		if (blocked || ignored) {
			action->sa.sa_handler = SIG_DFL;
			if (blocked) {
				sigdelset(&t->blocked, sig);
				recalc_sigpending_and_wake(t);
			}
		}
		if (action->sa.sa_handler == SIG_DFL)
			t->signal->flags &= ~SIGNAL_UNKILLABLE;

		shared_siglock = sig_shared(sig) || sig_fatal(t, sig);
		if (!shared_siglock) {
			spin_unlock(&t->sighand->siglock);
			spin_lock(&t->siglock);
		}

		ret = specific_send_sig_info(sig, info, t);

		if (!shared_siglock)
			spin_unlock(&t->siglock);
		else
			spin_unlock(&t->sighand->siglock);

		write_unlock_irqrestore(&t->sighand->action_lock, flags);
		return ret;
	}

This doesn't look very nice ;)

To me personally, the only "real" performance problem is kill-from-irq
(posix timers is the worst case), this should be solved somehow but
these changes can't help...

Anyway, the patches do not look right.

> +/* Should the signal be placed on shared_pending? */
> +#define sig_shared(sig)	\
> +	(((sig) < SIGRTMIN) && \
> +	 siginmask(sig, SIG_KERNEL_STOP_MASK | rt_sigmask(SIGCONT)))

OK, this is wrong but we already discussed this.

> @@ -142,7 +142,9 @@ static void __exit_signal(struct task_struct *tsk)
>  	 * Do this under ->siglock, we can race with another thread
>  	 * doing sigqueue_free() if we have SIGQUEUE_PREALLOC signals.
>  	 */
> +	spin_lock(&tsk->siglock);
>  	flush_sigqueue(&tsk->pending);
> +	spin_unlock(&tsk->siglock);

This only protects flush_sigqueue(), but this is not enough.

tkill() can run without ->siglock held, how can it ensure the target
can't exit before we take task->siglock?


> @@ -976,7 +1022,12 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  	 * (and therefore avoid the locking that would be necessary to
>  	 * do that safely).
>  	 */
> -	if (group || sig_kernel_stop(sig) || sig == SIGCONT)
> +	if (group || sig_shared(sig) || sig_fatal(t, sig))
> +		assert_spin_locked(&t->sighand->siglock);
> +	else
> +		assert_spin_locked(&t->siglock);
> +
> +	if (group || sig_shared(sig))
>  		pending = &t->signal->shared_pending;
>  	else
>  		pending = &t->pending;

Well. But later then we call complete_signal()->signal_wake_up(). And this
needs ->siglock. Now I recall why it is needed. Obviously, to serialize with
recalc_sigpending().

Note also that if you use task->siglock for sigaddset(t->pending), then
recalc_sigpending() should take this lock as well.

> @@ -1123,11 +1175,34 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
>  	unsigned long flags;
>  	int ret = -ESRCH;
>
> -	if (lock_task_sighand(p, &flags)) {
> +	read_lock_irqsave(&p->sighand->action_lock, flags);

How so? This is unsafe, p can exit, ->sighand can be NULL. Or exec can
change ->sighand, we can take the wrong lock.

And there are more wrong changes like this...

> @@ -1485,14 +1580,24 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
>  {
>  	int sig = q->info.si_signo;
>  	struct sigpending *pending;
> -	unsigned long flags;
> +	unsigned long flags, _flags;
> +	int shared_siglock;
>  	int ret;
>
>  	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
>
>  	ret = -1;
> -	if (!likely(lock_task_sighand(t, &flags)))
> -		goto ret;
> +	read_lock_irqsave(&t->sighand->action_lock, flags);
> +	shared_siglock = group || sig_shared(sig) || sig_fatal(t, sig);
> +	if (!shared_siglock) {
> +		spin_lock(&t->siglock);
> +		pending = &t->pending;
> +	} else {
> +		if (!likely(lock_task_sighand(t, &_flags)))
> +			goto ret;
> +
> +		pending = &t->signal->shared_pending;

This looks wrong wrong. We shouldn't do s/pending/shared_pending/ if
sig_fatal(). The signal can be blocked the this task can be ptraced.

> @@ -1666,7 +1779,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
>   	}
>
>  	sighand = parent->sighand;
> -	spin_lock_irqsave(&sighand->siglock, flags);
> +	read_lock_irqsave(&sighand->action_lock, flags);
> +	spin_lock(&sighand->siglock);

Why do we need both? (the same for do_notify_parent)

Oleg.


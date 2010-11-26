Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0KZOx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:53:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab0KZOx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:53:27 -0500
Date: Fri, 26 Nov 2010 15:46:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Subject: Re: [PATCH 04/14] signal: don't notify parent if not stopping
	after tracehook_notify_jctl() in do_signal_stop()
Message-ID: <20101126144654.GB28177@redhat.com>
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290768569-16224-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Tejun Heo wrote:
>
> do_signal_stop() tests sig->group_stop_count one more time after
> calling tracehook_notify_jctl() as it's allowed release siglock.  If
> group_stop_count has changed to zero, it no longer stops but still
> notifies the parent.

Only if tracehook_notify_jctl() returns nonzero. That was the
point, tracehook_ can ask to notify even if we are not going to
stop.

> Also, tracehook_notify_jctl() doesn't release siglock, so, currently,
> none of these matters at all.

Yes. But with this patch it is not possible to drop siglock in
tracehook_notify_jctl().

> This doesn't cause any behavior difference as the condition never
> triggers in the current code.

I don't understand the motivation then (probably I should read
the next patches).

If we kill the ability to drop ->siglock in tracehook_notify_jctl(),
we can simplify the code further. No need to start with
->group_stop_count = 1 and then decrement it again.

We could do something like

	static int do_signal_stop(int signr)
	{
		struct signal_struct *sig = current->signal;
		int notify;

		if (sig->group_stop_count) {
			--sig->group_stop_count;
		} else {
			struct task_struct *t;

			if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
			    unlikely(signal_group_exit(sig)))
				return 0;
			/*
			 * There is no group stop already in progress.
			 * We must initiate one now.
			 */
			sig->group_exit_code = signr;

			for (t = next_thread(current); t != current; t = next_thread(t))
				/*
				 * Setting state to TASK_STOPPED for a group
				 * stop is always done with the siglock held,
				 * so this check has no races.
				 */
				if (!(t->flags & PF_EXITING) &&
				    !task_is_stopped_or_traced(t)) {
					sig->group_stop_count++;
					signal_wake_up(t, 0);
				}
		}

		if (!sig->group_stop_count) {
			sig->flags = SIGNAL_STOP_STOPPED;
			current->exit_code = sig->group_exit_code;
			__set_current_state(TASK_STOPPED);
			notify = CLD_STOPPED;
		}
		spin_unlock_irq(&current->sighand->siglock);

		if (notify || current->ptrace) {
			read_lock(&tasklist_lock);
			do_notify_parent_cldstop(current, notify);
			read_unlock(&tasklist_lock);
		}

		/* Now we don't run again until woken by SIGCONT or SIGKILL */
		schedule();

		tracehook_finish_jctl();
		current->exit_code = 0;

		return 1;
	}

In short, this patch dismisses tracehook_notify_jctl().

Roland?

Oleg.


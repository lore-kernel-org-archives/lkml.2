Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2FXSOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 14:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab2FXSOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 14:14:07 -0400
Date: Sun, 24 Jun 2012 20:11:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: deferring __fput()
Message-ID: <20120624181153.GA26182@redhat.com>
References: <1340369098.2464.20.camel@falcor> <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623205755.GJ14083@ZenIV.linux.org.uk> <20120624152050.GA24596@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624152050.GA24596@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Oleg Nesterov wrote:
>
> On 06/23, Al Viro wrote:
> >
> > What we ought to
> > do instead of that is honestly keeping both the head of the (single-linked) list and
> > pointer to pointer to its last element.  Sure, that'll eat one more word in task_struct.
> > And it doesn't matter, since we'll be able to kill something else in there - namely,
> > ->scm_work_list.
>
> Still it is better to not add the second pointer, task->task_works can
> point to the last work, and last_work->next points to the first one.

So. task_struct has the single "struct task_work *last_twork" pointer,
task_work has ->next. I'll try to cleanup task_work_cancel() a bit, but
this all doesn't look too complicated, see below. (untested, probably
buggy, but hopefully close to correct).

Or do you still think we need the 2nd pointer in task_struct?

Oleg.

int
task_work_add(struct task_struct *task, struct task_work *twork, bool notify)
{
	unsigned long flags;
	struct task_work *last;
	int err = -ESRCH;

#ifndef TIF_NOTIFY_RESUME
	if (notify)
		return -ENOTSUPP;
#endif
	/*
	 * We must not insert the new work if the task has already passed
	 * exit_task_work(). We rely on do_exit()->raw_spin_unlock_wait()
	 * and check PF_EXITING under pi_lock.
	 */
	raw_spin_lock_irqsave(&task->pi_lock, flags);
	if (likely(!(task->flags & PF_EXITING))) {
		last = task->last_twork ?: twork;
		task->last_twork = twork;
		twork->next = last->next;
		last->next = twork;
		err = 0;
	}
	raw_spin_unlock_irqrestore(&task->pi_lock, flags);

	/* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
	if (likely(!err) && notify)
		set_notify_resume(task);
	return err;
}

struct task_work *
task_work_cancel(struct task_struct *task, task_work_func_t func)
{
	unsigned long flags;
	struct task_work *last;
	struct task_work *twork;
	struct task_work *prev;

	raw_spin_lock_irqsave(&task->pi_lock, flags);
	last = twork = task->last_twork;
	if (!last)
		goto unlock;

	do {
		prev = twork;
		twork = twork->next;
		if (twork->func != func)
			continue;

		prev->next = twork->next;
		if (twork == last) {
			if (prev == twork)
				prev = NULL;
			task->last_twork = prev;
		}
		goto unlock;

	} while (twork != last);
	twork = NULL;

 unlock:
	raw_spin_unlock_irqrestore(&task->pi_lock, flags);

	return twork;
}

void task_work_run(void)
{
	struct task_struct *task = current;
	struct task_work *last;
	struct task_work *twork;
	struct task_work *next;

	raw_spin_lock_irq(&task->pi_lock);
	last = task->last_twork;
	task->last_twork = NULL;
	raw_spin_unlock_irq(&task->pi_lock);

	if (unlikely(!last))
		return;

	next = last->next;
	do {
		twork = next;
		next = twork->next;
		twork->func(twork);
	} while (twork != last);
}


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1G1ODJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1G1ODH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:03:07 -0400
Date: Thu, 28 Jul 2011 15:59:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] make vfork killable/restartable/traceable
Message-ID: <20110728135958.GA9069@redhat.com>
References: <20110727163159.GA23785@redhat.com> <CA+55aFy83CAZ+AVZNtYZc=NnOzaxsQxksuspqBHGVwLx4hvMCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy83CAZ+AVZNtYZc=NnOzaxsQxksuspqBHGVwLx4hvMCg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27, Linus Torvalds wrote:
>
> On Wed, Jul 27, 2011 at 9:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > CLONE_VFORK sleeps in TASK_INTERRUPTIBLE until the child exits/execs.
> > This is obviously not good, it is sooo simple to create the task which
> > doesn't react to SIGKILL/SIGSTOP.
>
> Well, I don't know how bad that is.

Well, me to. That is why 0/9 starts with "do we really need this?".
I expected you won't be happy ;)

However.

> You just kill the child instead.

Sure. Assuming you know what happens and who should be killed.
Yes, it is not that hard to figure out. Still. vfork() is the
only example which allows to create the unkillable/unstoppable
task in a trivial way.

> And quite frankly, I think your patches 1-3 are unbelievably ugly. If
> it was some simple and straightforward "use
> wait_for_completion_killable() instead", I wouldn't mind it. But I
> think you made a simple and clean sequence convoluted and annoying.

Yes. This doesn't make the code simpler. I agree. The question is,
are they are more ugly then necessary. May be... I'll try to think
a bit more.

And just in case. Personally I think that "unstoppable" is worse
than "unkillable". Suppose that you run the "good" application
which doesn't abuse vfork/signals but does something like

	if (!vfork()) {
		do_simething();		
		execve(...);
	}

In this case ^C always works, even if do_something() blocks for
some reason.

But it is quite possible that ^Z "hangs" just because it races
with vfork().

> I *suspect* that the killable() thing could be done more nicely by
> moving the vfork_completion into the parent instead, and maybe the
> vfork cleanup could just use
> "complete(&task->parent->vfork_completion);" instead

I thought about moving the "vfork_done" thing (in some form) from
child to parent. So far I do not see a clean solution.

For example. If we simply use ->real_parent->vfork_completion, then
yes, we do not need to communicate with the child, the child can rely
on rcu to ensure "struct completion" can't go away. But, this bloats
task_struct a bit, and:

> (so if the parent
> goes away, it completes some irrelevant init case instead).

This assumes /sbin/init can't sleep in CLONE_VFORK. So we need some
complications again.

Not to mention, kthread/kthread_stop should be reworked somehow.

> especially since it's not a real problem

Well. Personally I don't agree.

I'll try to simplify the patches. I am not sure I can do something
really simple.

For example, 3/8 can do

	// called by mm_release()

	void complete_vfork_done(struct task_struct *tsk)
	{
		struct completion *vfork_done;

		task_lock(tsk);
		vfork_done = tsk->vfork_done;
		if (vfork_done) {
			tsk->vfork_done = NULL; // UNNEEDED
			complete(vfork_done);
		}
		task_unlock(tsk);
	}

	// used by do fork instead of wait_for_completion()

	static long wait_for_vfork_done(struct task_struct *child,
					struct completion *vfork_done)
	{
		int killed = wait_for_completion_killable(vfork_done);

		if (killed) {
			task_lock(tsk);
			child->vfork_done = NULL;
			task_unlock(tsk);

			return -EINTR;
		}

		return 0;
	}

Does this look "not too ugly" to you or not?

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0LVP2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:28:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab0LVP2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:28:20 -0500
Date: Wed, 22 Dec 2010 16:20:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCHSET] ptrace,signal: sane interaction between ptrace and
	job control signals, take#2
Message-ID: <20101222152029.GA9893@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Tejun Heo wrote:
>
> > Or. We can change the rules for ptrace_resume(), more on this later.
>
> You haven't written this yet, right?  (I reconfigured / migrated my
> mail setup during past few days so things are still a bit shaky.)

I am moving this to 0/16 to get more attention from everyone.

First of all, I'd like to clarify that I am not arguing with these
changes. Quite contrary, I think this is the good step in the right
direction imho. In this email, I do not try to comment this series,
I am going to ask the questions.

My concern is: we never tried to discuss the desired behaviour as
it seen by the user-space.



To simplify the discussion, let's assume that debugger != real_parent.
Now, what should we actually do if the tracee starts/completes the
group stop?

To me, the only obvious thing is that each thread should report
CLD_STOPPED to the debugger. Everything else is not clear to me. How
and when we should notify real_parent? What should we do if tracee
is multithreaded and some threads are not traced? (in the latter
case we can't know which thread completes the group stop and sends
the final notification).

Probably we can delay this notification until the debugger detaches
all threads. This makes sense because the debugger can resume the
stopped thread and confuse its real_parent (say, /bin/sh) who has
all rights to assume the child can't run without the subsequent
CLD_CONTINUED. However, this doesn't look very good. This doesn't
allow to write the "really transparent" strace, if the tracee was
stopped by SIGSTOP this should be visible to its real_parent who
probably owns this application and should react (again, sh/fg/bg).

So. I think that probably we need some very simple and predictable
behaviour, even if this implies the user-visible changes. If nothing
else, any fix in this area is visible to user-space. To me, the
best behaviour is

	- each thread notifies the debugger (if it is traced)

	- when the last thread stops, it also notifies its
	  real_parent. IOW, it can send two notifications if
	  it is traced.

	  (This differs from the logic in 12/16)

But, again, this means we are trying to fool the poor real_parent
who does do_wait() and doesn't expect the child can suddenly run
because of PTRACE_CONT/etc which does the unconditional wakeup.

A bit off-topic, but can't resist. I like very much what utrace
does in this case. Since it doesn't use these notifications (in
fact it doesn't use signals/reparenting at all) we do not have
any problems with parent/real_parent mess. And, utrace does _not_
resume the stopped tracee. If the debugger wants to resume a
thread in the SIGNAL_STOP_STOPPED group, it should send SIGCONT
and this is visible to the real_parent. But of course, we can't
change ptrace this way.

However. Any chance we can change ptrace_resume() so that it won't
break SIGNAL_STOP_STOPPED contract? Roughly, instead of unconditional
wake_up_process(child) ptrace_resume() should do

	if (child->signal->flags & SIGNAL_STOP_STOPPED)
		prepare_signal(SIGCONT);
	wake_up_state(child, __TASK_TRACED);

(of course, we should not literally use prepare_signal(), only to
 explain what I mean).

IOW, if we are going to resume the tracee and its thread group
is stopped, we notify the real_parent and wakeup all TASK_STOPPED
(or non-ptraced) sub-threads.

Sure, this is the serious change. But otherwise, imho whatever we
do the end result is not sane.

Thoughts?


As for CLD_CONTINUED, basically the same questions (in particular,
I think that real_parent should be notified unconditionally). Except,
perhaps the debugger doesn't need it at all?

Oleg.


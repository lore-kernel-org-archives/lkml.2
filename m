Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1BXNha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 08:37:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1BXNh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 08:37:27 -0500
Date: Thu, 24 Feb 2011 14:29:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110224132906.GA15733@redhat.com>
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D656F87.3090005@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23, Stas Sergeev wrote:
>
> 23.02.2011 22:14, Oleg Nesterov wrote:
>
>> Well. You should somehow convince people we need this ;)
> I don't have to: I need this patch, and that's the main motivation
> for me. :)

OK,

> Though of course I'll offer it for inclusion when its ready,
> but I am developing it mostly for my project.
> google reveals that many people were confused by the fact that
> daemon() silently drops all the threads, and the man page says
> nothing about that nasty habit.

I think it does... from man daemon

	This function forks,  and  if  the  fork(2)  succeeds,
	the  parent  calls _exit(2),

and of course fork() doesn't clone the sub-threads.

> And I really think there is no other
> way to daemonize the process with threads, than to use something
> like this patch, or is there?

Depends on what "daemonize" means. Even with this patch, setsid()
after PR_DETACH can fail because we do not change the pids and
the caller can still be pgrp leader.

And. What if the parent of PR_DETACH caller blocks or ignores
SIGCHLD or simply doesn't call do_wait()? The caller can run with
PR_DETACH set without any effect "forever".

There are other problems. For example, if the caller is ptraced
it can silently disappear from parent's radar. If you fix this, then
the actual reparenting can be delayed unpredictably whatever the
real parent does.

So, to be honest, I do not think this idea will be accepted, and I don't
really understand your motivation. But once again, I never argue with the
"we need this feature" requests, no need to convince me.

>> Only current can change its ->flags, this is racy
> Oh my, add a new lock only for that? :((
> Add another thread_struct member only for that?
> Abuse ->exit_state only for that?
> Nothing looks good...

Yep. But this is minor, if nothing else you can use signal->flags.
In fact, I do not understand why only the group leader can do
prctl(PR_DETACH) and why this flag is per-thread.

>> The usage of ->exit_code doesn't look right, espeicaily if it is traced.
> Could you please elaborate on that? I am using the
> ->exit_code to pass the (fake) exit code to the parent.
> The argument of my PR_DETACH is an exit code to pass.
> What is a problem with that?

The problem is that ptrace uses this ->exit_code member as well.
Suppose that the (ptraced) task calls PR_DETACH and, say, recieves
a signal after that. See ptrace_signal().

>>> @@ -1450,10 +1450,10 @@ int do_notify_parent(struct task_struct *tsk, int sig)
>>>
>>>   	BUG_ON(sig == -1);
>>>
>>> - 	/* do_notify_parent_cldstop should have been called instead.  */
>>> - 	BUG_ON(task_is_stopped_or_traced(tsk));
>>> +	/* do_notify_parent_cldstop should have been called instead.  */
>>> +	BUG_ON(task_is_stopped_or_traced(tsk));
>>>
>>> -	BUG_ON(!task_ptrace(tsk)&&
>>> +	BUG_ON(!task_ptrace(tsk)&&  (tsk->flags&  PF_EXITING)&&
>>>   	(tsk->group_leader != tsk || !thread_group_empty(tsk)));
>> Afaics, you are trying to hide the problem.... The code below can make
>> tsk detached if real_parent ignores SIGCHLD.
> Will fix the problem with parent ignoring SIGCHLD, thanks.
> Though could you please clarify whether or not you see the
> above hunk wrong? It is there just because the group is not
> empty when the leader does PR_DETACH, so I adjusted the
> sanity check.

I understand why you added PF_EXITING. And, once again, this is not
right afaics. The current condition is more or less "random" and mostly
historical, although correct. If we want to take PF_EXITING into account,
we should just add BUG_ON(!(tsk->flags & PF_EXITING)). IOW, it is just
wrong to call this function unless this tsk exits.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab1BWUkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:40:05 -0500
Received: from mail.aknet.ru ([78.158.192.28]:47184 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab1BWUkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:40:03 -0500
Message-ID: <4D656F87.3090005@aknet.ru>
Date: Wed, 23 Feb 2011 23:35:19 +0300
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com>
In-Reply-To: <20110223191442.GA717@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

23.02.2011 22:14, Oleg Nesterov wrote:
> The attched patch adds the PR_DETACH prctl command.
> Hi. The patch doesn't look right at first glance,
I know, thanks for the review. That's basically an RFC material.

> Well. You should somehow convince people we need this ;)
I don't have to: I need this patch, and that's the main motivation
for me. :) Though of course I'll offer it for inclusion when its ready,
but I am developing it mostly for my project.
google reveals that many people were confused by the fact that
daemon() silently drops all the threads, and the man page says
nothing about that nasty habit. And I really think there is no other
way to daemonize the process with threads, than to use something
like this patch, or is there?

> Only current can change its ->flags, this is racy
Oh my, add a new lock only for that? :((
Add another thread_struct member only for that?
Abuse ->exit_state only for that?
Nothing looks good...

>> +	if (!ptrace_reparented(p))
>> +		p->parent = init_pid_ns.child_reaper;
>> +	p->real_parent = init_pid_ns.child_reaper;
>> +	p->exit_signal = SIGCHLD;
>> +	list_move_tail(&p->sibling,&p->real_parent->children);
> No, we can't do this under read_lock(tasklist). And you forgot about
> threads, they also have ->real_parent == old_parent.
Thanks, will fix.

> The usage of ->exit_code doesn't look right, espeicaily if it is traced.
Could you please elaborate on that? I am using the
->exit_code to pass the (fake) exit code to the parent.
The argument of my PR_DETACH is an exit code to pass.
What is a problem with that?

> What if it is already dead? We are goint to reparent it, but init
> won't notice the new zombie.
>
> And what if do_wait() was called without WEXITED? say, the old parent
> does waitpid(WSTOPPED).
Will fix.

>> @@ -1450,10 +1450,10 @@ int do_notify_parent(struct task_struct *tsk, int sig)
>>
>>   	BUG_ON(sig == -1);
>>
>> - 	/* do_notify_parent_cldstop should have been called instead.  */
>> - 	BUG_ON(task_is_stopped_or_traced(tsk));
>> +	/* do_notify_parent_cldstop should have been called instead.  */
>> +	BUG_ON(task_is_stopped_or_traced(tsk));
>>
>> -	BUG_ON(!task_ptrace(tsk)&&
>> +	BUG_ON(!task_ptrace(tsk)&&  (tsk->flags&  PF_EXITING)&&
>>   	(tsk->group_leader != tsk || !thread_group_empty(tsk)));
> Afaics, you are trying to hide the problem.... The code below can make
> tsk detached if real_parent ignores SIGCHLD.
Will fix the problem with parent ignoring SIGCHLD, thanks.
Though could you please clarify whether or not you see the
above hunk wrong? It is there just because the group is not
empty when the leader does PR_DETACH, so I adjusted the
sanity check.

>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -1736,6 +1736,22 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>   			else
>>   				error = PR_MCE_KILL_DEFAULT;
>>   			break;
>> +		case PR_DETACH:
>> +			error = -EPERM;
>> +			/* if parent is init, or not a group leader - bail */
>> +			if (me->real_parent == init_pid_ns.child_reaper)
> This is not exactly right. What if the child of init's sub-thread
> does PR_DETACH?
Will fix.

Thanks for your review! I'll update the patch.

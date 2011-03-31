Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab1CaRrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:47:12 -0400
Received: from mail.aknet.ru ([78.158.192.28]:53221 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757702Ab1CaRrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:47:10 -0400
Message-ID: <4D94BE19.7050001@aknet.ru>
Date: Thu, 31 Mar 2011 21:47:05 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com>
In-Reply-To: <20110331170244.GA13271@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

31.03.2011 21:02, Oleg Nesterov wrote:
> I only looked at sys_prctl() code, and almost every line looks wrong.
Well, the lines you pointed, were also in the
previous patch, and, as you didn't complained
back then, I thought they were fine. :)

>> +			if (notif != DEATH_REAP) {
>> +				list_add_tail(&me->detached_sibling,
>> +					&me->real_parent->detached_children);
>> +				me->exit_state = EXIT_DETACHED;
> No, no, we can't set ->exit_state != 0. This means the task is dead.
Does this really break things? I mean, there are
probably no checks like "if (task->exit_state)", every
time the exact value is checked. And EXIT_DETACHED
is only set for the short period: the wait() from parent
(either new or old) will remove it.

>> +			/* detaching makes us a group leader */
>> +			me->group_leader = me;
> How? Now, we can't change ->group_leader, this is simply not possible
> and very wrong. If nothing else, think about tid/tgid, but there are
> a lot more problems.
OK, thats why in the previous patch I was allowing only
the group leader to detach, but you complained. Should
I return that back?

>> +			while_each_thread(me, p) {
>> +				if (p->real_parent != old_parent)
>> +					continue;
>> +				if (!ptrace_reparented(p))
>> +					p->parent = init_pid_ns.child_reaper;
>> +				p->real_parent = init_pid_ns.child_reaper;
> The same problems as above, pluse "p->real_parent != old_parent" looks
> bogus.
Just an extra care. Should I just remove that check?

> Well. Once again, I never argue with new features, but you need to
> convince lkml. Probably it is simple to implement PR_DETACH so that
> the task just "disappears" from the old_parent's radar.
Yes, that worked for me too:
https://lkml.org/lkml/2010/12/25/37
Yes, I know there are bugs too. :) But, at least the patch
is just few lines.

> Otherwise
> we need more complications, but I'd rather add the fake TASK_ZOMBIE
> task_struct for that. This will be much, much simply although not
> pretty anyway.
Well, maybe the patch looks more complex than it actually is.
How it works:
- num_waiters is set to 1 by fork(). Then PR_DETACH may increment
it if the old parent does not ignore the SIGCHLD. Both the
wait_task_zombie() and wait_task_detached() do decrement that
counter, and when it is zero, the task is reaped. Also, if the old
parent terminates without wait(), it decrements that counter, and,
if needed, reaps the task.
- exit_state is set to EXIT_DETACHED if the parent doesn't ignore
SIGCHLD. Then, if old parent wait()s, exit_state gets reset to 0. But
if the process exits, exit_state gets set to EXIT_ZOMBIE, and then,
by the use of the num_waiters counter, I make sure both parents
waited, before releasing the task.
There were some rearrangements in the exit.c code, that are
not directly related to the new feature. I can split them to the
separate patches, if that will help.

As for convincing LKML... Well, when the code is right, maybe. :))

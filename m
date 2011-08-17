Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1HQNN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:13:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55518 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1HQNNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:13:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110817115543.GA8745@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org> <20110817115543.GA8745@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 17 Aug 2011 15:13:35 +0200
Message-ID: <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
Subject: Re: + prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
 .patch added to -mm tree
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 13:55, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/16, Andrew Morton wrote:
>> From: Lennart Poettering <lennart@poettering.net>
>>
>> Userspace service managers/supervisors need to track their started
>> services.  Many services daemonize by double-forking and get implicitely
>> re-parented to PID 1.  The process manager will no longer be able to
>> receive the SIGCHLD signals for them.
>>
>> With this prctl, a service manager can mark itself as a sort of 'sub-init'
>> process, able to stay as the parent process for all processes created by
>> the started services.  All SIGCHLD signals will be delivered to the
>> service manager.
>
> I try to never argue with the new features. But to be honest, this
> doesn't look very good to me.
>
> OK, a service manager M does prctl(PR_SET_CHILD_REAPER), then it forks
> a service X which forks another child C and exits. Then C exits and
> notifies M.
>
> But. How can M know that the service X should be restarted? It only
> knows the pid.

Legacy services write pid files and we read them, so we know the pid
to watch for. Proper services never double-fork and reparent in a
modern init environment.

> What if wait(WEXITED) succeeds because C in turn does
> fork + exit?

Nothing is really doing this. There are a few hacks out there that do
that on service update instead of just restarting, and such services
explicitly need to tell their new pid, up or they just need to disable
supervision if they can't behave. :)

> What M has 2 or more services?

Nothing different from one service. They are all tracked the same way.

> Anyway, the implementation is certainly buggy.
>
>> @@ -1296,6 +1296,8 @@ struct task_struct {
>>                                * execve */
>>       unsigned in_iowait:1;
>>
>> +     /* Reparent child processes to this process instead of pid 1. */
>> +     unsigned child_reaper:1;
>
> First of all - this is already very wrong imho. This should be
> per-process, not per-thread.

What do you mean? That would go where instead?

>> +     /* find the first ancestor which is marked as child_reaper */
>> +     for (reaper = father->parent;
>> +          reaper != &init_task && reaper != pid_ns->child_reaper;
>> +          reaper = reaper->parent)
>
> This loop can never reach init_task/child_reaper and crash the kernel.

You mean: *if* this loop can never ...?

> For example, father->parent can point to init_task's sub-thread.
>
> OTOH you shouldn't use init_task at all.

What would we use instead?

> Also. You shouldn't do this if the sub-namespace init exits, this is
> wrong.

It we find a sub-init, before the namespace PID1, why wouldn't we return it?

>> +             if (reaper->child_reaper)
>> +                     return reaper;
>
> No, we can't blindly return this task, it can be dead/exiting. More
> precisely, we must not do this if it has already passed
> forget_original_parent(). That is why the code above checks PF_EXITING.

Ok.

Kay

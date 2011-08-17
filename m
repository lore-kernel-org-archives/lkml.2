Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1HQPpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 11:45:25 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36540 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1HQPpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 11:45:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110817134516.GA14136@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
 <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
 <20110817134516.GA14136@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 17 Aug 2011 17:45:03 +0200
Message-ID: <CAPXgP101N_GESzpqu=P_H8cLoekMzb2_W2eWyAqATSjm4Gj9CA@mail.gmail.com>
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

On Wed, Aug 17, 2011 at 15:45, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/17, Kay Sievers wrote:
>> On Wed, Aug 17, 2011 at 13:55, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > I try to never argue with the new features. But to be honest, this
>> > doesn't look very good to me.
>> >
>> > OK, a service manager M does prctl(PR_SET_CHILD_REAPER), then it forks
>> > a service X which forks another child C and exits. Then C exits and
>> > notifies M.
>> >
>> > But. How can M know that the service X should be restarted? It only
>> > knows the pid.
>>
>> Legacy services write pid files and we read them, so we know the pid
>> to watch for. Proper services never double-fork and reparent in a
>> modern init environment.
>
> OK. So, this patch can only help to handle the legacy services?

It helps them with services that need it. It is not recommended to
double-fork ever with a modern init system, but it's historic default
and common practice, and we are not going to change that any time
soon.

> And
> the service should participate (write pid files for example). And,

This is not meant as a security feature, if that's what your asking.
It will not prevent services from doing nasty things and escape the
process that started them. But it's still a feature that today only
PID 1 and which we need for more processes.

>> > What if wait(WEXITED) succeeds because C in turn does
>> > fork + exit?
>>
>> Nothing is really doing this.
>
> OK. But this means you propose this patch to solve the very specific
> problems.

No, it's for a very common problem. But again, it's not a security feature.

> IOW, imho this doesn't look very useful "in general" to me.

It is very useful if you have an init-like daemon.

> May be we need something else instead... And iiuc you don't really
> need to change the reparenting, you only want the notification if
> the process exits.

No, we want to be the parent of the process, and we want to be the one
who reaps all the child process, not only receive some out-of-band
notifications. The sub-init is the babysitter of all the things it has
started, and that should be reflected in the parent child relation.

>> >> @@ -1296,6 +1296,8 @@ struct task_struct {
>> >>                                * execve */
>> >>       unsigned in_iowait:1;
>> >>
>> >> +     /* Reparent child processes to this process instead of pid 1. */
>> >> +     unsigned child_reaper:1;
>> >
>> > First of all - this is already very wrong imho. This should be
>> > per-process, not per-thread.
>>
>> What do you mean? That would go where instead?
>
> You should mark the whole process as sub-reaper, not a single thread
> which does prctl(). The parent/child relationship is process-wide.

Ok.

> If nothing else. Suppose that application does pthread_create(), the
> new thread does prctl(REAPER) and exits.

I get the (weird) idea. :)

>> >> +     /* find the first ancestor which is marked as child_reaper */
>> >> +     for (reaper = father->parent;
>> >> +          reaper != &init_task && reaper != pid_ns->child_reaper;
>> >> +          reaper = reaper->parent)
>> >
>> > This loop can never reach init_task/child_reaper and crash the kernel.
>>
>> You mean: *if* this loop can never ...?
>
> Yes.
>
>> > For example, father->parent can point to init_task's sub-thread.
>> >
>> > OTOH you shouldn't use init_task at all.
>>
>> What would we use instead?
>
> You should check ->child_reaper only. But see above, it can be multithreaded.

The main PID 1 from the system has no ->child_reaper set as far as I
see, hence we check for init_task.

>> > Also. You shouldn't do this if the sub-namespace init exits, this is
>> > wrong.
>>
>> It we find a sub-init, before the namespace PID1, why wouldn't we return it?
>
> Ah, I meant pid_ns->child_reaper, not task->child_reaper.
>
> If pid_ns->child_reaper exits we should never try to "reparent" its
> children, see zap_pid_ns_processes() in particular. IOW, this should
> go into the "else" branch of "if (pid_ns->child_reaper == father)"

I don't understand this. If we find a marked task->child_reaper
_before_ we find a pid_ns->child_reaper in the chain of parents, why
wouldn't we return it?

Kay

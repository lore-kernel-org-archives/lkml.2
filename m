Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0FSFBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:01:01 -0400
Received: from smtp-out.google.com ([74.125.121.35]:1236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab0FSFBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:01:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=fRmaDbdX2HyYTp+fZxsyFZz6l8TbpkuZjmgJW8dETJs5/PBxr6mYubISgQnZ/FnOx
	xoirJdU8bzg0N3DglmDCw==
MIME-Version: 1.0
In-Reply-To: <20100618193403.GA17314@redhat.com>
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
Date: Fri, 18 Jun 2010 22:00:54 -0700
Message-ID: <AANLkTimh-7F4VK8FI6j-JQ4EDnxtEI3ZlGY-2X-lq6iM@mail.gmail.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
From: Mandeep Baines <msb@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 12:34 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> (add cc's)
>
> Hmm. Once I sent this patch, I suddenly realized with horror that
> while_each_thread() is NOT safe under rcu_read_lock(). Both
> do_each_thread/while_each_thread or do/while_each_thread() can
> race with exec().
>
> Yes, it is safe to do next_thread() or next_task(). But:
>
>        #define while_each_thread(g, t) \
>                while ((t = next_thread(t)) != g)
>
> suppose that t is not the group leader, and it does de_thread() and then
> release_task(g). After that next_thread(t) returns t, not g, and the loop
> will never stop.
>
> I _really_ hope I missed something, will recheck tomorrow with the fresh
> head. Still I'd like to share my concerns...
>

Yep. You're right. Not sure what I was thinking. This is only case
where do_each_thread
is protected by an rcu_read_lock. All others, correctly use read_lock.

> If I am right, probably we can fix this, something like
>
>        #define while_each_thread(g, t) \
>                while ((t = next_thread(t)) != g && pid_alive(g))
>

This seems like a reasonable approach. Maybe call it:

while_each_thread_maybe_rcu() :)

This makes hung_task a little less useful for failure fencing since
this (and rcu_lock_break)
increases the potential for never examining all threads but its still
a nice lightweight diagnostic
for finding bugs.

> [we can't do while (!thread_group_leadr(t = next_thread(t)))].
> but this needs barrires, and we should validate the callers anyway.
>
> Or, perhaps,
>
>        #define XXX(t)  ({
>                struct task_struct *__prev = t;
>                t = next_thread(t);
>                t != g && t != __prev;
>        })
>
>        #define while_each_thread(g, t) \
>                while (XXX(t))
>
> Please tell me I am wrong!
>
> Oleg.
>
> On 06/18, Oleg Nesterov wrote:
>>
>> check_hung_uninterruptible_tasks()->rcu_lock_break() introduced by
>> "softlockup: check all tasks in hung_task" commit ce9dbe24 looks
>> absolutely wrong.
>>
>>       - rcu_lock_break() does put_task_struct(). If the task has exited
>>         it is not safe to even read its ->state, nothing protects this
>>         task_struct.
>>
>>       - The TASK_DEAD checks are wrong too. Contrary to the comment, we
>>         can't use it to check if the task was unhashed. It can be unhashed
>>         without TASK_DEAD, or it can be valid with TASK_DEAD.
>>
>>         For example, an autoreaping task can do release_task(current)
>>         long before it sets TASK_DEAD in do_exit().
>>
>>         Or, a zombie task can have ->state == TASK_DEAD but release_task()
>>         was not called, and in this case we must not break the loop.
>>
>> Change this code to check pid_alive() instead, and do this before we
>> drop the reference to the task_struct.
>>
>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>> ---
>>
>>  kernel/hung_task.c |   11 +++++++----
>>  1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> --- 35-rc2/kernel/hung_task.c~CHT_FIX_RCU_LOCK_BREAK  2009-12-18 19:05:38.000000000 +0100
>> +++ 35-rc2/kernel/hung_task.c 2010-06-18 20:06:11.000000000 +0200
>> @@ -113,15 +113,20 @@ static void check_hung_task(struct task_
>>   * For preemptible RCU it is sufficient to call rcu_read_unlock in order
>>   * exit the grace period. For classic RCU, a reschedule is required.
>>   */
>> -static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
>> +static bool rcu_lock_break(struct task_struct *g, struct task_struct *t)
>>  {
>> +     bool can_cont;
>> +
>>       get_task_struct(g);
>>       get_task_struct(t);
>>       rcu_read_unlock();
>>       cond_resched();
>>       rcu_read_lock();
>> +     can_cont = pid_alive(g) && pid_alive(t);
>>       put_task_struct(t);
>>       put_task_struct(g);
>> +
>> +     return can_cont;
>>  }
>>
>>  /*
>> @@ -148,9 +153,7 @@ static void check_hung_uninterruptible_t
>>                       goto unlock;
>>               if (!--batch_count) {
>>                       batch_count = HUNG_TASK_BATCHING;
>> -                     rcu_lock_break(g, t);
>> -                     /* Exit if t or g was unhashed during refresh. */
>> -                     if (t->state == TASK_DEAD || g->state == TASK_DEAD)
>> +                     if (!rcu_lock_break(g, t))
>>                               goto unlock;
>>               }
>>               /* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
>
>

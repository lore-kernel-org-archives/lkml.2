Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab0FSPo4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 11:44:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9349 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab0FSPox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 11:44:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RU9LsEmtAk5dRNOghJMGXAO7L+4cymM7N6AHam+L+Y6QGa7RxHmJ7l9IZgvjtgKlG
	k64iRY2NDGLdNQF31GE/A==
MIME-Version: 1.0
In-Reply-To: <20100619053522.GA11264@nowhere>
References: <20100618190251.GA17297@redhat.com>
	<20100618193403.GA17314@redhat.com>
	<AANLkTimh-7F4VK8FI6j-JQ4EDnxtEI3ZlGY-2X-lq6iM@mail.gmail.com>
	<20100619053522.GA11264@nowhere>
Date: Sat, 19 Jun 2010 08:44:49 -0700
Message-ID: <AANLkTik27jcOPkiGTY90L8lTy1wxy81Zr6jBNLl5E9uI@mail.gmail.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
From: Mandeep Baines <msb@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
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

On Fri, Jun 18, 2010 at 10:35 PM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> On Fri, Jun 18, 2010 at 10:00:54PM -0700, Mandeep Baines wrote:
>> On Fri, Jun 18, 2010 at 12:34 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > (add cc's)
>> >
>> > Hmm. Once I sent this patch, I suddenly realized with horror that
>> > while_each_thread() is NOT safe under rcu_read_lock(). Both
>> > do_each_thread/while_each_thread or do/while_each_thread() can
>> > race with exec().
>> >
>> > Yes, it is safe to do next_thread() or next_task(). But:
>> >
>> >        #define while_each_thread(g, t) \
>> >                while ((t = next_thread(t)) != g)
>> >
>> > suppose that t is not the group leader, and it does de_thread() and then
>> > release_task(g). After that next_thread(t) returns t, not g, and the loop
>> > will never stop.
>> >
>> > I _really_ hope I missed something, will recheck tomorrow with the fresh
>> > head. Still I'd like to share my concerns...
>> >
>>
>> Yep. You're right. Not sure what I was thinking. This is only case
>> where do_each_thread
>> is protected by an rcu_read_lock. All others, correctly use read_lock.
>
>
>
> cgroup does too.
> taskstats also uses rcu with while_each_threads, and may be some
> others.
>
> It's not your fault, theses iterators are supposed to be rcu safe,
> we are just encountering a bad race :)
>

Thanks:) Feel less dumb now. My quick grep only turned up hung_task:

$ find . -name \*.c | xargs fgrep -B 10 do_each_thread | grep rcu
./kernel/hung_task.c-   rcu_read_lock();

>
>
>> > If I am right, probably we can fix this, something like
>> >
>> >        #define while_each_thread(g, t) \
>> >                while ((t = next_thread(t)) != g && pid_alive(g))
>> >
>>
>> This seems like a reasonable approach. Maybe call it:
>>
>> while_each_thread_maybe_rcu() :)
>
>
>
> Hmm, no while_each_thread must really be rcu_safe.
>

I didn't realize there were other cases which need while_each_thread to
be rcu-safe. For hung_task, its OK to break out on a release_task(g).
We'll just check the threads we missed on the next iteration.

>
>
>>
>> This makes hung_task a little less useful for failure fencing since
>> this (and rcu_lock_break)
>> increases the potential for never examining all threads but its still
>> a nice lightweight diagnostic
>> for finding bugs.
>
>
>
> In fact may be we could just drop the rcu break, people who really
> care about latencies can use the preemptable version.
>

For large systems, you'd pin a CPU for a very long time checking for
hung_tasks. You'd cause a lot of memory pressure by delaying the
grace period for such a long time. You'd also cause softlockups with
the huge burst of call_rcus being processed by rcu_process_callbacks.

> I know the worry is more about delaying too much the grace period if
> we walk a too long task list, but I don't think it's really a problem.
>
>

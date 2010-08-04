Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0HDEaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:30:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18875 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab0HDEaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:30:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=lpPLy0+NvTNP/1yyZhAyCvhZlRyyKfGZz9sVAUBqCJ9O296UHrjqrjvaWS5aqNS0g
	42yDmKYupWuGuVp0OkTAw==
MIME-Version: 1.0
In-Reply-To: <20100804100811.199d73ba.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
	<20100730235902.GC22644@ghc17.ghc.andrew.cmu.edu>
	<20100804100811.199d73ba.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 3 Aug 2010 21:30:00 -0700
Message-ID: <AANLkTikMofFGHSwF2QrdcAsit+hU6ihndhK5cod8duwS@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] cgroups: make procs file writable
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, Kame,

Sorry for the delay in getting to look at this,

On Tue, Aug 3, 2010 at 6:08 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>>       for_each_subsys(root, ss) {
>>               if (ss->attach)
>>                       ss->attach(ss, cgrp, oldcgrp, tsk, false);
>>       }
>> -     set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
>> +
>
> Hmm. By this, we call ss->attach(ss, cgrp, oldcgrp, tsk, false) after
> makring CGRP_RELEASABLE+synchronize_rcu() to oldcgroup...is it safe ?
> And why move it before attach() ?
>

Marking as releasable should be fine - the only time this is cleared
is when you write to notify_on_release.

I think that the put_css_set(oldcg) and synchronize_rcu() is safe, by
the following logic:

- we took cgroup_lock in cgroup_tasks_write()

- after this point, oldcgrp was initialized from the task's cgroup;
therefore oldcgrp still existed at this point

- even if all the threads (including the one being operated on) exit
(and hence leave oldcgrp) while we're doing the attach, we're holding
cgroup_lock so no-one else can delete oldcgrp

So it's certainly possible that the task in question has exited by the
time we call the subsys attach methods, but oldcgrp should still be
alive.

Whether we need an additional synchronize_rcu() after the attach()
calls is harder to determine - I guess it's better to be safe than
sorry, unless people are seeing specific performance issues with this.

I think the css_set_check_fetched() function needs more comments
explaining its behaviour and what its return value indicates.
>> +     /*
>> +      * we need to make sure we have css_sets for all the tasks we're
>> +      * going to move -before- we actually start moving them, so that in
>> +      * case we get an ENOMEM we can bail out before making any changes.

More than that - even if we don't get an ENOMEM, we can't safely sleep
in the RCU section, so we'd either have to do all memory allocations
atomically (which would be bad and unreliable) or else we avoid the
need to allocate in the RCU section (which is the choice taken here).

>> +      */
>> +     struct list_head newcg_list;
>> +     struct cg_list_entry *cg_entry, *temp_nobe;
>> +
>> +     /* check that we can legitimately attach to the cgroup. */
>> +     for_each_subsys(root, ss) {
>> +             if (ss->can_attach) {
>> +                     retval = ss->can_attach(ss, cgrp, leader, true);
>> +                     if (retval) {
>> +                             failed_ss = ss;
>> +                             goto out;
>> +                     }
>> +             }
>> +     }
>
> Then, we cannot do attach limitaion control per thread ? (This just check leader.)
> Is it ok for all subsys ?

By passing "true" as the "threadgroup" parameter to can_attach(),
we're letting the subsystem decide if it needs to do per-thread
checks. For most subsystems, calling them once for each thread would
be unnecessary.

>
>
>> +
>> +     /*
>> +      * step 1: make sure css_sets exist for all threads to be migrated.
>> +      * we use find_css_set, which allocates a new one if necessary.
>> +      */
>> +     INIT_LIST_HEAD(&newcg_list);
>> +     oldcgrp = task_cgroup_from_root(leader, root);
>> +     if (cgrp != oldcgrp) {
>> +             /* get old css_set */
>> +             task_lock(leader);
>> +             if (leader->flags & PF_EXITING) {
>> +                     task_unlock(leader);
>> +                     goto prefetch_loop;
>> +             }
> Why do we continue here ? not -ESRCH ?
>

It's possible that some threads from the process are exiting while
we're trying to move the entire process. As long as we move at least
one thread, we shouldn't care if some of its threads are exiting.

Which means that after we've done the prefetch loop, we should
probably check that the newcg_list isn't empty, and return -ESRCH in
that case.

>
>> +             oldcg = leader->cgroups;
>> +             get_css_set(oldcg);
>> +             task_unlock(leader);
>> +             /* acquire new one */

/* acquire a new css_set for the leader */

>> +      * if we need to fetch a new css_set for this task, we must exit the
>> +      * rcu_read section because allocating it can sleep. afterwards, we'll
>> +      * need to restart iteration on the threadgroup list - the whole thing
>> +      * will be O(nm) in the number of threads and css_sets; as the typical
>> +      * case has only one css_set for all of them, usually O(n). which ones

Maybe better to say "in the worst case this is O(n^2) on the number of
threads; however, in the vast majority of cases all the threads will
be in the same cgroups as the leader and we'll make a just single pass
through the list with no additional allocations needed".

>
> It's going away but seems to exist for a while....then, "continue" is safe
> for keeping consistency ?

Yes, because we don't sleep so the RCU list is still valid.

>> +             /* see if the new one for us is already in the list? */

/* See if we already have an appropriate css_set for this thread */

>> +                     /* begin iteration again. */

/* Since we may have slept in css_set_prefetch(), the RCU list is no
longer valid, so we must begin the iteration again; Any threads that
we've previously processed will pass the css_set_check_fetched() test
on subsequent iterations since we hold cgroup_lock, so we're
guaranteed to make progress. */

> Does this function work well if the process has 10000+ threads ?

In general there'll only be one cgroup so it'll be a single pass
through the list.

>
> How about this logic ?
> ==
>
>        /* At first, find out necessary things */
>        rcu_read_lock();
>        list_for_each_entry_rcu() {
>                oldcgrp = task_cgroup_from_root(tsk, root);
>                if (oldcgrp == cgrp)
>                        continue;
>                task_lock(task);
>                if (task->flags & PF_EXITING) {
>                        task_unlock(task);
>                        continue;
>                }
>                oldcg = tsk->cgroups;
>                get_css_set(oldcg);
>                task_unlock(task);
>                read_lock(&css_set_lock);
>                newcg = find_existing_css_set(oldcgrp cgrp, template);
>                if (newcg)
>                        remember_this_newcg(newcg, &found_cg_array); {
>                        put_css_set(oldcg);
>                } else
>                        remember_need_to_allocate(oldcg, &need_to_allocate_array);

The problem with this is that remember_need_to_allocate() will itself
need to allocate memory in order to allow need_to_allocate_array to
expand arbitrarily. Which can't be done without GFP_ATOMIC or else
sleeping in the RCU section, neither of which are good.
>> +list_teardown:
>> +     /* clean up the list of prefetched css_sets. */
>> +     list_for_each_entry_safe(cg_entry, temp_nobe, &newcg_list, links) {
>> +             list_del(&cg_entry->links);
>> +             put_css_set(cg_entry->cg);
>> +             kfree(cg_entry);
>> +     }

I wonder if we might need a synchronize_rcu() here?

>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -1404,6 +1404,10 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>>               struct task_struct *c;
>>
>>               rcu_read_lock();
>> +             if (!thread_group_leader(tsk)) {
>> +                     rcu_read_unlock();
>> +                     return -EAGAIN;
>> +             }

Why are you adding this requirement, here and in sched.c? (ns_cgroup.c
doesn't matter since it's being deleted).

Paul

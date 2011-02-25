Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab1BYUvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:51:37 -0500
Received: from smtp-out.google.com ([216.239.44.51]:26464 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab1BYUvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:51:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qf6YxE3iloALS28Uo+fDw9W5CTOGG97Rg5FxQJMNQy/PwKVUoVpV4DDHhkc0D6ohUd
         oh5Y9eggRbeNk+RtDZ5Q==
MIME-Version: 1.0
In-Reply-To: <20110225135856.GA2376@in.ibm.com>
References: <20110216031831.571628191@google.com> <20110216031841.068673650@google.com>
 <1298467933.2217.765.camel@twins> <AANLkTimydWA5xyROhdXeW5as3t8aqfR1H2dqc-42C+6=@mail.gmail.com>
 <20110225135856.GA2376@in.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 25 Feb 2011 12:51:01 -0800
Message-ID: <AANLkTin-SK1G+MdTKfYDw53bcWoEjBn6fqUzPn5mPzbq@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 3/7] sched: throttle cfs_rq entities
 which exceed their local quota
To: bharata@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 5:58 AM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
> On Thu, Feb 24, 2011 at 07:10:58PM -0800, Paul Turner wrote:
>> On Wed, Feb 23, 2011 at 5:32 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:
>>
>> >> +     update_cfs_load(cfs_rq, 0);
>> >> +
>> >> +     /* prevent previous buddy nominations from re-picking this se */
>> >> +     clear_buddies(cfs_rq_of(se), se);
>> >> +
>> >> +     /*
>> >> +      * It's possible for the current task to block and re-wake before task
>> >> +      * switch, leading to a throttle within enqueue_task->update_curr()
>> >> +      * versus an an entity that has not technically been enqueued yet.
>> >
>> > I'm not quite seeing how this would happen.. care to expand on this?
>> >
>>
>> I'm not sure the example Bharata gave is correct -- I'm going to treat
>> that discussion separately as it's not the intent here.
>
> Just for the record, my examples were not given for the above question from
> Peter.
>
> I answered two questions and I am tempted to stand by those until proven
> wrong :)

This is important to get right, I'm happy to elaborate.

>
> 1. Why do we have cfs_rq_throtted() check in dequeue_task_fair() ?

The check is primarily needed because we could become throttled as
part of a regular dequeue.  At which point we bail because the parent
dequeue is actually complete.

(Were it necessitated by load balance we could actually not do this
and just perform a hierarchal check within load_balance_fair)

> ( => How could we be running if our parent was throttled ?)
>

The only way we can be running if our parent was throttled is if /we/
triggered that throttle and have been marked for re-schedule.

> Consider the following hierarchy.
>
> Root Group
>   |
>   |
> Group 1 (Bandwidth constrained group)
>   |
>   |
> Group 2 (Infinite runtime group)
>
> Assume both the groups have tasks in them.
>
> When Group 1 is throttled, its cfs_rq is marked throttled, and is removed from
> Root group's runqueue. But leaf tasks in Group 2 continue to be enqueued in
> Group 1's runqueue.
>

Yes, the hierarchy state is maintained in isolation.

> Load balancer kicks in on CPU A and figures out that it can pull a few tasks
> from CPU B (busiest_cpu). It iterates through all the task groups
> (load_balance_fair) and considers Group 2 also. It tries to pull a task from
> CPU B's cfs_rq for Group 2. I don't see anything that would prevent the
> load balancer from bailing out here.

Per above, the descendants of a throttled group are also identified
(and appropriately skipped) using h_load.

> Note that Group 2 is technically
> not throttled, only its parent Group 1 is. Load balancer goes ahead and
> starts pulling individual tasks from Group 2's cfs_rq on CPU B.

In general, not true -- load balancing against a throttled hierarchy
is crazy[*].

>  This results in dequeuing of task whose hierarchy is throttled.
>

[*]: There is one edge case in which it may sanely occur:

Namely, if the load balance races with a throttle (since we don't take
rq->locks until we start actually moving tasks).  In this case it's
still ok because the cached h_load ensures the load balancer is still
working from a sane load view and it's as if we performed a minute
re-ordering so it's as if the load-balance had occurred fractionally
before the throttle instead of fractionally after.


> When load balancer iterates through Group 1's cfs_rqs, the situation is
> different because we have already marked Group 1's cfs_rqs as throttled.
> And we check this in load_balance_fair() and bail out from pulling tasks
> from throttled hierarchy.
>
> This is my understanding. Let me know what I miss. Specifically I would
> like to understand how do you ensure that load balancer doesn't consider
> tasks from throttled cfs_rqs for pulling.
>
> 2. Why there is cfs_rq_throttled() check in account_cfs_rq_quota() ?
>
> In addition to the case you described, I believe the situation I described
> is also valid.
>

The point made above was that it's actually for any update that may
(legitimately) occur as throttling can not always be aligned with
eviction.  The case you gave is one of several -- there's nothing
particularly unique about it (nor did I actually disagree with it).

> Regards,
> Bharata.
>

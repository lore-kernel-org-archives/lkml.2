Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1CBHIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:08:38 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1CBHIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hiJ5uT1W5X8Sw5UnKiz47CKy7BB0xNKbCj1DsHLmuXWjr+du0hlOPoU+yHYUAVnsgT
         b04hG6H4y0WMzmOxcvEA==
MIME-Version: 1.0
In-Reply-To: <1299048447.11469.22.camel@marge.simson.net>
References: <1299022433-17233-1-git-send-email-venki@google.com>
 <AANLkTinyAyXCH6sh9pOe36dCeTO_C8wbtmZriKanGtt3@mail.gmail.com> <1299048447.11469.22.camel@marge.simson.net>
From: Paul Turner <pjt@google.com>
Date: Tue, 1 Mar 2011 23:08:05 -0800
Message-ID: <AANLkTimhfvoKWdYJtxQLWhBwfSvZ3jGy7EXX_YSn_HLr@mail.gmail.com>
Subject: Re: [PATCH] sched: next buddy hint on sleep and preempt path
To: Mike Galbraith <efault@gmx.de>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 10:47 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Tue, 2011-03-01 at 21:43 -0800, Paul Turner wrote:
>> On Tue, Mar 1, 2011 at 3:33 PM, Venkatesh Pallipadi <venki@google.com> wrote:
>
>> >        for_each_sched_entity(se) {
>> >                cfs_rq = cfs_rq_of(se);
>> >                dequeue_entity(cfs_rq, se, flags);
>> >
>> >                /* Don't dequeue parent if it has other entities besides us */
>> > -               if (cfs_rq->load.weight)
>> > +               if (cfs_rq->load.weight) {
>> > +                       /*
>> > +                        * Bias pick_next to pick a task from this cfs_rq, as
>> > +                        * p is sleeping when it is within its sched_slice.
>> > +                        */
>> > +                       if (task_flags & DEQUEUE_SLEEP && se->parent)
>> > +                               set_next_buddy(se->parent);
>>
>> re-using the last_buddy would seem like a more natural fit here; also
>> doesn't have a clobber race with a wakeup
>
> Hm, that would break last_buddy no?  A preempted task won't get the CPU
> back after light preempting thread deactivates.  (it's disabled atm
> unless heavily overloaded anyway, but..)

Ommm yeah.. we're actually a little snookered in this case since the
pre-empting thread's sleep will be voluntary which will try to return
time to its hierarchy.

I suppose keeping the last_buddy is preferable to the occasional clobber.

>
> This wants a tweak either way though.
>
> static inline struct task_struct *task_of(struct sched_entity *se)
> {
> #ifdef CONFIG_SCHED_DEBUG
>        WARN_ON_ONCE(!entity_is_task(se));
> #endif
>        return container_of(se, struct task_struct, se);
> }
>
> static void set_next_buddy(struct sched_entity *se)
> {
>        if (likely(task_of(se)->policy != SCHED_IDLE)) {
>                for_each_sched_entity(se)
>                        cfs_rq_of(se)->next = se;
>        }
> }
>

yeah good catch, the if's do need to be broken out so that setting
buddies it works properly with non-task entities

>

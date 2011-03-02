Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab1CBTMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:12:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1CBTMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:12:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JHKwrVqc6Tb88zlVwNAxJpt3C/JsUmJnAhV4LPcl+DaOKxP5b0Gi8V57vBAAgSxcv9
         LG9NvL/wOCa9c5K8vSsw==
MIME-Version: 1.0
In-Reply-To: <1299048447.11469.22.camel@marge.simson.net>
References: <1299022433-17233-1-git-send-email-venki@google.com>
	<AANLkTinyAyXCH6sh9pOe36dCeTO_C8wbtmZriKanGtt3@mail.gmail.com>
	<1299048447.11469.22.camel@marge.simson.net>
Date: Wed, 2 Mar 2011 11:12:02 -0800
Message-ID: <AANLkTi=hy8mHp=RLkKbfc2nw0VGX65ZCmk89r3U-rb4-@mail.gmail.com>
Subject: Re: [PATCH] sched: next buddy hint on sleep and preempt path
From: Venkatesh Pallipadi <venki@google.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
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

Yes. Thanks for pointing this out. Will handle this in patch-respin.

Thanks,
Venki

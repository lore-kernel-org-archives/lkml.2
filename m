Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0JMGx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 02:53:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0JMGx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 02:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Q6hpTyO1J6KCvOgzZrwY91FHjGyqsV8RRUTLCG5jSGanBqOuj/rgMqzlVhOf5wv5k4
         TAA2WwQjxL5iNOgVjfSQ==
MIME-Version: 1.0
In-Reply-To: <20101013064757.GC4488@in.ibm.com>
References: <20101012074910.GA9893@in.ibm.com> <20101012075202.GD9893@in.ibm.com>
 <20101013153421.b38a5c6f.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTinSDt9U5py_PMVuNSgmqR0_PtCBxaCksuq8QR3F@mail.gmail.com>
 <20101013064757.GC4488@in.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 12 Oct 2010 23:52:53 -0700
Message-ID: <AANLkTinjneckYgLDi=xqFhGWBAtV4tqPZ48Tk_g1g1L5@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] sched: throttle cfs_rq entities which exceed their
 local quota
To: bharata@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 11:47 PM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
> On Tue, Oct 12, 2010 at 11:44:29PM -0700, Paul Turner wrote:
>> On Tue, Oct 12, 2010 at 11:34 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Tue, 12 Oct 2010 13:22:02 +0530
>> > Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
>> >
>> >> sched: throttle cfs_rq entities which exceed their local quota
>> >>
>> >> From: Paul Turner <pjt@google.com>
>> >>
>> >> In account_cfs_rq_quota() (via update_curr()) we track consumption versus a
>> >> cfs_rq's local quota and whether there is global quota available to continue
>> >> enabling it in the event we run out.
>> >>
>> >> This patch adds the required support for the latter case, throttling entities
>> >> until quota is available to run.  Throttling dequeues the entity in question
>> >> and sends a reschedule to the owning cpu so that it can be evicted.
>> >>
>> >> The following restrictions apply to a throttled cfs_rq:
>> >> - It is dequeued from sched_entity hierarchy and restricted from being
>> >>   re-enqueued.  This means that new/waking children of this entity will be
>> >>   queued up to it, but not past it.
>> >> - It does not contribute to weight calculations in tg_shares_up
>> >> - In the case that the cfs_rq of the cpu we are trying to pull from is throttled
>> >>   it is  is ignored by the loadbalancer in __load_balance_fair() and
>> >>   move_one_task_fair().
>> >>
>> >> Signed-off-by: Paul Turner <pjt@google.com>
>> >> Signed-off-by: Nikhil Rao <ncrao@google.com>
>> >> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
>> >> ---
>> >>  kernel/sched.c      |   12 ++++++++
>> >>  kernel/sched_fair.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++----
>> >>  2 files changed, 76 insertions(+), 6 deletions(-)
>> >>
>> >> --- a/kernel/sched.c
>> >> +++ b/kernel/sched.c
>> >> @@ -387,6 +387,7 @@ struct cfs_rq {
>> >>  #endif
>> >>  #ifdef CONFIG_CFS_BANDWIDTH
>> >>       u64 quota_assigned, quota_used;
>> >> +     int throttled;
>> >>  #endif
>> >>  #endif
>> >>  };
>> >> @@ -1668,6 +1669,8 @@ static void update_group_shares_cpu(stru
>> >>       }
>> >>  }
>> >>
>> >> +static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq);
>> >> +
>> >
>> > I just curious that static-inline forward declaration is inlined ?
>> >
>>
>> Hm.   This function is tiny, I should just move it up, thanks.
>>
>> >>  /*
>> >>   * Re-compute the task group their per cpu shares over the given domain.
>> >>   * This needs to be done in a bottom-up fashion because the rq weight of a
>> >> @@ -1688,7 +1691,14 @@ static int tg_shares_up(struct task_grou
>> >>       usd_rq_weight = per_cpu_ptr(update_shares_data, smp_processor_id());
>> >>
>> >>       for_each_cpu(i, sched_domain_span(sd)) {
>> >> -             weight = tg->cfs_rq[i]->load.weight;
>> >> +             /*
>> >> +              * bandwidth throttled entities cannot contribute to load
>> >> +              * balance
>> >> +              */
>> >> +             if (!cfs_rq_throttled(tg->cfs_rq[i]))
>> >> +                     weight = tg->cfs_rq[i]->load.weight;
>> >> +             else
>> >> +                     weight = 0;
>> >
>> > cpu.share and bandwidth control can't be used simultaneously or...
>> > is this fair ? I'm not familiar with scheduler but this allows boost this tg.
>> > Could you add a brief documentaion of a spec/feature. in the next post ?
>> >
>>
>> Bandwidth control is orthogonal to shares, shares continue controls
>> distribution of bandwidth when within quota.  Bandwidth control only
>> has 'perceivable' effect when you exceed your reservation within a
>> quota period.
>
> So if a group gets throttled since its approaching its limit, it might
> not be possible to see perfect fairness b/n groups since bandwidth control
> kind of takes priority.

It's two-fold:

A) The shares will be released so that they can be distributed to
other cpus within the group (where there may be quota remaining)
B) The weight will be hierarchically removed to *improve* fairness
since those entities are not actually running (this is fixing the
accounting, since these calculations are lazy we don't do it at time
of throttle).

It shouldn't have negative implications for group:group fairness.

>
> Regards,
> Bharata.
>

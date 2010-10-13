Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab0JMHOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:14:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab0JMHOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UiYG4n2VL9siAk3vhvUxx88f+1lbekCe5DWjbW82p5FvoLt55f8sEkJiuFy+hIzXEH
         W4gh8+Nv75zbUICvQNjg==
MIME-Version: 1.0
In-Reply-To: <20101013160011.76e7aadc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101012074910.GA9893@in.ibm.com> <20101012075202.GD9893@in.ibm.com>
 <20101013153421.b38a5c6f.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTinSDt9U5py_PMVuNSgmqR0_PtCBxaCksuq8QR3F@mail.gmail.com>
 <20101013160011.76e7aadc.kamezawa.hiroyu@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 13 Oct 2010 00:13:26 -0700
Message-ID: <AANLkTim4hA7CBshs5v0mO33VFVJa_o+qe6evyjBZ2N63@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] sched: throttle cfs_rq entities which exceed their
 local quota
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
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

On Wed, Oct 13, 2010 at 12:00 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 12 Oct 2010 23:44:29 -0700
> Paul Turner <pjt@google.com> wrote:
>
>> On Tue, Oct 12, 2010 at 11:34 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Tue, 12 Oct 2010 13:22:02 +0530
>> > Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
>
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
>>
>> What the above is doing is removing any throttled entities from the
>> load-balancer's weight calculations (based on contribution from
>> throttled entities) since these entities are already dequeued and
>> cannot be balanced.
>>
>> Or have I misunderstood your question?
>>
>
> Thank you for quick reply.
> It seems I don't undestand what "cfs_rq_throttled()==1" means.

cfs_rq_throttled() == 1 correlates to cfs_rq->throttled == 1.

This is set when a cfs_rq exceeds it's local bandwidth quota and there
is no quota available in the global pool to refresh it.

At that point the cfs_rq is forcibly throttled, we accomplish this by

a) Ending its execution
b) Removing it from the entity tree (se->on_rq == 0)
c) Setting the throttled flag

The cfs_rq->throttled flag is required to track this state so that we
do not re-enqueue a throttled entity on child wake-up.

It also tells us here that we should update the accounting since these
se's, while containing runnable entities, are not actually on_rq.
>
> Thanks,
> -Kame
>
>

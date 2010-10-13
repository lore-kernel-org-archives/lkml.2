Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0JMG1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 02:27:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37796 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0JMG1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 02:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=CsQ2G2vVHyGsWUt0FHuDIIXqbptPPrcVci7kmXuQmcP3Z3OQiL6SjZnmEAFGcR6zgh
         j/SHJcMKOuZgKHAWZZSw==
MIME-Version: 1.0
In-Reply-To: <20101013054412.GL30810@MAIL.13thfloor.at>
References: <20101012074910.GA9893@in.ibm.com> <20101013054412.GL30810@MAIL.13thfloor.at>
From: Paul Turner <pjt@google.com>
Date: Tue, 12 Oct 2010 23:26:34 -0700
Message-ID: <AANLkTi=+9LHypo=42MsNRxE0xcXidki=jRcz2qbeire4@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] CFS Bandwidth Control
To: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 10:44 PM, Herbert Poetzl <herbert@13thfloor.at> wrote:
> On Tue, Oct 12, 2010 at 01:19:10PM +0530, Bharata B Rao wrote:
>> Hi,
>
>> Its been a while since we posted CPS hard limits (aka CFS bandwidth
>
> Indeed, will see that I can incorporate those in the
> next experimental Linux-VServer patch for testing ...
>
> btw, is it planned to allow for hard limits which
> are temporarily disabled when the machine/cpu would
> be otherwise idle (i.e. running the idle thread) or
> as we solved it, can we artificially advance the
> time (for the hard limits) when idle so that contexts
> which have work to do can work without sacrificing
> the priorization or the actual limits?

This is a fairly useful idea, I hadn't planned on it but I can see the
applications for it.

It's somewhat complicated by the fact that throttled entities are not
in-tree, making correct selection in the case where the machine is
otherwise idle difficult.  One method of supporting this could be to
maintain a separate entity for throttled entities (the same mechanism
could be extended to include SCHED_IDLE entities, as well as extending
SCHED_IDLE to group scheduling).

I think it best to first iterate on the fundamentals since this has
been baking for a long time, before we try to add extensions.
>
> best,
> Herbert
>
> PS: from a quick glance I take it that using large
> values for period and quota, while keeping the ratio
> the same allows for 'burst loads'?
>

Exactly!

Another approach we've used is to use small value for period and quota
(with fixed ratio) for latency sensitive applications.  This allows
you to not blow out the tail of your latency distribution (since each
individual throttle is for a short period of time, tail latencies are
capped in exchange for a median latency increase).
>> control now) patches, hence a quick recap first:
>
>> - I have been working on CFS hard limits since last year and have posted
>>   a few versions of the same (last post: http://lkml.org/lkml/2010/1/5/44)
>> - Paul Turner and Nikhil Rao meanwhile started working on CFS bandwidth
>>   control and have posted a couple of versions.
>>   (last post v2: http://lwn.net/Articles/385055/)
>>
>> Paul's approach mainly changed the way the CPU hard limit was represented. After
>> his post, I decided to work with them and discontinue my patch series since
>> their global bandwidth specification for group appears more flexible than
>> the RT-type per-cpu bandwidth specification I had in my series.
>>
>> Since Paul seems to be busy, I am taking the freedom of posting the next
>> version of his patches with a few enhancements to the slack time handling.
>> (more on this later)
>>
>> Main changes in this post:
>>
>> - Return the unused and remaining local quota at each CPU to the global
>>   runtime pool.
>> - A few fixes:
>>       - Explicitly wake up the idle cpu during unthrottle.
>>       - Optimally handle throttling of current task within enqueue_task.
>>       - Fix compilation break with CONFIG_PREEMPT on.
>>       - Fix a compilation break at intermediate patch level.
>> - Applies on 2.6.36-rc7.
>>
>> More about slack time issue
>> ---------------------------
>> Bandwidth available to a group is specified by two parameters: cpu.cfs_quota_us
>> and cpu.cfs_period_us. cpu.cfs_quota_us is the max CPU time a group can
>> consume within the time period of cpu.cfs_period_us. The quota available
>> to a group within a period is maintained in a per-group global pool. In each
>> CPU, the consumption happens by obtaining a slice of this global pool.
>>
>> If the local quota (obtained as slices of global pool) isn't fully consumed
>> within a given period, a group can potentially get more CPU time than
>> its allowed for in the next interval. This is due to the slack time that may
>> be left over from the previous interval. More details about how this is fixed
>> is present in the description part of patch 7/7. Here I will only show the
>> benefit of handling the slack time correctly through this experiment:
>>
>> On a 16 CPU system, two different kinds of tasks were run as part of a group
>> which had quota/bandwidth as 500000/500000 [=> 500ms/500ms], which means that
>> the group was capped at 1CPU worth of time every period.
>>
>> Type A task: Complete CPU hog.
>> Type B task: Sleeps for 500ms and runs as CPU hog for next 500ms. And this cycle
>>               repeats.
>>
>> 1 task of type A and 15 tasks of type B were run for 20s, each bound to a
>> different CPU. At the end of 20s, the CPU time obtained by each of them
>> looked like this:
>>
>> -----------------------------------------------------------------------
>>                       Without returning       Returning slack time
>>                       slack time to global    to global pool
>>                       pool                    (with patch 7/7)
>> -----------------------------------------------------------------------
>> 1 type A task         7.96s                   10.71s
>> 15 type B tasks               12.36s                  9.79s
>> -----------------------------------------------------------------------
>>
>> This shows the effects of slack time and the benefit of handling it correctly.
>>
>> I request the scheduler maintainers and others for comments on these patches.
>>
>> Regards,
>> Bharata.
>

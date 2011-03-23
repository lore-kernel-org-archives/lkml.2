Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab1CWUKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:10:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4427 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857Ab1CWUKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qEmvfl5aThyhckOgQ9nnHEqnGNcrK8XlrEZ5b5usibd8iM2h/mNCHevz5Vjqs3hpK9
         dOIHsTM8VSwGN2ZRqkAA==
MIME-Version: 1.0
In-Reply-To: <20110322181231.GJ3757@redhat.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
	<20110322150905.GD3757@redhat.com>
	<AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>
	<20110322181231.GJ3757@redhat.com>
Date: Wed, 23 Mar 2011 13:10:32 -0700
Message-ID: <AANLkTi=uB_Wv08xu4SzpjCJ_9isvDPsN=ojTH=wAaDoS@mail.gmail.com>
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, mrubin@google.com,
        teravest@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:12 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Mar 22, 2011 at 10:39:36AM -0700, Chad Talbott wrote:
>> On Tue, Mar 22, 2011 at 8:09 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Why not just implement simply RT class groups and always allow an RT
>> > group to preempt an BE class. Same thing we do for cfq queues. I will
>> > not worry too much about a run away application consuming all the
>> > bandwidth. If that's a concern we could use blkio controller to limit
>> > the IO rate of a latency sensitive applicaiton to make sure it does
>> > not starve BE applications.
>>
>> That is not quite the same semantics.  This limited preemption patch
>> is still work-conserving.  If the RT task in the only task on the
>> system with IO, it will be able to use all available disk time.
>>
>
> It is not same semantics but it feels like too much of special casing
> for a single use case.

How are you counting use cases?

> You are using the generic notion of a RT thread (which in general means
> that it gets all the cpu or all the disk ahead of BE task). But you have
> changed the definition of RT for this special use case. And also now
> group RT is different from queue RT definition.

Perhaps the name RT has too much of a "this group should be able to
starve all other groups" connotation.  Is there a better name?  Maybe
latency sensitive?

> Why not have similar mechanism for cpu scheduler also then. This
> application first should be able to get cpu bandwidth in same predictable
> manner before it gets the disk bandwidth.

Perhaps this is a good idea.  If the CPU scheduler folks like it, I'll
be happy to support that.

> And I think your generation number patch should address this issue up
> to great extent. Isn't it? If a latency sensitive task is not using
> its fair quota, it will get a lower vdisktime and get to dispatch soon?

It will get to dispatch as soon as the current task's timeslice
expires.  This could be a long time, depending on the number of other
tasks and groups on the system.  We'd like to provide a latency
guarantee that's dependent only on the behavior of the low-latency
application.

> If that soon is not enough, then we could operate with reduce base slice
> length so that we allocate smaller slices to groups and get better IO
> latencies at the cost of total throughput.

With the limited preemption patch, I can still achieve good throughput
for many tasks, as long as the low-latency task is "quiet" or when
there is no low-latency task on the system.  If I use very small
timeslices, then I always pay a throughput price, even when there is
no low-latency task on the system or that task isn't doing any IO.

>> > If RT starving BE is an issue, then it is an issue with plain cfq queue
>> > also. First we shall have to fix it there.
>> >
>> > This definition that a latency sensitive task get prioritized only
>> > till it is consuming its fair share and if task starts using more than
>> > fair share then CFQ automatically stops prioritizing it sounds little
>> > odd to me. If you are looking for predictability, then we lost it. We
>> > shall have to very well know that task is not eating more than its
>> > fair share before we can gurantee any kind of latencies to that task. And
>> > if we know that task is not hogging the disk, there is anyway no risk
>> > of it starving other groups/tasks completely.
>>
>> In a shared environment, we have to be a little bit defensive.  We
>> hope that a latency sensitive task is well characterized and won't
>> exceed its share of the disk, and that we haven't over-committed the
>> disk.  If the app does do more IO than expected, then we'd like them
>> to bear the burden.  We have a choice of two outcomes.  A single job
>> sometimes failing to achieve low disk latency when it's very busy.  Or
>> all jobs on a disk sometimes being very slow when another (unrelated)
>> job is very busy.  The first is easier to understand and debug.
>
> To me you are trying to come up with a new scheduling class which is
> not RT and you are trying to overload the meaning of RT for your use
> case and that's the issue I have.

Can we come up with a better name?  I've used low-latency and
latency-sensitive in this email, and it's not too cumbersome.

> Coming up with a new scheduling class is also not desirable as that
> will demand another service tree and we already have too many. Also
> it should probably be also done for task and not just group otherwise
> extending this concept to hierarchical setup will get complicated. Queues
> and groups will just not gel well.

Is there a plan to provide RT class for groups in the hierarchical
future to allow full symmetry with RT tasks?

> Frankly speaking, the problem you are having should be solved by your
> generation number patch and by having smaller base slices.

Again, the throughput price is quite high to pay for all disks - even
when they have no latency sensitive groups, or those groups are not
issuing IO.

> Or You could put latency sensitive applications in an RT class and
> then throttle them using blkio controller. That way you get good
> latencies as well as you don't starve other tasks.

This is closer to the semantics offered by this patchset, but requires
debugging the complex interactions between two scheduling policies to
understand the resulting behavior.

> But I don't think overloading the meaning for RT or this specific use
> case is a good idea.

I hear you loud and clear, but I disagree.

Chad

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab2EOMcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:32:20 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52281 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab2EOMcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:32:19 -0400
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@gmail.com>
In-Reply-To: <1337083082.27020.151.camel@laptop>
Date: Tue, 15 May 2012 15:32:11 +0300
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        mou Chen <hi3766691@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C7197FD5-B8F2-4A92-92AD-5453659592B2@gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com> <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com> <CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com> <CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com> <833A8DB8-1AB4-45E4-8D44-14A0D782807D@gmail.com> <1337077714.27694.21.camel@twins> <9093E8BA-80E4-4113-B036-0259E5FB44F1@gmail.com> <1337083082.27020.151.camel@laptop>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On May 15, 2012, at 2:58 PM, Peter Zijlstra wrote:

> On Tue, 2012-05-15 at 14:35 +0300, Pantelis Antoniou wrote:
>> 
>> Throughput: MIPS(?), bogo-mips(?), some kind of performance counter?
> 
> Throughput is too generic a term to put a unit on. For some people its
> tnx/s for others its frames/s neither are much (if at all) related to
> MIPS (database tnx require lots of IO, video encoding likes FPU/SIMMD
> stuff etc..).
> 

I agree, throughput is a loaded term. However something simple as
amount of time in which the CPU was not idle is easy enough to get.
Now to get something more complicated like actual instruction counts
or FP/vector instruction counts you're going to need hardware support.

One fine point would be to respect the OPP points. I.e. a time period
t where the CPU was at 50% of max freq should be roughly analogous to
a t/2 time period were CPU was running at 100%.


>> Latency: usecs(?)
> 
> nsec (chips are really really fast and only getting faster), but nsecs
> of what :-) That is, which latency are we going to measure.
> 

At least we agree it's a time unit :) Measured from the point a task was
eligible for execution? Any other point?

>> Power: Now that's a tricky one, we can't measure power directly, it's a
>> function of the cpu load we run in a period of time, along with any
>> history of the cstates & pstates of that period. How can we collect
>> information about that? Also we to take into account peripheral device
>> power to that; GPUs are particularly power hungry. 
> 
> Intel provides some measure of CPU power drain on recent chips (iirc),
> but yeah that doesn't include GPUs and other peripherals iirc.
> 
>> Thermal management: How to distribute load to the processors in such
>> a way that the temperature of the die doesn't increase too much that
>> we have to either go to a lower OPP or shut down the core all-together.
>> This is in direct conflict with throughput since we'd have better performance 
>> if we could keep the same warmed-up cpu going.
> 
> Core-hopping.. yay! We have the whole sensors framework that provides an
> interface to such hardware, the question is, do chips have enough
> sensors spread on them to be useful?
> 

Well, not all of them do, but the ones that do are going to be pretty numerous
in the very near future :)

Combining this with the previous question, it is well known that CPUs physically
are nothing more than really efficient space heaters :) Could we use the 
readings from the sensor framework to come up with a correlation between
increased temperature X with power draw Y? If so how?

>> Memory I/O: Some workloads are memory bandwidth hungry but do not need
>> much CPU power. In the case of asymmetric cores it would make sense to move
>> the memory bandwidth hog to a lower performance CPU without any impact. 
>> Probably need to use some kind of performance counter for that; not going
>> to be very generic. 
> 
> You're assuming the slower cores have the same memory bandwidth, isn't
> that a dangerous assumption?
> 

Again, some class of hardware does provide the same bandwidth to the lower
performance cores. For some well know cases (cough, ..roid), it is said
that it is a win.

> Anyway, so the 'problem' with using PMCs from within the scheduler is
> that, 1) they're ass backwards slow on some chips (x86 anyone?) 2) some
> userspace gets 'upset' if they can't get at all of them.
> 

We might not have to access them at every context switch; would we be able
to get some useful data if we collected every few ms? Note, not all PMUs are
that slow as x86.

Userspace could always get access to the kernel's collected data if needed,
or we could just disable PMU accesses when userspace tries to do the same.
It is a corner user case after all. 

> So it has to be optional at best, and I hate knobs :-) Also, the more
> information you're going to feed this load-balancer thing, the harder
> all that becomes, you don't want to do the full nm! m-dimensional bin
> fit.. :-)
> 
> 
> 

Is this a contest about who hates knobs more? I'm in :)

Well, I don't plan to feed the load-balancer all this crap. What I'm thinking
is take those N metrics, form a vector according to some (yet unknown) weighting 
factors, and schedule according to the vector value, and how it 'fits' to a
virtual bin representing a core and it's environment.


Regards

-- Pantelis


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1HZOCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:02:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59805 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab1HZOCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:02:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=jOal+U7DYmHHvXBwDEU79Fozf+BhOAa33Fuq0K8ECZSUOfzEjji3h+Rua51o5jMW8
	xD6fCb9d9sy3rpuirPzZQ==
MIME-Version: 1.0
In-Reply-To: <1314360781.11049.2.camel@twins>
References: <CABPqkBS_Og3Vbe90xwyzA8S5ftfF08gMtJdtpqQTHFOwm+CAkg@mail.gmail.com>
	<1314293560.27911.38.camel@twins>
	<CABPqkBSaW3ShYbJoO6YdFpZ7Rt+OfszP8m-uLSoBjCWZYVQ0Bw@mail.gmail.com>
	<1314360781.11049.2.camel@twins>
Date: Fri, 26 Aug 2011 16:02:16 +0200
Message-ID: <CABPqkBSsyrCF4NZhs_eHxhdZuCsJ1pXGkQ+T3HZR2GjghdY=_Q@mail.gmail.com>
Subject: Re: [BUG] perf_event: semantic of PERF_SAMPLE_READ unclear
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 2:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-08-26 at 14:02 +0200, Stephane Eranian wrote:
>> On Thu, Aug 25, 2011 at 7:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, 2011-08-25 at 19:19 +0200, Stephane Eranian wrote:
>> >> But the difficulty is that
>> >> we cannot grab any locks, not sure we need one given the call path.
>> >
>> > Nah we should be able to simply iterate all siblings and update them
>> > in-place, since its group members they should all be co-scheduled. The
>> > only difficulty is cross pmu group members..
>> >
>> Are we allowing event from different PMU to be in the same event group?
>> If so, is that useful?
>
> We allow software events, which can always be scheduled, to be part of a
> hardware group. We don't allow mixing of different hardware pmus.
>
ok, good.

> Allowing a software event is useful if for example the hardware pmu
> doesn't have a sampling interrupt.
>
I think that's a good reason.

Now, there is something else I noticed when using PERF_SAMPLE_READ.
The libpfm4 example, task_smpl, shows the problem very easily.

$ task_smpl -e unhalted_core_cycles:period=2400000 noploop 1

IIP:0x0000000040062d PID:3658 TID:3658 TIME:19141370205834 STREAM_ID:1
PERIOD:2400000 ENA=979088465 RUN=979088465
	2330400873 unhalted_core_cycles:period=2400000

IIP:0x0000000040062d PID:3658 TID:3658 TIME:19141371213765 STREAM_ID:1
PERIOD:2400000 ENA=980096325 RUN=980096325
	2332800869 unhalted_core_cycles:period=2400000

IIP:0x0000000040062d PID:3658 TID:3658 TIME:19141372221662 STREAM_ID:1
PERIOD:2400000 ENA=981104225 RUN=981104225
	2335200869 unhalted_core_cycles:period=2400000

IIP:0x0000000040062d PID:3658 TID:3658 TIME:19141373229569 STREAM_ID:1
PERIOD:2400000 ENA=982112126 RUN=982112126
	2337600869 unhalted_core_cycles:period=2400000

Here each sample, capture the value of the sampling event. I would expect the
value to increase by at least the period (2400000) between two
consecutive samples.
The reality is: it's not always the case. It's close, though. For instance:

2332800869-2330400873 = 2399996

How to interpret this? Did the counter overflow before the period?

Is it that in the previous sample, it took a few cycles to stop the
PMU, i.e., the counter was not zero
when the PMU was stopped? And thus, when we add the period, we
actually come up with a shorter
effective period. I think the code that implements this is in
x86_perf_event_set_period().

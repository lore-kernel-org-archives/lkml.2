Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0JTMnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 08:43:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0JTMm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 08:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bXyH7png+ozA2FQ0HuMM9hFGRwtZKTICf+G0ZsMSVFqiNhR82k18Qn/b0S8Ni+OJip
         vyPAaTO2iwZ4InFQ4gfg==
MIME-Version: 1.0
In-Reply-To: <1287573196.3488.2.camel@twins>
References: <4cbdcbea.8491d80a.25b0.ffffece8@mx.google.com>
	<1287507178.1998.3440.camel@laptop>
	<AANLkTik5_h1hVfX=1chezE6z25r4KV6GfzQZ+JvD8J_p@mail.gmail.com>
	<1287508187.1998.3445.camel@laptop>
	<AANLkTimjabS1MEkheJ0z2keceH=0eEfC_NbyCjZ-Ltxz@mail.gmail.com>
	<1287573196.3488.2.camel@twins>
Date: Wed, 20 Oct 2010 14:42:56 +0200
Message-ID: <AANLkTimtD249SMg3DeyOX3BFpHCtZeq8cU-2g_m-5GKV@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix time tracking in samples
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 1:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-10-19 at 21:03 +0200, Stephane Eranian wrote:
>
>> >> Ok, I missed that. But I don't understand why you need the lock to
>> >> udpate the time. The lower-level clock is lockless if I recall. Can't you
>> >> use an atomic ops in update_context_time()?
>> >
>> > atomic ops would slow down those code paths, also, I don't think you can
>> > fully get the ordering between ->tstamp_$foo and ->total_time_$foo just
>> > right.
>> >
>>
>> I don't get that. Could you give an example?
>
> Take update_context_time(), it has:
>
> now = perf_clock();
> ctx->time += now - ctx->timestamp;
> ctx->timestamp = now;
>
> If you interleave two of those you get:
>
>  ctx->timestamp = T0;
>
>
>  now = perf_clock(); /* T1 */
>  ctx->time += now - ctx->timestamp;
>                                        now = perf_clock(); /* T2 */
>                                        ctx->time += now - ctx->timestamp;
>                                        ctx->timestamp = now;
>  ctx->timestamp = now;
>
>
> So at this point you would expect timestamp = T2 and time += T2-T0.
>
> Except that: time += T1 - T0 + T2 - T0 != T2 - T0 and
>             timestamp = T1
>
> You can of course write it as something like x86_perf_event_update(),
> but then there's trying to keep total_time_running and
> total_time_enabled in sync.
>
I think it is more complicated than x86_perf_event_update() because, this
time, you have to update 2 fields, i.e., ctx->time, ctx->timestamp. The
difficulty is to backtrack after you've successfully and atomically set
the first one. You cannot just subtract/replace what you've changed
because it was visible by whoever interrupted you. So it is already
too late.

It may be better to try another approach just for PERF_SAMPLE_READ
with its own version of ctx->time. What about if on event_sched_in() you
were snapshotting  ctx->time. Then in the perf_output_read_event(), you'd
have to compute the time delta and add it to this private version of
ctx->time and store that in the sample.


>
>> > Not sure, but barring 64bit atomics for all these, 32bit archs and NMI
>> > are going to be 'interesting'
>> >
>>
>> Every sample needs to be correct, otherwise you run the risk of introducing
>> bias.
>>
>> I think if the tradeoffs is correctness vs. speed, I'd choose correctness.
>
> Well, yes, but it sucks, esp. since its only relevant to
> PERF_SAMPLE_READ.
>

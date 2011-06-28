Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1F1L54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:57:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37724 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1F1L4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:56:04 -0400
MIME-Version: 1.0
In-Reply-To: <1309259105.6701.210.camel@twins>
References: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
	<20110628105335.GA17199@erda.amd.com>
	<1309259105.6701.210.camel@twins>
Date: Tue, 28 Jun 2011 13:56:03 +0200
Message-ID: <BANLkTimcxGWasWqgem=5EYDKGAM+dq26xQ@mail.gmail.com>
Subject: Re: [tip:perf/core] perf: Ignore non-sampling overflows
From: Francis Moreau <francis.moro@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 1:05 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-06-28 at 12:53 +0200, Robert Richter wrote:
>> > --- a/kernel/perf_event.c
>> > +++ b/kernel/perf_event.c
>> > @@ -4240,6 +4240,13 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
>> >     struct hw_perf_event *hwc = &event->hw;
>> >     int ret = 0;
>> >
>> > +   /*
>> > +    * Non-sampling counters might still use the PMI to fold short
>> > +    * hardware counters, ignore those.
>> > +    */
>> > +   if (unlikely(!is_sampling_event(event)))
>> > +           return 0;
>> > +
>
>> do you remember the background of this change. This check silently
>> drops data of non-sampling events. I want to use perf_event_overflow()
>> to write to the buffer and want to modify the check, but don't see
>> which 'accidentally' interrupts may occur that must be ignored.
>
> IIRC this is because we always program the interrupt bit, such that when
> the counter overflows we can account and reprogram the thing. This is
> needed because no hardware counter is in fact 64 bits wide. Therefore we
> have to program the counter to its max width and properly account the
> state and reprogram on overflow.
>
> Imagine a 32bit cycle counter (@1GHz), if we were not to program that as
> taking interrupts and nobody would read that counter for about 4.2
> seconds, we'd have overflowed and lost the actual count value for the
> thing.
>
> So what we do is program is at 31bits (so that the msb can toggle and
> trigger the interrupt), and on interrupt add to event->count, and reset
> the hardware to start counting again.
>
> Now some arch/*/perf_event.c implementations unconditionally called
> perf_event_overflow() from their IRQ handler, even for such non-sampling
> counters.

Yes that's what I recall too.

-- 
Francis

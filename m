Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1F2Kw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:52:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39998 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab1F2Kv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:51:59 -0400
Subject: Re: [tip:perf/core] perf: Ignore non-sampling overflows
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <20110629103714.GM4590@erda.amd.com>
References: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
	 <20110628105335.GA17199@erda.amd.com> <1309259105.6701.210.camel@twins>
	 <BANLkTimcxGWasWqgem=5EYDKGAM+dq26xQ@mail.gmail.com>
	 <20110629103714.GM4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 29 Jun 2011 12:50:55 +0200
Message-ID: <1309344655.6701.1054.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 12:37 +0200, Robert Richter wrote:

> I looked at the interrupt handlers. The events are always determined
> from a per-cpu array:
> 
> 	cpuc = &__get_cpu_var(cpu_hw_events);
> 	...
> 	event = cpuc->events[idx];
> 
> In case of interrupts the event should then always be a hw event (or
> uninitialized).  Even if the interrupt was triggered by a different
> source, it would always be mapped to the same event and the check
> is_sampling_event() would be meaningless.

I'm probably not quite getting what you mean, but how is
is_sampling_event() meaningless? the INT bit is enabled for _all_
events, whether they were configured as a sampling event or not.

Its just that for !sampling events we shouldn't attempt to generate any
output.

> There are other occurrences of perf_event_overflow() in
> kernel/events/core.c for events of type PERF_TYPE_SOFTWARE. These
> events are initialized with sample_period set and a check would always
> be true too.

I'm failing to see what you mean, where do we always set
event->attr.sample_period for software events?

> For both cases I stil don't see a reason for the check.

You're going to have to spell things out for me, I'm really not getting
your argument.

> Anyway, would the following extentension of the check above ok?
> 
> 	if (unlikely(!is_sampling_event(event) && !event->attr.sample_type))
> 		...
> 
> With no bits set in attr.sample_type the sample would be empty and
> nothing to report. Now, with this change, samples that have data to
> report wouldn't be dropped anymore.

Also, could you explain in what way data is dropped? Where do
non-sampling events need to write sample data?

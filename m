Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2JPMVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:21:41 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:49523 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2JPMVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:21:39 -0400
MIME-Version: 1.0
In-Reply-To: <20121016100809.GS8285@erda.amd.com>
References: <20121012012839.GA15348@us.ibm.com>
	<20121015155534.GR8285@erda.amd.com>
	<20121016100809.GS8285@erda.amd.com>
Date: Tue, 16 Oct 2012 14:21:38 +0200
Message-ID: <CABPqkBRd2wfjd1ObCkM+TSSwt7C9WP65dEE9POSyDK1ccvNL8A@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf: Add a few generic stalled-cycles events
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arun Sharma <asharma@fb.com>, Anton Blanchard <anton@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>, mpjohn@us.ibm.com,
        linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 12:08 PM, Robert Richter <robert.richter@amd.com> wrote:
> Sukadev,
>
> On 15.10.12 17:55:34, Robert Richter wrote:
>> On 11.10.12 18:28:39, Sukadev Bhattiprolu wrote:
>> > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FIXED_POINT },
>> > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_LOAD_STORE },
>> > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_INSTRUCTION_FETCH },
>> > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BRANCH },
>>
>> Instead of adding new hardware event types I would prefer to use raw
>> events in conjunction with sysfs, see e.g. the intel-uncore
>> implementation. Something like:
>>
In general, I don't like generic events and especially stall events. I
have not seen a clear definition of
what they mean. Without it, there is no way to understand how to map
them across architecture. If
the definition is too precise, you may not be able to find an exact
mapping. If the definition is to loose
then it is unclear what you are measuring.

Also this opens another can of worms which is that on some processors,
you may need more than
one event to encapsulate what the generic event is supposed to
measure. That means developing
a lot of code in the kernel to express and manage that. And of course,
you would not be able
to sample on those events (you cannot sample on a difference, for
instance). So all in all, I think
this is not a very good idea. You have to put this into the tool or a
library that auto-detects the
host CPU and programs the right set of events.

We've had that discussion many times. Just reiterating my personal
opinion on this.

>>  $ find /sys/bus/event_source/devices/cpu/events/
>>  ...
>>  /sys/bus/event_source/devices/cpu/events/stalled-cycles-fixed-point
>>  /sys/bus/event_source/devices/cpu/events/stalled-cycles-load-store
>>  /sys/bus/event_source/devices/cpu/events/stalled-cycles-instruction-fetch
>>  /sys/bus/event_source/devices/cpu/events/stalled-cycles-branch
>>  ...
>>  $ cat /sys/bus/event_source/devices/cpu/events/stalled-cycles-fixed-point
>>  event=0xff,umask=0x00
>>
>> Perf tool works then out-of-the-box with:
>>
>>  $ perf record -e cpu/stalled-cycles-fixed-point/ ...
>
> I refer here to arch/x86/kernel/cpu/perf_event_intel_uncore.c (should
> be in v3.7-rc1 or tip:perf/core). See the INTEL_UNCORE_EVENT_DESC()
> macro and 'if (type->event_descs) ...' in uncore_type_init(). The code
> should be reworked to be non-architectural.
>
> PMU registration is implemented for a longer time already for all
> architectures and pmu types:
>
>  /sys/bus/event_source/devices/*
>
> But
>
>  /sys/bus/event_source/devices/*/events/
>
> exists only for a small number of pmus. Perf tool support of this was
> implemented with:
>
>  a6146d5 perf/tool: Add PMU event alias support
>
> -Robert
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>

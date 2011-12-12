Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1LLDpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:45:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46411 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab1LLDpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:45:21 -0500
MIME-Version: 1.0
In-Reply-To: <1323608131.16764.19.camel@twins>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
	<1323559734-3488-3-git-send-email-eranian@google.com>
	<20111211080138.GB20790@elte.hu>
	<1323608131.16764.19.camel@twins>
Date: Sun, 11 Dec 2011 19:45:20 -0800
Message-ID: <CABPqkBQjCg6V66=z6bvosC0OXCy4FxVFNBWw_XWU=0TPmU1N4g@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES generic
 PMU event
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 4:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2011-12-11 at 09:01 +0100, Ingo Molnar wrote:
>> > +     PERF_COUNT_HW_REF_CPU_CYCLES            = 9,
>>
>> Btw., that was what 'bus cycles' tried to do a long time ago:
>> the constant, non-variable baseline heartbeat of the system.
>
> This isn't about that. Its about exposing the third fixed purpose
> counter. Intel, in their infinite wisdom, created a fixed purpose
> counter for which there is no equivalent in the general purpose events.
>
Peter is correct.

> Our fixed purpose counter support is predicated on the assumption that
> there is, and simply maps any event code to also include the fixed
> purpose counter if appropriate.
>
True.

> There not being an event to map from has thus far avoided exposing this
> third fixed purpose event.
>
> The problem with remapping BUS_CYCLES is that BUS_CYCLES (now) is
> something you can program on the {2,4,8} general purpose counters,
> whereas this new thing can only ever be ran from the 1 fixed purpose
> counter.
>
Fixed counter event do NOT have encodings. By constructions, this is
not needed. So far, perf_events was able to access 2 of the 3 fixed counter
events ONLY because they could ALSO be measured on generic counters.
In fact, the event scheduling algorithm as it stood until the AMD changes, put
those events on generic counters first, then fixed counters if needed.
But fixed counter 2 (counting unhalted_ref_cycles) is different. It cannot be
measured on generic counters.

BUS_CYCLES maps to an encoding for generic counters and it does count
clock ticks but not at the same rate as unhalted_reference_cycles (i.e., fixed
counter 2). In general bus_cycles counts at about 266Mhz  but could be higher
on some systems.
$ perf stat -e bus-cycles noploop 1
noploop for 1 seconds
 Performance counter stats for 'noploop 1':
         266062586 bus-cycles

Although there is a fixed ratio between that bus_cycles
(cpu_clk_unhalted:ref_p or bus)
and unhalted_reference_cycles, getting to it may not be easy. And then, if
you knew it, it could be kind of ugly to special case this event to adjust it
to count core ref cycles.

The patch chooses an encoding for the event, which means we can now name it.
The kernel then knows about that event (mapping table) and can avoid expanding
its list of supported counters to the generic counters.

I think expanding the list of generic HW events with this new one is
the simplest
way to make it available to tools. Users of raw events (like me) can also
use it via the raw encoding.

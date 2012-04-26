Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2DZMyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:54:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39606 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab2DZMyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:54:00 -0400
MIME-Version: 1.0
In-Reply-To: <1335436031.13683.6.camel@twins>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
	<1335178132.28150.117.camel@twins>
	<CABPqkBQ2w3RLRwq3fsaJQ_L=_=H+5kounBeuxUv_fk1ksimTOQ@mail.gmail.com>
	<1335436031.13683.6.camel@twins>
Date: Thu, 26 Apr 2012 14:53:58 +0200
Message-ID: <CABPqkBQdkWWgOoXU+ugJiTC=X=5+7OYZ5_K71KhUJTw7jq6+Rg@mail.gmail.com>
Subject: Re: [BUG] perf stat: useless output for raw events with new event parser
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        David Ahern <dsahern@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 12:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-04-23 at 13:17 +0200, Stephane Eranian wrote:
>> On Mon, Apr 23, 2012 at 12:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2012-04-23 at 12:45 +0200, Stephane Eranian wrote:
>> >> Hi,
>> >>
>> >> With the new event parser, one can express raw events field by field:
>> >>
>> >> $ perf stat -e cpu/event=0x3c,umask=0x0/,cpu/event=0xc5,umask=0x0/ noploop 1
>> >>
>> >> The problem with this is that the output of perf stat becomes useless:
>> >>
>> >> $ perf stat -e cpu/event=0x3c,umask=0x0/,cpu/event=0xc5,umask=0x0/ noploop 1
>> >> noploop for 1 seconds
>> >>
>> >>  Performance counter stats for 'noploop 1':
>> >>
>> >>         2395038678 pmu
>> >>             10787 pmu
>> >>                        ^^^^^^
>> >>        1.000802603 seconds time elapsed
>> >
>> > Yeah, I already complained about that.. Jolsa proposed adding a name=
>> > parameter so you could explicitly name your events. I think I've seen a
>> > patch adding that, but can't atm seem to locate it.
>> >
>> If the proposed solution is to add a pseudo field called "name", then I don't
>> see the point of this new parser compared to directly using my libpfm4
>> library which already allows:
>>
>>  perf stat -e inst_retired:any,wsm_unc:unc_cycles:u ...
>> And
>>  perf record -e instr_retired:period=200000,cpu_clk_unhalted:freq=100 ...
>>
>> If you have to make up names, you might as well, use the actual PMU
>> event names, but if you do so, why would you have to bother breaking
>> down the encoding into fields?
>
> I'd like to use the event names, but really, when you do:
>
>  cpu/event=instructions_retired,inv,cmask=16/
>
> is it still instructions_retired?

Yes, to some extent. Remember this is not equivalent to
unhalted_core_cycles.

I think this new syntax is too heavy. Again, all you need to know
is the event name + umask + modifiers (inv, cmask, edge, u, k).
You can structure the event string to make the tool auto detect
which string is pmu vs. event name vs. umask vs. modifier.


>
> In SFO we spoke about exporting those event tables you have in libpfm4
> in some structured file format so that we both might use them, the
> primary difficulty in that (IIRC) was the umask constraints per event.
>
Yes, for now the tables are C tables inside the library. This allows some
flexibility. Not all tables have the same format. But you can also express
more sophisticated umask constraints. For instance, offcore_response
where you need a request umask + a response umask on WSM. On
SNB is it even more complicated. Of course, the alternative it just
to have a flat list enumerating ALL the possible valid combinations.
But you have an explosion with WSM/SNB and offcore_response, though
maybe only few dozens do really make sense.

So I suspect for an extern text file, a flat list would make more sense even
though is would take up some memory to hold it. But then we'd have only
a couple of tables loaded per process (core, uncore, ...).

> I'm not too overly bothered by people specifying wrong events (at some
> point they really had better know wth they're doing anyway), so can we
> start with something that mostly works?
>
Yes, at the end of the day you need to understand how the hw works
and what the events actually measures, otherwise you won't accomplish
anything useful.

> I've already spoken with Jiri about adding this before all this parser
> stuff got implemented, so it should all be quite possible to add.
>
You mean as you suggested above?

I tried that 3 weeks ago and as I ran into a major issue having to do
with loss of semantic of the terms (event, umask) in the parser code.
Also I wonder how the syntax would accomodate umask combinations.
The problem is that you need to know that the keyword "event" refers
to the event code and "umask" to the event umask. Without that, hard
to lookup the event string and umask string properly. You need to know
you're looking for an event name vs. a umask name. That's regardless
of the fact that the table is internal to a library or in an external text file.
To work around that, you'd have to ass the content of the syfs format/event
file to machine specific code which would recognize the attr  + bit field and
determine whether or not this corresponds to an event code or umask. That's
pretty ugly. Especially given that I have proof that you don't need to
go through
all of this to get something working.

The advantage of the library is that is can be used for
self-monitoring programs.
Therefore the event syntax would remain identical. It can work on
non-Linux systems
as well. The library is layered between HW and OS.

> Furthermore, once we have a common format, we could even ask Intel/AMD
> (and other vendors) to provide their data in this format.
>
I am already doing that.

I think having external event tables would make it easier for people
to customize.
It would also decrease the memory footprint but it would probably increase the
startup time as you'd have to identify the event table and load it (parse it) on
demand. It is definitively something I want to pursue. I already
started experimenting
with it using JSON for the external file syntax.

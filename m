Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1ASPda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:33:30 -0500
Received: from mail.openrapids.net ([64.15.138.104]:42308 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753597Ab1ASPd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:33:28 -0500
Date: Wed, 19 Jan 2011 10:33:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119153326.GC11022@Krystal>
References: <1295382144.12215.123.camel@gandalf.stny.rr.com> <20110119050844.GA8776@Krystal> <20110118.223247.241909079.davem@davemloft.net> <20110118.232045.58440904.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118.232045.58440904.davem@davemloft.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:11:46 up 56 days, 20:14,  5 users,  load average: 0.26, 0.17,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 18 Jan 2011 22:32:47 -0800 (PST)
> 
> > As far as GCC can see, the object is static and also not part of an
> > array or any other C construct for which things like this could matter
> > as long as the alignment it chooses meets the minimum alignment
> > requirements of the ABI.
> > 
> > So it doesn't let us do this trick where we put the individual event
> > markers into a special section, yet mark it __used and static, then
> > later access them as if they were part of a globally visible array.
> > 
> > If you look these static objects, they are emitted with a leading
> > ".align 32" directive.  This is what screws everything up.
> > 
> > When the linker sees this, it aligns the start of every individual
> > "_ftrace_events" section, and that's where the "gaps" come from and
> > the crashes.
> 
> I've come up with one possible way to deal with this.
> 
> Put pointers to the trace objects into the special section, and
> interate over those instead.
> 
> I was wondering why this x86-64 weird alignment behavior doesn't bite
> us for our init funcs.  And the reason is that all of these weird
> alignment cases only trigger for aggregates (ie. structs and unions).
> 
> So we could do:
> 
> 	static struct ftace_event_call foo_event = { ... };
> 	static struct ftrace_event_call * __used
> 		__attribute__((section("_ftrace_event_ptrs")))
> 		foo_event_ptr = &foo_event;
> 
> and
> 
> 	extern struct ftrace_event_call *__start_ftrace_event_ptrs[];
> 	extern struct ftrace_event_call *__end_ftrace_event_ptrs[];
> 
> 	struct ftrace_event_call **p = __start_ftrace_event_ptrs;
> 	while (p < &__end_ftrace_event_ptrs[0]) {
> 		struct ftrace_event_call *event = *p++;
> 
> 		__trace_add_event_call(event, ...);
> 	}
> 
> you get the idea.
> 
> And we could mark this entire point section as "initdata" and thus
> free'able after bootup and post module load.

There are three downsides to this approach compared to forcing both the type and
variable alignments with attributes:

1) It consumes extra space: This approach lets gcc align foo_event on 32-byte
   boundaries, which is unneeded in this case. For structures repeated very
   often, this is a bad thing.

2) It mixes .data and struct ftrace_event_call definitions, thus polluting .data
   cache-lines (actually, the 32-byte alignment will leave some of these
   cachelines partly unused). This would be fixable by specifying yet another
   section name to hold the struct ftace_event_call definitions.

3) Freeing _ftrace_event_ptrs is only possible after init here because Ftrace
   data layout is sub-optimal. The linked-list created at init time by Ftrace
   kind of duplicates the arrays already implicit to the section. If we look at
   Tracepoints for example, which present the exact same section alignment
   problem, we iterate on the tracepoint section each time a tracepoint is
   activated or deactivated. So we need to keep the section there after init.
   Therefore, your indirection approach would grow the data footprint.
   The trade-off here is that walking the table is a very rare operation that
   does not need to be fast, so we accept the performance hit of walking the
   tracepoint table for each enabled tracepoint to shrink the memory footprint.

Especially for reasons (1) and (2), I'd be tempted to go for the
__long_long_aligned type and variable attribute instead. Thoughts ?

I'm still unsure that __long_long_aligned is needed over __long_aligned though.
AFAIK, the only requirement we have for, e.g. tracepoints, is to align on the
pointer size (sizeof(long)), so RCU pointer updates are performed atomically.
Aligning on the pointer size also allows the architecture to efficiently read
the field content. What does aligning on sizeof(long long) bring to us ? Is it
that you are concerned about the fact that the "aligned" type attribute, when
applied to a structure, is only used as a lower-bound by the compiler ? In that
case, we might want to consider using "packed" too:

#define __long_packed_aligned __attribute__((__packed__, __aligned__(__alignof__(long))))

I would just like to know if this attribute causes gcc to emit slower memory
access instructions on ppc/sparc/mips (I remember that at least one of these
emit slower instructions for unaligned read/writes, so I wonder if the compiler
uses them as soon as it sees the "packed" attribute, or if it is more clever
than that).

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

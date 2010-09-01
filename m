Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0IAWRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 18:17:36 -0400
Received: from mail.openrapids.net ([64.15.138.104]:55051 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752716Ab0IAWRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 18:17:35 -0400
Date: Wed, 1 Sep 2010 18:17:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Spear, Aaron" <aaron_spear@mentor.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        ltt-dev@lists.casi.polymtl.ca,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Martinez Ed-R12594 <r12594@freescale.com>,
        George Stephen-RVGG20 <RVGG20@freescale.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        "Burton, Felix" <Felix.Burton@windriver.com>,
        "Maisonneuve, Philippe" <Philippe.Maisonneuve@windriver.com>,
        "McDermott, Andrew" <Andrew.McDermott@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Michael Rubin <mrubin@google.com>,
        Michel Dagenais <michel.dagenais@polymtl.ca>,
        Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
        Joe Green <jgreen@mvista.com>,
        Tasneem Brutch - SISA <t.brutch@sisa.samsung.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] Common Trace Format Requirements (v1.3)
Message-ID: <20100901221731.GB4231@Krystal>
References: <20100831145030.GA18176@Krystal> <20100831153650.GI3185@redhat.com> <20100831163722.GA27279@Krystal> <20100831170453.GA5762@redhat.com> <20100831173019.GA1163@Krystal> <D86DB60C62D82A4792CAEC7F58CA04E70767A61E@NA1-MAIL.mgc.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D86DB60C62D82A4792CAEC7F58CA04E70767A61E@NA1-MAIL.mgc.mentorg.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:03:53 up 222 days, 40 min,  4 users,  load average: 0.02,
	0.05, 0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry, I had to remove a few CC to stop triggering LKML spam filter)

* Spear, Aaron (aaron_spear@mentor.com) wrote:
> > > > > If the metadata is not given in a standard form, then how do
> > > > > envision general trace analysis tools (those not hard-coded for
> > > > > some particular trace source) working?
> > >
> > > > We can have a metadata format selector at the beginning of the
> > > > metadata section, with reserved IDs for metadata formats. We can
> > > > think of a format generated natively by TRACE_EVENT(), a format
> > > > generated in some sort of XML. The trace analyzer would need the
> > > > metadata format parser in order to be able to read the trace.
> > >
> > > If one hopes that such tools should be able to consume data with
> > > drifting versions of TRACE_EVENT() or XML or whatnot, they
> themselves
> > > had better be fixed/standardized.  Otherwise, the data will not be
> > > self-describing, and all the tools will have to chase kernel/etc.
> > > versions.
> > 
> > The tool can bail out if it detects a type it does not know. So a tool
> > upgrade would be required.
> > 
> > Also the standard plans to have a major/minor trace version in there,
> > so we can explicitly break compatibility if it is required. It might
> > end up being much better than trying to support backward compatibility
> > forever. Then it would be up to the tool implementors to choose if
> they
> > want to provide backward compatibility for older trace versions or
> not.
> 
> What we have done in our own internal format (which I distributed for
> reference some time ago) is have a fixed set of fundamental types that
> can be inserted into the trace log (integers of various bit sizes,
> strings, Booleans, etc).  An event in the log is a collection of these
> fundamental types then,  (e.g. a semaphore post event might have a 16
> bit unsigned event id, a 32 bit unsigned semaphore handle, 32 bit
> unsigned current thread id, 64 bit timestamp, ...).  So at a base layer
> there can be a trace analyzer that simply knows how to display
> attributes of events but doesn't really know what they MEAN.

I agree that we have to describe types in the metadata, although I fear the
definitions of "basic types" differs widely depending on the execution context.
For instance, the Linux kernel just doesn't care about floating point values.
So I'd be tempted to treat all types in the same way, which means that all types
would be "optional". It's only if they are present in the trace that their
description becomes required.

>  On top of
> that you can layer plugin functionality in a trace analyzer that
> understands what a given type of event means and as such what sort of
> thing makes the most sense to do in a presentation.  Scheduling is a
> good example.  If there are scheduler events that indicate context
> switches, then if the trace analyzer knows this, it can use that
> information to help it draw a nice Gantt chart as opposed to a linear
> graph of simple event data.
> 
> I have been hoping that as a part of this standard that we will end up
> with common schemas for meta-data that are shared by various use cases,
> so that things that are common concepts to many OS'es for example could
> in fact be shared and thus you could have a trace analyzer that works
> for OS'es that have similar models and generate data in a compatible
> schema.  In practice this may be difficult, but it seems like a noble
> goal to aim for.  If we can get a fixed schema for the fundamental types
> that will be a step in the right direction. 

Those are very good ideas. Here is what I plan to add in the next RFC version.
Adding a per-event taxonomy to the metadata would allow automated creation of
a state machine in the trace analyzer that keeps track of state updates within
the taxonomy tree. So we can automate this tedious task rather than creating
custom plugins that each need deep knowledge about the events.

About the items below, I must remind everyone that this information is only
described _once per trace_ in the metadata section.

1.2) Extensions (optional capabilities)
  ...
  - Metadata
  ...

  - Optional per-event "current state tracking" information.
    Described in an file-system path-like taxonomy with additional []
    operator which indicates a lookup by value, e.g.:

    * For events in the trace stream updating the current state only based on
      information known from the context (either derived from the per-section or
      per-event context information):

    E.g., associated with a scheduling change event:

    "cpu[section/cpu]/thread = field/next_pid"
       Updates the current value of the current section's cpu "thread" attribute
       (e.g. currently running thread).

    E.g., associated with a system call:

    "thread[cpu[section/cpu]/thread]/syscall[field/syscall_id]/id
       = field/syscall_id"

       Updates the state value of the current thread "syscall" attribute.

    * For events in the trace stream targeting a path that depends on other
      fields into that same event (would be common for full system state dump at
      trace start):

    E.g., associated with a thread listing event:
    "thread[field/pid]/pid = field/pid"

    E.g., associated with a thread memory maps listing event:
    "thread[field/pid]/mmap[field/address]/address = field/address"
    "thread[field/pid]/mmap[field/address]/end = field/end"
    "thread[field/pid]/mmap[field/address]/flags = field/flags"
    "thread[field/pid]/mmap[field/address]/pgoff = field/pgoff"
    "thread[field/pid]/mmap[field/address]/inode = field/inode"

    All per-event context information (e.g. repeating the current PID and CPU
    for each event) can be represented with this taxonomy, e.g., in the
    section description:

    "section/pid = field/pid"
    "section/cpu = field/cpu"


Thanks !

Mathieu

> 
> Best regards,
> Aaron Spear
> Tools Architect, Mentor Graphics

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

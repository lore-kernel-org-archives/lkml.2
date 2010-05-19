Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0ESQIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:08:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0ESQIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:08:15 -0400
X-Authority-Analysis: v=1.1 cv=XlIRUSWzFvHiorqRgyN8fup7OiOLcGcwhtEWqPJTlSs= c=1 sm=0 a=1hn_8qm_4N4A:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=SXHWLqUM6VbhrehlSFwA:9 a=P2WmBIBO95OBq11lkC8A:7 a=bTbUdyvzU4Hu0b6zwC4rsK5d7R8A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH 5/5] perf: Implement perf_output_addr()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1274284201.5605.11212.camel@twins>
References: <20100518133258.000434886@chello.nl>
	 <20100518133726.214318408@chello.nl>  <20100519072138.GC5704@nowhere>
	 <1274255882.5605.10216.camel@twins>
	 <1274280439.26328.770.camel@gandalf.stny.rr.com>
	 <1274281506.5605.11111.camel@twins>
	 <1274283492.26328.779.camel@gandalf.stny.rr.com>
	 <1274284201.5605.11212.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 19 May 2010 12:08:13 -0400
Message-ID: <1274285293.26328.788.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 17:50 +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 11:38 -0400, Steven Rostedt wrote:
> 
> > > No, but suppose the tracepoint has a racy expression in it. Having to
> > > evaluate { assign; } multiple times could yield different results, which
> > > in turn means you have to run the filter multiple times too, etc..
> > 
> > I'm still a bit confused by what you mean here. Could you show an
> > example?
> 
> Well, suppose { assign; } contains:
> 
>  entry->foo = atomic_read(&bar);
> 
> Now suppose you have multiple active consumers of the tracepoint, either
> you do the evaluation once and copy that around, or you do it multiple
> times and end up with different results.

OK, this is where I'm getting a bit lost. The "multiple active
consumers". Is this multiple instances of perf? Or perf doing multiple
things with that event using different buffers?

> 
> > > Although I suppose you could delay the commit of the first even and copy
> > > from there into the next events, but that might give rather messy code.
> > > 
> > > > Note, the shrinking of the TRACE_EVENT() code that I pushed (and I'm
> > > > hoping makes it to 35 since it lays the ground work for lots of features
> > > > on top of TRACE_EVENT()), allows you to pass private data to each probe
> > > > registered to the tracepoint. Letting the same function handle two
> > > > different activities, or different tracepoints.
> > > 
> > > tracepoint_probe_register() is useless, it requires scheduling. I
> > > currently register a probe on pref_event creation and then maintain a
> > > per-cpu hlist of active events.
> > 
> > When is perf_event creation? When the user runs the code or at boot up?
> 
> sys_perf_counter_open()
> 
> And an event could be per task, so it needs to be scheduled along with
> the task context, try doing that with probes ;-)

Ah, this is basically the same thing that ftrace does too. It only
enables the tracepoint (or function tracer) at initiation of the trace,
and uses things like a hash table to determine if the event (or
function) should be traced or not.

> 
> > Hmm, could be, don't know for sure. I just want to keep the macro magic
> > to a minimum ;-)
> 
> Right, but filters evaluated at the point where you basically already
> done all the hard work simply don't make much sense in my book.

Well, the hard work was just to reserve the buffer, which is under 100ns
to do. But we still need the assign, because the filters compare the
result of those assigns.

I guess you are saying that if we have a filter, we need to do the
assign to a temporary buffer, evaluate, and then decide if we should
record it (via copy) or not.

-- Steve



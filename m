Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0ESPu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:50:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab0ESPuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:50:25 -0400
Subject: Re: [RFC PATCH 5/5] perf: Implement perf_output_addr()
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1274283492.26328.779.camel@gandalf.stny.rr.com>
References: <20100518133258.000434886@chello.nl>
	 <20100518133726.214318408@chello.nl>  <20100519072138.GC5704@nowhere>
	 <1274255882.5605.10216.camel@twins>
	 <1274280439.26328.770.camel@gandalf.stny.rr.com>
	 <1274281506.5605.11111.camel@twins>
	 <1274283492.26328.779.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 17:50:01 +0200
Message-ID: <1274284201.5605.11212.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 11:38 -0400, Steven Rostedt wrote:

> > No, but suppose the tracepoint has a racy expression in it. Having to
> > evaluate { assign; } multiple times could yield different results, which
> > in turn means you have to run the filter multiple times too, etc..
> 
> I'm still a bit confused by what you mean here. Could you show an
> example?

Well, suppose { assign; } contains:

 entry->foo = atomic_read(&bar);

Now suppose you have multiple active consumers of the tracepoint, either
you do the evaluation once and copy that around, or you do it multiple
times and end up with different results.

> > Although I suppose you could delay the commit of the first even and copy
> > from there into the next events, but that might give rather messy code.
> > 
> > > Note, the shrinking of the TRACE_EVENT() code that I pushed (and I'm
> > > hoping makes it to 35 since it lays the ground work for lots of features
> > > on top of TRACE_EVENT()), allows you to pass private data to each probe
> > > registered to the tracepoint. Letting the same function handle two
> > > different activities, or different tracepoints.
> > 
> > tracepoint_probe_register() is useless, it requires scheduling. I
> > currently register a probe on pref_event creation and then maintain a
> > per-cpu hlist of active events.
> 
> When is perf_event creation? When the user runs the code or at boot up?

sys_perf_counter_open()

And an event could be per task, so it needs to be scheduled along with
the task context, try doing that with probes ;-)

> Hmm, could be, don't know for sure. I just want to keep the macro magic
> to a minimum ;-)

Right, but filters evaluated at the point where you basically already
done all the hard work simply don't make much sense in my book.

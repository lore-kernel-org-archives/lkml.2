Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab0ESPFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:05:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41762 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0ESPFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:05:31 -0400
Subject: Re: [RFC PATCH 5/5] perf: Implement perf_output_addr()
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1274280439.26328.770.camel@gandalf.stny.rr.com>
References: <20100518133258.000434886@chello.nl>
	 <20100518133726.214318408@chello.nl>  <20100519072138.GC5704@nowhere>
	 <1274255882.5605.10216.camel@twins>
	 <1274280439.26328.770.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 17:05:06 +0200
Message-ID: <1274281506.5605.11111.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 10:47 -0400, Steven Rostedt wrote:
> On Wed, 2010-05-19 at 09:58 +0200, Peter Zijlstra wrote:
> > On Wed, 2010-05-19 at 09:21 +0200, Frederic Weisbecker wrote:
> > 
> > > I'm still not sure what you mean here by this multiplexing. Is
> > > this about per cpu multiplexing?
> > 
> > Suppose there's two events attached to the same tracepoint. Will you
> > write the tracepoint twice and risk different data in each, or will you
> > do it once and copy it into each buffer?
> 
> Is this because the same function deals with the same tracepoint, and
> has difficulty in knowing which event it is dealing with?

No, but suppose the tracepoint has a racy expression in it. Having to
evaluate { assign; } multiple times could yield different results, which
in turn means you have to run the filter multiple times too, etc..

Although I suppose you could delay the commit of the first even and copy
from there into the next events, but that might give rather messy code.

> Note, the shrinking of the TRACE_EVENT() code that I pushed (and I'm
> hoping makes it to 35 since it lays the ground work for lots of features
> on top of TRACE_EVENT()), allows you to pass private data to each probe
> registered to the tracepoint. Letting the same function handle two
> different activities, or different tracepoints.

tracepoint_probe_register() is useless, it requires scheduling. I
currently register a probe on pref_event creation and then maintain a
per-cpu hlist of active events.

> > > There is another problem. We need something like
> > > perf_output_discard() in case the filter reject the event (which
> > > must be filled for this check to happen).
> > 
> > Yeah, I utterly hate that, I opted to let anything with a filter take
> > the slow path. Not only would I have to add a discard, but I'd have to
> > decrement the counter as well, which is a big no-no.
> 
> Hmm, this would impact performance on system wide recording of events
> that are filtered. One would think adding a filter would speed things
> up, not slow it down.

Depends, actually running the filter and backing out might take more
time than simply logging it, esp if you've already done all of the work
and only lack a commit.

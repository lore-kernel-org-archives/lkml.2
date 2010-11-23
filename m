Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab0KWV3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:29:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60899 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0KWV3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:29:45 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=VINkOuZDQI4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=bFFpurj40r1yWggvNcwA:9 a=HpFZT6cC3ci4AKUsP8kA:7 a=oya3Zwdy9X04qhNyp99ce0bKziMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1290007007.2109.925.camel@laptop>
References: <20101117005357.024472450@goodmis.org>
	 <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de>
	 <20101117103914.GA21976@elte.hu>
	 <1289996753.30543.35.camel@gandalf.stny.rr.com>
	 <1290007007.2109.925.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 16:29:42 -0500
Message-ID: <1290547782.30543.397.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if the stable vs debug tracepoints debate is dead.

On Wed, 2010-11-17 at 16:16 +0100, Peter Zijlstra wrote:


> 
> > Are these events now going to be labeled as stable? 
> 
> For now I'm concentrating on the hardware events, those are more or less
> stable in that if you run it on the same hardware you get the same thing
> counted. Different hardware may miss some events since it simply cannot
> provide anything resembling, or count something related but slightly
> different (speculative vs retired events, or different cache level, or a
> slightly different definition of miss etc..)
> 
> Basically the same we already have with the perf 'generic' events.
> 
> >  Is every tracepoint
> > we have, much have the same data?  Linus specifically said at Kernel
> > Summit that he wants absolutely NO modules to have a stable tracepoint.
> > 
> > Also, if we just blindly label a tracepoint as "stable" then we must
> > keep all its contents. For example, the sched_switch will contain the
> > priority. As Peter has stated several times, that may go away. We also
> > do not want to lose getting that information, as a lot of us use it.
> 
> For now I've not at all looked at representing tracepoints in sysfs, for
> the hardware bits I'm looking to place the event_source (formerly known
> as PMU) in the hardware topology already present in /sys/devices/.
> 
> One suggestion was to place the software and tracepoint events
> in /sys/kernel/ some place. Another was to place driver specific, say
> wifi things near the wifi driver node.


Should we create a /sys/kernel/tracepoints/

directory for the stable tracepoints. And then have these directories
have the format of those tracepoints? Or is that against the "sysfs"
rule of only having a single line per file? The format is multi lines.


> 
> None of the proposals have dealt with the stable vs debug thing, simply
> because none of them were post KS.
> 
> 
> > Some distros already mount debugfs by default. It's a oneliner in fstab.
> 
> I haven't yet seen that.. maybe its automounted on /sys/kernel/debug/ or
> some daft place like that by magic initscipts outside of fstab but I'd
> not notice that.

I'd still like to keep the general tracepoints in something
like /sys/kernel/debug/events/... using the same format that we come up
with for stable tracepoints. The fact that you need to mount the debugfs
system to use it, should help keep some tools from using it.


> 
> > > 
> > > So putting it into sysfs looks like a pretty intelligent solution all around and i'd 
> > > prefer it.
> > 
> > Another downside is that you need to scan hundreds of directories to
> > find tracepoints. And again, are they all now stable?
> 
> Not really, they'd be accessible through the bus structure, something
> like:
> 
> /sys/bus/event_source/*/events/*

That's for every event? Or just software ones?

> 
> Sure, that's more than 1 directory, but then so
> is /debug/tracing/events/*/*/
> 
> 
> > > Steve, would you be interested in helping out Lin Ming and PeterZ with the sysfs 
> > > work - or at least help them come to the conclusion that we want eventfs?
> > 
> > I don't think I would be much help with the former, and I'm thinking I'm
> > losing the later.
> 
> Yeah, eventfs simply won't work for what we want to do with hardware
> events.

Well, hardware events are something that only depends on what you have
for hardware. I wasn't thinking of putting them in with the software
events. They probably should be separate.

Can the hardware events be traced? That is, not just profiled, but have
them traced for when they occur individually.


I'll go work on other things until we can come up with an agreement. I
hate to keep wasting days of work just to have someone NAK it again.

-- Steve



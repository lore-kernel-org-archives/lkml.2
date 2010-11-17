Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806Ab0KQPRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:17:05 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40962 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782Ab0KQPRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:17:04 -0500
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
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
In-Reply-To: <1289996753.30543.35.camel@gandalf.stny.rr.com>
References: <20101117005357.024472450@goodmis.org>
	 <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de>
	 <20101117103914.GA21976@elte.hu>
	 <1289996753.30543.35.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 16:16:47 +0100
Message-ID: <1290007007.2109.925.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 07:25 -0500, Steven Rostedt wrote:
> On Wed, 2010-11-17 at 11:39 +0100, Ingo Molnar wrote:

> > I also explained it in that eventfs suggestion thread that eventfs (or, indeed 
> > tracefs) is IMO only a second tier approach compared to the real thing: proper 
> > enumeration of events in sysfs.
> > 
> > [ Beyond the obvious compatibility detail that we are _NOT_ getting rid of 
> >   /debug/tracing/events/, as existing tooling depends on it. So unless eventfs or 
> >   sysfs integration brings some real tangible benefits over what we have already we 
> >   dont want to force tooling to migrate to yet another API. ]
> 
> One benefit is that we have a way to distinguish between
> in-field-debugging tracepoints and tracepoints that are only for
> analysis tools.

Right, and there was a clear consensus that that was a desired thing,
have a strong signal towards tool authors to request 'stable'
tracepoints or live with the fact they have to cope with the thing
changing.

As to the whole /debug/tracing/events thing, we can deprecate it like we
have done so many interfaces, provided we have indeed provided an
alternative interface.

> > Lin Ming and PeterZ are working on sysfs integration and they have posted several 
> > iterations of that work which extends event details to sysfs. That work is not 
> > complete yet and they need help. (I've Cc:-ed them.)
> 
> Actually, I suck at adding anything to the sysfs/kobject code. I always
> screw it up. I only got the /sys/kernel/events working because I copied
> it directly from Greg. I doubt I'd be much help.

Yeah, I suck at it too, sysfs is scary. Luckily Kay is helping me out.


> Are these events now going to be labeled as stable? 

For now I'm concentrating on the hardware events, those are more or less
stable in that if you run it on the same hardware you get the same thing
counted. Different hardware may miss some events since it simply cannot
provide anything resembling, or count something related but slightly
different (speculative vs retired events, or different cache level, or a
slightly different definition of miss etc..)

Basically the same we already have with the perf 'generic' events.

>  Is every tracepoint
> we have, much have the same data?  Linus specifically said at Kernel
> Summit that he wants absolutely NO modules to have a stable tracepoint.
> 
> Also, if we just blindly label a tracepoint as "stable" then we must
> keep all its contents. For example, the sched_switch will contain the
> priority. As Peter has stated several times, that may go away. We also
> do not want to lose getting that information, as a lot of us use it.

For now I've not at all looked at representing tracepoints in sysfs, for
the hardware bits I'm looking to place the event_source (formerly known
as PMU) in the hardware topology already present in /sys/devices/.

One suggestion was to place the software and tracepoint events
in /sys/kernel/ some place. Another was to place driver specific, say
wifi things near the wifi driver node.

None of the proposals have dealt with the stable vs debug thing, simply
because none of them were post KS.


> Some distros already mount debugfs by default. It's a oneliner in fstab.

I haven't yet seen that.. maybe its automounted on /sys/kernel/debug/ or
some daft place like that by magic initscipts outside of fstab but I'd
not notice that.

> > 
> > So putting it into sysfs looks like a pretty intelligent solution all around and i'd 
> > prefer it.
> 
> Another downside is that you need to scan hundreds of directories to
> find tracepoints. And again, are they all now stable?

Not really, they'd be accessible through the bus structure, something
like:

/sys/bus/event_source/*/events/*

Sure, that's more than 1 directory, but then so
is /debug/tracing/events/*/*/


> > Steve, would you be interested in helping out Lin Ming and PeterZ with the sysfs 
> > work - or at least help them come to the conclusion that we want eventfs?
> 
> I don't think I would be much help with the former, and I'm thinking I'm
> losing the later.

Yeah, eventfs simply won't work for what we want to do with hardware
events.

> Hmm, seems that every decision that we came to agreement with at Kernel
> Summit has been declined in practice. Makes me think that Kernel Summit
> is pointless, and was a waste of my time. :-(

Well, I don't know, clearly Ingo seems to disagree, but then he wasn't
at KS. Thomas and me were, and neither of us really see a problem with
the stable vs debug things (at least, I didn't hear tglx protest).

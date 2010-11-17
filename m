Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907Ab0KQKkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:40:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57301 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741Ab0KQKkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:40:05 -0500
Date: Wed, 17 Nov 2010 11:39:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
Message-ID: <20101117103914.GA21976@elte.hu>
References: <20101117005357.024472450@goodmis.org>
 <20101117005939.600541101@goodmis.org>
 <20101117033242.GB31335@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117033242.GB31335@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> On Tue, Nov 16, 2010 at 07:53:58PM -0500, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Copied mostly from debugfs, the eventfs is the filesystem that will include 
> > stable tracepoints. Currently nothing enables this filesystem as of this patch.
> 
> What?  Wait, I wrote tracefs a long time ago just for this, why not take that code 
> and use it instead?

Yeah, and i know that i suggested 'eventfs' to Steve and others in a prior thread a 
few months ago - and i suspect Steve was following up on that suggestion with this 
patch? So i guess it's partly my fault ;-)

[ Also, i think our _real_ problems with tracing lie entirely elsewhere, but i've
  explained that numerous times. Maintaining instrumentation bits is the ultimate
  cat herding experience ;-) ]

I also explained it in that eventfs suggestion thread that eventfs (or, indeed 
tracefs) is IMO only a second tier approach compared to the real thing: proper 
enumeration of events in sysfs.

[ Beyond the obvious compatibility detail that we are _NOT_ getting rid of 
  /debug/tracing/events/, as existing tooling depends on it. So unless eventfs or 
  sysfs integration brings some real tangible benefits over what we have already we 
  dont want to force tooling to migrate to yet another API. ]

Lin Ming and PeterZ are working on sysfs integration and they have posted several 
iterations of that work which extends event details to sysfs. That work is not 
complete yet and they need help. (I've Cc:-ed them.)

The sysfs approach has numerous upsides:

 - Design: sysfs is a mature, multi-year project with tons of meaningful hardware 
   and software hieararchies already well established. Attaching events to these
   existing nodes optionally is an obvious advantage and avoids duplication and
   forces people to think about structure.

 - Concentration of structure: subsystem and driver authors/maintainers already care 
   about their sysfs layout - and when they define new tracepoints for subsystem or 
   driver instrumentation it would be very natural for those events to go somewhere 
   nearby, in the existing sysfs hieararchy.

 - Practicalities: sysfs is already mounted on all distros so tooling could rely on 
   it universally. It's the ultimate 'describe system structure' store.

 - Long term maintenance: we want to be strict with events, i.e. keep the 
   descriptors read only and single-line structured. You sysfs folks are enforcing 
   that pretty well - with eventfs we'd always have the nasty lure to apply API 
   hacks to eventfs components when we really shouldnt ...

Eventfs has a couple of downsides:

 - Design: it's slapping events into a separate, partly duplicated, partly unique, 
   partly inconsistent set of hierarchies. We can deal with it, but it's not 
   particularly intelligent and i'd like us to try harder.

 - Practicalities: eventfs has to be mounted on every distro. It's an uphill climb
   in general and the appeal of an approach has to be _strong_ for this to be 
   feasible.

So putting it into sysfs looks like a pretty intelligent solution all around and i'd 
prefer it.

Steve, would you be interested in helping out Lin Ming and PeterZ with the sysfs 
work - or at least help them come to the conclusion that we want eventfs?

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab0DTGwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 02:52:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45403 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0DTGwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 02:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=inb2IOEztuOYlcFaAhIbL0li0WfWWumVdWt2JmAfzV+ZCpebzDZ5iZlQgEylHi+sAl
         o+1DNKo0XZUke2eZYw3Z5uNTzLl+4TlAsUOr4mR4BrdOe/uLvUOxti76ifcQQfPaB6K4
         7RwJISIWtGcvrMSsKt3Fccfcto3rQ93aOBIG8=
Subject: Re: request to add trace off and trace on with events
From: Tom Zanussi <tzanussi@gmail.com>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271721566.10448.162.camel@gandalf.stny.rr.com>
References: <1271707444.10448.12.camel@gandalf.stny.rr.com>
	 <4BCCBF6D.3030105@am.sony.com>
	 <1271709846.10448.29.camel@gandalf.stny.rr.com>
	 <20100419212950.GB8811@nowhere>
	 <1271713074.10448.101.camel@gandalf.stny.rr.com>
	 <20100419220437.GC8811@nowhere>
	 <1271715227.10448.145.camel@gandalf.stny.rr.com>
	 <20100419230438.GA11493@nowhere>
	 <1271721566.10448.162.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 20 Apr 2010 01:52:10 -0500
Message-Id: <1271746330.6381.134.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 19:59 -0400, Steven Rostedt wrote:
> On Tue, 2010-04-20 at 01:04 +0200, Frederic Weisbecker wrote:
> 
> > > # ls event/sched/sched_switch/triggers/tracing_off
> > > filter   enable
> > > 
> > > ?
> > 
> > 
> > That would be perhaps an overkill.
> 
> Perhaps, but I was also thinking of having triggers in the system level.
> That way all events below it can trigger.
> 
> > Having a filter inside means it's on, otherwise it's off.
> > 
> > 
> > 
> > > 
> > > > 
> > > > > 
> > > > > This could also allow a user to do:
> > > > > 
> > > > > echo "(a > 100)" > tracing_on
> > > > > echo "(a < 100)" > tracing_off
> > > > 
> > > > 
> > > > Yeah :)
> > > > But if the scope of the "tracing off" is only for this event, then
> > > > rather use:
> > > > 
> > > > echo "(a < 100)" > filter
> > > > 
> > > > You could have tracing_off/on that have this event scope and
> > > > tracing_off/on_all for a global tracing scope.
> > > 
> > > The two are not equivalent. In fact, just enabling a trigger does not
> > > mean that the event itself will be traced.
> > 
> > 
> > Yeah, the enable file would first need to be activated before any
> > trigger to take effect on the event, just like filters.
> > 
> > In fact I was thinking of tracing_on/tracing_off as kinds of
> > local pause/resume.
> > 
> > And tracing_on_global/tracing_off_global would act like what does
> > /debug/tracing/tracing_on: something that disables every tracing.
> > 
> > But of course, before any of these conditional triggers to be
> > evaluated, you need to enable the corresponding event.
> 
> We could have a "trace_event_on" and "trace_event_off" trigger that only
> enables the event when hit.
> 
> Actually, we can have these triggers enable other events, or make
> dynamic triggers:
> 
> echo "enable_sched_switch" > events/sched/sched_wakeup/trigger/activate
> 
> or something similar.
> 

Yeah, it could be pretty useful to have triggers be able to enable and
set filters on other events to see what's going on in lower layers under
some arbitrary condition e.g. just as a bogus example,

echo "enable_block_io("dev == sdb"), enable_pagecache if ("count > 128k
&& fd == 9999") > events/syscalls/sys_enter_read


Dynamic triggers that could modify their own filters could also provide
for some interesting applications.  For example, a trigger on e.g.
block_bio_complete could be used to track sectors that have been written
to over a certain period of time.  On each 'hit', the command would add
a predicate that describes the sector(xxx) and nr_sector(yyy) contained
in that event to its own filter e.g. ("!(sector >= xxx && sector <= xxx
+ yyy)") i.e. any event that matches the filter (isn't contained within
any of current sector predicates) invokes the command to add that
event's block to the filter.

At the end of the run, the filter itself would contain all of the
sectors that were written to; the resulting filter could simply be
dumped to retrieve them.  I know there are some virtual disk backup
companies out there that would probably find something like this pretty
useful...

Of course, for this to be feasible, the filter implementation would have
to be streamlined to handle large numbers of predicates e.g. managed in
a tree, predicate merging, etc.

I don't know if it's worth it just for this, but I'm sure there are
plenty of other examples where dynamic filters would be useful...

Tom 

> -- Steve
> 
> 
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1EJHgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:36:09 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:47456 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754626Ab1EJHgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:36:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AosEAA/pyE15LBzagWdsb2JhbAClfhUBARYmJYhxvEcOgxGCbwSeXQ
Date: Tue, 10 May 2011 17:36:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110510073601.GD19446@dastard>
References: <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
 <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
 <20110507144402.GC2859@elte.hu>
 <1304788829.11129.57.camel@frodo>
 <20110507190033.GA11465@elte.hu>
 <1304996847.2969.151.camel@frodo>
 <20110510044438.GB19446@dastard>
 <1305005990.2969.158.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305005990.2969.158.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 01:39:50AM -0400, Steven Rostedt wrote:
> On Tue, 2011-05-10 at 14:44 +1000, Dave Chinner wrote:
> > On Mon, May 09, 2011 at 11:07:27PM -0400, Steven Rostedt wrote:
> > > What happens if someone designs a tool that analyzes the XFS
> > > filesystem's 200+ tracepoints? Will all those tracepoints now become
> > > ABI?
> > 
> > That's crazy talk.
> 
> Right!
> 
> > 
> > XFS tracepoints are _not ever_ guaranteed to be consistent from one
> > kernel to another - they are highly dependent on the implementation
> > of the code, and as such will change *without warning*. This has
> > been the case for the XFS event subsystem since back in the days of
> > Irix (yes, that's where most of the events were originally
> > implemented). The fact that they are now exported via TRACE_EVENT()
> > (so no kernel debugger is needed) does not change the fact the
> > information is really for developer use only and as such are
> > volatile....
> 
> But what makes these tracepoints any different from any other
> tracepoint? Like power manament.

Perhaps the intent of the tracepoints needs to be taken into
account? The XFS tracepoints are primarily for developers debugging
the filesystem on a specific kernel revision, whereas something like
power management has userspace diagnostic tools (like powertop) that
want to work across multiple kernel revisions. IOWs, we have two
different and conflicting requirements from two separate and
non-interacting subsystems, both of which currently use the same
(unstable) event interface to provide the functionality.

So, if you are going to define tracepoints to be a stable ABI, then
really we need a TRACE_EVENT_STABLE() extension to define all the
events that are intended to be stable.  That would make the code
self documenting w.r.t. intent, enable unstable->stable transitions
when applications require events to be stable (on a case by case
basis) and, best of all, not require the majority of tracepoint
users to change anything.

> > So, if someone wants to write an application that parses the XFS
> > tracepoints directly, then they have to live with the fact that
> > tracepoints will come and go and change size and shape all the
> > time.
> 
> I totally agree. But that is our "wish" and may not reflect reality.

It has nothing to do with "wish". The reality is that the XFS
tracepoints are unstable and we change them at will.

> The
> whole point of this thread is if the kernel exports something to
> userspace (in a released kernel), and userspace tools start to depend on
> that data, the "reality" is that data just became an ABI, and Linus will
> revert any changes that breaks that tool.

Fmeh. Retrofitting a "one size fits all" model that clearly does not
fit the existing tracepoint use cases is a sure way to annoy people.
Trace points are currently unstable, and if we want them to be
stable we need to define a new interface with new semantics and
rules about how, when and what type of modifications are allowed.

> This is the precedence that I want to avoid. Yes, this may be "crazy
> talk", but the possibility of it happening exists. In this case, I
> rather be crazy than right.

So define a new a stable tracepoint ABI and convert everything that
userspace wants to be stable over to that.  That way if someone
writes an application that uses XFS tracepoints and wants them to be
stable across multiple releases, that's a discussion and decision
that can be made wholly within the XFS community. That is, stability
of tracepoints is (and should always be) a subsystem maintainer
decision, not a royal decree sent down from above that all serfs
must obey.

Define the model for a stable ABI, provide the infrastructure to
make it easy to define stable tracepoints, but leave the definition
of which tracepoints are stable up to those working intimately with
the tracepoints in question....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

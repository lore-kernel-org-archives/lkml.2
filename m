Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab2GYRXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:23:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53558 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2GYRXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:23:35 -0400
Date: Wed, 25 Jul 2012 09:43:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tglx@linutronix.de,
        mingo@kernel.org, peterz@infradead.org, rusty@rustcorp.com.au,
        namhyung@kernel.org, tj@kernel.org, rjw@sisk.pl,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] CPU hotplug: Reverse invocation of notifiers
 during CPU hotplug
Message-ID: <20120725164331.GB2378@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50101733.4030205@linux.vnet.ibm.com>
 <Pine.LNX.4.44L0.1207251205500.2008-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1207251205500.2008-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072517-1976-0000-0000-00000F822018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 12:10:41PM -0400, Alan Stern wrote:
> On Wed, 25 Jul 2012, Srivatsa S. Bhat wrote:
> 
> > On 07/25/2012 08:27 PM, Alan Stern wrote:
> > > On Wed, 25 Jul 2012, Srivatsa S. Bhat wrote:
> > > 
> > >> Hi,
> > >>
> > >> This patchset implements the approach of invoking the CPU hotplug callbacks
> > >> (notifiers) in one order during CPU online and in the reverse order during CPU
> > >> offline. The rationale behind this is that services for a CPU are started in a
> > >> particular order (perhaps, with implicit dependencies between them) while
> > >> bringing up the CPU, and hence, it makes sense to tear down the services in
> > >> the opposite order, thereby honoring most of the dependencies automatically
> > >> (and also correctly). This is explained in more detail in Patch 6.
> > > 
> > > This strongly suggests that a notifier chain may be the wrong mechanism
> > > to use here.  Notifiers provide only limited guarantees about ordering,
> > > and it's hard to say much about the services a particular chain will
> > > provide since callbacks can be added from anywhere.
> > > 
> > 
> > True, the ability to register any random callback from anywhere is still a
> > problem that we are fighting... The zillions of callbacks that we have today
> > makes the hotplug process quite entangled.. we can't even roll-back from a
> > failure easily!
> > 
> > > Instead of adding all this complication to the notifier mechanism, how 
> > > about using something else for CPU hotplug?
> > > 
> > 
> > The problem is that today, many different subsystems need to know about CPUs coming
> > up or going down.. And CPU hotplug is not atomic, it happens in stages, and the
> > coordination between those subsystems is what actually drives CPU hotplug, in a way.
> 
> All this reinforces the idea that notifiers are the wrong mechanism for 
> CPU hotplug.
> 
> > At present, I think that the best we can do is to redesign the hotplug code such that
> > the number of callbacks that are needed can be reduced to a minimum amount and then
> > have good control over what those callbacks do. For example, Thomas Gleixner posted
> > the park/unpark patchset[1], which not only speeds-up CPU hotplug by avoiding destruction
> > and creation of per-cpu kthreads on every hotplug operation, but also gets rid of quite
> > a few notifiers by providing a framework to manage those per-cpu kthreads...
> 
> I think the best you can do is stop using notifiers and use something 
> else instead.  For example, a simple set of function calls (assuming 
> you know beforehand what callbacks need to be invoked).

Unfortunately, we don't know beforehand.  There are loadable kernel
modules that need to be informed of CPU hotplug events.  So we do need
some runtime way to register to be notified CPU-hotplug events.

If it weren't for the modules, we might be able to use another data
section and get a contiguous list of functions that need to be called.
I suppose we could have such sections for modules and link/unlink them
at module load/unload time, but it is not at all clear to me that this
would be simpler than using notifiers.

But always happy to learn -- any specific suggestions?

> > One of the other ideas to improve the hotplug notifier stuff that came up during some
> > of the discussions was to implement explicit dependency tracking between the notifiers
> > and perhaps get rid of the priority numbers that are currently being used to provide
> > some sort of ordering between the callbacks. Links to some of the related discussions
> > are provided below.
> 
> This seems like misplaced over-engineering.

In fact, we have deferred dependency tracking.  If I remember correctly,
the main motivation was to execute notifiers in parallel, but the fraction
of time that hotplug spends executing notifiers proved to be quite small.
At this point, I would be surprised if we ever do much with dependency
tracking.

Again, any specific suggestions for improvement?

							Thanx, Paul


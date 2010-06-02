Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab0FBEOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 00:14:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:49526 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab0FBEOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 00:14:22 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: James Bottomley <James.Bottomley@suse.de>
To: markgross@thegnar.org
Cc: tytso@mit.edu, Peter Zijlstra <peterz@infradead.org>,
       felipe.balbi@nokia.com, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100602024538.GA5764@gvim.org>
References: <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	 <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop>
	 <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
	 <1275120618.27810.12699.camel@twins>
	 <1275149418.4503.128.camel@mulgrave.site>
	 <alpine.LFD.2.00.1005312231120.2933@localhost.localdomain>
	 <1275340869.2823.344.camel@mulgrave.site>
	 <20100601135102.GA8098@srcf.ucam.org>
	 <1275426085.21962.967.camel@mulgrave.site> <20100602024538.GA5764@gvim.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 04:14:14 +0000
Message-ID: <1275452054.21962.1814.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 19:45 -0700, mark gross wrote:
> On Tue, Jun 01, 2010 at 04:01:25PM -0500, James Bottomley wrote:
> > On Tue, 2010-06-01 at 14:51 +0100, Matthew Garrett wrote:
> > > On Mon, May 31, 2010 at 04:21:09PM -0500, James Bottomley wrote:
> > > 
> > > > You're the one mentioning x86, not me.  I already explained that some
> > > > MSM hardware (the G1 for example) has lower power consumption in S3
> > > > (which I'm using as an ACPI shorthand for suspend to ram) than any
> > > > suspend from idle C state.  The fact that current x86 hardware has the
> > > > same problem may be true, but it's not entirely relevant.
> > > 
> > > As long as you can set a wakeup timer, an S state is just a C state with 
> > > side effects. The significant one is that entering an S state stops the 
> > > process scheduler and any in-kernel timers. I don't think Google care at 
> > > all about whether suspend is entered through an explicit transition or 
> > > something hooked into cpuidle - the relevant issue is that they want to 
> > > be able to express a set of constraints that lets them control whether 
> > > or not the scheduler keeps on scheduling, and which doesn't let them 
> > > lose wakeup events in the process.
> > 
> > Exactly, so my understanding of where we currently are is:
> > 
> >      1. pm_qos will be updated to be able to express the android suspend
> >         blockers as interactivity constraints (exact name TBD, but
> >         probably /dev/cpu_interactivity)
> >      2. pm_qos will be updated to be callable from atomic context
> >      3. pm_qos will be updated to export statistics initially closely
> >         matching what suspend blockers provides (simple update of the rw
> >         interface?)
> > 
> > After this is done, the current android suspend block patch becomes a
> > re-expression in kernel space in terms of pm_qos, with the current
> > userspace wakelocks being adapted by the android framework into pm_qos
> > requirements expressed to /dev/cpu_interactivity (or whatever name is
> > chosen).  Then opportunistic suspend is either a small add-on kernel
> > patch they have in their tree to suspend when the interactivity
> > constraint goes to NONE, or it could be done entirely by a userspace
> > process.  Long term this could migrate to the freezer and suspend from
> > idle approach as the various problem timers get fixed.
> 
> This is all nice but, all this does is implement the exact same thing as
> the wake lock / suspend blocker API as a pm_qos request-class.

funny that ...

>   It
> leaves the overlapping constraint issue from ISR to user mode in place
> depending on exactly how the oppertunistic suspend is implemented.

if the vanilla kernel is simply consuming the pm_qos infrastructure and
using suspend from idle, this is irrelevant.  As I said, S3 suspend
*can* be implemented via a suspend manager process from userspace (the
alan stern proposal).  However, if I were coding the android kernel, I'd
do it as a tiny add on kernel patch.  The main goal of making the
android kernel close enough to the vanilla kernel for there not to be
two separate upstreams for the device driver writers has been achieved
regardless of which path is taken.

> I expect it will be via a notifier on the pm_qos request-class update
> that would do exactly what the wake lock code does today.  just load up
> an a "suspend_on_non_interactivity" driver that registers for the call
> back, have it enabled by the user mode PM, and you have the equivelent
> architecture as what was proposed by the wake lock patches.
> 
> it gives the Android guys what they want, without adding a new
> subsystem, minimizing the changes and makes most of the architecture
> much more politicaly acceptible.
> 
> But doesn't it have the same issues with getting the overlapping
> constraints right from wake up source to user mode and dealing with the
> wake up envents in a sane way?  Instead of sprinkling suspend-blockers
> about the kernel we'll sprinkle pm_qos_requests about.  I like getting
> more users of pm_qos, but isn't this the same thing?

Suspend from idle doesn't have the wakeup problem.  it only manifests if
you want to take the system down via the S states.  I think long term,
making suspend from idle work for all hardware is the agreed goal, even
if android can't implement it today and has to use an S state work
around.

> > I think the big unresolved issue is the stats extension.  For android,
> > we need just a name written along with the value, so we have something
> > to hang the stats off ... current pm_qos userspace users just write a
> > value, so the name would be optional.  From the kernel, we probably just
> > need an additional API that takes a stats name or NULL if none
> > (pm_qos_add_request_named()?).  Then reading the stats could be done by
> > implementing a fops read routine on the misc device.
> 
> I don't think the status would be a big deal to add.
> 
> 
> However; I am really burned out by this discussion.  I am willing to
> stub this out ASAP if it puts this behind us if the principles in the
> discussion are in more or less agreement.
> 
> --mgross
> 
> For the record, I still like my low power event idea, which could
> coexist with the above.

The proposal is isomorphic to what I said above ... just
s/pm_qos/whatever the lp API is/

James



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab0ERUmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:42:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34393 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab0ERUmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:42:35 -0400
Date: Tue, 18 May 2010 22:42:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Joe Perches <joe@perches.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, "Young, Brent" <brent.young@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100518204204.GA23204@elte.hu>
References: <4BF18995.6070008@redhat.com>
 <4BF2392A.9040409@jp.fujitsu.com>
 <4BF2C3D1.10009@redhat.com>
 <1274204560.17703.82.camel@Joe-Laptop.home>
 <20100518185305.GA23921@elte.hu>
 <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
 <20100518193022.GB30936@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518193022.GB30936@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > Furthermore it's NMI safe, offers structured 
> > > logging, has various streaming, multiplexing and 
> > > filtering capabilities that come handy for RAS 
> > > purposes and more.
> > 
> > Those of us present at the mini-summit were not 
> > familiar with all the features available. One area of 
> > concern was how to be sure that something is in fact 
> > listening to and logging the error events.  My 
> > understanding is that if there is no process attached 
> > to an event, the kernel will just drop it.  This is of 
> > particular concern because the kernel's first scan of 
> > the machine check banks occurs before there are any 
> > processes. So errors found early in boot (which might 
> > be saved fatal errors from before the boot) might be 
> > lost.
> 
> I proposed a (fairly straightforward) extension to which 
> Boris agreed: we can introduce 'persistent events', 
> which have task-less buffers attached to them, which 
> will hold (a configurable amount of) of events.
> 
> Those can then be picked up by a task later on and no 
> event is lost.
> 
> Would such a feature address your concern?

Tony, should we accelerate the development of this 
persistent events sub-feature?

Boris posted initial patches of the new perf events based 
EDAC/MCE/RAS design direction to lkml and indicated that 
it works for him. He also indicated that he can do the 
initial work of unifying EDAC and MCE without the 
persistent events feature for now. (this all is obviously 
v2.6.36-ish material)

But if it's important, if you'd like to move ahead with 
the unification swiftly then we can certainly increase its 
priority.

Also, a few notes:

1) the new RAS tool itself might or might not be part of 
tools/perf/ - for the prototype it certainly makes sense 
to be there but otherwise feel free to start tools/ras/ 
and share code with tools/perf/ but otherwise keep a 
separate RAS tool-space.

2) There's a new perf feature (that went upstream today) 
that is of EDAC/RAS interest: the ability to do live 
tracing. This is basically a daemon-alike, 
event->policy-action based flow that RAS eventing is 
about.

3) Another new perf feature of interest is 'perf inject' 
(this too went upstream today): to inject artificial 
events into the stream of events. This mechanism could be 
used to simulate rare error conditions and to test out 
policy reactions systematically - an important part of 
system error recovery testing.

4) We are working on enumerating events via sysfs, not via 
debugfs. This would make the events provided by EDAC/MCE 
more generally available. See Lin Ming's patches on lkml:

  Subject: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs

Please chime in that thread to make sure the event_source 
class is suitable to describe EDAC/MCE event sources as 
well. Any event_source that is made available by drivers 
can then by used by tools for event transport.

This gives us a broad platform to add various RAS events 
as well, beyond raw hardware events: we could for example 
events for various system anomalies such as lockup 
messages, kernel warnings/oopses, IOMMU exceptions - maybe 
even pure software concepts such as fatal segmentation 
fault events, etc. etc.

That way the RAS daemon could build and utilize a complete 
and coherent set of events it wants to subscribe to - all 
via the same event transport mechanism. It would thus have 
a comprehensive 'system health' view, via a single, 
reliable mechanism, and could act in a wide range of 
scenarios, with a wide range of policy actions, based on a 
very complete picture.

Getting all those features will certainly take time and 
effort, but this is the big picture where the whole idea 
leads us to: a genuinely more capable, more generic and 
more flexible RAS implementation for Linux.

Thanks,

	Ingo

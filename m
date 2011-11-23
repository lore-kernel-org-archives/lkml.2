Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1KWPag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:30:36 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47156 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1KWPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:30:35 -0500
Date: Wed, 23 Nov 2011 15:30:16 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: HW perf initialisation as early_initcall
Message-ID: <20111123153016.GQ25848@mudshark.cambridge.arm.com>
References: <20111123145658.GM25848@mudshark.cambridge.arm.com>
 <1322060889.14799.73.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322060889.14799.73.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 03:08:09PM +0000, Peter Zijlstra wrote:
> On Wed, 2011-11-23 at 14:56 +0000, Will Deacon wrote:
> > In commit 004417a6 ("perf, arch: Cleanup perf-pmu init vs lockup-detector"),
> > you moved the arch hw perf initialisation into an early initcall to satisfy a
> > race with the NMI lock detector (I'm not clear on what the relationship is).
> 
> NMI watchdog uses perf, getting the NMI watchdog up early is good,
> getting it up before perf is initialized, not so very good :-)

Ah, ok. We don't use this on ARM so I'm not familiar with it.

> > Anyway, with ARM big/little platforms on the horizon we have the fun of
> > heterogeneous PMUs in the sense that:
> > 
> > 	- They may have different numbers of event counters
> > 	- They may support different event types (possibly a distinct set)
> > 	- The event encodings for the generalised events may be different
> > 
> > The latter two points I think can be solved in the back-end by making events
> > affine to a particular PMU type (that is, they are only scheduled when the
> > profiled task is running on a given PMU type), although I'm not sure how this
> > will be exposed to userspace yet. It might be nice to register a separate
> > PMU with perf altogether, but I don't think the userspace tools are there
> > yet in terms of specifying the destination PMU for an event.
> 
> Ow gawd, that's horrid, will you please kick your cpu folks for me.

Just keep telling yourself that it makes the software more interesting :)

> > The first point is part of a bigger problem, namely that we can only find
> > out the PMU topology of the system by probing the device tree. For older
> > platforms, we will still probe the PMU of the boot CPU by inspecting the ID
> > registers.
> 
> And here I throught DT was up _waaay_ early because its used to bring up
> the platform itself, do I need to re-educate myself?

Well, I can probably probe the tree manually if I need to, it would just be
nice to use the same probe function for DT and platform_device
initialisation.

> > My question is: does the hw perf initialisation really need to be an
> > early_initcall and, if so, how much of the perf backend needs to be up and
> > running? It may be that the early initcall assumes all PMUs are the same and
> > then later on I go and rewrite things like the number of counters.
> 
> I think you can get away with doing it later, since you don't use the
> NMI watchdog (although if you ever get NMI like functionality you really
> should).

Ok, thanks. I'm still just thinking my way around the problem but that's
useful to know.

> > Of course, any ideas regarding the above are more than welcome!
> 
> Yeah, I'll try and let it soak in my brain, who knows what it'll come up
> with ;-)

Cheers. I think a key point to bear in mind is that it doesn't make sense to
combine event counts from the two PMUs. The microarchitectures are different
so we want to record them separately, even if the event encoding is the
same (then you could see how many cycles you spent on big and how many on
little, for example). An additional software event for cluster switch may
also be useful.

The main problem I'm having is fitting this into userspace where we probably
want to specify the PMU for each event and also have some method for
handling the generic events.

Will

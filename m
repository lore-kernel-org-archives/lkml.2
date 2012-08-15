Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2HOOnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:43:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54165 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab2HOOno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:43:44 -0400
Message-ID: <1345041802.31459.94.camel@twins>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@alien8.de>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Date: Wed, 15 Aug 2012 16:43:22 +0200
In-Reply-To: <20120815131514.GC4409@x1.osrc.amd.com>
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>
	 <20120815131514.GC4409@x1.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 15:15 +0200, Borislav Petkov wrote:
> On Wed, Aug 15, 2012 at 01:05:38PM +0200, Peter Zijlstra wrote:
> > On Mon, 2012-08-13 at 20:21 +0800, Alex Shi wrote:
> > > Since there is no power saving consideration in scheduler CFS, I has a
> > > very rough idea for enabling a new power saving schema in CFS.
> > 
> > Adding Thomas, he always delights poking holes in power schemes.
> > 
> > > It bases on the following assumption:
> > > 1, If there are many task crowd in system, just let few domain cpus
> > > running and let other cpus idle can not save power. Let all cpu take the
> > > load, finish tasks early, and then get into idle. will save more power
> > > and have better user experience.
> > 
> > I'm not sure this is a valid assumption. I've had it explained to me by
> > various people that race-to-idle isn't always the best thing. It has to
> > do with the cost of switching power states and the duration of execution
> > and other such things.
> 
> I think what he means here is that we might want to let all cores on
> the node (i.e., domain) finish and then power down the whole node which
> should bring much more power savings than letting a subset of the cores
> idle. Alex?

Sure we can do that.

> > So I'd leave the currently implemented scheme as performance, and I
> > don't think the above describes the current state.
> > 
> > > 			} else if (schedule policy == power)
> > > 				move tasks from busiest group to
> > > 				idlest group until busiest is just full
> > > 				of capacity.
> > > 				//the busiest group can balance
> > > 				//internally after next time LB,
> > 
> > There's another thing we need to do, and that is collect tasks in a
> > minimal amount of power domains.
> 
> Yep.
> 
> Btw, what heuristic would tell here when a domain overflows and another
> needs to get woken? Combined load of the whole domain?
> 
> And if I absolutely positively don't want a node to wake up, do I
> hotplug its cores off or are we going to have a way to tell the
> scheduler to overcommit the non-idle domains and spread the tasks only
> among them.
> 
> I'm thinking of short bursts here where it would be probably beneficial
> to let the tasks rather wait runnable for a while then wake up the next
> node and waste power...

I was thinking of a utilization measure made of per-task weighted
runnable averages. This should indeed cover that case and we'll overflow
when on average there is no (significant) idle time over a period longer
than the averaging period.

Anyway, I'm not too set on this and I'm very sure we can tweak this ad
infinitum, so starting with something relatively simple that works for
most is preferred.

As already stated, I think some of the Linaro people actually played
around with something like this based on PJTs patches.

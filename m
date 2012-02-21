Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2BUBex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:34:53 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:60989 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2BUBew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:34:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.229.77.15 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
Date: Tue, 21 Feb 2012 02:34:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
Message-ID: <20120221013443.GA13403@somewhere.redhat.com>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
 <1327591185.2446.102.camel@twins>
 <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
 <20120201170443.GE6731@somewhere.redhat.com>
 <CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com>
 <4F2AAEB9.9070302@tilera.com>
 <1328898816.25989.33.camel@laptop>
 <4F3C28AF.9080005@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3C28AF.9080005@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 04:50:39PM -0500, Chris Metcalf wrote:
> On 2/10/2012 1:33 PM, Peter Zijlstra wrote:
> > On Thu, 2012-02-02 at 10:41 -0500, Chris Metcalf wrote:
> >> At Tilera we have been supporting a "dataplane" mode (aka Zero Overhead
> >> Linux - the marketing name).  This is configured on a per-cpu basis, and in
> >> addition to setting isolcpus for those nodes, also suppresses various
> >> things that might otherwise run (soft lockup detection, vmstat work,
> >> etc.).  
> > See that's wrong.. it starts being wrong by depending on cpuisol and
> > goes from there.
> >
> >> The claim is that you need to specify these kinds of things
> >> per-core since it's not always possible for the kernel to know that you
> >> really don't want the scheduler or any other interrupt source to touch the
> >> core, as opposed to the case where you just happen to have a single process
> >> scheduled on the core and you don't mind occasional interrupts.
> > Right, so that claim is proven false I think.
> >
> >> But
> >> there's definitely appeal in having the kernel do it adaptively too,
> >> particularly if it can be made to work just as well as configuring it
> >> statically. 
> > I see no reason why it shouldn't work as well or even better.
> 
> Thanks for the feedback.  To echo Gilad's guess in a later email, the code
> as-is is not intended as a patch planned for a merge.  The code is in use
> by our customers, who have found it useful, but what I'd really like to do
> is to make sure to integrate all the functionality that's useful in our
> "dataplane" mode into Frederic's ongoing work with nohz cpusets.
> 
> The goal of the work we've done is to provide a way for customers to ensure
> they reliably have zero jitter on cpus that are trying to process real-time
> or otherwise low-latency events.  A good example is 10 Gb network traffic,
> where at min-packet sizes you have only 50-odd cpu cycles to dispatch the
> packet to one of our 64 cores, and each core then has a budget of only a
> few thousand cycles to deal with the core.  A kernel interrupt would mean
> dropping packets on the floor.  Similarly, for something like
> high-frequency trading, you'd want guaranteed low-latency response.
> 
> The Tilera dataplane code is available on the "dataplane" branch (off of
> 3.3-rc3 at the moment):
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git
> 
> I'm still looking at Frederic's git tree, but I'm assuming the following
> are all true of tasks that are running on a nohz cpuset core:
> 
> - The core will not run the global scheduler to do work stealing, since
> otherwise you can't guarantee that only tasks that care about userspace
> nohz get to run there.  (I suppose you could loosen thus such that the core
> would do work stealing as long as no task was pinned to that core by
> affinity, at which point the pinned task would become the only runnable task.)

A nohz cpuset doesn't really control that. It actually reacts to the scheduler
actions. Like try to stop the tick if there is only one task on the runqueue,
restart it when we have more.

Ensuring the CPU doesn't get distracted is rather the role of the user by
setting the right cpusets to get the desired affinity. And if we still have
noise with workqueues or something, this is something we need to look at
and fix on a case by case basis.


> - Kernel "background" tasks are disabled on that core, at least while
> userspace nohz tasks are running: softlockup watchdog, slab reap timer,
> vmstat thread, etc.

Yeah that's examples of "noisy" things. Those are in fact a seperate issues
that nohz cpusets don't touch. nohz cpuset are really only about trying to
shut down the periodic tick, or defer it for a far as possible in the future.

Now the nohz cpuset uses some user/kernel entry/exit hooks that we can extend
to cover some of these cases. We may want to make some timers "user-deferrable",
ie: deactivate, reactivate them on kernel entry and exit.

That need some thinking though, this may not always be a win for every workload.
But those that are userspace-mostly can profit.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2CAS1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:27:40 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:19795 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2CAS1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:27:38 -0500
Message-ID: <4F4FBF96.7070600@tilera.com>
Date: Thu, 1 Mar 2012 13:27:34 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gilad Ben-Yossef <gilad@benyossef.com>, <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com> <1327591185.2446.102.camel@twins> <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com> <20120201170443.GE6731@somewhere.redhat.com> <CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com> <4F2AAEB9.9070302@tilera.com> <1328898816.25989.33.camel@laptop> <4F3C28AF.9080005@tilera.com> <20120221013443.GA13403@somewhere.redhat.com>
In-Reply-To: <20120221013443.GA13403@somewhere.redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, away on vacation for a while, and just getting back to this thread.)

On 2/20/2012 8:34 PM, Frederic Weisbecker wrote:
> On Wed, Feb 15, 2012 at 04:50:39PM -0500, Chris Metcalf wrote:
>> The Tilera dataplane code is available on the "dataplane" branch (off of
>> 3.3-rc3 at the moment):
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git
>>
>> I'm still looking at Frederic's git tree, but I'm assuming the following
>> are all true of tasks that are running on a nohz cpuset core:
>>
>> - The core will not run the global scheduler to do work stealing, since
>> otherwise you can't guarantee that only tasks that care about userspace
>> nohz get to run there.  (I suppose you could loosen thus such that the core
>> would do work stealing as long as no task was pinned to that core by
>> affinity, at which point the pinned task would become the only runnable task.)
> A nohz cpuset doesn't really control that. It actually reacts to the scheduler
> actions. Like try to stop the tick if there is only one task on the runqueue,
> restart it when we have more.
>
> Ensuring the CPU doesn't get distracted is rather the role of the user by
> setting the right cpusets to get the desired affinity. And if we still have
> noise with workqueues or something, this is something we need to look at
> and fix on a case by case basis.

So won't it still be the case that the nohz cpus will try to run the global
scheduler to do load balancing?  Or are you relying on something like the
idle load balancer functionality to do the load balancing externally?  The
reason for isolcpus in the Tilera code is just to avoid having the
dataplane cpus ever end up having to schedule a tick just so they can do
load balancing work.

Frederic, do you have a design document, or anything else I can read other
than the code in your git tree?  I still haven't found time to do that,
though I'd definitely like to start figuring out how I can integrate your
stuff and the Tilera stuff into a single thing that both meets our
customers' needs, AND is actually integrated into the kernel.org master :-)

>> - Kernel "background" tasks are disabled on that core, at least while
>> userspace nohz tasks are running: softlockup watchdog, slab reap timer,
>> vmstat thread, etc.
> Yeah that's examples of "noisy" things. Those are in fact a seperate issues
> that nohz cpusets don't touch. nohz cpuset are really only about trying to
> shut down the periodic tick, or defer it for a far as possible in the future.
>
> Now the nohz cpuset uses some user/kernel entry/exit hooks that we can extend
> to cover some of these cases. We may want to make some timers "user-deferrable",
> ie: deactivate, reactivate them on kernel entry and exit.
>
> That need some thinking though, this may not always be a win for every workload.
> But those that are userspace-mostly can profit.

Yes.  The workloads we are focused on (along with Gilad and some others) is
just the very simple one where we want to be able to have something go into
userspace, and get 100.000% of the cpu until the task itself takes some
action that requires kernel support.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab2BQUMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:12:37 -0500
Received: from mail.lang.hm ([64.81.33.126]:60720 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab2BQUMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:12:36 -0500
Date: Fri, 17 Feb 2012 12:12:35 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: different speed cores in one system (aks arm big.LITTLE)
Message-ID: <alpine.DEB.2.02.1202171149390.18831@asgard.lang.hm>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following an article on lwn about more arm systems with different speed 
cores in them ( subscribers: http://lwn.net/Articles/481055 
non-subscribers: http://lwn.net/SubscriberLink/481055/cc3426371b328030 )

It seems to me that the special case approach of pairing a 'fast' and 
'slow' core together is a hack that will work with this particular part, 
but not work more generally. The approaches discussed seem to be more 
complicated than they needed to be. I've outlined my thoughts in the 
comments there, but figured I'd post here to get the attention of the 
scheduler folks.

First off, even on Intel/AMD x86 systems we have (or soon will have) the 
potential for different cores to be run at different speeds, including 
thermal/current limitations that make it so that if you turn off some 
cores you can run others at higher speeds. This means that the problem is 
not an ARM specific problem.

As I understand the current scheduler to work, there are two 'layers' to 
the scheduler.

The first 'layer' runs independantly on each core (using cpu local 
variables for performance) and schedules the next task to run from the 
tasks assigned to that core.

The second 'layer' moves tasks from one core to another. Ideally it runs 
when a core is otherwise idle, but it looks at the load on all the cores 
and can choose to 'pull' work from another core to itself. Part of the 
logic in deciding if it should pull a job could be considering the NUMA 
positioning of the old and new core to decide if it's a benefit to pull it 
or not.


I believe that unless one tasks (i.e. thread) is using more CPU than the 
slowest core can provide the current scheduler will 'just work' in the 
presense of cores of differing speeds, a slower core will get less work 
done, but that will just mean that it's utilization is higher for the same 
amount of work, so work will migrate around until the utilization is 
rougly the same.

I think it may be worth adding a check to the 'slow path' rebalancing 
algorithm, probably in a similar place to where the NUMA checks are made 
that will scale the tasks utilization to see if there is an advantage in 
pulling a task that's maxing out one core onto the new core (if the new 
core is faster, it can be a win), possibly adding a second check to make 
sure that you aren't migrating a task to a core that's not fast enough.

With this additional type of check, I think that the current scheduler 
will work well on systems with different speed cores, including drastic 
differences.

At that point, the remaining question is the policy question of what cores 
should be powered up/down, clockspeeds changed, etc. Since that sort of 
thing is very machine and workload specific, it seems to me that the 
obvious answer is that a userspace daemon working completely independantly 
to the kernel should watch the system and make the policy decisions to 
reconfigure the CPUs (very similar to how userspace power management tools 
work today), and 'just' extend the ability to change clock speeds to the 
ability to power down particular cores entirely.

The lwn article positions this as a super complex thing to figure out and 
is talking about doing hacks like pairing a fast and slow core togeather 
to only use one of the two at a time and consider moving work from one to 
the other 'just' a clockspeed change. This seems to me to be a far more 
complex approach than just adding the extra check to the scheduler slow 
path and doing the power management in userspace.

Thoughts?

Am I completely misunderstanding how the scheduler works? (I 
know I'm _drastically_ simplifying it)

Am I completely off base here? or am I seeing something that the ARM folks 
have been missing because they are too close to the problem?

David Lang

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2CUMSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 08:18:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab2CUMSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 08:18:06 -0400
Date: Wed, 21 Mar 2012 13:17:03 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dan Smith <danms@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] AutoNUMA alpha6
Message-ID: <20120321121703.GW24602@redhat.com>
References: <20120316144028.036474157@chello.nl>
 <20120316182511.GJ24602@redhat.com>
 <87k42edenh.fsf@danplanet.com>
 <20120321075349.GB24997@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321075349.GB24997@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 08:53:49AM +0100, Ingo Molnar wrote:
> My impression is that while threading is on the rise due to its 
> ease of use, many threaded HPC workloads still fall into the 
> second category.

This is why after Peter's initial complains that a threaded
application had to be handled perfectly by AutoNUMA even if it had
more threads than CPU in a node, I had to take a break, and rewrite
part of AutoNUMA to handle this scenario automatically, by introducing
the numa hinting page faults. Before Peter complains I only had the
pagetable scanner. So I appreciate his criticism for having convinced
me that AutoNUMA had to have this working immediately.

Perhaps somebody remembers what I told at KVMForum on stage about
this, back then I was planning to automatically handle only processes
that fit in a node. So the talk with Peter has been fundamental to add
one more gear to the design or I wouldn't be able to compete with his
syscalls.

> In fact they are often explicitly *turned* into the second 
> category at the application level by duplicating shared global 
> data explicitly and turning it into per thread local data.

per-thread local data is the best case of AutoNUMA. AutoNUMA already
detects and reacts to false sharing putting all false-sharing threads
in the same node statistically over time. It also cancels pending
migration pages queued, and requires two more consecutive hits from
threads in the same node before re-allowing migration. There's quite a
bit of work I did to make false sharing handled properly. But the
absolute best case is per-thread local storage (both numa01
-DTHREAD_ALLOC and numa02, numa02 spans over the whole system with the
same process, numa01 has two processes, where each fit in a node, with
local thread storage).

> And to default-enable any of this on stock kernels we'd need to 
> even more testing and widespread, feel-good speedups in almost 
> every key Linux workload... I don't see that happening though, 
> so the best we can get are probably some easy and flexible knobs 
> for HPC.

This is a very good point. We can merge AutoNUMA in a disabled way. It
won't ever do anything unless explicitly enabled, and even more
important if you disable it (echo 0 >enabled) it will deactivate
completely and everything will settle down like if has never run, it
will leave zero signs in the VM and scheduler.

There are three gears, if the pagetable scanner never runs (first
gear), all other gears never activates and it is a complete bypass (noop).

There are environments like virt that are quite memory static and
predictable, so if demonstrated it would work for them, it would be
real easy for virt admin to echo 1 >/sys/kernel/mm/autonuma/enabled .

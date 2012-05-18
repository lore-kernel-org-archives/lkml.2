Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966553Ab2ERL5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:57:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54347 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966227Ab2ERL5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:57:48 -0400
Date: Fri, 18 May 2012 13:57:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        riel@redhat.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org, bburns@redhat.com
Subject: [FEATURE TREE] sched, mm: Introduce the 'home node' affinity concept
Message-ID: <20120518115742.GA19785@gmail.com>
References: <tip-41h2mswllhkskd4bnxpoi388@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-41h2mswllhkskd4bnxpoi388@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Commit-ID:  84213e2b6e2166083c3d06e91dcf54f8e136bd78
> Gitweb:     http://git.kernel.org/tip/84213e2b6e2166083c3d06e91dcf54f8e136bd78
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Sat, 3 Mar 2012 17:05:16 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 18 May 2012 08:16:20 +0200
> 
> sched, mm: Introduce tsk_home_node()

So, I wanted to see some progress on this issue and committed 
Peter's 'home node NUMA affinity' changes to the tip:sched/numa 
tree.

Basically the scheme Peter implemented is an extended notion of 
NUMA affinity, one that both the scheduler and the MM honors - 
but one that is flexible and treats affinity as a preference, 
not as a hard mask:

 - For example if there's significant idle time on distant CPUs
   then the scheduler will still utilize those CPUs and fill the
   whole machine - but otherwise the scheduler and the MM will
   try to maintain good NUMA locality.

 - Similary, memory allocations will go to the home node even if
   the task is running on another node temporarily. [as long as
   the allocation can be satisfied.]

This is a more dynamic, more intelligent version of hard 
partitioning the system and workloads between NUMA nodes - yet 
it is pretty simple and existing MM and scheduling code mostly 
support this scheme and needed only small reorganization.

When home node awareness is active then applications can use new 
system calls to group themselves into affinity groups, via:

     sys_numa_tbind(tid, -1, 0);         // create new group, return new ng_id
     sys_numa_tbind(tid, -2, 0);         // returns existing ng_id
     sys_numa_tbind(tid, ng_id, 0);      // set ng_id

... and to assign memory to a NUMA group:

     sys_numa_mbind(addr, len, ng_id, 0);
 
We are seeing user-space daemons trying to achieve something 
similar, for example there's "numad":

   https://fedoraproject.org/w/index.php?title=Features/numad&oldid=272815

the kernel is in a much better position to handle affinities and 
resource allocation preferences, especially ones that change and 
mix so dynamically as scheduling and memory allocation - so 
maybe "numad" could make use of the new syscalls and map 
application/package policies into NUMA groups the kernel 
recognizes.

(There's more such daemons out there, in the HPC area.)

One configurability detail I'd like to suggest to Peter: could 
we make this NUMA affinity grouping capability unconditional to 
apps, i.e. enable apps to put themselves on home node aware 
policy even if the sysctl is off?

That way this capability would always be available on NUMA 
systems in an opt-in fashion, just like regular affinities are 
available. The sysctl would merely control whether all tasks on 
the system are scheduled in a home node aware fashion or not. 
(and it would still default to off)

Thanks,

	Ingo

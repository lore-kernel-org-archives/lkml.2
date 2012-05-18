Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966640Ab2ERMds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:33:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965342Ab2ERMdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:33:39 -0400
Message-ID: <4FB64185.5020308@redhat.com>
Date: Fri, 18 May 2012 08:33:09 -0400
From: Bill Burns <bburns@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        riel@redhat.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, bburns@redhat.com,
        Bill Gray <bgray@redhat.com>
Subject: Re: [FEATURE TREE] sched, mm: Introduce the 'home node' affinity
 concept
References: <tip-41h2mswllhkskd4bnxpoi388@git.kernel.org> <20120518115742.GA19785@gmail.com>
In-Reply-To: <20120518115742.GA19785@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 07:57 AM, Ingo Molnar wrote:
> * tip-bot for Peter Zijlstra<a.p.zijlstra@chello.nl>  wrote:
>
>> Commit-ID:  84213e2b6e2166083c3d06e91dcf54f8e136bd78
>> Gitweb:     http://git.kernel.org/tip/84213e2b6e2166083c3d06e91dcf54f8e136bd78
>> Author:     Peter Zijlstra<a.p.zijlstra@chello.nl>
>> AuthorDate: Sat, 3 Mar 2012 17:05:16 +0100
>> Committer:  Ingo Molnar<mingo@kernel.org>
>> CommitDate: Fri, 18 May 2012 08:16:20 +0200
>>
>> sched, mm: Introduce tsk_home_node()
> So, I wanted to see some progress on this issue and committed
> Peter's 'home node NUMA affinity' changes to the tip:sched/numa
> tree.
>
> Basically the scheme Peter implemented is an extended notion of
> NUMA affinity, one that both the scheduler and the MM honors -
> but one that is flexible and treats affinity as a preference,
> not as a hard mask:
>
>   - For example if there's significant idle time on distant CPUs
>     then the scheduler will still utilize those CPUs and fill the
>     whole machine - but otherwise the scheduler and the MM will
>     try to maintain good NUMA locality.
>
>   - Similary, memory allocations will go to the home node even if
>     the task is running on another node temporarily. [as long as
>     the allocation can be satisfied.]
>
> This is a more dynamic, more intelligent version of hard
> partitioning the system and workloads between NUMA nodes - yet
> it is pretty simple and existing MM and scheduling code mostly
> support this scheme and needed only small reorganization.
>
> When home node awareness is active then applications can use new
> system calls to group themselves into affinity groups, via:
>
>       sys_numa_tbind(tid, -1, 0);         // create new group, return new ng_id
>       sys_numa_tbind(tid, -2, 0);         // returns existing ng_id
>       sys_numa_tbind(tid, ng_id, 0);      // set ng_id
>
> ... and to assign memory to a NUMA group:
>
>       sys_numa_mbind(addr, len, ng_id, 0);
>
> We are seeing user-space daemons trying to achieve something
> similar, for example there's "numad":
>
>     https://fedoraproject.org/w/index.php?title=Features/numad&oldid=272815
>
> the kernel is in a much better position to handle affinities and
> resource allocation preferences, especially ones that change and
> mix so dynamically as scheduling and memory allocation - so
> maybe "numad" could make use of the new syscalls and map
> application/package policies into NUMA groups the kernel
> recognizes.
Thanks for the cc on this. I have cc'ed Bill Gray who authored
numad and will leave it to him to comment on the interfaces,
but indeed this has been something that we have been looking
for, the concept of a home node (or nodes).

cheers,
  Bill (Burns)

> (There's more such daemons out there, in the HPC area.)
>
> One configurability detail I'd like to suggest to Peter: could
> we make this NUMA affinity grouping capability unconditional to
> apps, i.e. enable apps to put themselves on home node aware
> policy even if the sysctl is off?
>
> That way this capability would always be available on NUMA
> systems in an opt-in fashion, just like regular affinities are
> available. The sysctl would merely control whether all tasks on
> the system are scheduled in a home node aware fashion or not.
> (and it would still default to off)
>
> Thanks,
>
> 	Ingo


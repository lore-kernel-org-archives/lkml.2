Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2DEXkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:40:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59223 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2DEXkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:40:09 -0400
Date: Thu, 5 Apr 2012 16:40:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
In-Reply-To: <20120405231306.GF29517@google.com>
Message-ID: <alpine.DEB.2.00.1204051630400.25838@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com> <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com> <20120405160829.GA12854@google.com> <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com> <20120405213704.GA29517@google.com>
 <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com> <20120405222400.GC29517@google.com> <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com> <20120405225854.GE29517@google.com> <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com>
 <20120405231306.GF29517@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Tejun Heo wrote:

> > We could still move to a single hierarchy, though, if we introduced a 
> > change to allow PF_THREAD_BOUND to attach to both cpusets and cpu iff 
> > its bound cpu is allowed and then do -EINVAL if its changed while still 
> > attached.
> 
> Yeah, making the affected controllers to deal with them somehow
> definitely is an option and will probably have to be chosen for some
> other cases too (e.g. rt tasks).

For cpusets, it's easy if update_nodemask() iterates over threads and 
finds if any PF_THREAD_BOUND thread is bound to a cpu that is disallowed 
by the new nodemask.

It's a very typical configuration to have threads within a cpuset attached 
to a set of mems to use sched_setaffinity() for a subset of those cpus as 
well.  A PF_THREAD_BOUND thread is then perfectly legitimate in a cpuset 
where its cpu intersects with the set of mems but with the above 
restriction that update_nodemask() fails with -EINVAL if its changed to be 
disjoint.

> I still feel lukewarm about the
> ability to put kthreadd to !root cgroup tho.  I mean, for any kind of
> sane accounting, forked kthreads would have to be further classified
> and where kthreadd lives and fork happens wouldn't matter all that
> much.

Forked kthreads may not have to be further classified if the memcg cgroup, 
for example, is mounted after boot and you want to track the memory usage 
of all workqueues or kmem incurred by certain syscalls that don't get 
attributed to the thread calling the syscall because the memory allocation 
is done by a kthread.

The problem is that I'm not in a position to say what everybodys use-case 
is or isn't so I'm biased toward unnecessarily restricting it unless 
absolutely necessary (for cpusets and cpu _until_ we move in the direction 
where update_nodemask(), for example, can fail when PF_THREAD_BOUND 
threads are attached).

I'd also hate to see a cgroup come along in the future, perhaps for 
security where you can only access certain portions of a thread's state if 
they are in the same cgroup, where this will make even more sense beyond 
memcg and cpuacct and then we get into a discussion about why kthreadd is 
prohibited and need to recall this discussion that it's only really 
cpusets and cpu.

> It feels like we're fussing over stuff which isn't that
> significant either way.
> 

Well, I'm fussing over it because the patch being considered unnecessary 
requires that kthreadd can't be moved anywhere and I know one company is 
trying to move in a direction where nothing is in the root memcg.

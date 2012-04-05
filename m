Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab2DEWzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:55:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37250 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2DEWzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:55:14 -0400
Date: Thu, 5 Apr 2012 15:55:11 -0700 (PDT)
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
In-Reply-To: <20120405222400.GC29517@google.com>
Message-ID: <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com> <1333604949.7783.76.camel@marge.simpson.net> <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com> <1333608177.7783.106.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com> <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com> <20120405160829.GA12854@google.com> <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com> <20120405213704.GA29517@google.com>
 <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com> <20120405222400.GC29517@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Tejun Heo wrote:

> > The reason we're discussing kthreadd here is because it has the funny 
> > ability to fork other kthreads that become PF_THREAD_BOUND.  Usually the 
> > only PF_THREAD_BOUND threads are ones created at boot.  However, if a 
> > kthread is started for a specific cpu, it gets this bit set to stay on 
> > that cpu via kthread_bind().  That's what causes an inconsistency for only 
> > two types of cgroups: cpusets and cpu and we don't allow them to move 
> > amongst them because of that.
> 
> That and because ramifications of putting kthreadd is difficult to
> predict it being the root of all kthreads.  It's fine to be able to
> put specific kthreads into cgroups if doing such makes sense for that
> type of kthreads.
> 

But it's not fine to put kthreadd in a cgroup to monitor cpu or memory of 
workqueues?  We're using the forking property of attaching all children to 
the same cgroup as its parent.  Modules calling daemonize() get reparented 
to kthreadd but are not moved amongst cgroups in which they were created, 
why wouldn't they be attached to the root cgroup too if you're going to 
mandate this for all cgroups?  We need no cpuset or cpu consideration here 
because daemonize() does not adjust the cpu affinity of the user thread.

> > That's what this patch series addresses.  Please don't unnecessarily limit 
> > our ability with kthreadd or kthreads in general for accounting of system 
> > activity.
> 
> I can see your point but the problem is that it conflicts with the
> long term direction cgroup is taking and that cgroup seems generally
> over-engineered to allow too many things which aren't too necessary to
> the point where it's a giant pain in the ass for the subsystems and
> people involved, so I'm far more likely to go for chopping down and
> restricting stuff if it's not strictly necessary.

How does kthreadd's placement conflict with the long-term direction of 
cgroups?  We don't need to have a hierarchy for monitoring, we can easily 
iterate over all memcgs or cpu cgroups that house kernel threads or other 
daemons and add their memory.usage_in_bytes or cpuacct.usage if we want 
the aggregate.  The point is that we want to monitor the memory and cpu of 
a set of tasks and cgroups is naturally the perfect interface for doing 
this and already has cgroups such as memcg and cpuacct that allow it.

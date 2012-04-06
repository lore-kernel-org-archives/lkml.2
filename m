Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2DFUrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:47:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42578 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2DFUq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:46:59 -0400
Date: Fri, 6 Apr 2012 13:46:56 -0700 (PDT)
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
In-Reply-To: <20120406155203.GA4798@dhcp-172-17-108-109.mtv.corp.google.com>
Message-ID: <alpine.DEB.2.00.1204061337570.23328@chino.kir.corp.google.com>
References: <20120405160829.GA12854@google.com> <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com> <20120405213704.GA29517@google.com> <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com> <20120405222400.GC29517@google.com>
 <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com> <20120405225854.GE29517@google.com> <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com> <20120405231306.GF29517@google.com> <alpine.DEB.2.00.1204051630400.25838@chino.kir.corp.google.com>
 <20120406155203.GA4798@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Tejun Heo wrote:

> "Nothing in the root memcg" can't be a goal in and of itself.  You
> want that to achieve some functional goal and I'm trying to say this
> specific kthreadd change doesn't necessarily affect the goal - better
> accounting - all that much.  If root group is gonna be completely
> empty otherwise, just combine information from it.

That doesn't work, the kmem extension to memcg does not allow slab to be 
properly accounted to threads in the root memcg.  From 
Documentation/cgroups/memory.txt section 2.7:

"Kernel memory limits are not imposed for the root cgroup. Usage for the 
root cgroup may or may not be accounted."

Kernel memory, I'm sure we'll all agree, is particularly pertinent for 
kthreadd and would really be the most interesting reason to ever move it 
to a different memcg.  This is the use-case that I cited when I said we're 
moving in a direction to have nothing in the root memcg, for finer-grained 
accounting of kernel memory.

> Even if that
> doesn't work, assigning specific kthreads to appropriate cgroups after
> the creation wouldn't be too far off.  I just don't see how relevant
> it actually would be.
> 

What about for workqueues?

> If we want all controlles to play by the same rules, which is
> necessary for having a unified hierarchy, I wanna keep those rules
> simple.

That's a different goal, in my opinion.  We already talked about how we 
relax the restriction on PF_THREAD_BOUND for both cpusets and cpuacct by 
doing -EINVAL for changes to a cgroup that include such threads that are 
invalid (for cpusets, changing cpuset.mems to be different than the bound 
cpu; for cpu, force rt_runtime for attachment).  If we do that then we 
don't need any special handling of kthreadd either, which is the direction 
in which I thought this discussion was going.

In the interim, however, we need a restriction in place for kthreadd for 
both cgroups until such time as that is made a reality.  It's not like 
we're going to dictate everyone use a signal hierarchy in 3.4.

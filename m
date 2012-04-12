Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965375Ab2DLOzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:55:22 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:51452 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965169Ab2DLOzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:55:20 -0400
Date: Thu, 12 Apr 2012 16:55:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
Message-ID: <20120412145507.GC11455@somewhere.redhat.com>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <20120412010745.GE1787@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412010745.GE1787@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 03:07:45AM +0200, Johannes Weiner wrote:
> On Wed, Apr 11, 2012 at 08:57:20PM +0200, Frederic Weisbecker wrote:
> > Hi,
> > 
> > While talking with Tejun about targetting the cgroup task counter subsystem
> > for the next merge window, he suggested to check if this could be merged into
> > the memcg subsystem rather than creating a new one cgroup subsystem just
> > for task count limit purpose.
> > 
> > So I'm pinging you guys to seek your insight.
> 
> I'm sorry you are given a runaround like this with that code.

Nevermind, as long as I end up with something with most people are fine
with.

> 
> > I assume not everybody in the Cc list knows what the task counter subsystem
> > is all about. So here is a summary: this is a cgroup subsystem (latest version
> > in https://lwn.net/Articles/478631/) that keeps track of the number of tasks
> > present in a cgroup. Hooks are set in task fork/exit and cgroup migration to
> > maintain this accounting visible to a special tasks.usage file. The user can
> > set a limit on the number of tasks by writing on the tasks.limit file.
> > Further forks or cgroup migration are then rejected if the limit is exceeded.
> > 
> > This feature is especially useful to protect against forkbombs in containers.
> > Or more generally to limit the resources on the number of tasks on a cgroup
> > as it involves some kernel memory allocation.
> 
> You could also twist this around and argue the same for cpu usage and
> make it part of the cpu cgroup, but it doesn't really fit in either
> subsystem, IMO.

Ok.

> 
> > Now the dilemna is how to implement it?
> > 
> > 1) As a standalone subsystem, as it stands currently (https://lwn.net/Articles/478631/)
> 
> What was wrong with that again?

Nothing. Tejun and I just wanted to do a last check to see if we are not
missing an existing interface/subsys where it would potentially fit.

> 
> > 2) As a feature in memcg, part of the memory.kmem.* files. This makes sense
> > because this is about kernel memory allocation limitation. We could have a
> > memory.kmem.tasks.count
> > 
> > My personal opinion is that the task counter brings some overhead: a charge
> > across the whole hierarchy at every fork, and the mirrored uncharge on task exit.
> > And this overhead happens even in the off-case (when the task counter susbsystem
> > is mounted but the limit is the default: ULLONG_MAX).
> 
> 3) Make it an integral part of cgroups, because keeping track of tasks
> in them already is, so it would be a more natural approach than
> bolting it onto the memory controller.

(Adding Kosaki in Cc because he proposed me the same at the collab
summit).

Yeah. But keeping track of tasks is not unconditional in cgroups. It
triggers only after the first call to cgroup_iter_start(). It seems
we've tried hard to keep the check for this lockless. The end result
is that we account new tasks in cgroup_post_fork(): after the task is
added on the tasklist.

If we want to use the task tracking for counting purpose on top of
which we can cancel a fork, we need to move it before the task is added
to the tasklist. Because afterward it can't be cancelled anymore.

Doing this means that we can't do the task tracking conditionally
anymore.

That said, this lockless off-case is an issue on some other areas.
Like this race in the cgroup freezer: https://lkml.org/lkml/2012/3/8/69

So for now doing this in the cgroup core involves a real overhead even
in the off-case.

> 
> But this has the same overhead.  And even if this would end up being a
> better idea, we could still do this after merging it as a separate
> controller as long as we maintain the interface.

Yeah indeed.

> 
> > So if we choose the second solution, this overhead will be added unconditionally
> > to memcg.
> > But I don't expect every users of memcg will need the task counter. So perhaps
> > the overhead should be kept in its own separate subsystem.
> > 
> > OTOH memory.kmem.* interface would have be a good fit.
> > 
> > What do you think?
> 
> Instead of integrating it task-wise, could the problem be solved by
> accounting the kernel stack to kmem?  And then have a kmem limit,
> which we already want anway?

I don't know how the kernel stack is allocated for tasks. Do you mean
that we allocate a chunck of it for each new task and we could rely
on that?

> After all, we would only restrict the number of tasks for the
> resources they require

It depends if the kernel stack can have other kind of "consumer".

>, not to only allow an arbitrary number of tasks
> (unless one wants to sell Windows 7 Starter style containers, in which
> case one can go play with oneself out of tree as far as I'm concerned)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2DLLc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:32:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37859 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761794Ab2DLLc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:32:27 -0400
Date: Thu, 12 Apr 2012 13:32:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
Message-ID: <20120412113217.GB11455@somewhere.redhat.com>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <4F862851.3040208@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F862851.3040208@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 09:56:49AM +0900, KAMEZAWA Hiroyuki wrote:
> (2012/04/12 3:57), Frederic Weisbecker wrote:
> 
> > Hi,
> > 
> > While talking with Tejun about targetting the cgroup task counter subsystem
> > for the next merge window, he suggested to check if this could be merged into
> > the memcg subsystem rather than creating a new one cgroup subsystem just
> > for task count limit purpose.
> > 
> > So I'm pinging you guys to seek your insight.
> > 
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
> > 
> > Now the dilemna is how to implement it?
> > 
> > 1) As a standalone subsystem, as it stands currently (https://lwn.net/Articles/478631/)
> > 
> > 2) As a feature in memcg, part of the memory.kmem.* files. This makes sense
> > because this is about kernel memory allocation limitation. We could have a
> > memory.kmem.tasks.count
> > 
> > My personal opinion is that the task counter brings some overhead: a charge
> > across the whole hierarchy at every fork, and the mirrored uncharge on task exit.
> > And this overhead happens even in the off-case (when the task counter susbsystem
> > is mounted but the limit is the default: ULLONG_MAX).
> > 
> > So if we choose the second solution, this overhead will be added unconditionally
> > to memcg.
> > But I don't expect every users of memcg will need the task counter. So perhaps
> > the overhead should be kept in its own separate subsystem.
> > 
> > OTOH memory.kmem.* interface would have be a good fit.
> > 
> > What do you think?
> 
> 
> Sounds interesting to me. Hm, does your 'overhead' of task accounting is
> enough large to be visible to users ? How performance regression is big ?

I haven't measured. But on every fork, we do a res_counter_charge() that
walks through css_set and all its css_set ancestors, take a spinlock and
increment something to every level. In terms of cache trashing and algorithm
complexity, I believe the issue is real.

> BTW, now, all memcg's limit interfaces use 'bytes' as an unit of accounting.
> It's a small concern to me to have mixture of bytes and numbers of objects
> for accounting.

Indeed, this can be confusing for users.

> But I think increasing number of subsystem is not very good....

If the result is a better granularity on the overhead, I believe this
can be a good thing.

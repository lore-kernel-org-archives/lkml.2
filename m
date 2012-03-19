Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031829Ab2CSPFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:05:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53645 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031623Ab2CSPFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:05:15 -0400
Date: Mon, 19 Mar 2012 16:05:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        =?utf-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Message-ID: <20120319150507.GD2660@somewhere>
References: <4F587199.6050404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F587199.6050404@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 04:45:13PM +0800, Li Zefan wrote:
> A similar bug exists in cpuset, and those are long-standing bugs.
> 
> As reported by Frederic:
> 
> > When a user freezes a cgroup, the freezer sets the subsystem state
> > to CGROUP_FREEZING and then iterates over the tasks in the cgroup links.
> > 
> > But there is a possible race here, although unlikely, if a task
> > forks and the parent is preempted between write_unlock(tasklist_lock)
> > and cgroup_post_fork(). If we freeze the cgroup while the parent
> > is sleeping and the parent wakes up thereafter, its child will
> > be missing from the set of tasks to freeze because:
> > 
> > - The child was not yet linked to its css_set->tasks, as is done
> > from cgroup_post_fork(). cgroup_iter_start() has thus missed it.
> > 
> > - The cgroup freezer's fork callback can handle that child but
> > cgroup_fork_callbacks() has been called already.
> 
> I try to fix it by using seqcount. We read the counter before calling
> cgroup_fork_callbacks(), and we check the counter after cgroup_post_fork().
> If the seq numbers don't match, we know the forking task's cgroup
> has been/is being frozen, so we freeze the child task.
> 
> cpuset can be fixed accordingly.
> 
> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I feel we are a bit stuck here. All these complications come from the
fact we are conditionally setting this css_set link.

I wish we could set it unconditionally on cgroup_fork() time.
This unfortunately implies at least locking the css_set and to do
a list_add() unconditionally. And at times where cgroup is often
critisized for the overhead it involves, I guess this is not welcome.

This ->post_fork() based solution is not pretty, unfortunately I can't
come with a better idea.

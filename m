Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab2HGDAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:00:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:48946 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932447Ab2HGDAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:00:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/BrE8Q6kbBgJybLkWyUe7gdn48HdGcUSWI8RG/la
	Ja5TS+1pE8M437
Message-ID: <1344308413.6846.7.camel@marge.simpson.net>
Subject: Re: [patch] sched,cgroup_sched: fix up task_groups list
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 07 Aug 2012 05:00:13 +0200
In-Reply-To: <1344285688.27828.114.camel@twins>
References: <1344267125.6853.33.camel@marge.simpson.net>
	 <1344279897.27828.97.camel@twins>
	 <1344283776.6768.10.camel@marge.simpson.net>
	 <1344285688.27828.114.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 22:41 +0200, Peter Zijlstra wrote: 
> On Mon, 2012-08-06 at 22:09 +0200, Mike Galbraith wrote:
> > On Mon, 2012-08-06 at 21:04 +0200, Peter Zijlstra wrote: 
> > > On Mon, 2012-08-06 at 17:32 +0200, Mike Galbraith wrote:
> > > > Thinko happened during sched migration to kernel/sched, fix it up.
> > > 
> > > what's the effect.. that is what broke and why are we backporting this
> > > to -stable?
> > 
> > The effect is that for_each_rt_rq() doesn't work, because it's not the
> > same task_groups list that groups were added to, it's an empty list, so
> > __enable/disable_runtime() and print_rt_stats() don't work, and you
> > can't see rt task groups.
> 
> It seems to me this makes for excellent changelog material ;-)

You do have a point there.  Back when I was looking for why the hell rt
task groups went missing, it was "<facepalm> well _duh_" upon finding
the why, and changelog seemed self evident ;-)

sched,cgroup_sched: fix up task_groups list

With multiple instances of task_groups, for_each_rt_rq() is a noop,
no task groups having been added to the rt.c list instance.  This
renders __enable/disable_runtime() and print_rt_stats() noop, the
user (non) visible effect being that rt task groups are missing in
/proc/sched_debug.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: stable@kernel.org # v3.3+
---
 kernel/sched/core.c  |    1 +
 kernel/sched/sched.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7246,6 +7246,7 @@ int in_sched_functions(unsigned long add
 
 #ifdef CONFIG_CGROUP_SCHED
 struct task_group root_task_group;
+LIST_HEAD(task_groups);
 #endif
 
 DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -80,7 +80,7 @@ extern struct mutex sched_domains_mutex;
 struct cfs_rq;
 struct rt_rq;
 
-static LIST_HEAD(task_groups);
+extern struct list_head task_groups;
 
 struct cfs_bandwidth {
 #ifdef CONFIG_CFS_BANDWIDTH



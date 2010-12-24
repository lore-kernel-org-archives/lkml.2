Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0LXP7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 10:59:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:46038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0LXP7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 10:59:32 -0500
Subject: [PATCH] sched, cgroup: Use exit hook to avoid use-after-free crash
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Miklos Vajna <vmiklos@frugalware.org>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, Greg KH <greg@kroah.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <1293192999.18035.4.camel@marge.simson.net>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	 <1277808215.1868.5.camel@laptop>
	 <20101219020313.GJ31750@genesis.frugalware.org>
	 <20101222002248.GP10557@genesis.frugalware.org>
	 <1293006589.2170.41.camel@laptop>
	 <1293007311.11370.172.camel@marge.simson.net>
	 <1293008842.2170.70.camel@laptop>
	 <20101222133154.GS10557@genesis.frugalware.org>
	 <1293026422.2170.136.camel@laptop> <1293027112.2170.140.camel@laptop>
	 <20101222151434.GW10557@genesis.frugalware.org>
	 <1293037718.2170.155.camel@laptop> <1293050173.2170.389.camel@laptop>
	 <AANLkTi=1GMKF4emms0Qpx31=xk-FZXOTaeONmCohzWb2@mail.gmail.com>
	 <1293106330.2170.618.camel@laptop>  <1293107624.2170.642.camel@laptop>
	 <1293128670.2170.748.camel@laptop>
	 <1293132304.6798.6.camel@marge.simson.net>
	 <1293132862.25981.22.camel@laptop>
	 <1293187425.7138.2.camel@marge.simson.net>
	 <1293188091.25981.200.camel@laptop>
	 <1293192999.18035.4.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 24 Dec 2010 16:59:13 +0100
Message-ID: <1293206353.29444.205.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-24 at 13:16 +0100, Mike Galbraith wrote:
> On Fri, 2010-12-24 at 11:54 +0100, Peter Zijlstra wrote:

> > Right, so the cgroup core is supposed to already emit -EBUSY when there
> > are associated tasks with the cgroup, that _should_ be sufficient, the
> > pre_destroy() method is to frob some extra constraints or somesuch.
> > 
> > Our problem looks to be that a task (afaict usually current) changes
> > cgroups without us getting notified of it. On destruction the task is
> > still enqueued in the cfs_rq being destroyed but is not actually part of
> > that cgroup according to the task->css bits.
> 
> Could it be an exiting task?  We're still preemptible, and iirc, you run
> a CONFIG_PREEMPT kernel.  (grasp at all straws;)
> 
> cgroup_exit:
>         /* Reassign the task to the init_css_set. */
>         task_lock(tsk);
>         cg = tsk->cgroups;
>         tsk->cgroups = &init_css_set;
>         task_unlock(tsk);
>         if (cg)
>                 put_css_set_taskexit(cg);
> 

This straw appears true:

$ grep -e cpu_cgroup\\\|f491447c log9

...

kworker/-1196    0d..2. 1601180us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /system/systemd-modules-load.service
kworker/-1196    0d..2. 1601186us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /system/systemd-modules-load.service
kworker/-1196    0d..2. 1601188us : __dequeue_entity: f491447c from f492a480, 1 left
kworker/-1196    0d..2. 1601188us : pick_next_task_fair: picked: f491447c, modprobe/1210
kworker/-1196    0d..2. 1601192us : __print_runqueue:      curr: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /system/systemd-modules-load.service
modprobe-1210    0d..5. 1601802us : __print_runqueue:      curr: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
modprobe-1210    0d..5. 1601807us : __print_runqueue:      curr: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
modprobe-1210    0d..2. 1601817us : __print_runqueue:      curr: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
modprobe-1210    0d..2. 1601819us : __enqueue_entity: f491447c to f492a480, 1 tasks
modprobe-1210    0d..2. 1601826us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
modprobe-1210    0d..2. 1601832us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
modprobe-1210    0d..2. 1601839us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
kworker/-1196    0d..2. 1601848us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
kworker/-1196    0d..2. 1601854us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
kworker/-1196    0d..2. 1601860us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
kworker/-1196    0d..2. 1601865us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
kworker/-1196    0d..2. 1601871us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
kworker/-1196    0d..2. 1601872us : __dequeue_entity: f491447c from f492a480, 1 left
kworker/-1196    0d..2. 1601873us : pick_next_task_fair: picked: f491447c, modprobe/1210
kworker/-1196    0d..2. 1601876us : __print_runqueue:      curr: f491447c, comm: modprobe/1210, state: 0, load: 1024, cgroup: /
modprobe-1210    0d..7. 1601895us : __print_runqueue:      curr: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
modprobe-1210    0d..7. 1601900us : __print_runqueue:      curr: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
modprobe-1210    0d..2. 1601909us : __print_runqueue:      curr: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
modprobe-1210    0d..2. 1601911us : __enqueue_entity: f491447c to f492a480, 1 tasks
modprobe-1210    0d..2. 1601918us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
modprobe-1210    0d..2. 1601924us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
modprobe-1210    0d..2. 1601931us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
kworker/-1196    0d..2. 1602071us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
kworker/-1196    0d..2. 1602080us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
kworker/-1196    0d..2. 1602089us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
kworker/-1196    0d..2. 1602097us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
kworker/-1196    0d..2. 1602105us : __print_runqueue:      se: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
kworker/-1196    0d..2. 1602107us : __dequeue_entity: f491447c from f492a480, 1 left
kworker/-1196    0d..2. 1602108us : pick_next_task_fair: picked: f491447c, modprobe/1210
kworker/-1196    0d..2. 1602114us : __print_runqueue:      curr: f491447c, comm: modprobe/1210, state: 16, load: 1024, cgroup: /
modprobe-1210    0d..3. 1602128us : __print_runqueue:      curr: f491447c, comm: modprobe/1210, state: 80, load: 1024, cgroup: /


So cgroup moves a task without calling cgroup_subsys::attach() which is
odd, but it does have an ::exit method, sadly it calls that _before_
re-assigning the task, which means we have to jump through some hoops.

The below seems to fix the problem for me..

---
Subject: sched, cgroup: Use exit hook to avoid use-after-free crash

By not notifying the controller of the on-exit move back to
init_css_set, we fail to move the task out of the previous cgroup's
cfs_rq. This leads to an opportunity for a cgroup-destroy to come in and
free the cgroup (there are no active tasks left in it after all) to
which the not-quite dead task is still enqueued.

Cc: stable@kernel.org
Reported-by: Miklos Vajna <vmiklos@frugalware.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7e401f8..572625c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -611,6 +611,9 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct task_group *tg;
 	struct cgroup_subsys_state *css;
 
+	if (p->flags & PF_EXITING)
+		return &root_task_group;
+
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
 			lockdep_is_held(&task_rq(p)->lock));
 	tg = container_of(css, struct task_group, css);
@@ -8887,6 +8890,12 @@ cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	}
 }
 
+static void
+cpu_cgroup_exit(struct cgroup_subsys *ss, struct task_struct *task)
+{
+	sched_move_task(task);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
@@ -8959,6 +8968,7 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 	.destroy	= cpu_cgroup_destroy,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
+	.exit		= cpu_cgroup_exit,
 	.populate	= cpu_cgroup_populate,
 	.subsys_id	= cpu_cgroup_subsys_id,
 	.early_init	= 1,



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1BHKXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:23:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab1BHKXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:23:16 -0500
Subject: Re: [RFC][PATCH] cgroup: Fix cgroup_subsys::exit callback
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Menage <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
In-Reply-To: <AANLkTikWS86TPjp+J=iiwCQJ56pqYTQo8Z9_V20GEcEz@mail.gmail.com>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
	 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>
	 <20110202115012.GA16409@balbir.in.ibm.com>
	 <1296650792.26581.319.camel@laptop>
	 <20110202190251.GB16409@balbir.in.ibm.com>
	 <1297095033.13327.46.camel@laptop>
	 <AANLkTimF+8XAZxF4psrXSKx1CHFxin6AW=tu5OLGUgNi@mail.gmail.com>
	 <1297108959.13327.54.camel@laptop>
	 <AANLkTikWS86TPjp+J=iiwCQJ56pqYTQo8Z9_V20GEcEz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 11:24:15 +0100
Message-ID: <1297160655.13327.92.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 13:21 -0800, Paul Menage wrote:
> On Mon, Feb 7, 2011 at 12:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2011-02-07 at 11:28 -0800, Paul Menage wrote:
> >> On Mon, Feb 7, 2011 at 8:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> >
> >> > Make the ::exit method act like ::attach, it is after all very nearly
> >> > the same thing.
> >>
> >> The major difference between attach and exit is that the former is
> >> only triggered in response to user cgroup-management action, whereas
> >> the latter is triggered whenever a task exits, even if cgroups aren't
> >> set up.
> >
> > And the major likeness is that they both migrate a task from one cgroup
> > to another. You cannot simply ignore that.
> 
> True, and the exit path for cgroups has always been a bit fuzzy - that
> was kind of inherited from cpusets, where this worked out OK, but the
> CPU subsystem has more interesting requirements.

Yeah, from that pov we're actually still a running task that can and
will scheduler still.

> An important semantic difference between attach and exit is that in
> the exit case the destination is always the root, and the task in
> question is going to be exiting before doing anything else
> interesting. So it should be possible to optimize that path a lot
> compared to the regular attach (many things related to resource usage
> can be ignored, since the task won't have time to actually use any
> non-trivial amount of resources).

One could also argue that the accumulated time (/other resources) of all
tasks exiting might end up being a significant amount, but yeah
whatever :-)

I'm mostly concerned with not wrecking state (and crashing/leaking etc).

> >
> > If maybe you're like respond more often than about once every two months
> > I might actually care what you think.
> 
> Yes, sadly since switching groups at Google, cgroups has become pretty
> much just a spare-time activity for me 

And here I thought Google was starting to understand what community
participation meant.. is there anybody you know who can play a more
active role in the whole cgroup thing?

> - but that in itself doesn't
> automatically invalidate my opinion when I do have time to respond.
> It's still the case that cgroup_mutex is an incredibly heavyweight
> mutex that has no business being in the task exit path. Or do you just
> believe that ad hominem is a valid style of argument?

No, it was mostly frustration talking.

> How about if the exit callback was moved before the preceding
> task_unlock()? Since I think the scheduler is still the only user of
> the exit callback, redefining the locking semantics should be fine.

Like the below? Both the perf and sched exit callback are fine with
being called under task_lock afaict, but I haven't actually ran with
lockdep enabled to see if I missed something.

I also pondered doing the cgroup exit from __put_task_struct() but that
had another problem iirc.

---
Index: linux-2.6/include/linux/cgroup.h
===================================================================
--- linux-2.6.orig/include/linux/cgroup.h
+++ linux-2.6/include/linux/cgroup.h
@@ -474,7 +474,8 @@ struct cgroup_subsys {
 			struct cgroup *old_cgrp, struct task_struct *tsk,
 			bool threadgroup);
 	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
-	void (*exit)(struct cgroup_subsys *ss, struct task_struct *task);
+	void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			struct cgroup *old_cgrp, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -4230,20 +4230,8 @@ void cgroup_post_fork(struct task_struct
  */
 void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 {
-	int i;
 	struct css_set *cg;
-
-	if (run_callbacks && need_forkexit_callback) {
-		/*
-		 * modular subsystems can't use callbacks, so no need to lock
-		 * the subsys array
-		 */
-		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
-			struct cgroup_subsys *ss = subsys[i];
-			if (ss->exit)
-				ss->exit(ss, tsk);
-		}
-	}
+	int i;
 
 	/*
 	 * Unlink from the css_set task list if necessary.
@@ -4261,7 +4249,24 @@ void cgroup_exit(struct task_struct *tsk
 	task_lock(tsk);
 	cg = tsk->cgroups;
 	tsk->cgroups = &init_css_set;
+
+	if (run_callbacks && need_forkexit_callback) {
+		/*
+		 * modular subsystems can't use callbacks, so no need to lock
+		 * the subsys array
+		 */
+		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
+			struct cgroup_subsys *ss = subsys[i];
+			if (ss->exit) {
+				struct cgroup *old_cgrp =
+					rcu_dereference_raw(cg->subsys[i])->cgroup;
+				struct cgroup *cgrp = task_cgroup(tsk, i);
+				ss->exit(ss, cgrp, old_cgrp, tsk);
+			}
+		}
+	}
 	task_unlock(tsk);
+
 	if (cg)
 		put_css_set_taskexit(cg);
 }
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -606,9 +606,6 @@ static inline struct task_group *task_gr
 	struct task_group *tg;
 	struct cgroup_subsys_state *css;
 
-	if (p->flags & PF_EXITING)
-		return &root_task_group;
-
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
 			lockdep_is_held(&task_rq(p)->lock));
 	tg = container_of(css, struct task_group, css);
@@ -9081,7 +9078,8 @@ cpu_cgroup_attach(struct cgroup_subsys *
 }
 
 static void
-cpu_cgroup_exit(struct cgroup_subsys *ss, struct task_struct *task)
+cpu_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
+		struct cgroup *old_cgrp, struct task_struct *task)
 {
 	/*
 	 * cgroup_exit() is called in the copy_process() failure path.



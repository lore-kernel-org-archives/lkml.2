Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455Ab0KPM6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:58:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:40509 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758180Ab0KPM6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:58:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+zVhJpVvizVsETvelSbm13lykPp7Yl/DY1it3jS8
	ND6jI4SZPGv/l2
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <menage@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Daniel Lezcano <daniel.lezcano@free.fr>
In-Reply-To: <AANLkTikvcug2V70Uy7oGnO5vFZbS+DLvzP4wpysdU5uV@mail.gmail.com>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
	 <1288078144.7478.9.camel@marge.simson.net>
	 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
	 <1289489200.11397.21.camel@maggy.simson.net> <30291.1289860866@localhost>
	 <1289864780.14719.172.camel@maggy.simson.net>
	 <AANLkTikztvdgFucCUjZ+A5Je-LUKLknV5+aznVvL98oQ@mail.gmail.com>
	 <1289865870.14719.185.camel@maggy.simson.net>
	 <AANLkTik53N7HMyXMOEzh2Qr_4gg9eXSmXiT6TQ9gFC+h@mail.gmail.com>
	 <AANLkTikvcug2V70Uy7oGnO5vFZbS+DLvzP4wpysdU5uV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 05:58:19 -0700
Message-ID: <1289912299.5169.53.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 17:55 -0800, Paul Menage wrote:
> On Mon, Nov 15, 2010 at 5:18 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > so sched_debug_show() is apparently calling cgroup_path() with a NULL
> > cgroup. I think it's "print_task()" that is to blame, it does
> >
> >     cgroup_path(task_group(p)->css.cgroup, ..
> >
> > without checking whether there _is_ any css.cgroup.
> 
> Right - previously the returned task_group would be always associated
> with a cgroup. Now, it may not be.
> 
> The original task_group() should be made accessible for anything that
> wants a real cgroup in the scheduler hierarchy, and called from the
> new task_group() function. Not sure what the best naming convention
> would be, maybe task_group() and effective_task_group() ?

effective_task_group() works for me.  Autogroup (currently at least)
only needs to interface with set_task_rq().

A tasty alternative would be to have autogroup be it's own subsystem,
with full cgroup userspace visibility/tweakability.  I have no idea if
that's feasible though.  I glanced at cgroup.c, but didn't see the dirt
simple I wanted, and quickly ran away. 

---
 kernel/sched.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -606,27 +606,33 @@ static inline int cpu_of(struct rq *rq)
  */
 static inline struct task_group *task_group(struct task_struct *p)
 {
-	struct task_group *tg;
 	struct cgroup_subsys_state *css;
 
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
 			lockdep_is_held(&task_rq(p)->lock));
-	tg = container_of(css, struct task_group, css);
+	return container_of(css, struct task_group, css);
+}
 
-	return autogroup_task_group(p, tg);
+static inline struct task_group *effective_task_group(struct task_struct *p)
+{
+	return autogroup_task_group(p, task_group(p));
 }
 
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
+#if (defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
+	struct task_group *tg = effective_task_group(p);
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
-	p->se.parent = task_group(p)->se[cpu];
+	p->se.cfs_rq = tg->cfs_rq[cpu];
+	p->se.parent = tg->se[cpu];
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
-	p->rt.parent = task_group(p)->rt_se[cpu];
+	p->rt.rt_rq  = tg->rt_rq[cpu];
+	p->rt.parent = tg->rt_se[cpu];
 #endif
 }
 



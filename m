Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1BVOCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:02:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:40094 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752906Ab1BVOCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:02:04 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19aXGESAU9aSJTad/QbbZzQHBeS6/hpQ4YCypd0Y4
	VZ/DY6WWf0rnTC
Subject: Re: [PATCH V2] sched, autogroup: always show autogroup name in
 sched_debug
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110222121002.GA2100@zhy>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
	 <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
	 <1298207379.7998.11.camel@marge.simson.net> <20110220141003.GA6006@zhy>
	 <1298222533.7881.15.camel@marge.simson.net>
	 <1298306175.24121.14.camel@twins>
	 <AANLkTin_aqBTXUyO4H-p1_4i-9FAvxChBi1QpPFXvqD_@mail.gmail.com>
	 <1298368566.2217.18.camel@twins>  <20110222121002.GA2100@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 15:02:00 +0100
Message-ID: <1298383320.8036.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 20:10 +0800, Yong Zhang wrote:
> On Tue, Feb 22, 2011 at 10:56:06AM +0100, Peter Zijlstra wrote:
> > On Tue, 2011-02-22 at 11:13 +0800, Yong Zhang wrote:
> > > So show autogroup name always. But for the root group,
> > > its name will dance between "cfs_rq[cpu]:" and
> > > "cfs_rq[cpu]:/autogroup-0" according to
> > > sysctl_sched_autogroup_enabled. 
> > 
> > Would it make sense to force the root group to always be a !autogroup?
> 
> Hmmm, I think it's ok.

Yup, it's not an autogroup, so let's stop claiming it.

sched, autogroup: stop claiming ownership of the root task group.

Disown it, and only display autogroup association if one exists.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 9fb6562..506faa0 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -12,7 +12,6 @@ static atomic_t autogroup_seq_nr;
 static void __init autogroup_init(struct task_struct *init_task)
 {
 	autogroup_default.tg = &root_task_group;
-	root_task_group.autogroup = &autogroup_default;
 	kref_init(&autogroup_default.kref);
 	init_rwsem(&autogroup_default.lock);
 	init_task->signal->autogroup = &autogroup_default;
@@ -130,7 +129,7 @@ task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 
 static inline bool task_group_is_autogroup(struct task_group *tg)
 {
-	return tg != &root_task_group && tg->autogroup;
+	return !!tg->autogroup;
 }
 
 static inline struct task_group *
@@ -247,10 +246,14 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 {
 	struct autogroup *ag = autogroup_task_get(p);
 
+	if (!task_group_is_autogroup(ag->tg))
+		goto out;
+
 	down_read(&ag->lock);
 	seq_printf(m, "/autogroup-%ld nice %d\n", ag->id, ag->nice);
 	up_read(&ag->lock);
 
+out:
 	autogroup_kref_put(ag);
 }
 #endif /* CONFIG_PROC_FS */
@@ -258,9 +261,7 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 #ifdef CONFIG_SCHED_DEBUG
 static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
 {
-	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
-
-	if (!enabled || !tg->autogroup)
+	if (!task_group_is_autogroup(tg))
 		return 0;
 
 	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);




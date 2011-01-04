Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab1ADOT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:19:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:32983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1ADOT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:19:26 -0500
Date: Tue, 4 Jan 2011 14:18:52 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, oleg@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
In-Reply-To: <1292508592.5940.28.camel@maggy.simson.net>
References: <1292508592.5940.28.camel@maggy.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, autogroup: Fix potential access to freed memory
Message-ID: <tip-4f8219875a0dad2cfad9e93a3fafcd9626db98d2@git.kernel.org>
Git-Commit-ID: 4f8219875a0dad2cfad9e93a3fafcd9626db98d2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 14:18:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f8219875a0dad2cfad9e93a3fafcd9626db98d2
Gitweb:     http://git.kernel.org/tip/4f8219875a0dad2cfad9e93a3fafcd9626db98d2
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 16 Dec 2010 15:09:52 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Jan 2011 15:10:34 +0100

sched, autogroup: Fix potential access to freed memory

Oleg pointed out that the /proc interface kref_get() useage may race with
the final put during autogroup_move_group().  A signal->autogroup assignment
may be in flight when the /proc interface dereference, leaving them taking
a reference to an already dead group.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1292508592.5940.28.camel@maggy.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_autogroup.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 57a7ac2..c80fedc 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -41,6 +41,20 @@ static inline struct autogroup *autogroup_kref_get(struct autogroup *ag)
 	return ag;
 }
 
+static inline struct autogroup *autogroup_task_get(struct task_struct *p)
+{
+	struct autogroup *ag;
+	unsigned long flags;
+
+	if (!lock_task_sighand(p, &flags))
+		return autogroup_kref_get(&autogroup_default);
+
+	ag = autogroup_kref_get(p->signal->autogroup);
+	unlock_task_sighand(p, &flags);
+
+	return ag;
+}
+
 static inline struct autogroup *autogroup_create(void)
 {
 	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
@@ -149,11 +163,7 @@ EXPORT_SYMBOL(sched_autogroup_detach);
 
 void sched_autogroup_fork(struct signal_struct *sig)
 {
-	struct task_struct *p = current;
-
-	spin_lock_irq(&p->sighand->siglock);
-	sig->autogroup = autogroup_kref_get(p->signal->autogroup);
-	spin_unlock_irq(&p->sighand->siglock);
+	sig->autogroup = autogroup_task_get(current);
 }
 
 void sched_autogroup_exit(struct signal_struct *sig)
@@ -172,7 +182,6 @@ __setup("noautogroup", setup_autogroup);
 
 #ifdef CONFIG_PROC_FS
 
-/* Called with siglock held. */
 int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
 {
 	static unsigned long next = INITIAL_JIFFIES;
@@ -194,7 +203,7 @@ int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
 		return -EAGAIN;
 
 	next = HZ / 10 + jiffies;
-	ag = autogroup_kref_get(p->signal->autogroup);
+	ag = autogroup_task_get(p);
 
 	down_write(&ag->lock);
 	err = sched_group_set_shares(ag->tg, prio_to_weight[*nice + 20]);
@@ -209,7 +218,7 @@ int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
 
 void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 {
-	struct autogroup *ag = autogroup_kref_get(p->signal->autogroup);
+	struct autogroup *ag = autogroup_task_get(p);
 
 	down_read(&ag->lock);
 	seq_printf(m, "/autogroup-%ld nice %d\n", ag->id, ag->nice);

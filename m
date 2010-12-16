Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab0LPOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:09:57 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58942 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755884Ab0LPOJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:09:55 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/o+6AHT2XoC7TguBg7DbCufMKoNmVYOWJXd++9Hn
	HmChAl52lP92kE
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
 automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, mathieu.desnoyers@efficios.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        markus@trippelsdorf.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1292486036.10931.314.camel@maggy.simson.net>
References: <1290281700.28711.9.camel@maggy.simson.net>
	 <tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
	 <20101215175010.GA14267@redhat.com>
	 <1292486036.10931.314.camel@maggy.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 15:09:52 +0100
Message-ID: <1292508592.5940.28.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 08:53 +0100, Mike Galbraith wrote:
> On Wed, 2010-12-15 at 18:50 +0100, Oleg Nesterov wrote:

> Thanks again for your excellent eyeballs.  The below should plug that
> hole, no?  (hope so, seems pointless to lock movement)

I'd also have to disable interrupts though, so may as well just lock it.

I didn't do the -ESRCH or no display bit.  As far as autogroup is
concerned, if you couldn't lock, it's history, so belongs to init.

sched: fix potential access to freed memory

Oleg pointed out that the /proc interface kref_get() useage may race with
the final put during autogroup_move_group().  A signal->autogroup assignment
may be in flight when the /proc interface dereference, leaving them taking
a reference to an already dead group.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>

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



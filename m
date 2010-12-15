Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0LOR53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:57:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab0LOR51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:57:27 -0500
Date: Wed, 15 Dec 2010 18:50:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, mathieu.desnoyers@efficios.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        markus@trippelsdorf.de, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
	automated per session task groups
Message-ID: <20101215175010.GA14267@redhat.com>
References: <1290281700.28711.9.camel@maggy.simson.net> <tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply, I am slowly crawling through my mbox...

On 11/30, tip-bot for Mike Galbraith wrote:
>
> Commit-ID:  5091faa449ee0b7d73bc296a93bca9540fc51d0a
> Gitweb:     http://git.kernel.org/tip/5091faa449ee0b7d73bc296a93bca9540fc51d0a
> Author:     Mike Galbraith <efault@gmx.de>
> AuthorDate: Tue, 30 Nov 2010 14:18:03 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 30 Nov 2010 16:03:35 +0100

I assume this is the latest version. In this case I think it needs
minor fixes.

> +#ifdef CONFIG_PROC_FS
> +
> +/* Called with siglock held. */

This is not true, and that is why we can't blindly use kref_get().

> +int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
> +{
> +	static unsigned long next = INITIAL_JIFFIES;
> +	struct autogroup *ag;
> +	int err;
> +
> +	if (*nice < -20 || *nice > 19)
> +		return -EINVAL;
> +
> +	err = security_task_setnice(current, *nice);
> +	if (err)
> +		return err;
> +
> +	if (*nice < 0 && !can_nice(current, *nice))
> +		return -EPERM;
> +
> +	/* this is a heavy operation taking global locks.. */
> +	if (!capable(CAP_SYS_ADMIN) && time_before(jiffies, next))
> +		return -EAGAIN;
> +
> +	next = HZ / 10 + jiffies;
> +	ag = autogroup_kref_get(p->signal->autogroup);

We can race with autogroup_move_group() and use the already freed
->autogroup. We need ->siglock or task_rq_lock() to read it.

IOW, I think we need something like the patch below, but - sorry -
if was completely untested.

And the question,

> +	down_write(&ag->lock);
> +	err = sched_group_set_shares(ag->tg, prio_to_weight[*nice + 20]);

Do we really want this if ag == autogroup_default ? Say, autogroup_create()
fails, now the owner of this process can affect init_task_group. Or admin
can change init_task_group "by accident" (although currently this is hardly
possible, sched_autogroup_detach() has no callers). Just curious.

Oleg.

--- a/kernel/sched_autogroup.c
+++ a/kernel/sched_autogroup.c
@@ -41,6 +41,19 @@ static inline struct autogroup *autogrou
 	return ag;
 }
 
+static struct autogroup *task_get_autogroup(struct task_struct *p)
+{
+	struct autogroup *ag = NULL;
+	unsigned long flags;
+
+	if (lock_task_sighand(p, &flags)) {
+		ag = autogroup_kref_get(p->signal->autogroup);
+		unlock_task_sighand(p, &flags);
+	}
+
+	return ag;
+}
+
 static inline struct autogroup *autogroup_create(void)
 {
 	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
@@ -149,11 +162,7 @@ EXPORT_SYMBOL(sched_autogroup_detach);
 
 void sched_autogroup_fork(struct signal_struct *sig)
 {
-	struct task_struct *p = current;
-
-	spin_lock_irq(&p->sighand->siglock);
-	sig->autogroup = autogroup_kref_get(p->signal->autogroup);
-	spin_unlock_irq(&p->sighand->siglock);
+	sig->autogroup = task_get_autogroup(current);
 }
 
 void sched_autogroup_exit(struct signal_struct *sig)
@@ -172,7 +181,6 @@ __setup("noautogroup", setup_autogroup);
 
 #ifdef CONFIG_PROC_FS
 
-/* Called with siglock held. */
 int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
 {
 	static unsigned long next = INITIAL_JIFFIES;
@@ -193,9 +201,11 @@ int proc_sched_autogroup_set_nice(struct
 	if (!capable(CAP_SYS_ADMIN) && time_before(jiffies, next))
 		return -EAGAIN;
 
-	next = HZ / 10 + jiffies;
-	ag = autogroup_kref_get(p->signal->autogroup);
+	ag = task_get_autogroup(p);
+	if (!ag)
+		return -ESRCH;
 
+	next = HZ / 10 + jiffies;
 	down_write(&ag->lock);
 	err = sched_group_set_shares(ag->tg, prio_to_weight[*nice + 20]);
 	if (!err)
@@ -209,7 +219,10 @@ int proc_sched_autogroup_set_nice(struct
 
 void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 {
-	struct autogroup *ag = autogroup_kref_get(p->signal->autogroup);
+	struct autogroup *ag = task_get_autogroup(p);
+
+	if (!ag)
+		return;
 
 	down_read(&ag->lock);
 	seq_printf(m, "/autogroup-%ld nice %d\n", ag->id, ag->nice);


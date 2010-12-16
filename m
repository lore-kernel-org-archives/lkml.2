Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0LPHyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 02:54:01 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41388 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753549Ab0LPHx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 02:53:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ObHAEGRBOxHD1YLcdKT4bHzRNz5LFMcOOxPzgAY
	CO7XRg1HFTNqCq
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
 automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, mathieu.desnoyers@efficios.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        markus@trippelsdorf.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101215175010.GA14267@redhat.com>
References: <1290281700.28711.9.camel@maggy.simson.net>
	 <tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
	 <20101215175010.GA14267@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 08:53:56 +0100
Message-ID: <1292486036.10931.314.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 18:50 +0100, Oleg Nesterov wrote:

> I assume this is the latest version. In this case I think it needs
> minor fixes.
> 
> > +#ifdef CONFIG_PROC_FS
> > +
> > +/* Called with siglock held. */
> 
> This is not true, and that is why we can't blindly use kref_get().

I was going to lock it all up, but convinced myself it wasn't necessary.
The comment should have also gone away.

> > +int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
> > +{
> > +	static unsigned long next = INITIAL_JIFFIES;
> > +	struct autogroup *ag;
> > +	int err;
> > +
> > +	if (*nice < -20 || *nice > 19)
> > +		return -EINVAL;
> > +
> > +	err = security_task_setnice(current, *nice);
> > +	if (err)
> > +		return err;
> > +
> > +	if (*nice < 0 && !can_nice(current, *nice))
> > +		return -EPERM;
> > +
> > +	/* this is a heavy operation taking global locks.. */
> > +	if (!capable(CAP_SYS_ADMIN) && time_before(jiffies, next))
> > +		return -EAGAIN;
> > +
> > +	next = HZ / 10 + jiffies;
> > +	ag = autogroup_kref_get(p->signal->autogroup);
> 
> We can race with autogroup_move_group() and use the already freed
> ->autogroup. We need ->siglock or task_rq_lock() to read it.

I don't see how/why.  I took a reference to the new group before
assignment of p->signal->autogroup, and put the previous group after
it's assigned.

Ponders that.. uhoh.

Mover does atomic write, but signal->autogroup write comes after that,
so can still be in flight when reader dereferences.  Game over unless
the reader beats ->autogroup writer to the punch.

Thanks again for your excellent eyeballs.  The below should plug that
hole, no?  (hope so, seems pointless to lock movement)

> IOW, I think we need something like the patch below, but - sorry -
> if was completely untested.
> 
> And the question,
> 
> > +	down_write(&ag->lock);
> > +	err = sched_group_set_shares(ag->tg, prio_to_weight[*nice + 20]);
> 
> Do we really want this if ag == autogroup_default ? Say, autogroup_create()
> fails, now the owner of this process can affect init_task_group. Or admin
> can change init_task_group "by accident" (although currently this is hardly
> possible, sched_autogroup_detach() has no callers). Just curious.

sched_group_set_shares() does the right thing, says no to changing the
root task group's shares.



sched: fix potential access to freed memory

Oleg pointed out that the /proc interface kref_get() useage may race with
the final put during autogroup_move_group().  A signal->autogroup assignment
may be in flight when the /proc interface dereference, leaving them taking
a reference to an already dead group.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 57a7ac2..713b6c0 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -41,6 +41,12 @@ static inline struct autogroup *autogroup_kref_get(struct autogroup *ag)
 	return ag;
 }
 
+static inline struct autogroup *autogroup_task_get(struct task_struct *p)
+{
+	smp_rmb();
+	return autogroup_kref_get(p->signal->autogroup);
+}
+
 static inline struct autogroup *autogroup_create(void)
 {
 	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
@@ -119,6 +125,7 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 	}
 
 	p->signal->autogroup = autogroup_kref_get(ag);
+	smp_mb();
 
 	t = p;
 	do {
@@ -172,7 +179,6 @@ __setup("noautogroup", setup_autogroup);
 
 #ifdef CONFIG_PROC_FS
 
-/* Called with siglock held. */
 int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
 {
 	static unsigned long next = INITIAL_JIFFIES;
@@ -194,7 +200,7 @@ int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
 		return -EAGAIN;
 
 	next = HZ / 10 + jiffies;
-	ag = autogroup_kref_get(p->signal->autogroup);
+	ag = autogroup_task_get(p);
 
 	down_write(&ag->lock);
 	err = sched_group_set_shares(ag->tg, prio_to_weight[*nice + 20]);
@@ -209,7 +215,7 @@ int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
 
 void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 {
-	struct autogroup *ag = autogroup_kref_get(p->signal->autogroup);
+	struct autogroup *ag = autogroup_task_get(p);
 
 	down_read(&ag->lock);
 	seq_printf(m, "/autogroup-%ld nice %d\n", ag->id, ag->nice);



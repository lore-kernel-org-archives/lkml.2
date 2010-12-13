Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0LMQmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:42:31 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:44634 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab0LMQm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:42:28 -0500
Subject: Re: [patch v2 4/4] taskstats: Export "cdata_wait" CPU times with
 taskstats
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20101213143306.GA22840@redhat.com>
References: <20101129164237.522034198@linux.vnet.ibm.com>
	 <20101129164435.903722027@linux.vnet.ibm.com>
	 <20101201185128.GA7656@redhat.com>
	 <1291307641.1928.125.camel@holzheu-laptop>
	 <20101208202308.GA1804@redhat.com>
	 <1291987580.1933.10.camel@holzheu-laptop>
	 <20101211173931.GA8084@redhat.com>
	 <1292245515.2063.168.camel@holzheu-laptop>
	 <1292246456.2063.179.camel@holzheu-laptop>
	 <20101213143306.GA22840@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 13 Dec 2010 17:42:24 +0100
Message-ID: <1292258544.2063.189.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 15:33 +0100, Oleg Nesterov wrote:
> > --- a/include/linux/taskstats_kern.h
> > +++ b/include/linux/taskstats_kern.h
> > @@ -21,7 +21,8 @@ static inline void taskstats_tgid_free(s
> >  		kmem_cache_free(taskstats_cache, sig->stats);
> >  }
> >  
> > -extern void taskstats_exit(struct task_struct *, int group_dead);
> > +extern void taskstats_exit_notify(struct task_struct *, int group_dead);
> > +extern void taskstats_exit_add_thread(struct task_struct *);
> You forgot to update the !CONFIG_TASKSTATS case ;)

... of course, thanks!

[snip]

> Well. I do not like the fact we take ->siglock unconditionally.
> And _irqsave is not needed. And we take it twice if sig->stats == NULL.
> And "if (!tsk->signal->stats)" under ->siglock in
> taskstats_exit_add_thread() looks a bit ugly...

Yes I also saw that, but I didn't want to change too much. In fact your
code is much better. I added it to the patch and also replaced
_add_thread with _add_task, because task seems to be the term for thread
used in the taskstats code. I also did some testing. Everything still
seems to work well.

The new patch is attached below. Balbir, do you agree?

Michael
---
 include/linux/taskstats_kern.h |    8 +++-
 kernel/exit.c                  |    3 +
 kernel/taskstats.c             |   67 ++++++++++++++---------------------------
 3 files changed, 32 insertions(+), 46 deletions(-)

--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -21,10 +21,14 @@ static inline void taskstats_tgid_free(s
 		kmem_cache_free(taskstats_cache, sig->stats);
 }
 
-extern void taskstats_exit(struct task_struct *, int group_dead);
+extern void taskstats_exit_notify(struct task_struct *tsk, int group_dead);
+extern void taskstats_exit_add_task(struct task_struct *tsk);
 extern void taskstats_init_early(void);
 #else
-static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
+static inline void taskstats_exit_notify(struct task_struct *tsk,
+					 int group_dead)
+{}
+static inline void taskstats_exit_add_task(struct task_struct *tsk);
 {}
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {}
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1030,6 +1030,7 @@ NORET_TYPE void do_exit(long code)
 	/* sync mm's RSS info before statistics gathering */
 	if (tsk->mm)
 		sync_mm_rss(tsk, tsk->mm);
+	taskstats_exit_add_task(tsk);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		struct cdata *tcd = &tsk->signal->cdata_threads;
@@ -1045,7 +1046,7 @@ NORET_TYPE void do_exit(long code)
 		audit_free(tsk);
 
 	tsk->exit_code = code;
-	taskstats_exit(tsk, group_dead);
+	taskstats_exit_notify(tsk, group_dead);
 
 	exit_mm(tsk);
 
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -263,24 +263,35 @@ out:
 	return rc;
 }
 
-static void fill_tgid_exit(struct task_struct *tsk)
+void taskstats_exit_add_task(struct task_struct *tsk)
 {
-	unsigned long flags;
+	struct taskstats *stats = NULL;
 
-	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	if (!tsk->signal->stats)
-		goto ret;
+	if (!tsk->signal->stats) {
+		if (thread_group_empty(tsk))
+			return;
 
+		stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
+		if (!stats)
+			return; /* Bad luck, we will loose this task */
+	}
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (!tsk->signal->stats) {
+		tsk->signal->stats = stats;
+		stats = NULL;
+	}
 	/*
 	 * Each accounting subsystem calls its functions here to
 	 * accumalate its per-task stats for tsk, into the per-tgid structure
 	 *
-	 *	per-task-foo(tsk->signal->stats, tsk);
+	 *      per-task-foo(tsk->signal->stats, tsk);
 	 */
 	delayacct_add_tsk(tsk->signal->stats, tsk);
-ret:
-	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
-	return;
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	if (unlikely(stats))
+		kmem_cache_free(taskstats_cache, stats);
 }
 
 static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
@@ -530,39 +541,14 @@ static int taskstats_user_cmd(struct sk_
 		return -EINVAL;
 }
 
-static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
-{
-	struct signal_struct *sig = tsk->signal;
-	struct taskstats *stats;
-
-	if (sig->stats || thread_group_empty(tsk))
-		goto ret;
-
-	/* No problem if kmem_cache_zalloc() fails */
-	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
-
-	spin_lock_irq(&tsk->sighand->siglock);
-	if (!sig->stats) {
-		sig->stats = stats;
-		stats = NULL;
-	}
-	spin_unlock_irq(&tsk->sighand->siglock);
-
-	if (stats)
-		kmem_cache_free(taskstats_cache, stats);
-ret:
-	return sig->stats;
-}
-
 /* Send pid data out on exit */
-void taskstats_exit(struct task_struct *tsk, int group_dead)
+void taskstats_exit_notify(struct task_struct *tsk, int group_dead)
 {
 	int rc;
 	struct listener_list *listeners;
 	struct taskstats *stats;
 	struct sk_buff *rep_skb;
 	size_t size;
-	int is_thread_group;
 
 	if (!family_registered)
 		return;
@@ -573,13 +559,8 @@ void taskstats_exit(struct task_struct *
 	size = nla_total_size(sizeof(u32)) +
 		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
 
-	is_thread_group = !!taskstats_tgid_alloc(tsk);
-	if (is_thread_group) {
-		/* PID + STATS + TGID + STATS */
-		size = 2 * size;
-		/* fill the tsk->signal->stats structure */
-		fill_tgid_exit(tsk);
-	}
+	if (group_dead && tsk->signal->stats)
+		size = 2 * size; /* PID + STATS + TGID + STATS */
 
 	listeners = &__raw_get_cpu_var(listener_array);
 	if (list_empty(&listeners->list))
@@ -598,7 +579,7 @@ void taskstats_exit(struct task_struct *
 	/*
 	 * Doesn't matter if tsk is the leader or the last group member leaving
 	 */
-	if (!is_thread_group || !group_dead)
+	if (!group_dead || tsk->signal->stats == NULL)
 		goto send;
 
 	stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tsk->tgid);



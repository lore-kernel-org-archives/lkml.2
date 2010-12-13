Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab0LMNVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:21:06 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:42552 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab0LMNVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:21:03 -0500
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
In-Reply-To: <1292245515.2063.168.camel@holzheu-laptop>
References: <20101129164237.522034198@linux.vnet.ibm.com>
	 <20101129164435.903722027@linux.vnet.ibm.com>
	 <20101201185128.GA7656@redhat.com>
	 <1291307641.1928.125.camel@holzheu-laptop>
	 <20101208202308.GA1804@redhat.com>
	 <1291987580.1933.10.camel@holzheu-laptop>
	 <20101211173931.GA8084@redhat.com>
	 <1292245515.2063.168.camel@holzheu-laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 13 Dec 2010 14:20:56 +0100
Message-ID: <1292246456.2063.179.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 14:05 +0100, Michael Holzheu wrote:
> > And this looks racy, or I missed something again. group_dead can be
> > true, but this doesn't mean all other threads have already passed
> > taskstats_exit()->fill_tgid_exit()->delayacct_add_tsk().
> 
> I think you are right.
> 
> One way to fix that could be to separate the aggregation from the
> sending. We could call fill_tgid_exit()->delayacct_add_tsk() before
> atomic_dec_and_test(&tsk->signal->live) in do_exit() and
> taskstats_exit() with the sender part afterwards.

Something like the following patch...
---
 include/linux/taskstats_kern.h |    3 +
 kernel/exit.c                  |    3 +
 kernel/taskstats.c             |   62 +++++++++++++++++------------------------
 3 files changed, 31 insertions(+), 37 deletions(-)

--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -21,7 +21,8 @@ static inline void taskstats_tgid_free(s
 		kmem_cache_free(taskstats_cache, sig->stats);
 }
 
-extern void taskstats_exit(struct task_struct *, int group_dead);
+extern void taskstats_exit_notify(struct task_struct *, int group_dead);
+extern void taskstats_exit_add_thread(struct task_struct *);
 extern void taskstats_init_early(void);
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1030,6 +1030,7 @@ NORET_TYPE void do_exit(long code)
 	/* sync mm's RSS info before statistics gathering */
 	if (tsk->mm)
 		sync_mm_rss(tsk, tsk->mm);
+	taskstats_exit_add_thread(tsk);
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
@@ -263,10 +263,32 @@ out:
 	return rc;
 }
 
-static void fill_tgid_exit(struct task_struct *tsk)
+static void alloc_signal_stats(struct task_struct *tsk)
+{
+	struct signal_struct *sig = tsk->signal;
+	struct taskstats *stats;
+
+	/* No problem if kmem_cache_zalloc() fails */
+	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (!sig->stats) {
+		sig->stats = stats;
+		stats = NULL;
+	}
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	if (stats)
+		kmem_cache_free(taskstats_cache, stats);
+}
+
+void taskstats_exit_add_thread(struct task_struct *tsk)
 {
 	unsigned long flags;
 
+	if (tsk->signal->stats == NULL && !thread_group_empty(tsk))
+		alloc_signal_stats(tsk);
+
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
 	if (!tsk->signal->stats)
 		goto ret;
@@ -530,39 +552,14 @@ static int taskstats_user_cmd(struct sk_
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
@@ -573,13 +570,8 @@ void taskstats_exit(struct task_struct *
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
@@ -598,7 +590,7 @@ void taskstats_exit(struct task_struct *
 	/*
 	 * Doesn't matter if tsk is the leader or the last group member leaving
 	 */
-	if (!is_thread_group || !group_dead)
+	if (!group_dead || tsk->signal->stats == NULL)
 		goto send;
 
 	stats = mk_reply(rep_skb, TASKSTATS_TYPE_TGID, tsk->tgid);




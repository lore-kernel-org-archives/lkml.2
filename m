Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab2FBJuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 05:50:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50426 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865Ab2FBJua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 05:50:30 -0400
MIME-Version: 1.0
In-Reply-To: <CA+i8gK+H-hm9bjJub4siH0pCdOrzRxJXaX2QjosnKCjeWYPt4A@mail.gmail.com>
References: <CAJd=RBB1s-_VOtoDsBbLidS51HwW6e98p=U-4mL-spByUMvETw@mail.gmail.com>
	<CA+i8gKKQyGBc-BNBJ72S6rq7aiFqS=onqWQyeY4P+VVvFCeXJw@mail.gmail.com>
	<CAJd=RBA=mvMGQgdKgW26dgd8nK2-_dW_epQLwbjOo2Zx2gsbeg@mail.gmail.com>
	<CA+i8gK+H-hm9bjJub4siH0pCdOrzRxJXaX2QjosnKCjeWYPt4A@mail.gmail.com>
Date: Sat, 2 Jun 2012 17:50:29 +0800
Message-ID: <CAJd=RBBxnD7JirPpy-jTgE9kpnZXN6gkTMsgcG8=goZxgQfTaQ@mail.gmail.com>
Subject: Re: [patch] BFS 420: a tiny step forward
From: Hillf Danton <dhillf@gmail.com>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Manuel Krause <manuelkrause@t-online.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel and Manuel

On Thu, May 31, 2012 at 9:16 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>
> it builds fine now but it won't boot. Some crappy
> mobile phone picture here:
> http://ompldr.org/vZTE1eQ/IMG_20120531_200543.jpg
>
The ttwu was messed up by Hillf, lets revert it.

Good Weekend
-hd


--- a/kernel/sched/bfs.c	Sat Jun  2 17:14:58 2012
+++ b/kernel/sched/bfs.c	Sat Jun  2 17:30:28 2012
@@ -1491,6 +1491,8 @@ static void ttwu_stat(struct task_struct
 #ifdef CONFIG_SMP
 	if (success)
 		p->wakeup_cpu = smp_processor_id();
+#else
+	schedstat_inc(rq, ttwu_local);
 #endif
 	schedstat_inc(rq, ttwu_count);
 #endif
@@ -1515,8 +1517,6 @@ static inline void ttwu_post_activation(
 					bool success)
 {
 	trace_sched_wakeup(p, success);
-	if (!success)
-		return;
 	p->state = TASK_RUNNING;

 	/*
@@ -1562,8 +1562,6 @@ static bool try_to_wake_up(struct task_s
 	/* This barrier is undocumented, probably for p->state? くそ */
 	smp_wmb();

-	if (!(p->state & state))
-		goto out;
 	/*
 	 * No need to do time_lock_grq as we only need to update the rq clock
 	 * if we activate the task
@@ -1586,7 +1584,6 @@ out_running:
 out_unlock:
 	task_grq_unlock(&flags);

-out:
 	ttwu_stat(p, success);

 	put_cpu();
@@ -1610,17 +1607,14 @@ static void try_to_wake_up_local(struct
 	lockdep_assert_held(&grq.lock);

 	if (!(p->state & TASK_NORMAL))
-		goto out;
-
-	if (task_queued(p) || task_running(p))
-		goto out;
-
-	ttwu_activate(p, rq, false);
-	success = true;
+		return;

-out:
+	if (!task_queued(p)) {
+		ttwu_activate(p, rq, false);
+		success = true;
+		ttwu_stat(p, success);
+	}
 	ttwu_post_activation(p, rq, success);
-	ttwu_stat(p, success);
 }

 /**
@@ -3052,8 +3046,10 @@ task_struct *earliest_deadline_task(stru
 			 * deadline when the CPU is scaling, based on cpu
 			 * cache locality.
 			 */
-			dl = p->deadline << (locality_diff(p, rq) +
-							!!scaling_rq(rq));
+			dl = p->deadline;
+#ifdef CONFIG_SMP
+			dl <<= locality_diff(p, rq) + scaling_rq(rq);
+#endif

 			if (deadline_before(dl, earliest_deadline)) {
 				earliest_deadline = dl;
--

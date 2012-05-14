Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab2ENNVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:21:33 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36297 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab2ENNVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:21:32 -0400
MIME-Version: 1.0
Date: Mon, 14 May 2012 21:21:31 +0800
Message-ID: <CAJd=RBCQpVgNzAiFn5q1MnJAqctOrOZGK7U-GyCkHWg=TfCyCw@mail.gmail.com>
Subject: [2/3] BFS 420: compact enqueue_task
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A helper is added to reflect the meat of the two enqueue routines.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Mon May 14 20:53:28 2012
@@ -698,6 +698,16 @@ static bool isoprio_suitable(void)
 	return !grq.iso_refractory;
 }

+static void __enqueue_task(struct task_struct *p, bool at_head)
+{
+	__set_bit(p->prio, grq.prio_bitmap);
+	if (at_head)
+		list_add(&p->run_list, grq.queue + p->prio);
+	else
+		list_add_tail(&p->run_list, grq.queue + p->prio);
+	sched_info_queued(p);
+}
+
 /*
  * Adding to the global runqueue. Enter with grq locked.
  */
@@ -711,17 +721,13 @@ static void enqueue_task(struct task_str
 		else
 			p->prio = NORMAL_PRIO;
 	}
-	__set_bit(p->prio, grq.prio_bitmap);
-	list_add_tail(&p->run_list, grq.queue + p->prio);
-	sched_info_queued(p);
+	__enqueue_task(p, false);
 }

 /* Only idle task does this as a real time task*/
 static inline void enqueue_task_head(struct task_struct *p)
 {
-	__set_bit(p->prio, grq.prio_bitmap);
-	list_add(&p->run_list, grq.queue + p->prio);
-	sched_info_queued(p);
+	__enqueue_task(p, true);
 }

 static inline void requeue_task(struct task_struct *p)
--

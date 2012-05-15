Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab2EONZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:25:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40925 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859Ab2EONZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:25:04 -0400
MIME-Version: 1.0
Date: Tue, 15 May 2012 21:25:03 +0800
Message-ID: <CAJd=RBAEavw-LE94_j9-9uz2c+SRjgzoRuHVAxyjGa7ac3j9+g@mail.gmail.com>
Subject: BFS 420: nuke the sticky bits
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right task could be selected without maitaining the sticky stuff but based on
CPU cache locality.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Tue May 15 21:12:54 2012
@@ -1095,6 +1095,7 @@ resched_closest_idle(struct rq *rq, int
 static inline void
 swap_sticky(struct rq *rq, int cpu, struct task_struct *p)
 {
+	return;
 	if (rq->sticky_task) {
 		if (rq->sticky_task == p) {
 			p->sticky = true;
@@ -3065,18 +3066,11 @@ task_struct *earliest_deadline_task(stru
 				continue;

 			/*
-			 * Soft affinity happens here by not scheduling a task
-			 * with its sticky flag set that ran on a different CPU
-			 * last when the CPU is scaling, or by greatly biasing
-			 * against its deadline when not, based on cpu cache
-			 * locality.
+			 * Soft affinity happens here by biasing against
+			 * deadline when the CPU is scaling, based on CPU
+			 * cache locality.
 			 */
-			if (task_sticky(p) && task_rq(p) != rq) {
-				if (scaling_rq(rq))
-					continue;
-				dl = p->deadline << locality_diff(p, rq);
-			} else
-				dl = p->deadline;
+			dl = p->deadline << (locality_diff(p, rq) + !!scaling_rq(rq));

 			if (deadline_before(dl, earliest_deadline)) {
 				earliest_deadline = dl;
--

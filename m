Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab2EYNfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:35:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54961 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab2EYNfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:35:38 -0400
MIME-Version: 1.0
Date: Fri, 25 May 2012 21:35:37 +0800
Message-ID: <CAJd=RBCk2--3+W1ub8yUF7vSnFkUTJKf-dpH_BwmRYCGfBj+7A@mail.gmail.com>
Subject: [patch 3/4] BFS 420: add task state check in ttwu
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the given state does not match task, no bother acquiring the global
runqueue lock.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Fri May 25 20:28:00 2012
@@ -1583,6 +1583,8 @@ static bool try_to_wake_up(struct task_s
 	/* This barrier is undocumented, probably for p->state? くそ */
 	smp_wmb();

+	if (!(p->state & state))
+		goto out;
 	/*
 	 * No need to do time_lock_grq as we only need to update the rq clock
 	 * if we activate the task
@@ -1597,14 +1599,14 @@ static bool try_to_wake_up(struct task_s
 	if (task_queued(p) || task_running(p))
 		goto out_running;

-	ttwu_activate(p, rq, wake_flags & WF_SYNC);
+	ttwu_activate(p, rq, !!(wake_flags & WF_SYNC));
 	success = true;

 out_running:
 	ttwu_post_activation(p, rq, success);
 out_unlock:
 	task_grq_unlock(&flags);
-
+out:
 	ttwu_stat(p, cpu, success);

 	put_cpu();
--

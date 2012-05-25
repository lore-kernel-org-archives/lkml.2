Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2EYNhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:37:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34837 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2EYNhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:37:45 -0400
MIME-Version: 1.0
Date: Fri, 25 May 2012 21:37:45 +0800
Message-ID: <CAJd=RBDWf8yYsSj0h5nyDqqC2K2s5mx7xVZuvTBqfk2UL-cMLA@mail.gmail.com>
Subject: [patch 4/4] BFS 420: fix try_to_wake_up_local
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is changed to be the same behavior with ttwu.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Fri May 25 20:28:00 2012
@@ -1630,18 +1630,16 @@ static void try_to_wake_up_local(struct
 	lockdep_assert_held(&grq.lock);

 	if (!(p->state & TASK_NORMAL))
-		return;
+		goto out;

-	if (!task_queued(p)) {
-		if (likely(!task_running(p))) {
-			schedstat_inc(rq, ttwu_count);
-			schedstat_inc(rq, ttwu_local);
-		}
-		ttwu_activate(p, rq, false);
-		ttwu_stat(p, smp_processor_id(), true);
-		success = true;
-	}
+	if (task_queued(p) || task_running(p))
+		goto out;
+
+	ttwu_activate(p, rq, false);
+	success = true;
+out:
 	ttwu_post_activation(p, rq, success);
+	ttwu_stat(p, smp_processor_id(), success);
 }

 /**
--

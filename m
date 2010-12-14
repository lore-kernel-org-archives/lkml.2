Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab0LNN4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:56:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:42358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759278Ab0LNN4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:56:14 -0500
Message-ID: <4D077772.30600@kernel.org>
Date: Tue, 14 Dec 2010 14:56:02 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
CC: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, rostedt@goodmis.org
Subject: [GIT PULL UPDATED] workqueue for v2.6.37-rc4
References: <4D025824.7030407@kernel.org>
In-Reply-To: <4D025824.7030407@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 13:56:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

I made the following changes to the tree since the original pull
request.

* Added the tree info to the MAINTAINERS entry.

* Applied Steven Rostedt's patch to drop the reversed [un]likely() on
  WORK_NOT_RUNNING tests.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

Thanks.
---
Hitoshi Mitake (1):
      workqueue: check the allocation of system_unbound_wq

Steven Rostedt (1):
      workqueue: It is likely that WORKER_NOT_RUNNING is true

Tejun Heo (1):
      MAINTAINERS: Add workqueue entry

 MAINTAINERS        |    9 +++++++++
 kernel/workqueue.c |    7 ++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b3be8b3..374eecc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6585,6 +6585,15 @@ F:	include/linux/mfd/wm8400*
 F:	include/sound/wm????.h
 F:	sound/soc/codecs/wm*

+WORKQUEUE
+M:	Tejun Heo <tj@kernel.org>
+L:	linux-kernel@vger.kernel.org
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git
+S:	Maintained
+F:	include/linux/workqueue.h
+F:	kernel/workqueue.c
+F:	Documentation/workqueue.txt
+
 X.25 NETWORK LAYER
 M:	Andrew Hendry <andrew.hendry@gmail.com>
 L:	linux-x25@vger.kernel.org
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 90db1bd..e785b0f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -661,7 +661,7 @@ void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
 {
 	struct worker *worker = kthread_data(task);

-	if (likely(!(worker->flags & WORKER_NOT_RUNNING)))
+	if (!(worker->flags & WORKER_NOT_RUNNING))
 		atomic_inc(get_gcwq_nr_running(cpu));
 }

@@ -687,7 +687,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	struct global_cwq *gcwq = get_gcwq(cpu);
 	atomic_t *nr_running = get_gcwq_nr_running(cpu);

-	if (unlikely(worker->flags & WORKER_NOT_RUNNING))
+	if (worker->flags & WORKER_NOT_RUNNING)
 		return NULL;

 	/* this can only happen on the local cpu */
@@ -3692,7 +3692,8 @@ static int __init init_workqueues(void)
 	system_nrt_wq = alloc_workqueue("events_nrt", WQ_NON_REENTRANT, 0);
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
 					    WQ_UNBOUND_MAX_ACTIVE);
-	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
+	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq ||
+	       !system_unbound_wq);
 	return 0;
 }
 early_initcall(init_workqueues);

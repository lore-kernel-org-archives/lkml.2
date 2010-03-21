Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab0CUSt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 14:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0CUStX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 14:49:23 -0400
Date: Sun, 21 Mar 2010 19:47:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Veaceslav Falico <vfalico@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/3] kill the obsolete thread_group_cputime_free() and
	taskstats_tgid_init() helpers
Message-ID: <20100321184754.GA29075@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial, but a separate patch for paranoid reasons.

- Kill the empty thread_group_cputime_free() helper. It was needed
  to free the per-cpu data which we no longer have.

- Kill taskstats_tgid_init(), unneeded since
  "copy_signal() cleanup: use zalloc and remove initializations"
  a56704ef6b0c5796c9ff38cc78aa232dfb9644d7

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h          |    4 ----
 include/linux/taskstats_kern.h |    7 -------
 kernel/fork.c                  |    1 -
 3 files changed, 12 deletions(-)

--- 34-rc1/include/linux/sched.h~12_KILL_DEAD_HELPERS	2010-03-21 18:31:47.000000000 +0100
+++ 34-rc1/include/linux/sched.h	2010-03-21 18:35:01.000000000 +0100
@@ -2396,10 +2396,6 @@ static inline void thread_group_cputime_
 	sig->cputimer.running = 0;
 }
 
-static inline void thread_group_cputime_free(struct signal_struct *sig)
-{
-}
-
 /*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
--- 34-rc1/include/linux/taskstats_kern.h~12_KILL_DEAD_HELPERS	2010-03-21 18:31:47.000000000 +0100
+++ 34-rc1/include/linux/taskstats_kern.h	2010-03-21 18:35:01.000000000 +0100
@@ -14,11 +14,6 @@
 extern struct kmem_cache *taskstats_cache;
 extern struct mutex taskstats_exit_mutex;
 
-static inline void taskstats_tgid_init(struct signal_struct *sig)
-{
-	sig->stats = NULL;
-}
-
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {
 	if (sig->stats)
@@ -30,8 +25,6 @@ extern void taskstats_init_early(void);
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
-static inline void taskstats_tgid_init(struct signal_struct *sig)
-{}
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {}
 static inline void taskstats_init_early(void)
--- 34-rc1/kernel/fork.c~12_KILL_DEAD_HELPERS	2010-03-21 18:34:02.000000000 +0100
+++ 34-rc1/kernel/fork.c	2010-03-21 18:35:01.000000000 +0100
@@ -160,7 +160,6 @@ EXPORT_SYMBOL(free_task);
 
 static inline void free_signal_struct(struct signal_struct *sig)
 {
-	thread_group_cputime_free(sig);
 	kmem_cache_free(signal_cachep, sig);
 }
 


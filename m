Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0HQHzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:55:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:47086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab0HQHzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:55:39 -0400
Date: Tue, 17 Aug 2010 07:55:12 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jkacur@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkacur@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1281021054-4228-1-git-send-email-jkacur@redhat.com>
References: <1281021054-4228-1-git-send-email-jkacur@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep: Remove __debug_show_held_locks
Message-ID: <tip-f1b499f029c5dde85d46a8811353c62f29157541@git.kernel.org>
Git-Commit-ID: f1b499f029c5dde85d46a8811353c62f29157541
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 Aug 2010 07:55:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1b499f029c5dde85d46a8811353c62f29157541
Gitweb:     http://git.kernel.org/tip/f1b499f029c5dde85d46a8811353c62f29157541
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Thu, 5 Aug 2010 17:10:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Aug 2010 09:11:10 +0200

lockdep: Remove __debug_show_held_locks

There is no longer any functional difference between
__debug_show_held_locks() and debug_show_held_locks(),
so remove the former.

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1281021054-4228-1-git-send-email-jkacur@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/debug_locks.h |    5 -----
 kernel/hung_task.c          |    2 +-
 kernel/lockdep.c            |    8 +-------
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 29b3ce3..2833452 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -49,7 +49,6 @@ struct task_struct;
 
 #ifdef CONFIG_LOCKDEP
 extern void debug_show_all_locks(void);
-extern void __debug_show_held_locks(struct task_struct *task);
 extern void debug_show_held_locks(struct task_struct *task);
 extern void debug_check_no_locks_freed(const void *from, unsigned long len);
 extern void debug_check_no_locks_held(struct task_struct *task);
@@ -58,10 +57,6 @@ static inline void debug_show_all_locks(void)
 {
 }
 
-static inline void __debug_show_held_locks(struct task_struct *task)
-{
-}
-
 static inline void debug_show_held_locks(struct task_struct *task)
 {
 }
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 0c642d5..bca9423 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -98,7 +98,7 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 	printk(KERN_ERR "\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
 			" disables this message.\n");
 	sched_show_task(t);
-	__debug_show_held_locks(t);
+	debug_show_held_locks(t);
 
 	touch_nmi_watchdog();
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index f2852a5..84baa71 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3775,7 +3775,7 @@ EXPORT_SYMBOL_GPL(debug_show_all_locks);
  * Careful: only use this function if you are sure that
  * the task cannot run in parallel!
  */
-void __debug_show_held_locks(struct task_struct *task)
+void debug_show_held_locks(struct task_struct *task)
 {
 	if (unlikely(!debug_locks)) {
 		printk("INFO: lockdep is turned off.\n");
@@ -3783,12 +3783,6 @@ void __debug_show_held_locks(struct task_struct *task)
 	}
 	lockdep_print_held_locks(task);
 }
-EXPORT_SYMBOL_GPL(__debug_show_held_locks);
-
-void debug_show_held_locks(struct task_struct *task)
-{
-		__debug_show_held_locks(task);
-}
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
 void lockdep_sys_exit(void)

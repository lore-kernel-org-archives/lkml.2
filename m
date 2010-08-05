Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab0HEPL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:11:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40920 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab0HEPLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:11:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=lqJFCZkcOIWVCsNYbQ1COpeDfFZ7kxGGIgnEZZm9Pqmriz3axytcnbO0St8O4wAubE
         IQ+5cCHCfKgLlWNM+gMXdV8YRH+buq0WolIx6u7iF/ZzN/dKz7Q792QhIofDsNpK5PNO
         dO9Fgmt+xVCBT1XqIR0FX8nTldt7Zw0GDv1B8=
From: John Kacur <jkacur@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/2] lockdep: Remove __debug_show_held_locks
Date: Thu,  5 Aug 2010 17:10:53 +0200
Message-Id: <1281021054-4228-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no longer any functional difference between
__debug_show_held_locks() and debug_show_held_locks(),
so remove the former.

Signed-off-by: John Kacur <jkacur@redhat.com>
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
index 5428679..843030b 100644
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
-- 
1.7.2


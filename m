Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0ENMlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 08:41:22 -0400
Received: from smtp-out.google.com ([74.125.121.35]:63275 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0ENMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 08:41:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=GkD04CXNfLVSTMomBaXKG6lOEtI40AZg0HBwIntSZnZrH6m0R06D6KgqpXiq+hrrk
	SQhDSH7n1qBHskAZLOOZw==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 10/10] Use down_read_unfair() for /sys/<pid>/exe and /sys/<pid>/maps files
Date: Fri, 14 May 2010 05:39:42 -0700
Message-Id: <1273840782-5920-11-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273840782-5920-1-git-send-email-walken@google.com>
References: <1273840782-5920-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps in the following situation:
- Thread A takes a page fault while reading or writing memory.
  do_page_fault() acquires the mmap_sem for read and blocks on disk
  (either reading the page from file, or hitting swap) for a long time.
- Thread B does an mmap call and blocks trying to acquire the mmap_sem
  for write
- Thread C is a monitoring process trying to read every /proc/pid/maps
  in the system. This requires acquiring the mmap_sem for read. Thread C
  blocks behind B, waiting for A to release the rwsem.  If thread C
  could be allowed to run in parallel with A, it would probably get done
  long before thread A's disk access completes, thus not actually slowing
  down thread B.

The unfair behavior is restricted to processes with the CAP_SYS_NICE
capability in order to avoid possible DoS attacks.

Test results with down_read_unfair_test (10 seconds):

2.6.33.3:
threadA completes ~600 faults
threadB completes ~300 mmap/munmap cycles
threadC completes ~600 /proc/pid/maps reads

2.6.33.3 + down_read_unfair:
threadA completes ~600 faults
threadB completes ~300 mmap/munmap cycles
threadC completes ~160000 /proc/pid/maps reads

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 fs/proc/base.c             |    2 +-
 fs/proc/task_mmu.c         |    2 +-
 fs/proc/task_nommu.c       |    2 +-
 include/linux/capability.h |    1 +
 include/linux/rwsem.h      |    3 +++
 kernel/rwsem.c             |   14 ++++++++++++++
 6 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8418fcc..9941802 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1367,7 +1367,7 @@ struct file *get_mm_exe_file(struct mm_struct *mm)
 
 	/* We need mmap_sem to protect against races with removal of
 	 * VM_EXECUTABLE vmas */
-	down_read(&mm->mmap_sem);
+	down_read_unfair_if_nice_capable(&mm->mmap_sem);
 	exe_file = mm->exe_file;
 	if (exe_file)
 		get_file(exe_file);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 0705534..47127e7 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -123,7 +123,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	mm = mm_for_maps(priv->task);
 	if (!mm)
 		return NULL;
-	down_read(&mm->mmap_sem);
+	down_read_unfair_if_nice_capable(&mm->mmap_sem);
 
 	tail_vma = get_gate_vma(priv->task);
 	priv->tail_vma = tail_vma;
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 46d4b5d..af87191 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -194,7 +194,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		priv->task = NULL;
 		return NULL;
 	}
-	down_read(&mm->mmap_sem);
+	down_read_unfair_if_nice_capable(&mm->mmap_sem);
 
 	/* start from the Nth VMA */
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p))
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 39e5ff5..de003dc 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -296,6 +296,7 @@ struct cpu_vfs_cap_data {
    processes and setting the scheduling algorithm used by another
    process. */
 /* Allow setting cpu affinity on other processes */
+/* Allow unfair rwsem read acquire with down_read_unfair_if_nice_capable() */
 
 #define CAP_SYS_NICE         23
 
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 0d3310b..1322ee5 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -32,9 +32,12 @@ extern void down_read(struct rw_semaphore *sem);
  */
 #ifdef __HAVE_DOWN_READ_UNFAIR
 extern void down_read_unfair(struct rw_semaphore *sem);
+extern void down_read_unfair_if_nice_capable(struct rw_semaphore *sem);
 #else
 static inline void down_read_unfair(struct rw_semaphore *sem)
 	{ down_read(sem); }
+static inline void down_read_unfair_if_nice_capable(struct rw_semaphore *sem)
+	{ down_read(sem); }
 #endif
 
 /*
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index d7b424b..2c51880 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/capability.h>
 #include <linux/rwsem.h>
 
 #include <asm/system.h>
@@ -41,6 +42,19 @@ void __sched down_read_unfair(struct rw_semaphore *sem)
 
 EXPORT_SYMBOL(down_read_unfair);
 
+void __sched down_read_unfair_if_nice_capable(struct rw_semaphore *sem)
+{
+	int unfair = capable(CAP_SYS_NICE);
+
+	might_sleep();
+	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_read_trylock,
+		       (unfair ? __down_read_unfair : __down_read));
+}
+
+EXPORT_SYMBOL(down_read_unfair_if_nice_capable);
+
 #endif
 
 /*
-- 
1.7.0.1


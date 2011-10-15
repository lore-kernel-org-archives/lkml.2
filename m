Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1JONO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 09:14:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45415 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1JONOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 09:14:24 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 3/5] ipc/sem.c: Remove private structures from public header file
Date: Sat, 15 Oct 2011 15:21:48 +0200
Message-Id: <1318684908-1977-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/sem.h contains several structures that are only used
within ipc/sem.c.
The patch moves them into ipc/sem.c - there is no need to expose
the structures to the whole kernel.

No functional changes, only whitespace cleanups and 80-char per line fixes.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/sem.h |   42 ------------------------------------------
 ipc/sem.c           |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 1feb2de..4648426 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -83,13 +83,6 @@ struct  seminfo {
 
 struct task_struct;
 
-/* One semaphore structure for each semaphore in the system. */
-struct sem {
-	int	semval;		/* current value */
-	int	sempid;		/* pid of last operation */
-	struct list_head sem_pending; /* pending single-sop operations */
-};
-
 /* One sem_array data structure for each set of semaphores in the system. */
 struct sem_array {
 	struct kern_ipc_perm	____cacheline_aligned_in_smp
@@ -103,41 +96,6 @@ struct sem_array {
 	int			complex_count;	/* pending complex operations */
 };
 
-/* One queue for each sleeping process in the system. */
-struct sem_queue {
-	struct list_head	simple_list; /* queue of pending operations */
-	struct list_head	list;	 /* queue of pending operations */
-	struct task_struct	*sleeper; /* this process */
-	struct sem_undo		*undo;	 /* undo structure */
-	int    			pid;	 /* process id of requesting process */
-	int    			status;	 /* completion status of operation */
-	struct sembuf		*sops;	 /* array of pending operations */
-	int			nsops;	 /* number of operations */
-	int			alter;   /* does the operation alter the array? */
-};
-
-/* Each task has a list of undo requests. They are executed automatically
- * when the process exits.
- */
-struct sem_undo {
-	struct list_head	list_proc;	/* per-process list: all undos from one process. */
-						/* rcu protected */
-	struct rcu_head		rcu;		/* rcu struct for sem_undo() */
-	struct sem_undo_list	*ulp;		/* sem_undo_list for the process */
-	struct list_head	list_id;	/* per semaphore array list: all undos for one array */
-	int			semid;		/* semaphore set identifier */
-	short *			semadj;		/* array of adjustments, one per semaphore */
-};
-
-/* sem_undo_list controls shared access to the list of sem_undo structures
- * that may be shared among all a CLONE_SYSVSEM task group.
- */ 
-struct sem_undo_list {
-	atomic_t		refcnt;
-	spinlock_t		lock;
-	struct list_head	list_proc;
-};
-
 struct sysv_sem {
 	struct sem_undo_list *undo_list;
 };
diff --git a/ipc/sem.c b/ipc/sem.c
index 227948f..1be2aa9 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -90,6 +90,52 @@
 #include <asm/uaccess.h>
 #include "util.h"
 
+/* One semaphore structure for each semaphore in the system. */
+struct sem {
+	int	semval;		/* current value */
+	int	sempid;		/* pid of last operation */
+	struct list_head sem_pending; /* pending single-sop operations */
+};
+
+/* One queue for each sleeping process in the system. */
+struct sem_queue {
+	struct list_head	simple_list; /* queue of pending operations */
+	struct list_head	list;	 /* queue of pending operations */
+	struct task_struct	*sleeper; /* this process */
+	struct sem_undo		*undo;	 /* undo structure */
+	int			pid;	 /* process id of requesting process */
+	int			status;	 /* completion status of operation */
+	struct sembuf		*sops;	 /* array of pending operations */
+	int			nsops;	 /* number of operations */
+	int			alter;	 /* does *sops alter the array? */
+};
+
+/* Each task has a list of undo requests. They are executed automatically
+ * when the process exits.
+ */
+struct sem_undo {
+	struct list_head	list_proc;	/* per-process list: *
+						 * all undos from one process
+						 * rcu protected */
+	struct rcu_head		rcu;		/* rcu struct for sem_undo */
+	struct sem_undo_list	*ulp;		/* back ptr to sem_undo_list */
+	struct list_head	list_id;	/* per semaphore array list:
+						 * all undos for one array */
+	int			semid;		/* semaphore set identifier */
+	short			*semadj;	/* array of adjustments */
+						/* one per semaphore */
+};
+
+/* sem_undo_list controls shared access to the list of sem_undo structures
+ * that may be shared among all a CLONE_SYSVSEM task group.
+ */
+struct sem_undo_list {
+	atomic_t		refcnt;
+	spinlock_t		lock;
+	struct list_head	list_proc;
+};
+
+
 #define sem_ids(ns)	((ns)->ids[IPC_SEM_IDS])
 
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
-- 
1.7.6.4


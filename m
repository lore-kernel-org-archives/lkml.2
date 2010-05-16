Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0EPQnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 12:43:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35546 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0EPQnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 12:43:16 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] ipc/sem.c: Update description of the implementation
Date: Sun, 16 May 2010 18:44:38 +0200
Message-Id: <1274028278-1990-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipc/sem.c begins with a 15 year old description about bugs in the initial
implementation in Linux-1.0.
The patch replaces that with a top level description of the current code.

>From this text, a TODO could be derived:
The opengroup man page for semop() does not mandate FIFO.
Thus there is no need for a semaphore array list of pending operations.

If
- this list is removed
- the per-semaphore array spinlock is removed (possible if there is no
  list to protect)
- sem_otime is moved into the semaphores and calculated on demand during
  semctl()
then the array would be read-mostly - which would significantly improve
scaling for applications that use semaphore arrays with lots of entries.

The price would be expensive semctl() calls:

	for(i=0;i<sma->sem_nsems;i++) spin_lock(sma->sem_lock);
	<do stuff>
	for(i=0;i<sma->sem_nsems;i++) spin_unlock(sma->sem_lock);

I'm not sure if the complexity is worth the effort, thus here is the
documentation of the current behavior first.

Andrew - could you add the patch to your -mm tree?
It's on top of the series you have in your tree right now.

And: IMHO the whole series is ready for 2.6.35: It improves the scaling
and fixes some of the O(N^2) cases.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |  103 +++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 53 insertions(+), 50 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index a744eb5..9a22cdb 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -3,56 +3,6 @@
  * Copyright (C) 1992 Krishna Balasubramanian
  * Copyright (C) 1995 Eric Schenk, Bruno Haible
  *
- * IMPLEMENTATION NOTES ON CODE REWRITE (Eric Schenk, January 1995):
- * This code underwent a massive rewrite in order to solve some problems
- * with the original code. In particular the original code failed to
- * wake up processes that were waiting for semval to go to 0 if the
- * value went to 0 and was then incremented rapidly enough. In solving
- * this problem I have also modified the implementation so that it
- * processes pending operations in a FIFO manner, thus give a guarantee
- * that processes waiting for a lock on the semaphore won't starve
- * unless another locking process fails to unlock.
- * In addition the following two changes in behavior have been introduced:
- * - The original implementation of semop returned the value
- *   last semaphore element examined on success. This does not
- *   match the manual page specifications, and effectively
- *   allows the user to read the semaphore even if they do not
- *   have read permissions. The implementation now returns 0
- *   on success as stated in the manual page.
- * - There is some confusion over whether the set of undo adjustments
- *   to be performed at exit should be done in an atomic manner.
- *   That is, if we are attempting to decrement the semval should we queue
- *   up and wait until we can do so legally?
- *   The original implementation attempted to do this.
- *   The current implementation does not do so. This is because I don't
- *   think it is the right thing (TM) to do, and because I couldn't
- *   see a clean way to get the old behavior with the new design.
- *   The POSIX standard and SVID should be consulted to determine
- *   what behavior is mandated.
- *
- * Further notes on refinement (Christoph Rohland, December 1998):
- * - The POSIX standard says, that the undo adjustments simply should
- *   redo. So the current implementation is o.K.
- * - The previous code had two flaws:
- *   1) It actively gave the semaphore to the next waiting process
- *      sleeping on the semaphore. Since this process did not have the
- *      cpu this led to many unnecessary context switches and bad
- *      performance. Now we only check which process should be able to
- *      get the semaphore and if this process wants to reduce some
- *      semaphore value we simply wake it up without doing the
- *      operation. So it has to try to get it later. Thus e.g. the
- *      running process may reacquire the semaphore during the current
- *      time slice. If it only waits for zero or increases the semaphore,
- *      we do the operation in advance and wake it up.
- *   2) It did not wake up all zero waiting processes. We try to do
- *      better but only get the semops right which only wait for zero or
- *      increase. If there are decrement operations in the operations
- *      array we do the same as before.
- *
- * With the incarnation of O(1) scheduler, it becomes unnecessary to perform
- * check/retry algorithm for waking up blocked processes as the new scheduler
- * is better at handling thread switch than the old one.
- *
  * /proc/sysvipc/sem support (c) 1999 Dragos Acostachioaie <dragos@iname.com>
  *
  * SMP-threaded, sysctl's added
@@ -61,6 +11,8 @@
  * (c) 2001 Red Hat Inc
  * Lockless wakeup
  * (c) 2003 Manfred Spraul <manfred@colorfullife.com>
+ * Further wakeup optimizations, documentation
+ * (c) 2010 Manfred Spraul <manfred@colorfullife.com>
  *
  * support for audit of ipc object properties and permission changes
  * Dustin Kirkland <dustin.kirkland@us.ibm.com>
@@ -68,6 +20,57 @@
  * namespaces support
  * OpenVZ, SWsoft Inc.
  * Pavel Emelianov <xemul@openvz.org>
+ *
+ * Implementation notes: (May 2010)
+ * This file implements System V semaphores.
+ *
+ * User space visible behavior:
+ * - FIFO ordering for semop() operations (just FIFO, not starvation
+ *   protection)
+ * - multiple semaphore operations that alter the same semaphore in
+ *   one semop() are handled.
+ * - sem_ctime (time of last semctl()) is updated in the IPC_SET, SETVAL and
+ *   SETALL calls.
+ * - two Linux specific semctl() commands: SEM_STAT, SEM_INFO.
+ * - undo adjustments at process exit are limited to 0..SEMVMX.
+ * - namespace are supported.
+ * - SEMMSL, SEMMNS, SEMOPM and SEMMNI can be configured at runtine by writing
+ *   to /proc/sys/kernel/sem.
+ * - statistics about the usage are reported in /proc/sysvipc/sem.
+ *
+ * Internals:
+ * - scalability:
+ *   - all global variables are read-mostly.
+ *   - semop() calls and semctl(RMID) are synchronized by RCU.
+ *   - most operations do write operations (actually: spin_lock calls) to
+ *     the per-semaphore array structure.
+ *   Thus: Perfect SMP scaling between independent semaphore arrays.
+ *         If multiple semaphores in one array are used, then cache line
+ *         trashing on the semaphore array spinlock will limit the scaling.
+ * - semncnt and semzcnt are calculated on demand in count_semncnt() and
+ *   count_semzcnt()
+ * - the task that performs a successful semop() scans the list of all
+ *   sleeping tasks and completes any pending operations that can be fulfilled.
+ *   Semaphores are actively given to waiting tasks (necessary for FIFO).
+ *   (see update_queue())
+ * - To improve the scalability, the actual wake-up calls are performed after
+ *   dropping all locks. (see wake_up_sem_queue_prepare(),
+ *   wake_up_sem_queue_do())
+ * - All work is done by the waker, the woken up task does not have to do
+ *   anything - not even acquiring a lock or dropping a refcount.
+ * - A woken up task may not even touch the semaphore array anymore, it may
+ *   have been destroyed already by a semctl(RMID). 
+ * - The synchronizations between wake-ups due to a timeout/signal and a
+ *   wake-up due to a completed semaphore operation is achieved by using an
+ *   intermediate state (IN_WAKEUP).
+ * - UNDO values are stored in an array (one per process and per
+ *   semaphore array, lazily allocated). For backwards compatibility, multiple
+ *   modes for the UNDO variables are supported (per process, per thread)
+ *   (see copy_semundo, CLONE_SYSVSEM)
+ * - There are two lists of the pending operations: a per-array list
+ *   and per-semaphore list (stored in the array). This allows to achieve FIFO
+ *   ordering without always scanning all pending operations.
+ *   The worst-case behavior is nevertheless O(N^2) for N wakeups.
  */
 
 #include <linux/slab.h>
-- 
1.6.6.1


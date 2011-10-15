Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1JONOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 09:14:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62483 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1JONOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 09:14:12 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 1/5] ipc/sem.c: Fix return code race with semop vs. semop +semctl(IPC_RMID)
Date: Sat, 15 Oct 2011 15:21:33 +0200
Message-Id: <1318684893-1921-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_semtimedop() may return -EIDRM although the semaphore operation completed
successfully:

thread 1:	thread 2:
		semtimedop(), sleeps
semop():
* acquires sem_lock()
		semtimedop() woken up due to timeout
		sem_lock() loops
* notices that thread 2 could be completed.
* performs the operations that thread 2 is sleeping on.
* marks the semaphore operation as IN_WAKEUP
* drops sem_lock(), does wakeup, sets return code to 0
		* thread delayed due to interrupt, whatever
* returns to user space
		* thread still delayed
semctl(IPC_RMID)
* acquires sem_lock()
* ipc_rmid(), ipcp->deleted=1
* drops sem_lock()
		* thread finally continues - but seem_lock()
		  now fails due to ipcp->deleted == 1
		* returns -EIDRM instead of 0

The fix is trivial: Always use the return code in queue.status.

In real world, the race probably doesn't matter:
If the semaphore array is destroyed, the app is probably not interested
if the last operation succeeded or was already cancelled.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index c8e00f8..fb13be1 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1460,7 +1460,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 * Array removed? If yes, leave without sem_unlock().
 	 */
 	if (IS_ERR(sma)) {
-		error = -EIDRM;
 		goto out_free;
 	}
 
-- 
1.7.6


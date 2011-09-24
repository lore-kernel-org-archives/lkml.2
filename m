Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1IXRal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 13:30:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48729 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1IXRaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 13:30:39 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 2/3] ipc/sem.c: handle spurious wakeups
Date: Sat, 24 Sep 2011 19:37:11 +0200
Message-Id: <1316885831-11996-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

semtimedop() does not handle spurious wakeups, it returns -EINTR to user space.
Most other schedule() users would just loop and not return to user space.
The patch adds such a loop to semtimedop()

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index fb13be1..227948f 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1426,6 +1426,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 
 	queue.status = -EINTR;
 	queue.sleeper = current;
+
+sleep_again:
 	current->state = TASK_INTERRUPTIBLE;
 	sem_unlock(sma);
 
@@ -1478,6 +1480,13 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 */
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
+
+	/*
+	 * If the wakeup was spurious, just retry
+	 */
+	if (error == -EINTR && !signal_pending(current))
+		goto sleep_again;
+
 	unlink_queue(sma, &queue);
 
 out_unlock_free:
-- 
1.7.6


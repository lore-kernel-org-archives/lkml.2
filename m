Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab1GUGjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 02:39:13 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:55331 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1GUGjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 02:39:11 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] [ipc/sem.c] fix race with concurrent semtimedop() timeouts and IPC_RMID
Date: Thu, 21 Jul 2011 08:42:53 +0200
Message-Id: <1311230573-6244-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a semaphore array is removed and in parallel a sleeping task is woken up
(signal or timeout, does not matter), then the woken up task does not wait
until wake_up_sem_queue_do() is completed. This will cause crashes, because
wake_up_sem_queue_do() will read from a stale pointer.

The fix is simple: Regardless of anything, always call get_queue_result().
This function waits until wake_up_sem_queue_do() has finished it's task.

Andrew, could you please take care of merging the patch?

Reported-by: Yuriy Yevtukhov <yuriy@ucoz.com>
Reported-by: Harald Laabs <kernel@dasr.de>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 34193ed..add93d2 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1456,15 +1456,24 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	}
 
 	sma = sem_lock(ns, semid);
+
+	/*
+	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
+	 */
+	error = get_queue_result(&queue);
+
+	/*
+	 * Array removed? If yes, leave without sem_unlock().
+	 */
 	if (IS_ERR(sma)) {
 		error = -EIDRM;
 		goto out_free;
 	}
 
-	error = get_queue_result(&queue);
 
 	/*
-	 * If queue.status != -EINTR we are woken up by another process
+	 * If queue.status != -EINTR we are woken up by another process.
+	 * Leave without unlink_queue(), but with sem_unlock().
 	 */
 
 	if (error != -EINTR) {
-- 
1.7.6


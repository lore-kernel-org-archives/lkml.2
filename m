Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1G1Xob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:27791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab1G1XoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552449"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: manfred@colorfullife.com, eric.dumazet@gmail.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [5/50] ipc/sem.c: fix race with concurrent semtimedop() timeouts
Message-Id: <20110728234409.640422403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Manfred Spraul <manfred@colorfullife.com>

[ upstream commit d694ad62bf539dbb20a0899ac2a954555f9e4a83 ]
 and IPC_RMID

If a semaphore array is removed and in parallel a sleeping task is woken
up (signal or timeout, does not matter), then the woken up task does not
wait until wake_up_sem_queue_do() is completed.  This will cause crashes,
because wake_up_sem_queue_do() will read from a stale pointer.

The fix is simple: Regardless of anything, always call get_queue_result().
This function waits until wake_up_sem_queue_do() has finished it's task.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=27142

Reported-by: Yuriy Yevtukhov <yuriy@ucoz.com>
Reported-by: Harald Laabs <kernel@dasr.de>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: <stable@kernel.org>		[2.6.35+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/ipc/sem.c
===================================================================
--- linux-2.6.35.y.orig/ipc/sem.c
+++ linux-2.6.35.y/ipc/sem.c
@@ -1452,15 +1452,24 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab0ENJJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 05:09:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65187 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0ENJJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 05:09:43 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] ipc/sem.c: Bugfix for incorrect setting of sem_otime
Date: Fri, 14 May 2010 11:10:56 +0200
Message-Id: <1273828256-2078-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch corrects a bug that I've introduced with the previous
patch series:
sem_otime is the time of the last successful semop() call.

Andrew, could you add it into your -mm tree?
It is on top of the path that fixes the missing initialization.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 58dbbf7..a744eb5 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -534,7 +534,7 @@ static int check_restart(struct sem_array *sma, struct sem_queue *q)
  * must be set to -1.
  * The tasks that must be woken up are added to @pt. The return code
  * is stored in q->pid.
- * The function return 1 if at least one array variable was modified.
+ * The function return 1 if at least one semop was completed successfully.
  */
 static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 {
@@ -542,7 +542,7 @@ static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 	struct list_head *walk;
 	struct list_head *pending_list;
 	int offset;
-	int retval = 0;
+	int semop_completed = 0;
 
 	/* if there are complex operations around, then knowing the semaphore
 	 * that was modified doesn't help us. Assume that multiple semaphores
@@ -586,19 +586,19 @@ again:
 			continue;
 
 		unlink_queue(sma, q);
-		if (q->alter)
-			retval = 1;
 
-		if (error)
+		if (error) {
 			restart = 0;
-		else
+		} else {
+			semop_completed = 1;
 			restart = check_restart(sma, q);
+		}
 
 		wake_up_sem_queue_prepare(pt, q, error);
 		if (restart)
 			goto again;
 	}
-	return retval;
+	return semop_completed;
 }
 
 /**
-- 
1.6.6.1


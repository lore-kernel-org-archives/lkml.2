Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2DJJBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:01:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62452 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2DJJBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:01:20 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH] Removed less than zero check, since Schedule_timeout return value is guaranteed to be non-negative
Date: Tue, 10 Apr 2012 14:32:27 +0530
Message-Id: <1334048547-2983-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

validating timeout against negiatve value is not required, schedule_timeout always returns >= 0.

If someone passes timeout as negative value, Instead of simply returning -ETIME we have to warn them (schedule_timeout 
is already doing it by dumping stack and priniting an error message) about it. 

We must return -ETIME on timer expiry not for invaild timeouts.

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 kernel/semaphore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 60636a4..029c05b 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -214,7 +214,7 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
 	for (;;) {
 		if (signal_pending_state(state, task))
 			goto interrupted;
-		if (timeout <= 0)
+		if (!timeout)
 			goto timed_out;
 		__set_task_state(task, state);
 		raw_spin_unlock_irq(&sem->lock);
-- 
1.7.3.4


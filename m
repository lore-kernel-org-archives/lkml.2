Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965579Ab0GPMt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:49:56 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54065 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419Ab0GPMtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:20 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 09/16] writeback: do not lose wake-ups in bdi threads
Date: Fri, 16 Jul 2010 15:45:05 +0300
Message-Id: <1279284312-2411-10-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:49:10.0203 (UTC) FILETIME=[490F20B0:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The bdi threads ('bdi_writeback_thread()') can lose wake-ups if,
for example, 'bdi_queue_work()' is executed while after the bdi
thread finished 'wb_do_writeback()' but before it has called
'schedule_timeout_interruptible()'.

To fix this issue, we have to check whether we have works to
process after we change the task state to 'TASK_INTERRUPTIBLE'.

Also, 'bdi_writeback_thread()' inconsistently handles the cases
when 'dirty_writeback_interval' is zero and non-zero. But there is
no fundamental difference between these cases, so they have to be
handled the same way, which this patch also does.

This patch also removes strange 'list_empty_careful()' call.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3fc5194..f045450 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -848,17 +848,18 @@ int bdi_writeback_thread(void *data)
 				break;
 		}
 
-		if (dirty_writeback_interval) {
-			wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
-			schedule_timeout_interruptible(wait_jiffies);
-		} else {
-			set_current_state(TASK_INTERRUPTIBLE);
-			if (list_empty_careful(&wb->bdi->work_list) &&
-			    !kthread_should_stop())
-				schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!list_empty(&bdi->work_list)) {
 			__set_current_state(TASK_RUNNING);
+			continue;
 		}
 
+		if (dirty_writeback_interval) {
+			wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
+			schedule_timeout(wait_jiffies);
+		} else
+			schedule();
+
 		try_to_freeze();
 	}
 
-- 
1.7.1.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab0GYIaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:30:13 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49907 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0GYI3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:29:51 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv5 05/15] writeback: do not lose wake-ups in bdi threads
Date: Sun, 25 Jul 2010 11:29:31 +0300
Message-Id: <1280046581-23623-6-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
References: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 Jul 2010 08:29:45.0612 (UTC) FILETIME=[898EC4C0:01CB2BD3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Currently, bdi threads ('bdi_writeback_thread()') can lose wake-ups. For
example, if 'bdi_queue_work()' is executed after the bdi thread have had
finished 'wb_do_writeback()' but before it called
'schedule_timeout_interruptible()'.

To fix this issue, we have to check whether we have works to process after we
have changed the task state to 'TASK_INTERRUPTIBLE'.

This patch also clean-ups handling of the cases when 'dirty_writeback_interval'
is zero or non-zero.

Additionally, this patch also removes unneeded 'list_empty_careful()' call.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5e6b7fc..8cf53ba 100644
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


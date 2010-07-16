Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965590Ab0GPMuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:50:00 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54060 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965417Ab0GPMtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:19 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 08/16] writeback: do not lose default bdi wake-ups
Date: Fri, 16 Jul 2010 15:45:04 +0300
Message-Id: <1279284312-2411-9-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:49:08.0867 (UTC) FILETIME=[48434530:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Currently the default bdi can lose wake ups. E.g., if
'bdi_queue_work()' is called when 'bdi_forker_thread()' is executing
code after

	if (bdi_has_dirty_io(me->bdi))
		wb_do_writeback(me, 0);

but before 'set_current_state(TASK_INTERRUPTIBLE)'. This is unlikely,
and the result is not very severe - we'll just delay the execution
of the work, but this is still not very nice.

This patch fixes the issue by checking whether the default bdi has
works before the forker thread goes sleep.

This patch also removes strange comment about a temporary measure,
because there is nothing temporary there - many FSes use default
bdi.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 mm/backing-dev.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 14fe1bb..ab783b9 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -335,10 +335,6 @@ static int bdi_forker_thread(void *ptr)
 		struct backing_dev_info *bdi, *tmp;
 		struct task_struct *task;
 
-		/*
-		 * Temporary measure, we want to make sure we don't see
-		 * dirty data on the default backing_dev_info
-		 */
 		if (bdi_has_dirty_io(me->bdi))
 			wb_do_writeback(me, 0);
 
@@ -358,6 +354,10 @@ static int bdi_forker_thread(void *ptr)
 			bdi_add_default_flusher_thread(bdi);
 		}
 
+		/* Keep working if default bdi still has some works */
+		if (!list_empty(&me->bdi->work_list))
+			__set_current_state(TASK_RUNNING);
+
 		if (list_empty(&bdi_pending_list)) {
 			unsigned long wait;
 
-- 
1.7.1.1


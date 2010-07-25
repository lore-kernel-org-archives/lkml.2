Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0GYLbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 07:31:43 -0400
Received: from smtp.nokia.com ([192.100.105.134]:43497 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0GYL3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 07:29:35 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv6 14/15] writeback: add new tracepoints
Date: Sun, 25 Jul 2010 14:29:24 +0300
Message-Id: <1280057365-10297-15-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
References: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 Jul 2010 11:29:30.0219 (UTC) FILETIME=[A5AF33B0:01CB2BEC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Add 2 new trace points to the periodic write-back wake up case, just like we do
in the 'bdi_queue_work()' function. Namely, introduce:

1. trace_writeback_wake_thread(bdi)
2. trace_writeback_wake_forker_thread(bdi)

The first event is triggered every time we wake up a bdi thread to start
periodic background write-out. The second event is triggered only when the bdi
thread does not exist and should be created by the forker thread.

This patch was suggested by Dave Chinner and Christoph Hellwig.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/trace/events/writeback.h |    2 ++
 mm/backing-dev.c                 |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 84ab72d..f345f66 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -81,6 +81,8 @@ DEFINE_EVENT(writeback_class, name, \
 	TP_ARGS(bdi))
 
 DEFINE_WRITEBACK_EVENT(writeback_nowork);
+DEFINE_WRITEBACK_EVENT(writeback_wake_thread);
+DEFINE_WRITEBACK_EVENT(writeback_wake_forker_thread);
 DEFINE_WRITEBACK_EVENT(writeback_bdi_register);
 DEFINE_WRITEBACK_EVENT(writeback_bdi_unregister);
 DEFINE_WRITEBACK_EVENT(writeback_thread_start);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 9989083..9008c4e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -310,6 +310,7 @@ static void wakeup_timer_fn(unsigned long data)
 
 	spin_lock_bh(&bdi->wb_lock);
 	if (bdi->wb.task) {
+		trace_writeback_wake_thread(bdi);
 		wake_up_process(bdi->wb.task);
 	} else {
 		/*
@@ -317,6 +318,7 @@ static void wakeup_timer_fn(unsigned long data)
 		 * In this case we have to wake-up the forker thread which
 		 * should create and run the bdi thread.
 		 */
+		trace_writeback_wake_forker_thread(bdi);
 		wake_up_process(default_backing_dev_info.wb.task);
 	}
 	spin_unlock_bh(&bdi->wb_lock);
-- 
1.7.1.1


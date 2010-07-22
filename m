Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab0GVN56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:57:58 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52147 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab0GVN5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:57:09 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 14/14] writeback: add new tracepoints
Date: Thu, 22 Jul 2010 16:56:28 +0300
Message-Id: <1279806988-14100-15-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279806988-14100-1-git-send-email-dedekind1@gmail.com>
References: <1279806988-14100-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 22 Jul 2010 13:56:38.0309 (UTC) FILETIME=[B4659550:01CB29A5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Add 2 new trace points to the periodic write-back wake up case, just like we do
in the 'bdi_queue_work()' function. Namely, introduce:

1. trace_writeback_wakeup(bdi)
2. trace_writeback_wakeup_nothread(bdi)

The first event is triggered every time we wake up a bdi thread to start
periodic background write-out. The second event is triggered only when the bdi
thread does not exist and should be created by the forker thread.

This patch was suggested by Dave Chinner <david@fromorbit.com>

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/trace/events/writeback.h |    2 ++
 mm/backing-dev.c                 |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 84ab72d..eb07d48 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -81,6 +81,8 @@ DEFINE_EVENT(writeback_class, name, \
 	TP_ARGS(bdi))
 
 DEFINE_WRITEBACK_EVENT(writeback_nowork);
+DEFINE_WRITEBACK_EVENT(writeback_wakeup);
+DEFINE_WRITEBACK_EVENT(writeback_wakeup_nothread);
 DEFINE_WRITEBACK_EVENT(writeback_bdi_register);
 DEFINE_WRITEBACK_EVENT(writeback_bdi_unregister);
 DEFINE_WRITEBACK_EVENT(writeback_thread_start);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 90e56ab..9143f93 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -308,6 +308,8 @@ static void wakeup_timer_fn(unsigned long data)
 {
 	struct backing_dev_info *bdi = (struct backing_dev_info *)data;
 
+	trace_writeback_wakeup(bdi);
+
 	spin_lock(&bdi->wb_lock);
 	if (bdi->wb.task) {
 		wake_up_process(bdi->wb.task);
@@ -317,6 +319,7 @@ static void wakeup_timer_fn(unsigned long data)
 		 * In this case we have to wake-up the forker thread which
 		 * should create and run the bdi thread.
 		 */
+		trace_writeback_wakeup_nothread(bdi);
 		wake_up_process(default_backing_dev_info.wb.task);
 	}
 	spin_unlock(&bdi->wb_lock);
-- 
1.7.1.1


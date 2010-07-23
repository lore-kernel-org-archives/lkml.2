Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185Ab0GWPGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:06:00 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52419 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab0GWPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:05:55 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv4 08/14] writeback: move last_active to bdi
Date: Fri, 23 Jul 2010 18:05:48 +0300
Message-Id: <1279897554-1526-9-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
References: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 23 Jul 2010 15:05:50.0694 (UTC) FILETIME=[89D30060:01CB2A78]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Currently bdi threads use local variable 'last_active' which stores last time
when the bdi thread did some useful work. Move this local variable to 'struct
bdi_writeback'. This is just a preparation for the further patches which will
make the forker thread decide when bdi threads should be killed.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c           |    6 +++---
 include/linux/backing-dev.h |   13 +++++++------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index eaef5c9..53e1028 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -800,12 +800,12 @@ int bdi_writeback_thread(void *data)
 {
 	struct bdi_writeback *wb = data;
 	struct backing_dev_info *bdi = wb->bdi;
-	unsigned long last_active = jiffies;
 	unsigned long wait_jiffies = -1UL;
 	long pages_written;
 
 	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
 	set_freezable();
+	wb->last_active = jiffies;
 
 	/*
 	 * Our parent may run at a different priority, just set us to normal
@@ -827,7 +827,7 @@ int bdi_writeback_thread(void *data)
 		trace_writeback_pages_written(pages_written);
 
 		if (pages_written)
-			last_active = jiffies;
+			wb->last_active = jiffies;
 		else if (wait_jiffies != -1UL) {
 			unsigned long max_idle;
 
@@ -837,7 +837,7 @@ int bdi_writeback_thread(void *data)
 			 * recreated automatically.
 			 */
 			max_idle = max(5UL * 60 * HZ, wait_jiffies);
-			if (time_after(jiffies, max_idle + last_active))
+			if (time_after(jiffies, max_idle + wb->last_active))
 				break;
 		}
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 95ecb2b..71b6223 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -45,15 +45,16 @@ enum bdi_stat_item {
 #define BDI_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
 
 struct bdi_writeback {
-	struct backing_dev_info *bdi;		/* our parent bdi */
+	struct backing_dev_info *bdi;	/* our parent bdi */
 	unsigned int nr;
 
-	unsigned long last_old_flush;		/* last old data flush */
+	unsigned long last_old_flush;	/* last old data flush */
+	unsigned long last_active;	/* last time bdi thread was active */
 
-	struct task_struct	*task;		/* writeback thread */
-	struct list_head	b_dirty;	/* dirty inodes */
-	struct list_head	b_io;		/* parked for writeback */
-	struct list_head	b_more_io;	/* parked for more writeback */
+	struct task_struct *task;	/* writeback thread */
+	struct list_head b_dirty;	/* dirty inodes */
+	struct list_head b_io;		/* parked for writeback */
+	struct list_head b_more_io;	/* parked for more writeback */
 };
 
 struct backing_dev_info {
-- 
1.7.1.1


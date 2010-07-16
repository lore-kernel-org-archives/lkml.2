Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524Ab0GPMti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:49:38 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40007 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965400Ab0GPMtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:13 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 06/16] writeback: improve bdi_has_dirty_io
Date: Fri, 16 Jul 2010 15:45:02 +0300
Message-Id: <1279284312-2411-7-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:49:05.0750 (UTC) FILETIME=[4667A760:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch is of clean-up type. Currently the purpose of the
'bdi_has_dirty_io()' function is not very clear - it is equivalent
to 'wb_has_dirty_io()' and there is little point for it to exist.
It is used inconsistently as well, e.g., in 'bdi_forker_thread()'
we use

if (wb_has_dirty_io() || !list_empty(&me->bdi->work_list))

but in the other place we use another construct to achieve the
essentially same goal:

if (!bdi_has_dirty_io(bdi) && list_empty(&bdi->work_list))

which is inconsistent and make code more difficult to follow.

This patch changes semantics of 'bdi_has_dirty_io()' a bit, and now
it checks for dirty io _and_ bdi works. The code which needs to check
only dirty inodes can use 'wb_has_dirty_io()'. This makes the bdi
forker code a bit nicer, and justifies the existence of
'bdi_has_dirty_io()'.

Just a small cleanup.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |    2 +-
 mm/backing-dev.c  |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5e6b7fc..3fc5194 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -891,7 +891,7 @@ void wakeup_flusher_threads(long nr_pages)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
-		if (!bdi_has_dirty_io(bdi))
+		if (!wb_has_dirty_io(&bdi->wb))
 			continue;
 		__bdi_start_writeback(bdi, nr_pages, false, false);
 	}
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 8be2e13..03a3d82 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -263,7 +263,8 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 
 int bdi_has_dirty_io(struct backing_dev_info *bdi)
 {
-	return wb_has_dirty_io(&bdi->wb);
+	return wb_has_dirty_io(&bdi->wb) ||
+	       !list_empty(&bdi->work_list);
 }
 
 static void bdi_flush_io(struct backing_dev_info *bdi)
@@ -338,7 +339,7 @@ static int bdi_forker_thread(void *ptr)
 		 * Temporary measure, we want to make sure we don't see
 		 * dirty data on the default backing_dev_info
 		 */
-		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
+		if (bdi_has_dirty_io(me->bdi))
 			wb_do_writeback(me, 0);
 
 		spin_lock_bh(&bdi_lock);
@@ -350,8 +351,7 @@ static int bdi_forker_thread(void *ptr)
 		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
 			if (bdi->wb.task)
 				continue;
-			if (list_empty(&bdi->work_list) &&
-			    !bdi_has_dirty_io(bdi))
+			if (!bdi_has_dirty_io(bdi))
 				continue;
 
 			bdi_add_default_flusher_thread(bdi);
@@ -637,7 +637,7 @@ void bdi_destroy(struct backing_dev_info *bdi)
 	 * Splice our entries to the default_backing_dev_info, if this
 	 * bdi disappears
 	 */
-	if (bdi_has_dirty_io(bdi)) {
+	if (wb_has_dirty_io(&bdi->wb)) {
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
 
 		spin_lock(&inode_lock);
-- 
1.7.1.1


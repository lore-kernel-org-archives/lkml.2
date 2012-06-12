Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2FLLqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:46:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44308 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2FLLqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:46:19 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH v2] writeback: avoid race when update bandwidth
Date: Tue, 12 Jun 2012 19:46:01 +0800
Message-Id: <1339501561-4570-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

"V1 -> V2"
* remove dirty_lock

Since bdi->wb.list_lock is used to protect the b_* lists,
so the flushers who call wb_writeback to writeback pages will
stuck when bandwidth update policy holds this lock. In order
to avoid this race we can introduce a new bandwidth_lock who
is responsible for protecting bandwidth update policy.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

---
 mm/page-writeback.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index c833bf0..e28d36e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -815,7 +815,6 @@ static void global_update_bandwidth(unsigned long thresh,
 				    unsigned long dirty,
 				    unsigned long now)
 {
-	static DEFINE_SPINLOCK(dirty_lock);
 	static unsigned long update_time;
 
 	/*
@@ -824,12 +823,10 @@ static void global_update_bandwidth(unsigned long thresh,
 	if (time_before(now, update_time + BANDWIDTH_INTERVAL))
 		return;
 
-	spin_lock(&dirty_lock);
 	if (time_after_eq(now, update_time + BANDWIDTH_INTERVAL)) {
 		update_dirty_limit(thresh, dirty);
 		update_time = now;
 	}
-	spin_unlock(&dirty_lock);
 }
 
 /*
@@ -1032,12 +1029,14 @@ static void bdi_update_bandwidth(struct backing_dev_info *bdi,
 				 unsigned long bdi_dirty,
 				 unsigned long start_time)
 {
+	static DEFINE_SPINLOCK(bandwidth_lock);
+
 	if (time_is_after_eq_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
 		return;
-	spin_lock(&bdi->wb.list_lock);
+	spin_lock(&bandwidth_lock);
 	__bdi_update_bandwidth(bdi, thresh, bg_thresh, dirty,
 			       bdi_thresh, bdi_dirty, start_time);
-	spin_unlock(&bdi->wb.list_lock);
+	spin_unlock(&bandwidth_lock);
 }
 
 /*
-- 
1.7.9.5


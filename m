Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2FLK1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:27:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36835 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2FLK1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:27:15 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Wanpeng Li <liswp@linux.vnet.ibm.com>
Subject: [PATCH] writeback: avoid race when update bandwidth
Date: Tue, 12 Jun 2012 18:26:43 +0800
Message-Id: <1339496803-2885-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since bdi->wb.list_lock is used to protect the b_* lists,
so the flushers who call wb_writeback to writeback pages will
stuck when bandwidth update policy holds this lock. In order
to avoid this race we can introduce a new bandwidth_lock who
is responsible for protecting bandwidth update policy.

Signed-off-by: Wanpeng Li <liswp@linux.vnet.ibm.com>
---
 mm/page-writeback.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index c8945e0..b3b08fb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1032,12 +1032,14 @@ static void bdi_update_bandwidth(struct backing_dev_info *bdi,
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


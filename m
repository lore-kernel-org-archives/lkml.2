Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab2FJEUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 00:20:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62517 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2FJEUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 00:20:54 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: [PATCH] page-writeback.c: fix update bandwidth time judgment error
Date: Sun, 10 Jun 2012 12:20:05 +0800
Message-Id: <1339302005-366-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpneg Li <liwp@linux.vnet.ibm.com>

Since bdi_update_bandwidth function  should estimate write bandwidth at 200ms intervals,
so the time is bdi->bw_time_stamp + BANDWIDTH_INTERVAL == jiffies, but
if use time_is_after_eq_jiffies intervals will be bdi->bw_time_stamp +
BANDWIDTH_INTERVAL + 1.

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index c833bf0..099e225 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1032,7 +1032,7 @@ static void bdi_update_bandwidth(struct backing_dev_info *bdi,
 				 unsigned long bdi_dirty,
 				 unsigned long start_time)
 {
-	if (time_is_after_eq_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
+	if (time_is_after_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
 		return;
 	spin_lock(&bdi->wb.list_lock);
 	__bdi_update_bandwidth(bdi, thresh, bg_thresh, dirty,
-- 
1.7.9.5


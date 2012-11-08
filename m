Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2KHJJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:09:54 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39402 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab2KHJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:02:50 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        cmm@us.ibm.com, swhiteho@redhat.com, dave@jikos.cz,
        darrick.wong@oracle.com, andi@firstfloor.org, northrup.james@gmail.com,
        gregkh@linuxfoundation.org, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 08/18] vfs: add aging function
Date: Thu,  8 Nov 2012 17:01:15 +0800
Message-Id: <1352365285-32419-9-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
References: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110809-3620-0000-0000-0000004C02DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |    6 +++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 4b143a4..e85eaa6 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -392,6 +392,24 @@ static u32 hot_temp_calc(struct hot_freq_data *freq_data)
 	return result;
 }
 
+static bool hot_is_obsolete(struct hot_freq_data *freq_data)
+{
+	int ret = 0;
+	struct timespec ckt = current_kernel_time();
+
+	u64 cur_time = timespec_to_ns(&ckt);
+	u64 last_read_ns =
+		(cur_time - timespec_to_ns(&freq_data->last_read_time));
+	u64 last_write_ns =
+		(cur_time - timespec_to_ns(&freq_data->last_write_time));
+	u64 kick_ns =  TIME_TO_KICK * NSEC_PER_SEC;
+
+	if ((last_read_ns > kick_ns) && (last_write_ns > kick_ns))
+		ret = 1;
+
+	return ret;
+}
+
 /*
  * Calculate a new temperature and, if necessary,
  * move the list_head corresponding to this inode or range
@@ -459,6 +477,44 @@ static void hot_map_update(struct hot_freq_data *freq_data,
 	}
 }
 
+/* Update temperatures for each range item for aging purposes */
+static void hot_range_update(struct hot_inode_item *he,
+					struct hot_info *root)
+{
+	struct hot_range_item *hr_nodes[8];
+	loff_t start = 0;
+	bool obsolete;
+	int i, n;
+
+	while (1) {
+		spin_lock(&he->lock);
+		n = radix_tree_gang_lookup(&he->hot_range_tree,
+				(void **)hr_nodes, start,
+				ARRAY_SIZE(hr_nodes));
+		if (!n) {
+			spin_unlock(&he->lock);
+			break;
+		}
+		spin_unlock(&he->lock);
+
+		start = hr_nodes[n - 1]->start + 1;
+		for (i = 0; i < n; i++) {
+			kref_get(&hr_nodes[i]->hot_range.refs);
+			hot_map_update(
+				&hr_nodes[i]->hot_range.hot_freq_data, root);
+
+			spin_lock(&hr_nodes[i]->hot_range.lock);
+			obsolete = hot_is_obsolete(
+					&hr_nodes[i]->hot_range.hot_freq_data);
+			spin_unlock(&hr_nodes[i]->hot_range.lock);
+
+			hot_range_item_put(hr_nodes[i]);
+			if (obsolete)
+				hot_range_item_put(hr_nodes[i]);
+		}
+	}
+}
+
 /*
  * Initialize inode and range map info.
  */
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 2f209b6..0d28e6f 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -25,6 +25,12 @@
 #define RANGE_SIZE (1 << RANGE_BITS)
 #define FREQ_POWER 4
 
+/*
+ * time to quit keeping track of
+ * tracking data (seconds)
+ */
+#define TIME_TO_KICK 300
+
 /* NRR/NRW heat unit = 2^X accesses */
 #define NRR_MULTIPLIER_POWER 20 /* NRR - number of reads since mount */
 #define NRR_COEFF_POWER 0
-- 
1.7.6.5


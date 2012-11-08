Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2KHJKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:10:31 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36696 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab2KHJCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:02:49 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        cmm@us.ibm.com, swhiteho@redhat.com, dave@jikos.cz,
        darrick.wong@oracle.com, andi@firstfloor.org, northrup.james@gmail.com,
        gregkh@linuxfoundation.org, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 07/18] vfs: add map info update function
Date: Thu,  8 Nov 2012 17:01:14 +0800
Message-Id: <1352365285-32419-8-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
References: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110809-5806-0000-0000-00001B8B34E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |   21 ++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 3fd6255..4b143a4 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -393,6 +393,73 @@ static u32 hot_temp_calc(struct hot_freq_data *freq_data)
 }
 
 /*
+ * Calculate a new temperature and, if necessary,
+ * move the list_head corresponding to this inode or range
+ * to the proper list with the new temperature
+ */
+static void hot_map_update(struct hot_freq_data *freq_data,
+				struct hot_info *root)
+{
+	struct hot_map_head *buckets, *cur_bucket;
+	struct hot_comm_item *comm_item;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+	u32 temp = hot_temp_calc(freq_data);
+	u8 a_temp = (u8)hot_raw_shift((u64)temp, (32 - HEAT_MAP_BITS), false);
+	u8 b_temp = (u8)hot_raw_shift((u64)freq_data->last_temp,
+					(32 - HEAT_MAP_BITS), false);
+
+	comm_item = container_of(freq_data,
+			struct hot_comm_item, hot_freq_data);
+
+	if (freq_data->flags & FREQ_DATA_TYPE_INODE) {
+		he = container_of(comm_item,
+			struct hot_inode_item, hot_inode);
+		buckets = root->heat_inode_map;
+
+		if (he == NULL)
+			return;
+
+		spin_lock(&he->hot_inode.lock);
+		if (list_empty(&he->hot_inode.n_list) || (a_temp != b_temp)) {
+			if (!list_empty(&he->hot_inode.n_list)) {
+				list_del_init(&he->hot_inode.n_list);
+				root->hot_map_nr--;
+			}
+
+			cur_bucket = buckets + a_temp;
+			list_add_tail(&he->hot_inode.n_list,
+					&cur_bucket->node_list);
+			root->hot_map_nr++;
+			freq_data->last_temp = temp;
+		}
+		spin_unlock(&he->hot_inode.lock);
+	} else if (freq_data->flags & FREQ_DATA_TYPE_RANGE) {
+		hr = container_of(comm_item,
+			struct hot_range_item, hot_range);
+		buckets = root->heat_range_map;
+
+		if (hr == NULL)
+			return;
+
+		spin_lock(&hr->hot_range.lock);
+		if (list_empty(&hr->hot_range.n_list) || (a_temp != b_temp)) {
+			if (!list_empty(&hr->hot_range.n_list)) {
+				list_del_init(&hr->hot_range.n_list);
+				root->hot_map_nr--;
+			}
+
+			cur_bucket = buckets + a_temp;
+			list_add_tail(&hr->hot_range.n_list,
+					&cur_bucket->node_list);
+			root->hot_map_nr++;
+			freq_data->last_temp = temp;
+		}
+		spin_unlock(&hr->hot_range.lock);
+	}
+}
+
+/*
  * Initialize inode and range map info.
  */
 static void hot_map_init(struct hot_info *root)
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 7f279af..2f209b6 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -25,4 +25,25 @@
 #define RANGE_SIZE (1 << RANGE_BITS)
 #define FREQ_POWER 4
 
+/* NRR/NRW heat unit = 2^X accesses */
+#define NRR_MULTIPLIER_POWER 20 /* NRR - number of reads since mount */
+#define NRR_COEFF_POWER 0
+#define NRW_MULTIPLIER_POWER 20 /* NRW - number of writes since mount */
+#define NRW_COEFF_POWER 0
+
+/* LTR/LTW heat unit = 2^X ns of age */
+#define LTR_DIVIDER_POWER 30 /* LTR - time elapsed since last read(ns) */
+#define LTR_COEFF_POWER 1
+#define LTW_DIVIDER_POWER 30 /* LTW - time elapsed since last write(ns) */
+#define LTW_COEFF_POWER 1
+
+/*
+ * AVR/AVW cold unit = 2^X ns of average delta
+ * AVR/AVW heat unit = HEAT_MAX_VALUE - cold unit
+ */
+#define AVR_DIVIDER_POWER 40 /* AVR - average delta between recent reads(ns) */
+#define AVR_COEFF_POWER 0
+#define AVW_DIVIDER_POWER 40 /* AVW - average delta between recent writes(ns) */
+#define AVW_COEFF_POWER 0
+
 #endif /* __HOT_TRACKING__ */
-- 
1.7.6.5


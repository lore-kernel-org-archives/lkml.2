Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab2LTOpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 09:45:11 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36038 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2LTOok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 09:44:40 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        dave@jikos.cz, darrick.wong@oracle.com, andi@firstfloor.org,
        hch@infradead.org, linuxram@linux.vnet.ibm.com, zwu.kernel@gmail.com,
        wuzhy@linux.vnet.ibm.com
Subject: [PATCH RESEND v1 07/16] vfs: add map info update function
Date: Thu, 20 Dec 2012 22:43:26 +0800
Message-Id: <1356014615-15073-8-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122014-2398-0000-0000-00000F3D42A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index ba4decf..6a5ef53 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -389,6 +389,73 @@ static u32 hot_temp_calc(struct hot_freq_data *freq_data)
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
-- 
1.7.6.5


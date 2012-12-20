Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2LTOrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 09:47:43 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39781 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab2LTOos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 09:44:48 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        dave@jikos.cz, darrick.wong@oracle.com, andi@firstfloor.org,
        hch@infradead.org, linuxram@linux.vnet.ibm.com, zwu.kernel@gmail.com,
        wuzhy@linux.vnet.ibm.com
Subject: [PATCH RESEND v1 08/16] vfs: add aging function
Date: Thu, 20 Dec 2012 22:43:27 +0800
Message-Id: <1356014615-15073-9-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122014-5806-0000-0000-00001D3C3FF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |    6 ++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 6a5ef53..45d0164 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -388,6 +388,24 @@ static u32 hot_temp_calc(struct hot_freq_data *freq_data)
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
@@ -455,6 +473,37 @@ static void hot_map_update(struct hot_freq_data *freq_data,
 	}
 }
 
+/* Update temperatures for each range item for aging purposes */
+static void hot_range_update(struct hot_inode_item *he,
+					struct hot_info *root)
+{
+	struct rb_node *node;
+	struct hot_comm_item *ci;
+	struct hot_range_item *hr;
+	bool obsolete;
+
+	spin_lock(&he->lock);
+	node = rb_first(&he->hot_range_tree.map);
+	while (node) {
+		ci = rb_entry(node, struct hot_comm_item, rb_node);
+		hr = container_of(ci, struct hot_range_item, hot_range);
+		kref_get(&hr->hot_range.refs);
+		hot_map_update(&hr->hot_range.hot_freq_data, root);
+
+		spin_lock(&hr->hot_range.lock);
+		obsolete = hot_is_obsolete(
+				&hr->hot_range.hot_freq_data);
+		spin_unlock(&hr->hot_range.lock);
+
+		node = rb_next(node);
+
+		hot_range_item_put(hr);
+		if (obsolete)
+			hot_range_item_put(hr);
+	}
+	spin_unlock(&he->lock);
+}
+
 /*
  * Initialize inode and range map info.
  */
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index f33066f..46d068a 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -24,6 +24,12 @@
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


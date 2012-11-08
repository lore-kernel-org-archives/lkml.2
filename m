Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2KHJCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:02:51 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:45897 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2KHJCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:02:41 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        cmm@us.ibm.com, swhiteho@redhat.com, dave@jikos.cz,
        darrick.wong@oracle.com, andi@firstfloor.org, northrup.james@gmail.com,
        gregkh@linuxfoundation.org, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v1 hot_track 06/18] vfs: add temp calculation function
Date: Thu,  8 Nov 2012 17:01:13 +0800
Message-Id: <1352365285-32419-7-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
References: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110809-7408-0000-0000-00000A102236
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 7101b73..3fd6255 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -25,6 +25,14 @@
 static struct kmem_cache *hot_inode_item_cachep __read_mostly;
 static struct kmem_cache *hot_range_item_cachep __read_mostly;
 
+static u64 hot_raw_shift(u64 counter, u32 bits, bool dir)
+{
+	if (dir)
+		return counter << bits;
+	else
+		return counter >> bits;
+}
+
 /*
  * Initialize the inode tree. Should be called for each new inode
  * access or other user of the hot_inode interface.
@@ -319,6 +327,72 @@ static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
 }
 
 /*
+ * hot_temp_calc() is responsible for distilling the six heat
+ * criteria down into a single temperature value for the data,
+ * which is an integer between 0 and HEAT_MAX_VALUE.
+ */
+static u32 hot_temp_calc(struct hot_freq_data *freq_data)
+{
+	u32 result = 0;
+
+	struct timespec ckt = current_kernel_time();
+	u64 cur_time = timespec_to_ns(&ckt);
+
+	u32 nrr_heat = (u32)hot_raw_shift((u64)freq_data->nr_reads,
+					NRR_MULTIPLIER_POWER, true);
+	u32 nrw_heat = (u32)hot_raw_shift((u64)freq_data->nr_writes,
+					NRW_MULTIPLIER_POWER, true);
+
+	u64 ltr_heat =
+	hot_raw_shift((cur_time - timespec_to_ns(&freq_data->last_read_time)),
+			LTR_DIVIDER_POWER, false);
+	u64 ltw_heat =
+	hot_raw_shift((cur_time - timespec_to_ns(&freq_data->last_write_time)),
+			LTW_DIVIDER_POWER, false);
+
+	u64 avr_heat =
+	hot_raw_shift((((u64) -1) - freq_data->avg_delta_reads),
+			AVR_DIVIDER_POWER, false);
+	u64 avw_heat =
+	hot_raw_shift((((u64) -1) - freq_data->avg_delta_writes),
+			AVW_DIVIDER_POWER, false);
+
+	/* ltr_heat is now guaranteed to be u32 safe */
+	if (ltr_heat >= hot_raw_shift((u64) 1, 32, true))
+		ltr_heat = 0;
+	else
+		ltr_heat = hot_raw_shift((u64) 1, 32, true) - ltr_heat;
+
+	/* ltw_heat is now guaranteed to be u32 safe */
+	if (ltw_heat >= hot_raw_shift((u64) 1, 32, true))
+		ltw_heat = 0;
+	else
+		ltw_heat = hot_raw_shift((u64) 1, 32, true) - ltw_heat;
+
+	/* avr_heat is now guaranteed to be u32 safe */
+	if (avr_heat >= hot_raw_shift((u64) 1, 32, true))
+		avr_heat = (u32) -1;
+
+	/* avw_heat is now guaranteed to be u32 safe */
+	if (avw_heat >= hot_raw_shift((u64) 1, 32, true))
+		avw_heat = (u32) -1;
+
+	nrr_heat = (u32)hot_raw_shift((u64)nrr_heat,
+		(3 - NRR_COEFF_POWER), false);
+	nrw_heat = (u32)hot_raw_shift((u64)nrw_heat,
+		(3 - NRW_COEFF_POWER), false);
+	ltr_heat = hot_raw_shift(ltr_heat, (3 - LTR_COEFF_POWER), false);
+	ltw_heat = hot_raw_shift(ltw_heat, (3 - LTW_COEFF_POWER), false);
+	avr_heat = hot_raw_shift(avr_heat, (3 - AVR_COEFF_POWER), false);
+	avw_heat = hot_raw_shift(avw_heat, (3 - AVW_COEFF_POWER), false);
+
+	result = nrr_heat + nrw_heat + (u32) ltr_heat +
+		(u32) ltw_heat + (u32) avr_heat + (u32) avw_heat;
+
+	return result;
+}
+
+/*
  * Initialize inode and range map info.
  */
 static void hot_map_init(struct hot_info *root)
-- 
1.7.6.5


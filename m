Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0DZTce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:32:34 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51603 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab0DZT2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 04/19] staging:iio: Support functions for scan mask matching
Date: Mon, 26 Apr 2010 20:31:06 +0100
Message-Id: <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/iio.h |   45 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index 71dbfe1..a12072a 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -96,6 +96,7 @@ void iio_remove_event_from_list(struct iio_event_handler_list *el,
  *			control method is used
  * @scan_count:	[INTERN] the number of elements in the current scan mode
  * @scan_mask:		[INTERN] bitmask used in masking scan mode elements
+ * @available_scan_masks: [DRIVER] optional array of allowed bitmasks
  * @scan_timestamp:	[INTERN] does the scan mode include a timestamp
  * @trig:		[INTERN] current device trigger (ring buffer modes)
  * @pollfunc:		[DRIVER] function run on trigger being recieved
@@ -122,7 +123,8 @@ struct iio_dev {
 	struct attribute_group		*scan_el_attrs;
 	int				scan_count;
 
-	u16				scan_mask;
+	u32				scan_mask;
+	u32				*available_scan_masks;
 	bool				scan_timestamp;
 	struct iio_trigger		*trig;
 	struct iio_poll_func		*pollfunc;
@@ -132,22 +134,57 @@ struct iio_dev {
  * These are mainly provided to allow for a change of implementation if a device
  * has a large number of scan elements
  */
-#define IIO_MAX_SCAN_LENGTH 15
+#define IIO_MAX_SCAN_LENGTH 31
+
+/* note 0 used as error indicator as it doesn't make sense. */
+static inline u32 iio_scan_mask_match(u32 *av_masks, u32 mask)
+{
+	while (*av_masks) {
+		if (!(~*av_masks & mask))
+			return *av_masks;
+		av_masks++;
+	}
+	return 0;
+}
 
 static inline int iio_scan_mask_query(struct iio_dev *dev_info, int bit)
 {
+	u32 mask;
+
 	if (bit > IIO_MAX_SCAN_LENGTH)
 		return -EINVAL;
+
+	if (!dev_info->scan_mask)
+		return 0;
+
+	if (dev_info->available_scan_masks)
+		mask = iio_scan_mask_match(dev_info->available_scan_masks,
+					dev_info->scan_mask);
 	else
-		return !!(dev_info->scan_mask & (1 << bit));
+		mask = dev_info->scan_mask;
+
+	if (!mask)
+		return -EINVAL;
+
+	return !!(mask & (1 << bit));
 };
 
 static inline int iio_scan_mask_set(struct iio_dev *dev_info, int bit)
 {
+	u32 mask;
+	u32 trialmask = dev_info->scan_mask | (1 << bit);
+
 	if (bit > IIO_MAX_SCAN_LENGTH)
 		return -EINVAL;
-	dev_info->scan_mask |= (1 << bit);
+	if (dev_info->available_scan_masks) {
+		mask = iio_scan_mask_match(dev_info->available_scan_masks,
+					trialmask);
+		if (!mask)
+			return -EINVAL;
+	}
+	dev_info->scan_mask = trialmask;
 	dev_info->scan_count++;
+
 	return 0;
 };
 
-- 
1.6.4.4


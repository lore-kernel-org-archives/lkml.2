Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab1ITN7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:59:10 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:37925 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751450Ab1ITN7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:59:08 -0400
From: Nestor Lopez Casado <nlopezcasad@logitech.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ogay@logitech.com, jzanone@logitech.com, dan.carpenter@oracle.com
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>
Subject: [PATCH 1/1] HID: hid-logitech-dj: Out of bound by one bug
Date: Tue, 20 Sep 2011 15:59:03 +0200
Message-Id: <1316527143-15123-1-git-send-email-nlopezcasad@logitech.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug where a device with index 6 would write out of bounds in
the array of paired devices.
This patch fixes that problem.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Reviewed-by: Olivier Gay <ogay@logitech.com>
Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
---
Hi Jiri, Dan,

Many thanks to Dan for reporting that bug. We increased the array size by one.

Cheers, 
    Nestor

 drivers/hid/hid-logitech-dj.c |    5 +----
 drivers/hid/hid-logitech-dj.h |    5 ++++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 5bb6f42..38b12e4 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -179,9 +179,6 @@ static const u8 hid_reportid_size_map[NUMBER_OF_HID_REPORTS] = {
 
 #define LOGITECH_DJ_INTERFACE_NUMBER 0x02
 
-#define DJ_DEVICE_INDEX_MIN 1
-#define DJ_DEVICE_INDEX_MAX 6
-
 static struct hid_ll_driver logi_dj_ll_driver;
 
 static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
@@ -823,7 +820,7 @@ static void logi_dj_remove(struct hid_device *hdev)
 	 * have finished and no more raw_event callbacks should arrive after
 	 * the remove callback was triggered so no locks are put around the
 	 * code below */
-	for (i = 0; i < DJ_MAX_PAIRED_DEVICES; i++) {
+	for (i = 0; i < (DJ_MAX_PAIRED_DEVICES + DJ_DEVICE_INDEX_MIN); i++) {
 		dj_dev = djrcv_dev->paired_dj_devices[i];
 		if (dj_dev != NULL) {
 			hid_destroy_device(dj_dev->hdev);
diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
index 5982263..fd28a5e 100644
--- a/drivers/hid/hid-logitech-dj.h
+++ b/drivers/hid/hid-logitech-dj.h
@@ -27,6 +27,8 @@
 
 #define DJ_MAX_PAIRED_DEVICES			6
 #define DJ_MAX_NUMBER_NOTIFICATIONS		8
+#define DJ_DEVICE_INDEX_MIN 			1
+#define DJ_DEVICE_INDEX_MAX 			6
 
 #define DJREPORT_SHORT_LENGTH			15
 #define DJREPORT_LONG_LENGTH			32
@@ -94,7 +96,8 @@ struct dj_report {
 
 struct dj_receiver_dev {
 	struct hid_device *hdev;
-	struct dj_device *paired_dj_devices[DJ_MAX_PAIRED_DEVICES];
+	struct dj_device *paired_dj_devices[DJ_MAX_PAIRED_DEVICES +
+					    DJ_DEVICE_INDEX_MIN];
 	struct work_struct work;
 	struct kfifo notif_fifo;
 	spinlock_t lock;
-- 
1.7.5.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032411Ab2I1Vl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:41:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63188 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032423Ab2I1U0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 088/218] HID: Fix logitech-dj: missing Unifying device issue
Date: Fri, 28 Sep 2012 13:15:05 -0700
Message-Id: <20120928201511.682582903@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nestor Lopez Casado <nlopezcasad@logitech.com>

commit 596264082f10dd4a567c43d4526b2f54ac5520bc upstream.

This patch fixes an issue introduced after commit 4ea5454203d991ec
("HID: Fix race condition between driver core and ll-driver").

After that commit, hid-core discards any incoming packet that arrives while
hid driver's probe function is being executed.

This broke the enumeration process of hid-logitech-dj, that must receive
control packets in-band with the mouse and keyboard packets. Discarding mouse
or keyboard data at the very begining is usually fine, but it is not the case
for control packets.

This patch forces a re-enumeration of the paired devices when a packet arrives
that comes from an unknown device.

Based on a patch originally written by Benjamin Tissoires.

Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-dj.c |   41 +++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-logitech-dj.h |    1 +
 2 files changed, 42 insertions(+)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -185,6 +185,7 @@ static struct hid_ll_driver logi_dj_ll_d
 static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
 					size_t count,
 					unsigned char report_type);
+static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev);
 
 static void logi_dj_recv_destroy_djhid_device(struct dj_receiver_dev *djrcv_dev,
 						struct dj_report *dj_report)
@@ -225,6 +226,7 @@ static void logi_dj_recv_add_djhid_devic
 	if (dj_report->report_params[DEVICE_PAIRED_PARAM_SPFUNCTION] &
 	    SPFUNCTION_DEVICE_LIST_EMPTY) {
 		dbg_hid("%s: device list is empty\n", __func__);
+		djrcv_dev->querying_devices = false;
 		return;
 	}
 
@@ -235,6 +237,12 @@ static void logi_dj_recv_add_djhid_devic
 		return;
 	}
 
+	if (djrcv_dev->paired_dj_devices[dj_report->device_index]) {
+		/* The device is already known. No need to reallocate it. */
+		dbg_hid("%s: device is already known\n", __func__);
+		return;
+	}
+
 	dj_hiddev = hid_allocate_device();
 	if (IS_ERR(dj_hiddev)) {
 		dev_err(&djrcv_hdev->dev, "%s: hid_allocate_device failed\n",
@@ -298,6 +306,7 @@ static void delayedwork_callback(struct
 	struct dj_report dj_report;
 	unsigned long flags;
 	int count;
+	int retval;
 
 	dbg_hid("%s\n", __func__);
 
@@ -330,6 +339,25 @@ static void delayedwork_callback(struct
 		logi_dj_recv_destroy_djhid_device(djrcv_dev, &dj_report);
 		break;
 	default:
+	/* A normal report (i. e. not belonging to a pair/unpair notification)
+	 * arriving here, means that the report arrived but we did not have a
+	 * paired dj_device associated to the report's device_index, this
+	 * means that the original "device paired" notification corresponding
+	 * to this dj_device never arrived to this driver. The reason is that
+	 * hid-core discards all packets coming from a device while probe() is
+	 * executing. */
+	if (!djrcv_dev->paired_dj_devices[dj_report.device_index]) {
+		/* ok, we don't know the device, just re-ask the
+		 * receiver for the list of connected devices. */
+		retval = logi_dj_recv_query_paired_devices(djrcv_dev);
+		if (!retval) {
+			/* everything went fine, so just leave */
+			break;
+		}
+		dev_err(&djrcv_dev->hdev->dev,
+			"%s:logi_dj_recv_query_paired_devices "
+			"error:%d\n", __func__, retval);
+		}
 		dbg_hid("%s: unexpected report type\n", __func__);
 	}
 }
@@ -360,6 +388,12 @@ static void logi_dj_recv_forward_null_re
 	if (!djdev) {
 		dbg_hid("djrcv_dev->paired_dj_devices[dj_report->device_index]"
 			" is NULL, index %d\n", dj_report->device_index);
+		kfifo_in(&djrcv_dev->notif_fifo, dj_report, sizeof(struct dj_report));
+
+		if (schedule_work(&djrcv_dev->work) == 0) {
+			dbg_hid("%s: did not schedule the work item, was already "
+			"queued\n", __func__);
+		}
 		return;
 	}
 
@@ -390,6 +424,12 @@ static void logi_dj_recv_forward_report(
 	if (dj_device == NULL) {
 		dbg_hid("djrcv_dev->paired_dj_devices[dj_report->device_index]"
 			" is NULL, index %d\n", dj_report->device_index);
+		kfifo_in(&djrcv_dev->notif_fifo, dj_report, sizeof(struct dj_report));
+
+		if (schedule_work(&djrcv_dev->work) == 0) {
+			dbg_hid("%s: did not schedule the work item, was already "
+			"queued\n", __func__);
+		}
 		return;
 	}
 
@@ -437,6 +477,7 @@ static int logi_dj_recv_query_paired_dev
 	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
 }
 
+
 static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 					  unsigned timeout)
 {
--- a/drivers/hid/hid-logitech-dj.h
+++ b/drivers/hid/hid-logitech-dj.h
@@ -101,6 +101,7 @@ struct dj_receiver_dev {
 	struct work_struct work;
 	struct kfifo notif_fifo;
 	spinlock_t lock;
+	bool querying_devices;
 };
 
 struct dj_device {



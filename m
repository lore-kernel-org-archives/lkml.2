Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2JGXgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:36:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38421 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128Ab2JGXWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:39 -0400
Message-Id: <20121007225844.105600523@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>
Subject: [ 068/108] HID: hidraw: add proper error handling to raw event reporting
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit b6787242f32700377d3da3b8d788ab3928bab849 upstream.

If kmemdup() in hidraw_report_event() fails, we are not propagating
this fact properly.

Let hidraw_report_event() and hid_report_raw_event() return an error
value to the caller.

Reported-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-core.c |   16 +++++++++++-----
 drivers/hid/hidraw.c   |   19 +++++++++++++------
 include/linux/hid.h    |    2 +-
 include/linux/hidraw.h |    4 ++--
 4 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8be458b..0cddcaa 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1032,7 +1032,7 @@ static struct hid_report *hid_get_report(struct hid_report_enum *report_enum,
 	return report;
 }
 
-void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
+int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		int interrupt)
 {
 	struct hid_report_enum *report_enum = hid->report_enum + type;
@@ -1040,10 +1040,11 @@ void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 	unsigned int a;
 	int rsize, csize = size;
 	u8 *cdata = data;
+	int ret = 0;
 
 	report = hid_get_report(report_enum, data);
 	if (!report)
-		return;
+		goto out;
 
 	if (report_enum->numbered) {
 		cdata++;
@@ -1063,14 +1064,19 @@ void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
 		hid->hiddev_report_event(hid, report);
-	if (hid->claimed & HID_CLAIMED_HIDRAW)
-		hidraw_report_event(hid, data, size);
+	if (hid->claimed & HID_CLAIMED_HIDRAW) {
+		ret = hidraw_report_event(hid, data, size);
+		if (ret)
+			goto out;
+	}
 
 	for (a = 0; a < report->maxfield; a++)
 		hid_input_field(hid, report->field[a], cdata, interrupt);
 
 	if (hid->claimed & HID_CLAIMED_INPUT)
 		hidinput_report_event(hid, report);
+out:
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hid_report_raw_event);
 
@@ -1147,7 +1153,7 @@ nomem:
 		}
 	}
 
-	hid_report_raw_event(hid, type, data, size, interrupt);
+	ret = hid_report_raw_event(hid, type, data, size, interrupt);
 
 unlock:
 	up(&hid->driver_lock);
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index cf7d6d5..36fa77b 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -87,11 +87,13 @@ static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t count,
 		len = list->buffer[list->tail].len > count ?
 			count : list->buffer[list->tail].len;
 
-		if (copy_to_user(buffer, list->buffer[list->tail].value, len)) {
-			ret = -EFAULT;
-			goto out;
+		if (list->buffer[list->tail].value) {
+			if (copy_to_user(buffer, list->buffer[list->tail].value, len)) {
+				ret = -EFAULT;
+				goto out;
+			}
+			ret = len;
 		}
-		ret = len;
 
 		kfree(list->buffer[list->tail].value);
 		list->tail = (list->tail + 1) & (HIDRAW_BUFFER_SIZE - 1);
@@ -437,19 +439,24 @@ static const struct file_operations hidraw_ops = {
 	.llseek =	noop_llseek,
 };
 
-void hidraw_report_event(struct hid_device *hid, u8 *data, int len)
+int hidraw_report_event(struct hid_device *hid, u8 *data, int len)
 {
 	struct hidraw *dev = hid->hidraw;
 	struct hidraw_list *list;
+	int ret = 0;
 
 	list_for_each_entry(list, &dev->list, node) {
-		list->buffer[list->head].value = kmemdup(data, len, GFP_ATOMIC);
+		if (!(list->buffer[list->head].value = kmemdup(data, len, GFP_ATOMIC))) {
+			ret = -ENOMEM;
+			break;
+		}
 		list->buffer[list->head].len = len;
 		list->head = (list->head + 1) & (HIDRAW_BUFFER_SIZE - 1);
 		kill_fasync(&list->fasync, SIGIO, POLL_IN);
 	}
 
 	wake_up_interruptible(&dev->wait);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hidraw_report_event);
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 3a95da6..58b3857 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -896,7 +896,7 @@ static inline int hid_hw_power(struct hid_device *hdev, int level)
 	return hdev->ll_driver->power ? hdev->ll_driver->power(hdev, level) : 0;
 }
 
-void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
+int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		int interrupt);
 
 extern int hid_generic_init(void);
diff --git a/include/linux/hidraw.h b/include/linux/hidraw.h
index 4b88e69..9cdc9b6 100644
--- a/include/linux/hidraw.h
+++ b/include/linux/hidraw.h
@@ -76,13 +76,13 @@ struct hidraw_list {
 #ifdef CONFIG_HIDRAW
 int hidraw_init(void);
 void hidraw_exit(void);
-void hidraw_report_event(struct hid_device *, u8 *, int);
+int hidraw_report_event(struct hid_device *, u8 *, int);
 int hidraw_connect(struct hid_device *);
 void hidraw_disconnect(struct hid_device *);
 #else
 static inline int hidraw_init(void) { return 0; }
 static inline void hidraw_exit(void) { }
-static inline void hidraw_report_event(struct hid_device *hid, u8 *data, int len) { }
+static inline int hidraw_report_event(struct hid_device *hid, u8 *data, int len) { }
 static inline int hidraw_connect(struct hid_device *hid) { return -1; }
 static inline void hidraw_disconnect(struct hid_device *hid) { }
 #endif



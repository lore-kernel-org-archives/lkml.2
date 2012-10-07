Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2JGXgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:36:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38390 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056Ab2JGXWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:38 -0400
Message-Id: <20121007225844.525931211@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ratan Nalumasu <ratan@google.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 071/108] HID: hidraw: dont deallocate memory when it is in use
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratan Nalumasu <ratan@google.com>

commit 4fe9f8e203fdad1524c04beb390f3c6099781ed9 upstream.

When a device is unplugged, wait for all processes that have opened the device
to close before deallocating the device.

Signed-off-by: Ratan Nalumasu <ratan@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hidraw.c |   69 +++++++++++++++++++-------------------------------
 1 file changed, 26 insertions(+), 43 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 3b6f7bf..c46c5f1 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -42,6 +42,7 @@ static struct cdev hidraw_cdev;
 static struct class *hidraw_class;
 static struct hidraw *hidraw_table[HIDRAW_MAX_DEVICES];
 static DEFINE_MUTEX(minors_lock);
+static void drop_ref(struct hidraw *hid, int exists_bit);
 
 static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 {
@@ -113,7 +114,7 @@ static ssize_t hidraw_send_report(struct file *file, const char __user *buffer,
 	__u8 *buf;
 	int ret = 0;
 
-	if (!hidraw_table[minor]) {
+	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -261,7 +262,7 @@ static int hidraw_open(struct inode *inode, struct file *file)
 	}
 
 	mutex_lock(&minors_lock);
-	if (!hidraw_table[minor]) {
+	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		err = -ENODEV;
 		goto out_unlock;
 	}
@@ -298,36 +299,12 @@ out:
 static int hidraw_release(struct inode * inode, struct file * file)
 {
 	unsigned int minor = iminor(inode);
-	struct hidraw *dev;
 	struct hidraw_list *list = file->private_data;
-	int ret;
-	int i;
-
-	mutex_lock(&minors_lock);
-	if (!hidraw_table[minor]) {
-		ret = -ENODEV;
-		goto unlock;
-	}
 
+	drop_ref(hidraw_table[minor], 0);
 	list_del(&list->node);
-	dev = hidraw_table[minor];
-	if (!--dev->open) {
-		if (list->hidraw->exist) {
-			hid_hw_power(dev->hid, PM_HINT_NORMAL);
-			hid_hw_close(dev->hid);
-		} else {
-			kfree(list->hidraw);
-		}
-	}
-
-	for (i = 0; i < HIDRAW_BUFFER_SIZE; ++i)
-		kfree(list->buffer[i].value);
 	kfree(list);
-	ret = 0;
-unlock:
-	mutex_unlock(&minors_lock);
-
-	return ret;
+	return 0;
 }
 
 static long hidraw_ioctl(struct file *file, unsigned int cmd,
@@ -529,21 +506,7 @@ EXPORT_SYMBOL_GPL(hidraw_connect);
 void hidraw_disconnect(struct hid_device *hid)
 {
 	struct hidraw *hidraw = hid->hidraw;
-
-	mutex_lock(&minors_lock);
-	hidraw->exist = 0;
-
-	device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
-
-	hidraw_table[hidraw->minor] = NULL;
-
-	if (hidraw->open) {
-		hid_hw_close(hid);
-		wake_up_interruptible(&hidraw->wait);
-	} else {
-		kfree(hidraw);
-	}
-	mutex_unlock(&minors_lock);
+	drop_ref(hidraw, 1);
 }
 EXPORT_SYMBOL_GPL(hidraw_disconnect);
 
@@ -585,3 +548,23 @@ void hidraw_exit(void)
 	unregister_chrdev_region(dev_id, HIDRAW_MAX_DEVICES);
 
 }
+
+static void drop_ref(struct hidraw *hidraw, int exists_bit)
+{
+	mutex_lock(&minors_lock);
+	if (exists_bit) {
+		hid_hw_close(hidraw->hid);
+		hidraw->exist = 0;
+		if (hidraw->open)
+			wake_up_interruptible(&hidraw->wait);
+	} else {
+		--hidraw->open;
+	}
+
+	if (!hidraw->open && !hidraw->exist) {
+		device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
+		hidraw_table[hidraw->minor] = NULL;
+		kfree(hidraw);
+	}
+	mutex_unlock(&minors_lock);
+}



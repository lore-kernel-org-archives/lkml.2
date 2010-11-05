Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0KETFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:05:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:46558 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab0KETFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:05:37 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: stern@rowland.harvard.edu
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, Dmitry Torokhov <dtor@mail.ru>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [RFC PATCH 3/5] Input: input_reset()
Date: Fri,  5 Nov 2010 14:05:04 -0500
Message-Id: <1288983906-31129-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288983906-31129-3-git-send-email-jason.wessel@windriver.com>
References: <1288983906-31129-1-git-send-email-jason.wessel@windriver.com>
 <1288983906-31129-2-git-send-email-jason.wessel@windriver.com>
 <1288983906-31129-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Nov 2010 19:05:17.0542 (UTC) FILETIME=[6281C860:01CB7D1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@mail.ru>

Expose part of the logic used to resume from suspend to clear a
keyboard state for use from an exported function called
input_reset_device().  The intended use of the function is allow
reseting the input state after resuming kernel execution from the
kernel debugger.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/input/input.c |   50 ++++++++++++++++++++++++++++++++++--------------
 include/linux/input.h |    4 ++-
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index d092ef9..75bed63 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1565,8 +1565,7 @@ static int input_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 		}							\
 	} while (0)
 
-#ifdef CONFIG_PM
-static void input_dev_reset(struct input_dev *dev, bool activate)
+static void input_dev_toggle(struct input_dev *dev, bool activate)
 {
 	if (!dev->event)
 		return;
@@ -1580,12 +1579,44 @@ static void input_dev_reset(struct input_dev *dev, bool activate)
 	}
 }
 
+/**
+ * input_reset_device() - reset/restore the state of input device
+ * @dev: input device whose state needs to be reset
+ *
+ * This function tries to reset the state of an opened input device and
+ * bring internal state and state if the hardware in sync with each other.
+ * We mark all keys as released, restore LED state, repeat rate, etc.
+ */
+void input_reset_device(struct input_dev *dev)
+{
+	mutex_lock(&dev->mutex);
+
+	if (dev->users) {
+		input_dev_toggle(dev, true);
+
+		/*
+		 * Keys that have been pressed at suspend time are unlikely
+		 * to be still pressed when we resume.
+		 */
+		spin_lock_irq(&dev->event_lock);
+		input_dev_release_keys(dev);
+		spin_unlock_irq(&dev->event_lock);
+	}
+
+	mutex_unlock(&dev->mutex);
+}
+EXPORT_SYMBOL(input_reset_device);
+
+#ifdef CONFIG_PM
 static int input_dev_suspend(struct device *dev)
 {
 	struct input_dev *input_dev = to_input_dev(dev);
 
 	mutex_lock(&input_dev->mutex);
-	input_dev_reset(input_dev, false);
+
+	if (input_dev->users)
+		input_dev_toggle(input_dev, false);
+
 	mutex_unlock(&input_dev->mutex);
 
 	return 0;
@@ -1595,18 +1626,7 @@ static int input_dev_resume(struct device *dev)
 {
 	struct input_dev *input_dev = to_input_dev(dev);
 
-	mutex_lock(&input_dev->mutex);
-	input_dev_reset(input_dev, true);
-
-	/*
-	 * Keys that have been pressed at suspend time are unlikely
-	 * to be still pressed when we resume.
-	 */
-	spin_lock_irq(&input_dev->event_lock);
-	input_dev_release_keys(input_dev);
-	spin_unlock_irq(&input_dev->event_lock);
-
-	mutex_unlock(&input_dev->mutex);
+	input_reset_device(input_dev);
 
 	return 0;
 }
diff --git a/include/linux/input.h b/include/linux/input.h
index 51af441..6ef4446 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1406,6 +1406,8 @@ static inline void input_set_drvdata(struct input_dev *dev, void *data)
 int __must_check input_register_device(struct input_dev *);
 void input_unregister_device(struct input_dev *);
 
+void input_reset_device(struct input_dev *);
+
 int __must_check input_register_handler(struct input_handler *);
 void input_unregister_handler(struct input_handler *);
 
@@ -1421,7 +1423,7 @@ void input_release_device(struct input_handle *);
 int input_open_device(struct input_handle *);
 void input_close_device(struct input_handle *);
 
-int input_flush_device(struct input_handle* handle, struct file* file);
+int input_flush_device(struct input_handle *handle, struct file *file);
 
 void input_event(struct input_dev *dev, unsigned int type, unsigned int code, int value);
 void input_inject_event(struct input_handle *handle, unsigned int type, unsigned int code, int value);
-- 
1.6.3.3


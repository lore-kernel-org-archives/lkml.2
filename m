Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab2BHD0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 22:26:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46654 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2BHDZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 22:25:43 -0500
From: Che-Liang Chiou <clchiou@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Che-Liang Chiou <clchiou@chromium.org>
Subject: [PATCH 4/5] Input: serio_raw - add debugfs interface
Date: Wed,  8 Feb 2012 11:24:56 +0800
Message-Id: <1328671497-20880-5-git-send-email-clchiou@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
References: <1328671497-20880-1-git-send-email-clchiou@chromium.org>
In-Reply-To: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
References: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debugfs interface for each serio_raw module instance. Take
serio_raw0 for example, the interface should look like:

  /sys/kernel/debug/serio_raw0/replay
                           .../user
                           .../device

Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
---
 drivers/input/serio/serio_raw.c |   51 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 5d13c64..7b02691 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -21,6 +21,7 @@
 #include <linux/miscdevice.h>
 #include <linux/wait.h>
 #include <linux/mutex.h>
+#include <linux/debugfs.h>
 
 #define DRIVER_DESC	"Raw serio driver"
 
@@ -45,6 +46,9 @@ struct serio_raw {
 	struct list_head client_list;
 	struct list_head node;
 	bool dead;
+	u32 replay;  /* not bool because debugfs_create_bool() takes u32 */
+
+	struct dentry *dentry;
 };
 
 struct serio_raw_client {
@@ -342,6 +346,17 @@ static const struct file_operations serio_raw_fops = {
 
 
 /*********************************************************************
+ *             Interface with debugfs (file operations)              *
+ *********************************************************************/
+
+static const struct file_operations debug_user_fops = {
+};
+
+static const struct file_operations debug_device_fops = {
+};
+
+
+/*********************************************************************
  *                   Interface with serio port                       *
  *********************************************************************/
 
@@ -361,6 +376,36 @@ static irqreturn_t serio_raw_interrupt(struct serio *serio, unsigned char data,
 	return IRQ_HANDLED;
 }
 
+static int serio_raw_debug_init(struct serio_raw *serio_raw)
+{
+	const mode_t mode = S_IRUSR | S_IWUSR;
+
+	serio_raw->dentry = debugfs_create_dir(serio_raw->name, NULL);
+	if (!serio_raw->dentry)
+		return -ENOENT;
+
+	if (!debugfs_create_bool("replay", mode, serio_raw->dentry,
+				&serio_raw->replay))
+		goto err;
+	if (!debugfs_create_file("user", mode, serio_raw->dentry, serio_raw,
+				&debug_user_fops))
+		goto err;
+	if (!debugfs_create_file("device", mode, serio_raw->dentry, serio_raw,
+				&debug_device_fops))
+		goto err;
+
+	return 0;
+
+err:
+	debugfs_remove_recursive(serio_raw->dentry);
+	return -ENOENT;
+}
+
+static void serio_raw_debug_cleanup(struct serio_raw *serio_raw)
+{
+	debugfs_remove_recursive(serio_raw->dentry);
+}
+
 static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 {
 	static atomic_t serio_raw_no = ATOMIC_INIT(0);
@@ -413,6 +458,10 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 		goto err_unlink;
 	}
 
+	if (serio_raw_debug_init(serio_raw))
+		dev_warn(&serio->dev, "failed to register debugfs for %s\n",
+				serio->phys);
+
 	dev_info(&serio->dev, "raw access enabled on %s (%s, minor %d)\n",
 		 serio->phys, serio_raw->name, serio_raw->dev.minor);
 	return 0;
@@ -475,6 +524,8 @@ static void serio_raw_disconnect(struct serio *serio)
 
 	serio_raw_hangup(serio_raw);
 
+	serio_raw_debug_cleanup(serio_raw);
+
 	serio_close(serio);
 	kref_put(&serio_raw->kref, serio_raw_free);
 
-- 
1.7.7.3


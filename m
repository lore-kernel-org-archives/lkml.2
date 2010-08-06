Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565Ab0HFQaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 12:30:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50273 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760111Ab0HFQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TkTju38MKpY7+Cw0JUtxALrjQaBFH8sYquNrQIZlVi6fceRQMRS5YZrJcspNHqT7PQ
         LZEggfdoCw8oTt7KSF+PLvE0Q8N95xwaXVDRC2iFJj09Y4lTyykuZhSF4w1d9hNl75da
         cq+8ON1Q9P3ERnFL7jxv5iIVx8EhBkTbshPLg=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tty_io: add an API to get device corresponding to tty_struct
Date: Fri,  6 Aug 2010 20:29:28 +0400
Message-Id: <1281112169-27086-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some device drivers (mostly tty line disciplines) would like to have way
to get a struct device instancve corresponding to passed tty_struct. Add
respective API call.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/char/tty_io.c |   20 ++++++++++++++++++++
 include/linux/tty.h   |    1 +
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d71f0fc..43fdeef 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3017,6 +3017,26 @@ dev_t tty_devnum(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_devnum);
 
+static int dev_match_devt(struct device *dev, void *data)
+{
+	dev_t *devt = data;
+	return dev->devt == *devt;
+}
+
+/**
+ * 	tty_get_device - get a device corresponding to tty
+ * 	@tty: the struct that describes the tty device
+ *
+ * 	Returns a pointer to the struct device for this tty device
+ * 	(or NULL in case of error).
+ */
+struct device *tty_get_device(struct tty_struct *tty)
+{
+	dev_t devt = tty_devnum(tty);
+	return class_find_device(tty_class, NULL, &devt, dev_match_devt);
+}
+EXPORT_SYMBOL(tty_get_device);
+
 void proc_clear_tty(struct task_struct *p)
 {
 	unsigned long flags;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 931078b..5038433 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -451,6 +451,7 @@ extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
 extern dev_t tty_devnum(struct tty_struct *tty);
+struct device *tty_get_device(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
-- 
1.7.1


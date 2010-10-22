Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab0JVSVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:21:31 -0400
Received: from kroah.org ([198.145.64.141]:41835 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab0JVSVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/49] tty: add tty_struct->dev pointer to corresponding device instance
Date: Fri, 22 Oct 2010 11:20:40 -0700
Message-Id: <1287771688-14805-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Some device drivers (mostly tty line disciplines) would like to have way
know a struct device instance corresponding to passed tty_struct. Add
a struct device pointer to struct tty_struct and populate it during
initialize_tty_struct().

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |   17 +++++++++++++++++
 include/linux/tty.h   |    1 +
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 613c852..dc184d4 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -183,6 +183,8 @@ struct tty_struct *alloc_tty_struct(void)
 
 void free_tty_struct(struct tty_struct *tty)
 {
+	if (tty->dev)
+		put_device(tty->dev);
 	kfree(tty->write_buf);
 	tty_buffer_free_all(tty);
 	kfree(tty);
@@ -2783,6 +2785,20 @@ void do_SAK(struct tty_struct *tty)
 
 EXPORT_SYMBOL(do_SAK);
 
+static int dev_match_devt(struct device *dev, void *data)
+{
+	dev_t *devt = data;
+	return dev->devt == *devt;
+}
+
+/* Must put_device() after it's unused! */
+static struct device *tty_get_device(struct tty_struct *tty)
+{
+	dev_t devt = tty_devnum(tty);
+	return class_find_device(tty_class, NULL, &devt, dev_match_devt);
+}
+
+
 /**
  *	initialize_tty_struct
  *	@tty: tty to initialize
@@ -2823,6 +2839,7 @@ void initialize_tty_struct(struct tty_struct *tty,
 	tty->ops = driver->ops;
 	tty->index = idx;
 	tty_line_name(driver, idx, tty->name);
+	tty->dev = tty_get_device(tty);
 }
 
 /**
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 67d64e6..d94eb86 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -256,6 +256,7 @@ struct tty_operations;
 struct tty_struct {
 	int	magic;
 	struct kref kref;
+	struct device *dev;
 	struct tty_driver *driver;
 	const struct tty_operations *ops;
 	int index;
-- 
1.7.2


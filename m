Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0HIOXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:23:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39942 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab0HIOXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:23:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=loahZuaXX7SOp1rldw7pYeT77ZgdLn7sqee5f2Qra4yNPEB07Ona8SQFrXIdFxmji8
         XupQKeWBw54C37Znuhg2VHSP0vPCQRCi2MqCXH7UfyxUkcOKvS1pw+ssfLMjcxwnp2tm
         M3CE4IsJ9KavLwAa9vL7KhZPsGxmQlsiWDzIw=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] tty: add tty_struct->dev pointer to corresponding device instance
Date: Mon,  9 Aug 2010 18:22:49 +0400
Message-Id: <1281363770-23598-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some device drivers (mostly tty line disciplines) would like to have way
know a struct device instance corresponding to passed tty_struct. Add
a struct device pointer to struct tty_struct and populate it during
initialize_tty_struct().

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/tty_io.c |   17 +++++++++++++++++
 include/linux/tty.h   |    1 +
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d71f0fc..2469682 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -179,6 +179,8 @@ struct tty_struct *alloc_tty_struct(void)
 
 void free_tty_struct(struct tty_struct *tty)
 {
+	if (tty->dev)
+		put_device(tty->dev);
 	kfree(tty->write_buf);
 	tty_buffer_free_all(tty);
 	kfree(tty);
@@ -2737,6 +2739,20 @@ void do_SAK(struct tty_struct *tty)
 
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
@@ -2777,6 +2793,7 @@ void initialize_tty_struct(struct tty_struct *tty,
 	tty->ops = driver->ops;
 	tty->index = idx;
 	tty_line_name(driver, idx, tty->name);
+	tty->dev = tty_get_device(tty);
 }
 
 /**
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 931078b..d64db5a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -254,6 +254,7 @@ struct tty_operations;
 struct tty_struct {
 	int	magic;
 	struct kref kref;
+	struct device *dev;
 	struct tty_driver *driver;
 	const struct tty_operations *ops;
 	int index;
-- 
1.7.1


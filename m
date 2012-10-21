Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2JUHYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 03:24:36 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63694 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2JUHYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 03:24:35 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 1/2] char_dev: allow setting up and pinning parent devices
Date: Sun, 21 Oct 2012 00:24:30 -0700
Message-Id: <1350804271-2449-1-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <20121019175046.GP2616@ZenIV.linux.org.uk>
References: <20121019175046.GP2616@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In certain cases (for example when a cdev structure is embedded into
another object whose lifetime is controlled by a separate device object)
it is beneficial to tie lifetime of another struct device to the lifetime
of character device so that related object is not freed until after
char_dev object is freed. To achieve this allow setting a "parent" device
for character devices and pin them when doing cdev_add() and unpin when
last reference to cdev structure is being released.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Sorry, messed up the first attempt to send...

So, how about these 2? I enabled kmemleak and added some debug printks and
it looks like we dropping references and freeing object at right times and
in proper order.

Thanks!

 fs/char_dev.c        | 18 +++++++++++++++++-
 include/linux/cdev.h |  1 +
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 3f152b9..f8c44cc 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -471,9 +471,19 @@ static int exact_lock(dev_t dev, void *data)
  */
 int cdev_add(struct cdev *p, dev_t dev, unsigned count)
 {
+	int error;
+
 	p->dev = dev;
 	p->count = count;
-	return kobj_map(cdev_map, dev, count, NULL, exact_match, exact_lock, p);
+
+	error = kobj_map(cdev_map, dev, count, NULL,
+			 exact_match, exact_lock, p);
+	if (error)
+		return error;
+
+	get_device(p->parent);
+
+	return 0;
 }
 
 static void cdev_unmap(dev_t dev, unsigned count)
@@ -498,14 +508,20 @@ void cdev_del(struct cdev *p)
 static void cdev_default_release(struct kobject *kobj)
 {
 	struct cdev *p = container_of(kobj, struct cdev, kobj);
+	struct device *parent = p->parent;
+
 	cdev_purge(p);
+	put_device(parent);
 }
 
 static void cdev_dynamic_release(struct kobject *kobj)
 {
 	struct cdev *p = container_of(kobj, struct cdev, kobj);
+	struct device *parent = p->parent;
+
 	cdev_purge(p);
 	kfree(p);
+	put_device(parent);
 }
 
 static struct kobj_type ktype_cdev_default = {
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index fb45919..eba8251 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -12,6 +12,7 @@ struct module;
 struct cdev {
 	struct kobject kobj;
 	struct module *owner;
+	struct device *parent;
 	const struct file_operations *ops;
 	struct list_head list;
 	dev_t dev;
-- 
1.7.11.7


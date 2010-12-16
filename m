Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0LPPBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:01:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42526 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab0LPPBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:01:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vfv9+n3yL/eMOfOx5oDwPWBHO6IuNZcYt3oL5F2jaxN3qMRTWKzGCGZm5ov1jlQAzR
         mCJigHdPeCXpDrYfFoSSMCz/jaz4Xd91G5aqi7oELGrgPmlcxlmjI1gd0F9Bl0SUCzej
         KWgomJHw+WGVawVxNcTOXW/st9uS0ar+FJ5h4=
MIME-Version: 1.0
Date: Thu, 16 Dec 2010 23:01:13 +0800
Message-ID: <AANLkTikBMhdb3kSPniF-2AOO_=TjNgCn=tMsp0e0RjbO@mail.gmail.com>
Subject: [PATCH] replace idr in block layer SCSI generic (bsg) driver with
 kzalloced buffer
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel library, idr, is used in bsg for storing and managing minors of
registered block queue.

In this work idr is replaced with kzalloced buffer, storing and managing
minors with cached info. The advantage looks that
1) it is not monstrous, and
2) it is faster when allocating, looking up and removing minors.

And disadvantage is that is not old.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/block/bsg.c	2010-11-01 19:54:12.000000000 +0800
+++ b/block/bsg.c	2010-12-16 22:14:54.000000000 +0800
@@ -18,7 +18,6 @@
 #include <linux/jiffies.h>
 #include <linux/percpu.h>
 #include <linux/uio.h>
-#include <linux/idr.h>
 #include <linux/bsg.h>
 #include <linux/slab.h>

@@ -64,7 +63,6 @@ enum {
 #endif

 static DEFINE_MUTEX(bsg_mutex);
-static DEFINE_IDR(bsg_minor_idr);

 #define BSG_LIST_ARRAY_SIZE	8
 static struct hlist_head bsg_device_list[BSG_LIST_ARRAY_SIZE];
@@ -88,6 +86,25 @@ struct bsg_command {
 	char sense[SCSI_SENSE_BUFFERSIZE];
 };

+struct bsg_idr {
+	/* cached info of freed minors */
+	int	left, right;
+	/* pointer for getting new minor from buf */
+	int	index;
+	/* house-keeping info buf */
+	int	used, alloc;
+	/* kzalloced buffer for storing registered minors */
+	void	**buf;
+};
+
+static struct bsg_idr	bsg_minor_idr;
+
+/* methods of bsg idr */
+static void *bsg_idr_find(struct bsg_idr *, unsigned);
+static void bsg_idr_remove(struct bsg_idr *, int);
+static int bsg_idr_get_new(struct bsg_idr *, void *);
+
+
 static void bsg_free_command(struct bsg_command *bc)
 {
 	struct bsg_device *bd = bc->bd;
@@ -819,7 +836,7 @@ static struct bsg_device *bsg_get_device
 	 * find the class device
 	 */
 	mutex_lock(&bsg_mutex);
-	bcd = idr_find(&bsg_minor_idr, iminor(inode));
+	bcd = bsg_idr_find(&bsg_minor_idr, iminor(inode));
 	if (bcd)
 		kref_get(&bcd->ref);
 	mutex_unlock(&bsg_mutex);
@@ -968,6 +985,77 @@ static const struct file_operations bsg_
 	.llseek		=	default_llseek,
 };

+static void *bsg_idr_find(struct bsg_idr *idr, unsigned minor)
+{
+	if (minor < (idr->alloc / sizeof(void *)))
+		return idr->buf[minor];
+
+	return NULL;
+}
+
+static void bsg_idr_remove(struct bsg_idr idr*, int minor)
+{
+	if (idr->left == BSG_MAX_DEVS)
+		idr->left = minor;
+	else if (idr->right == BSG_MAX_DEVS)
+		idr->right = minor;
+
+	idr->used--;
+	idr->buf[minor] = 0;
+}
+
+static int bsg_idr_get_new(struct bsg_idr *idr, void *bcd)
+{
+	int minor;
+
+	if (idr->used >= BSG_MAX_DEVS)
+		return -ENOSPC;
+
+	if (idr->used >= (idr->alloc / sizeof(void *))) {
+		void **buf;
+
+		buf = kzalloc(idr->alloc + PAGE_SIZE, GFP_KERNEL);
+		if (! buf)
+			return -ENOMEM;
+
+		memcpy(buf, idr->buf, idr->alloc);
+		kfree(idr->buf);
+		idr->buf = buf;
+		idr->alloc += PAGE_SIZE;
+	}
+
+	if (idr->left != BSG_MAX_DEVS) {
+		minor = idr->left;
+		idr->left = BSG_MAX_DEVS;
+	}
+	else if (idr->right != BSG_MAX_DEVS) {
+		minor = idr->right;
+		idr->right = BSG_MAX_DEVS;
+	}
+	else {
+		int i;
+		int cnt = idr->alloc / sizeof(void *);
+
+		for (minor = idr->index, i = 0; i < cnt; i++) {
+			if (minor == cnt)
+				minor = 1;
+			if (! idr->buf[minor])
+				break;
+			minor++;
+		}
+
+		if (i == cnt)
+			return -ENOSPC;
+
+		idr->index = minor + 1;
+	}
+
+	idr->used++;
+	idr->buf[minor] = bcd;
+
+	return minor;
+}
+
 void bsg_unregister_queue(struct request_queue *q)
 {
 	struct bsg_class_device *bcd = &q->bsg_dev;
@@ -976,7 +1064,7 @@ void bsg_unregister_queue(struct request
 		return;

 	mutex_lock(&bsg_mutex);
-	idr_remove(&bsg_minor_idr, bcd->minor);
+	bsg_idr_remove(&bsg_minor_idr, bcd->minor);
 	sysfs_remove_link(&q->kobj, "bsg");
 	device_unregister(bcd->class_dev);
 	bcd->class_dev = NULL;
@@ -1010,22 +1098,10 @@ int bsg_register_queue(struct request_qu

 	mutex_lock(&bsg_mutex);

-	ret = idr_pre_get(&bsg_minor_idr, GFP_KERNEL);
-	if (!ret) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
-
-	ret = idr_get_new(&bsg_minor_idr, bcd, &minor);
+	minor = ret = bsg_idr_get_new(&bsg_minor_idr, bcd);
 	if (ret < 0)
 		goto unlock;

-	if (minor >= BSG_MAX_DEVS) {
-		printk(KERN_ERR "bsg: too many bsg devices\n");
-		ret = -EINVAL;
-		goto remove_idr;
-	}
-
 	bcd->minor = minor;
 	bcd->queue = q;
 	bcd->parent = get_device(parent);
@@ -1052,8 +1128,7 @@ unregister_class_dev:
 	device_unregister(class_dev);
 put_dev:
 	put_device(parent);
-remove_idr:
-	idr_remove(&bsg_minor_idr, minor);
+	bsg_idr_remove(&bsg_minor_idr, minor);
 unlock:
 	mutex_unlock(&bsg_mutex);
 	return ret;
@@ -1067,16 +1142,36 @@ static char *bsg_devnode(struct device *
 	return kasprintf(GFP_KERNEL, "bsg/%s", dev_name(dev));
 }

+static int __init bsg_init_idr(struct bsg_idr *idr)
+{
+	idr->buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (! idr->buf)
+		return -ENOMEM;
+
+	idr->alloc = PAGE_SIZE;
+	idr->used = 0;
+	idr->left = 1;
+	idr->right = 2;
+	idr->index = 3;
+
+	return 0;
+}
+
 static int __init bsg_init(void)
 {
 	int ret, i;
 	dev_t devid;

+	ret = bsg_init_idr(&bsg_minor_idr);
+	if (ret)
+		return ret;
+
 	bsg_cmd_cachep = kmem_cache_create("bsg_cmd",
 				sizeof(struct bsg_command), 0, 0, NULL);
 	if (!bsg_cmd_cachep) {
 		printk(KERN_ERR "bsg: failed creating slab cache\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto destroy_idr;
 	}

 	for (i = 0; i < BSG_LIST_ARRAY_SIZE; i++)
@@ -1109,6 +1204,8 @@ destroy_bsg_class:
 	class_destroy(bsg_class);
 destroy_kmemcache:
 	kmem_cache_destroy(bsg_cmd_cachep);
+destroy_idr:
+	kfree(bsg_minor_idr.buf);
 	return ret;
 }

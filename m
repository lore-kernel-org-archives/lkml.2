Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0KCQyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:54:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45636 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab0KCQy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=If02+BxjnXZLoFvM2MzUqfFvNhePwB8s9nat/QbKXc+8Jidv7nH+m8IwD3/bLNJdyj
         WCESFqppId2Ea3IGaduZylGSMMOQdDmiYyVY+PPLZKelHEbmVHMLnWX5f46+fNjF2Dwm
         9+7RwGuafEqHwNiAv6APmP493eP40Nu7KhbgI=
From: cdhmanning@gmail.com
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 2/9] Add yaffs allocator, bitmap and attrib source
Date: Thu,  4 Nov 2010 05:53:17 +1300
Message-Id: <1288803204-3849-3-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Manning <cdhmanning@gmail.com>

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_allocator.c |  393 +++++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_allocator.h |   30 ++++
 fs/yaffs2/yaffs_attribs.c   |  124 ++++++++++++++
 fs/yaffs2/yaffs_attribs.h   |   28 +++
 fs/yaffs2/yaffs_bitmap.c    |  104 ++++++++++++
 fs/yaffs2/yaffs_bitmap.h    |   33 ++++
 6 files changed, 712 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_allocator.c
 create mode 100644 fs/yaffs2/yaffs_allocator.h
 create mode 100644 fs/yaffs2/yaffs_attribs.c
 create mode 100644 fs/yaffs2/yaffs_attribs.h
 create mode 100644 fs/yaffs2/yaffs_bitmap.c
 create mode 100644 fs/yaffs2/yaffs_bitmap.h

diff --git a/fs/yaffs2/yaffs_allocator.c b/fs/yaffs2/yaffs_allocator.c
new file mode 100644
index 0000000..03ede86
--- /dev/null
+++ b/fs/yaffs2/yaffs_allocator.c
@@ -0,0 +1,393 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_allocator.h"
+#include "yaffs_guts.h"
+#include "yaffs_trace.h"
+#include "yportenv.h"
+
+#ifdef CONFIG_YAFFS_YMALLOC_ALLOCATOR
+
+void yaffs_deinit_raw_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	dev = dev;
+}
+
+void yaffs_init_raw_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	dev = dev;
+}
+
+struct yaffs_tnode *yaffs_alloc_raw_tnode(struct yaffs_dev *dev)
+{
+	return (struct yaffs_tnode *)YMALLOC(dev->tnode_size);
+}
+
+void yaffs_free_raw_tnode(struct yaffs_dev *dev, struct yaffs_tnode *tn)
+{
+	dev = dev;
+	YFREE(tn);
+}
+
+void yaffs_init_raw_objs(struct yaffs_dev *dev)
+{
+	dev = dev;
+}
+
+void yaffs_deinit_raw_objs(struct yaffs_dev *dev)
+{
+	dev = dev;
+}
+
+struct yaffs_obj *yaffs_alloc_raw_obj(struct yaffs_dev *dev)
+{
+	dev = dev;
+	return (struct yaffs_obj *)YMALLOC(sizeof(struct yaffs_obj));
+}
+
+void yaffs_free_raw_obj(struct yaffs_dev *dev, struct yaffs_obj *obj)
+{
+
+	dev = dev;
+	YFREE(obj);
+}
+
+#else
+
+struct yaffs_tnode_list {
+	struct yaffs_tnode_list *next;
+	struct yaffs_tnode *tnodes;
+};
+
+struct yaffs_obj_list {
+	struct yaffs_obj_list *next;
+	struct yaffs_obj *objects;
+};
+
+struct yaffs_allocator {
+	int n_tnodes_created;
+	struct yaffs_tnode *free_tnodes;
+	int n_free_tnodes;
+	struct yaffs_tnode_list *alloc_tnode_list;
+
+	int n_obj_created;
+	struct yaffs_obj *free_objs;
+	int n_free_objects;
+
+	struct yaffs_obj_list *allocated_obj_list;
+};
+
+static void yaffs_deinit_raw_tnodes(struct yaffs_dev *dev)
+{
+
+	struct yaffs_allocator *allocator =
+	    (struct yaffs_allocator *)dev->allocator;
+
+	struct yaffs_tnode_list *tmp;
+
+	if (!allocator) {
+		YBUG();
+		return;
+	}
+
+	while (allocator->alloc_tnode_list) {
+		tmp = allocator->alloc_tnode_list->next;
+
+		YFREE(allocator->alloc_tnode_list->tnodes);
+		YFREE(allocator->alloc_tnode_list);
+		allocator->alloc_tnode_list = tmp;
+
+	}
+
+	allocator->free_tnodes = NULL;
+	allocator->n_free_tnodes = 0;
+	allocator->n_tnodes_created = 0;
+}
+
+static void yaffs_init_raw_tnodes(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (allocator) {
+		allocator->alloc_tnode_list = NULL;
+		allocator->free_tnodes = NULL;
+		allocator->n_free_tnodes = 0;
+		allocator->n_tnodes_created = 0;
+	} else
+		YBUG();
+}
+
+static int yaffs_create_tnodes(struct yaffs_dev *dev, int n_tnodes)
+{
+	struct yaffs_allocator *allocator =
+	    (struct yaffs_allocator *)dev->allocator;
+	int i;
+	struct yaffs_tnode *new_tnodes;
+	u8 *mem;
+	struct yaffs_tnode *curr;
+	struct yaffs_tnode *next;
+	struct yaffs_tnode_list *tnl;
+
+	if (!allocator) {
+		YBUG();
+		return YAFFS_FAIL;
+	}
+
+	if (n_tnodes < 1)
+		return YAFFS_OK;
+
+	/* make these things */
+
+	new_tnodes = YMALLOC(n_tnodes * dev->tnode_size);
+	mem = (u8 *) new_tnodes;
+
+	if (!new_tnodes) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR("yaffs: Could not allocate Tnodes" TENDSTR)));
+		return YAFFS_FAIL;
+	}
+
+	/* New hookup for wide tnodes */
+	for (i = 0; i < n_tnodes - 1; i++) {
+		curr = (struct yaffs_tnode *)&mem[i * dev->tnode_size];
+		next = (struct yaffs_tnode *)&mem[(i + 1) * dev->tnode_size];
+		curr->internal[0] = next;
+	}
+
+	curr = (struct yaffs_tnode *)&mem[(n_tnodes - 1) * dev->tnode_size];
+	curr->internal[0] = allocator->free_tnodes;
+	allocator->free_tnodes = (struct yaffs_tnode *)mem;
+
+	allocator->n_free_tnodes += n_tnodes;
+	allocator->n_tnodes_created += n_tnodes;
+
+	/* Now add this bunch of tnodes to a list for freeing up.
+	 * NB If we can't add this to the management list it isn't fatal
+	 * but it just means we can't free this bunch of tnodes later.
+	 */
+
+	tnl = YMALLOC(sizeof(struct yaffs_tnode_list));
+	if (!tnl) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR
+		   ("yaffs: Could not add tnodes to management list" TENDSTR)));
+		return YAFFS_FAIL;
+	} else {
+		tnl->tnodes = new_tnodes;
+		tnl->next = allocator->alloc_tnode_list;
+		allocator->alloc_tnode_list = tnl;
+	}
+
+	T(YAFFS_TRACE_ALLOCATE, (TSTR("yaffs: Tnodes added" TENDSTR)));
+
+	return YAFFS_OK;
+}
+
+struct yaffs_tnode *yaffs_alloc_raw_tnode(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator =
+	    (struct yaffs_allocator *)dev->allocator;
+	struct yaffs_tnode *tn = NULL;
+
+	if (!allocator) {
+		YBUG();
+		return NULL;
+	}
+
+	/* If there are none left make more */
+	if (!allocator->free_tnodes)
+		yaffs_create_tnodes(dev, YAFFS_ALLOCATION_NTNODES);
+
+	if (allocator->free_tnodes) {
+		tn = allocator->free_tnodes;
+		allocator->free_tnodes = allocator->free_tnodes->internal[0];
+		allocator->n_free_tnodes--;
+	}
+
+	return tn;
+}
+
+/* FreeTnode frees up a tnode and puts it back on the free list */
+void yaffs_free_raw_tnode(struct yaffs_dev *dev, struct yaffs_tnode *tn)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (!allocator) {
+		YBUG();
+		return;
+	}
+
+	if (tn) {
+		tn->internal[0] = allocator->free_tnodes;
+		allocator->free_tnodes = tn;
+		allocator->n_free_tnodes++;
+	}
+	dev->checkpoint_blocks_required = 0;	/* force recalculation */
+}
+
+static void yaffs_init_raw_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (allocator) {
+		allocator->allocated_obj_list = NULL;
+		allocator->free_objs = NULL;
+		allocator->n_free_objects = 0;
+	} else
+		YBUG();
+}
+
+static void yaffs_deinit_raw_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+	struct yaffs_obj_list *tmp;
+
+	if (!allocator) {
+		YBUG();
+		return;
+	}
+
+	while (allocator->allocated_obj_list) {
+		tmp = allocator->allocated_obj_list->next;
+		YFREE(allocator->allocated_obj_list->objects);
+		YFREE(allocator->allocated_obj_list);
+
+		allocator->allocated_obj_list = tmp;
+	}
+
+	allocator->free_objs = NULL;
+	allocator->n_free_objects = 0;
+	allocator->n_obj_created = 0;
+}
+
+static int yaffs_create_free_objs(struct yaffs_dev *dev, int n_obj)
+{
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	int i;
+	struct yaffs_obj *new_objs;
+	struct yaffs_obj_list *list;
+
+	if (!allocator) {
+		YBUG();
+		return YAFFS_FAIL;
+	}
+
+	if (n_obj < 1)
+		return YAFFS_OK;
+
+	/* make these things */
+	new_objs = YMALLOC(n_obj * sizeof(struct yaffs_obj));
+	list = YMALLOC(sizeof(struct yaffs_obj_list));
+
+	if (!new_objs || !list) {
+		if (new_objs) {
+			YFREE(new_objs);
+			new_objs = NULL;
+		}
+		if (list) {
+			YFREE(list);
+			list = NULL;
+		}
+		T(YAFFS_TRACE_ALLOCATE,
+		  (TSTR("yaffs: Could not allocate more objects" TENDSTR)));
+		return YAFFS_FAIL;
+	}
+
+	/* Hook them into the free list */
+	for (i = 0; i < n_obj - 1; i++) {
+		new_objs[i].siblings.next =
+		    (struct list_head *)(&new_objs[i + 1]);
+	}
+
+	new_objs[n_obj - 1].siblings.next = (void *)allocator->free_objs;
+	allocator->free_objs = new_objs;
+	allocator->n_free_objects += n_obj;
+	allocator->n_obj_created += n_obj;
+
+	/* Now add this bunch of Objects to a list for freeing up. */
+
+	list->objects = new_objs;
+	list->next = allocator->allocated_obj_list;
+	allocator->allocated_obj_list = list;
+
+	return YAFFS_OK;
+}
+
+struct yaffs_obj *yaffs_alloc_raw_obj(struct yaffs_dev *dev)
+{
+	struct yaffs_obj *obj = NULL;
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (!allocator) {
+		YBUG();
+		return obj;
+	}
+
+	/* If there are none left make more */
+	if (!allocator->free_objs)
+		yaffs_create_free_objs(dev, YAFFS_ALLOCATION_NOBJECTS);
+
+	if (allocator->free_objs) {
+		obj = allocator->free_objs;
+		allocator->free_objs =
+		    (struct yaffs_obj *)(allocator->free_objs->siblings.next);
+		allocator->n_free_objects--;
+	}
+
+	return obj;
+}
+
+void yaffs_free_raw_obj(struct yaffs_dev *dev, struct yaffs_obj *obj)
+{
+
+	struct yaffs_allocator *allocator = dev->allocator;
+
+	if (!allocator)
+		YBUG();
+	else {
+		/* Link into the free list. */
+		obj->siblings.next = (struct list_head *)(allocator->free_objs);
+		allocator->free_objs = obj;
+		allocator->n_free_objects++;
+	}
+}
+
+void yaffs_deinit_raw_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	if (dev->allocator) {
+		yaffs_deinit_raw_tnodes(dev);
+		yaffs_deinit_raw_objs(dev);
+
+		YFREE(dev->allocator);
+		dev->allocator = NULL;
+	} else
+		YBUG();
+}
+
+void yaffs_init_raw_tnodes_and_objs(struct yaffs_dev *dev)
+{
+	struct yaffs_allocator *allocator;
+
+	if (!dev->allocator) {
+		allocator = YMALLOC(sizeof(struct yaffs_allocator));
+		if (allocator) {
+			dev->allocator = allocator;
+			yaffs_init_raw_tnodes(dev);
+			yaffs_init_raw_objs(dev);
+		}
+	} else
+		YBUG();
+}
+
+#endif
diff --git a/fs/yaffs2/yaffs_allocator.h b/fs/yaffs2/yaffs_allocator.h
new file mode 100644
index 0000000..4d5f2ae
--- /dev/null
+++ b/fs/yaffs2/yaffs_allocator.h
@@ -0,0 +1,30 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_ALLOCATOR_H__
+#define __YAFFS_ALLOCATOR_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_init_raw_tnodes_and_objs(struct yaffs_dev *dev);
+void yaffs_deinit_raw_tnodes_and_objs(struct yaffs_dev *dev);
+
+struct yaffs_tnode *yaffs_alloc_raw_tnode(struct yaffs_dev *dev);
+void yaffs_free_raw_tnode(struct yaffs_dev *dev, struct yaffs_tnode *tn);
+
+struct yaffs_obj *yaffs_alloc_raw_obj(struct yaffs_dev *dev);
+void yaffs_free_raw_obj(struct yaffs_dev *dev, struct yaffs_obj *obj);
+
+#endif
diff --git a/fs/yaffs2/yaffs_attribs.c b/fs/yaffs2/yaffs_attribs.c
new file mode 100644
index 0000000..aaf4685
--- /dev/null
+++ b/fs/yaffs2/yaffs_attribs.c
@@ -0,0 +1,124 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_guts.h"
+#include "yaffs_attribs.h"
+
+void yaffs_load_attribs(struct yaffs_obj *obj, struct yaffs_obj_hdr *oh)
+{
+	obj->yst_uid = oh->yst_uid;
+	obj->yst_gid = oh->yst_gid;
+	obj->yst_atime = oh->yst_atime;
+	obj->yst_mtime = oh->yst_mtime;
+	obj->yst_ctime = oh->yst_ctime;
+	obj->yst_rdev = oh->yst_rdev;
+}
+
+void yaffs_load_attribs_oh(struct yaffs_obj_hdr *oh, struct yaffs_obj *obj)
+{
+	oh->yst_uid = obj->yst_uid;
+	oh->yst_gid = obj->yst_gid;
+	oh->yst_atime = obj->yst_atime;
+	oh->yst_mtime = obj->yst_mtime;
+	oh->yst_ctime = obj->yst_ctime;
+	oh->yst_rdev = obj->yst_rdev;
+
+}
+
+void yaffs_load_current_time(struct yaffs_obj *obj, int do_a, int do_c)
+{
+	obj->yst_mtime = Y_CURRENT_TIME;
+	if (do_a)
+		obj->yst_atime = obj->yst_atime;
+	if (do_c)
+		obj->yst_ctime = obj->yst_atime;
+}
+
+void yaffs_attribs_init(struct yaffs_obj *obj, u32 gid, u32 uid, u32 rdev)
+{
+	yaffs_load_current_time(obj, 1, 1);
+	obj->yst_rdev = rdev;
+	obj->yst_uid = uid;
+	obj->yst_gid = gid;
+}
+
+loff_t yaffs_get_file_size(struct yaffs_obj *obj)
+{
+	YCHAR *alias = NULL;
+	obj = yaffs_get_equivalent_obj(obj);
+
+	switch (obj->variant_type) {
+	case YAFFS_OBJECT_TYPE_FILE:
+		return obj->variant.file_variant.file_size;
+	case YAFFS_OBJECT_TYPE_SYMLINK:
+		alias = obj->variant.symlink_variant.alias;
+		if (!alias)
+			return 0;
+		return yaffs_strnlen(alias, YAFFS_MAX_ALIAS_LENGTH);
+	default:
+		return 0;
+	}
+}
+
+int yaffs_set_attribs(struct yaffs_obj *obj, struct iattr *attr)
+{
+	unsigned int valid = attr->ia_valid;
+
+	if (valid & ATTR_MODE)
+		obj->yst_mode = attr->ia_mode;
+	if (valid & ATTR_UID)
+		obj->yst_uid = attr->ia_uid;
+	if (valid & ATTR_GID)
+		obj->yst_gid = attr->ia_gid;
+
+	if (valid & ATTR_ATIME)
+		obj->yst_atime = Y_TIME_CONVERT(attr->ia_atime);
+	if (valid & ATTR_CTIME)
+		obj->yst_ctime = Y_TIME_CONVERT(attr->ia_ctime);
+	if (valid & ATTR_MTIME)
+		obj->yst_mtime = Y_TIME_CONVERT(attr->ia_mtime);
+
+	if (valid & ATTR_SIZE)
+		yaffs_resize_file(obj, attr->ia_size);
+
+	yaffs_update_oh(obj, NULL, 1, 0, 0, NULL);
+
+	return YAFFS_OK;
+
+}
+
+int yaffs_get_attribs(struct yaffs_obj *obj, struct iattr *attr)
+{
+	unsigned int valid = 0;
+
+	attr->ia_mode = obj->yst_mode;
+	valid |= ATTR_MODE;
+	attr->ia_uid = obj->yst_uid;
+	valid |= ATTR_UID;
+	attr->ia_gid = obj->yst_gid;
+	valid |= ATTR_GID;
+
+	Y_TIME_CONVERT(attr->ia_atime) = obj->yst_atime;
+	valid |= ATTR_ATIME;
+	Y_TIME_CONVERT(attr->ia_ctime) = obj->yst_ctime;
+	valid |= ATTR_CTIME;
+	Y_TIME_CONVERT(attr->ia_mtime) = obj->yst_mtime;
+	valid |= ATTR_MTIME;
+
+	attr->ia_size = yaffs_get_file_size(obj);
+	valid |= ATTR_SIZE;
+
+	attr->ia_valid = valid;
+
+	return YAFFS_OK;
+}
diff --git a/fs/yaffs2/yaffs_attribs.h b/fs/yaffs2/yaffs_attribs.h
new file mode 100644
index 0000000..33d541d
--- /dev/null
+++ b/fs/yaffs2/yaffs_attribs.h
@@ -0,0 +1,28 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_ATTRIBS_H__
+#define __YAFFS_ATTRIBS_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_load_attribs(struct yaffs_obj *obj, struct yaffs_obj_hdr *oh);
+void yaffs_load_attribs_oh(struct yaffs_obj_hdr *oh, struct yaffs_obj *obj);
+void yaffs_attribs_init(struct yaffs_obj *obj, u32 gid, u32 uid, u32 rdev);
+void yaffs_load_current_time(struct yaffs_obj *obj, int do_a, int do_c);
+int yaffs_set_attribs(struct yaffs_obj *obj, struct iattr *attr);
+int yaffs_get_attribs(struct yaffs_obj *obj, struct iattr *attr);
+
+#endif
diff --git a/fs/yaffs2/yaffs_bitmap.c b/fs/yaffs2/yaffs_bitmap.c
new file mode 100644
index 0000000..5d1cfb2
--- /dev/null
+++ b/fs/yaffs2/yaffs_bitmap.c
@@ -0,0 +1,104 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_bitmap.h"
+#include "yaffs_trace.h"
+/*
+ * Chunk bitmap manipulations
+ */
+
+static Y_INLINE u8 *yaffs_block_bits(struct yaffs_dev *dev, int blk)
+{
+	if (blk < dev->internal_start_block || blk > dev->internal_end_block) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR("**>> yaffs: BlockBits block %d is not valid" TENDSTR),
+		   blk));
+		YBUG();
+	}
+	return dev->chunk_bits +
+	    (dev->chunk_bit_stride * (blk - dev->internal_start_block));
+}
+
+void yaffs_verify_chunk_bit_id(struct yaffs_dev *dev, int blk, int chunk)
+{
+	if (blk < dev->internal_start_block || blk > dev->internal_end_block ||
+	    chunk < 0 || chunk >= dev->param.chunks_per_block) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR("**>> yaffs: Chunk Id (%d:%d) invalid" TENDSTR),
+		   blk, chunk));
+		YBUG();
+	}
+}
+
+void yaffs_clear_chunk_bits(struct yaffs_dev *dev, int blk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+
+	memset(blk_bits, 0, dev->chunk_bit_stride);
+}
+
+void yaffs_clear_chunk_bit(struct yaffs_dev *dev, int blk, int chunk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+
+	yaffs_verify_chunk_bit_id(dev, blk, chunk);
+
+	blk_bits[chunk / 8] &= ~(1 << (chunk & 7));
+}
+
+void yaffs_set_chunk_bit(struct yaffs_dev *dev, int blk, int chunk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+
+	yaffs_verify_chunk_bit_id(dev, blk, chunk);
+
+	blk_bits[chunk / 8] |= (1 << (chunk & 7));
+}
+
+int yaffs_check_chunk_bit(struct yaffs_dev *dev, int blk, int chunk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+	yaffs_verify_chunk_bit_id(dev, blk, chunk);
+
+	return (blk_bits[chunk / 8] & (1 << (chunk & 7))) ? 1 : 0;
+}
+
+int yaffs_still_some_chunks(struct yaffs_dev *dev, int blk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+	int i;
+	for (i = 0; i < dev->chunk_bit_stride; i++) {
+		if (*blk_bits)
+			return 1;
+		blk_bits++;
+	}
+	return 0;
+}
+
+int yaffs_count_chunk_bits(struct yaffs_dev *dev, int blk)
+{
+	u8 *blk_bits = yaffs_block_bits(dev, blk);
+	int i;
+	int n = 0;
+	for (i = 0; i < dev->chunk_bit_stride; i++) {
+		u8 x = *blk_bits;
+		while (x) {
+			if (x & 1)
+				n++;
+			x >>= 1;
+		}
+
+		blk_bits++;
+	}
+	return n;
+}
diff --git a/fs/yaffs2/yaffs_bitmap.h b/fs/yaffs2/yaffs_bitmap.h
new file mode 100644
index 0000000..cf9ea58
--- /dev/null
+++ b/fs/yaffs2/yaffs_bitmap.h
@@ -0,0 +1,33 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+/*
+ * Chunk bitmap manipulations
+ */
+
+#ifndef __YAFFS_BITMAP_H__
+#define __YAFFS_BITMAP_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_verify_chunk_bit_id(struct yaffs_dev *dev, int blk, int chunk);
+void yaffs_clear_chunk_bits(struct yaffs_dev *dev, int blk);
+void yaffs_clear_chunk_bit(struct yaffs_dev *dev, int blk, int chunk);
+void yaffs_set_chunk_bit(struct yaffs_dev *dev, int blk, int chunk);
+int yaffs_check_chunk_bit(struct yaffs_dev *dev, int blk, int chunk);
+int yaffs_still_some_chunks(struct yaffs_dev *dev, int blk);
+int yaffs_count_chunk_bits(struct yaffs_dev *dev, int blk);
+
+#endif
-- 
1.7.1


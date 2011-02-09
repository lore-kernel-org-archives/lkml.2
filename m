Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1BID2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 22:28:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45370 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab1BID0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 22:26:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ko/wDnyfxRPQ3/4WyGqwg7RF5frBospuNlBGXpJbtlGygnSgq665uIcG4aCgYOqQf7
         QOhozdMszLDGzZcdhCeTXfE9Q+lP/MmDlzIMO5f9uMxG8Z4BL8Ifm4I1S0tp6Qk0Nad5
         K9ST5Cb+vOlc9KgfKv0JjH7SEec54LGonQ3Kg=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ryan@bluewatersys.com, akpm@linux-foundation.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 02/10] Add yaffs2 file system: attrib and xattrib handling
Date: Wed,  9 Feb 2011 16:26:00 +1300
Message-Id: <1297221968-6747-3-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_attribs.c |  124 ++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_attribs.h |   28 ++++++
 fs/yaffs2/yaffs_nameval.c |  201 +++++++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_nameval.h |   28 ++++++
 4 files changed, 381 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_attribs.c
 create mode 100644 fs/yaffs2/yaffs_attribs.h
 create mode 100644 fs/yaffs2/yaffs_nameval.c
 create mode 100644 fs/yaffs2/yaffs_nameval.h

diff --git a/fs/yaffs2/yaffs_attribs.c b/fs/yaffs2/yaffs_attribs.c
new file mode 100644
index 0000000..fe914e5
--- /dev/null
+++ b/fs/yaffs2/yaffs_attribs.c
@@ -0,0 +1,124 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2011 Aleph One Ltd.
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
+		obj->yst_atime = obj->yst_mtime;
+	if (do_c)
+		obj->yst_ctime = obj->yst_mtime;
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
+		return strnlen(alias, YAFFS_MAX_ALIAS_LENGTH);
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
index 0000000..5b21b08
--- /dev/null
+++ b/fs/yaffs2/yaffs_attribs.h
@@ -0,0 +1,28 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2011 Aleph One Ltd.
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
diff --git a/fs/yaffs2/yaffs_nameval.c b/fs/yaffs2/yaffs_nameval.c
new file mode 100644
index 0000000..e75411b
--- /dev/null
+++ b/fs/yaffs2/yaffs_nameval.c
@@ -0,0 +1,201 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2011 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * This simple implementation of a name-value store assumes a small number of
+* values and fits into a small finite buffer.
+ *
+ * Each attribute is stored as a record:
+ *  sizeof(int) bytes   record size.
+ *  strnlen+1 bytes name null terminated.
+ *  nbytes    value.
+ *  ----------
+ *  total size  stored in record size
+ *
+ * This code has not been tested with unicode yet.
+ */
+
+#include "yaffs_nameval.h"
+
+#include "yportenv.h"
+
+static int nval_find(const char *xb, int xb_size, const YCHAR *name,
+		     int *exist_size)
+{
+	int pos = 0;
+	int size;
+
+	memcpy(&size, xb, sizeof(int));
+	while (size > 0 && (size < xb_size) && (pos + size < xb_size)) {
+		if (!strncmp((YCHAR *) (xb + pos + sizeof(int)), name, size)) {
+			if (exist_size)
+				*exist_size = size;
+			return pos;
+		}
+		pos += size;
+		if (pos < xb_size - sizeof(int))
+			memcpy(&size, xb + pos, sizeof(int));
+		else
+			size = 0;
+	}
+	if (exist_size)
+		*exist_size = 0;
+	return -ENODATA;
+}
+
+static int nval_used(const char *xb, int xb_size)
+{
+	int pos = 0;
+	int size;
+
+	memcpy(&size, xb + pos, sizeof(int));
+	while (size > 0 && (size < xb_size) && (pos + size < xb_size)) {
+		pos += size;
+		if (pos < xb_size - sizeof(int))
+			memcpy(&size, xb + pos, sizeof(int));
+		else
+			size = 0;
+	}
+	return pos;
+}
+
+int nval_del(char *xb, int xb_size, const YCHAR *name)
+{
+	int pos = nval_find(xb, xb_size, name, NULL);
+	int size;
+
+	if (pos < 0 || pos >= xb_size)
+		return -ENODATA;
+
+	/* Find size, shift rest over this record,
+	 * then zero out the rest of buffer */
+	memcpy(&size, xb + pos, sizeof(int));
+	memcpy(xb + pos, xb + pos + size, xb_size - (pos + size));
+	memset(xb + (xb_size - size), 0, size);
+	return 0;
+}
+
+int nval_set(char *xb, int xb_size, const YCHAR *name, const char *buf,
+		int bsize, int flags)
+{
+	int pos;
+	int namelen = strnlen(name, xb_size);
+	int reclen;
+	int size_exist = 0;
+	int space;
+	int start;
+
+	pos = nval_find(xb, xb_size, name, &size_exist);
+
+	if (flags & XATTR_CREATE && pos >= 0)
+		return -EEXIST;
+	if (flags & XATTR_REPLACE && pos < 0)
+		return -ENODATA;
+
+	start = nval_used(xb, xb_size);
+	space = xb_size - start + size_exist;
+
+	reclen = (sizeof(int) + namelen + 1 + bsize);
+
+	if (reclen > space)
+		return -ENOSPC;
+
+	if (pos >= 0) {
+		nval_del(xb, xb_size, name);
+		start = nval_used(xb, xb_size);
+	}
+
+	pos = start;
+
+	memcpy(xb + pos, &reclen, sizeof(int));
+	pos += sizeof(int);
+	strncpy((YCHAR *) (xb + pos), name, reclen);
+	pos += (namelen + 1);
+	memcpy(xb + pos, buf, bsize);
+	return 0;
+}
+
+int nval_get(const char *xb, int xb_size, const YCHAR * name, char *buf,
+	     int bsize)
+{
+	int pos = nval_find(xb, xb_size, name, NULL);
+	int size;
+
+	if (pos >= 0 && pos < xb_size) {
+
+		memcpy(&size, xb + pos, sizeof(int));
+		pos += sizeof(int);	/* advance past record length */
+		size -= sizeof(int);
+
+		/* Advance over name string */
+		while (xb[pos] && size > 0 && pos < xb_size) {
+			pos++;
+			size--;
+		}
+		/*Advance over NUL */
+		pos++;
+		size--;
+
+		if (size <= bsize) {
+			memcpy(buf, xb + pos, size);
+			return size;
+		}
+	}
+	if (pos >= 0)
+		return -ERANGE;
+
+	return -ENODATA;
+}
+
+int nval_list(const char *xb, int xb_size, char *buf, int bsize)
+{
+	int pos = 0;
+	int size;
+	int name_len;
+	int ncopied = 0;
+	int filled = 0;
+
+	memcpy(&size, xb + pos, sizeof(int));
+	while (size > sizeof(int) &&
+		size <= xb_size &&
+		(pos + size) < xb_size &&
+		!filled) {
+		pos += sizeof(int);
+		size -= sizeof(int);
+		name_len = strnlen((YCHAR *) (xb + pos), size);
+		if (ncopied + name_len + 1 < bsize) {
+			memcpy(buf, xb + pos, name_len * sizeof(YCHAR));
+			buf += name_len;
+			*buf = '\0';
+			buf++;
+			if (sizeof(YCHAR) > 1) {
+				*buf = '\0';
+				buf++;
+			}
+			ncopied += (name_len + 1);
+		} else {
+			filled = 1;
+		}
+		pos += size;
+		if (pos < xb_size - sizeof(int))
+			memcpy(&size, xb + pos, sizeof(int));
+		else
+			size = 0;
+	}
+	return ncopied;
+}
+
+int nval_hasvalues(const char *xb, int xb_size)
+{
+	return nval_used(xb, xb_size) > 0;
+}
diff --git a/fs/yaffs2/yaffs_nameval.h b/fs/yaffs2/yaffs_nameval.h
new file mode 100644
index 0000000..951e64f
--- /dev/null
+++ b/fs/yaffs2/yaffs_nameval.h
@@ -0,0 +1,28 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2011 Aleph One Ltd.
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
+#ifndef __NAMEVAL_H__
+#define __NAMEVAL_H__
+
+#include "yportenv.h"
+
+int nval_del(char *xb, int xb_size, const YCHAR * name);
+int nval_set(char *xb, int xb_size, const YCHAR * name, const char *buf,
+	     int bsize, int flags);
+int nval_get(const char *xb, int xb_size, const YCHAR * name, char *buf,
+	     int bsize);
+int nval_list(const char *xb, int xb_size, char *buf, int bsize);
+int nval_hasvalues(const char *xb, int xb_size);
+#endif
-- 
1.7.1


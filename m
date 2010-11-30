Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab0K3V7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:59:00 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48572 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab0K3V6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:58:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RlFk7BrdxJQFXlcSYcmCnrlEx7zMHAeDP0fqpfS+pJHdZKv5DMMk0UEka8VnCGUrDG
         3YwujbQ55gY/RHU4yOTRnNWgcOvMMSLuItjMEFm8MY4o8iftYXdM8MiGkomAGXJ5Slcs
         DCT0qUCI/eyCU/428rlp3qTcLgBXzvvQ+3BL0=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 6/8] Add yaffs2 file system: xattrib code
Date: Wed,  1 Dec 2010 10:57:32 +1300
Message-Id: <1291154254-22533-7-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_nameval.c |  201 +++++++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_nameval.h |   28 ++++++
 2 files changed, 229 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_nameval.c
 create mode 100644 fs/yaffs2/yaffs_nameval.h

diff --git a/fs/yaffs2/yaffs_nameval.c b/fs/yaffs2/yaffs_nameval.c
new file mode 100644
index 0000000..d8c548a
--- /dev/null
+++ b/fs/yaffs2/yaffs_nameval.c
@@ -0,0 +1,201 @@
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
+/*
+ * This simple implementation of a name-value store assumes a small number of values and fits
+ * into a small finite buffer.
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
+static int nval_find(const char *xb, int xb_size, const YCHAR * name,
+		     int *exist_size)
+{
+	int pos = 0;
+	int size;
+
+	memcpy(&size, xb, sizeof(int));
+	while (size > 0 && (size < xb_size) && (pos + size < xb_size)) {
+		if (yaffs_strncmp
+		    ((YCHAR *) (xb + pos + sizeof(int)), name, size) == 0) {
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
+	return -1;
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
+int nval_del(char *xb, int xb_size, const YCHAR * name)
+{
+	int pos = nval_find(xb, xb_size, name, NULL);
+	int size;
+
+	if (pos >= 0 && pos < xb_size) {
+		/* Find size, shift rest over this record, then zero out the rest of buffer */
+		memcpy(&size, xb + pos, sizeof(int));
+		memcpy(xb + pos, xb + pos + size, xb_size - (pos + size));
+		memset(xb + (xb_size - size), 0, size);
+		return 0;
+	} else {
+		return -ENODATA;
+        }
+}
+
+int nval_set(char *xb, int xb_size, const YCHAR * name, const char *buf,
+	     int bsize, int flags)
+{
+	int pos;
+	int namelen = yaffs_strnlen(name, xb_size);
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
+	yaffs_strncpy((YCHAR *) (xb + pos), name, reclen);
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
+
+	}
+	if (pos >= 0)
+		return -ERANGE;
+	else
+		return -ENODATA;
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
+	while (size > sizeof(int) && size <= xb_size && (pos + size) < xb_size
+	       && !filled) {
+		pos += sizeof(int);
+		size -= sizeof(int);
+		name_len = yaffs_strnlen((YCHAR *) (xb + pos), size);
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
+                }
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
index 0000000..2bb02b6
--- /dev/null
+++ b/fs/yaffs2/yaffs_nameval.h
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab2BUUB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:01:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab2BUTxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/73] union-mount: Add union_alloc() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:00:26 +0000
Message-ID: <20120221180026.25235.25010.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

union_alloc() allocates a union stack with enough entries for the
maximum possible number of directories that might be unioned at this
point.

The union_stack may be larger than strictly necessary if this
directory does not exist on all layers, but allocating exactly the
right number would require keeping the number of layers in the
union_stack structure.  We optimize for the case of unioning two file
systems and keep the count of layers in the superblock.

Original-author: Jan Blunck <j.blunck@tu-harburg.de>
Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/Makefile |    1 +
 fs/union.c  |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)
 create mode 100644 fs/union.c

diff --git a/fs/Makefile b/fs/Makefile
index 93804d4..768fbf3 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
 
 obj-y				+= quota/
+obj-$(CONFIG_UNION_MOUNT)	+= union.o
 
 obj-$(CONFIG_PROC_FS)		+= proc/
 obj-$(CONFIG_SYSFS)		+= sysfs/
diff --git a/fs/union.c b/fs/union.c
new file mode 100644
index 0000000..c8d7766
--- /dev/null
+++ b/fs/union.c
@@ -0,0 +1,38 @@
+/*
+ * VFS-based union mounts for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007-2009 Novell Inc.
+ * Copyright (C) 2009-2010 Red Hat, Inc.
+ *
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *              Valerie Aurora <vaurora@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/fs_struct.h>
+#include <linux/slab.h>
+
+#include "union.h"
+
+/**
+ * union_alloc - allocate a union stack
+ * @path: path of topmost directory
+ *
+ * Allocate a union_stack large enough to contain the maximum number
+ * of layers in this union mount.
+ */
+static struct union_stack *union_alloc(struct path *topmost)
+{
+	unsigned int layers = topmost->dentry->d_sb->s_union_count;
+	BUG_ON(!S_ISDIR(topmost->dentry->d_inode->i_mode));
+
+	return kcalloc(sizeof(struct path), layers, GFP_KERNEL);
+}


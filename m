Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0IPWO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab0IPWOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:23 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 10/34] union-mount: Add union_alloc()
Date: Thu, 16 Sep 2010 15:12:01 -0700
Message-Id: <1284675145-4391-11-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

union_alloc() allocates a union stack with enough entries for the
maximum possible number of directories that might be unioned at this
point.

The union_stack may be larger than strictly necessary if this
directory does not exist on all layers, but allocating exactly the
right number would require keeping the number of layers in the
union_stack structure.  We optimize for the case of unioning two file
systems and keep the count of layers in the superblock.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/Makefile |    1 +
 fs/union.c  |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 fs/union.c

diff --git a/fs/Makefile b/fs/Makefile
index e6ec1d3..936acf0 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 
 obj-y				+= quota/
+obj-$(CONFIG_UNION_MOUNT)	+= union.o
 
 obj-$(CONFIG_PROC_FS)		+= proc/
 obj-y				+= partitions/
diff --git a/fs/union.c b/fs/union.c
new file mode 100644
index 0000000..52a5c28
--- /dev/null
+++ b/fs/union.c
@@ -0,0 +1,42 @@
+ /*
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
+#include <linux/bootmem.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/fs_struct.h>
+#include <linux/slab.h>
+
+#include "union.h"
+
+/**
+ * union_alloc - allocate a union stack
+ *
+ * @path: path of topmost directory
+ *
+ * Allocate a union_stack large enough to contain the maximum number
+ * of layers in this union mount.
+ */
+
+static struct union_stack *union_alloc(struct path *topmost)
+{
+	unsigned int layers = topmost->dentry->d_sb->s_union_count;
+	BUG_ON(!S_ISDIR(topmost->dentry->d_inode->i_mode));
+
+	return kzalloc(sizeof(struct path) * layers, GFP_KERNEL);
+}
-- 
1.6.3.3


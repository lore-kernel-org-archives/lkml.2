Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253Ab2AEXos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:44:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55912 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab2AEXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:43:36 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/11] vfs: add fcheck tracepoint
Date: Thu,  5 Jan 2012 15:42:52 -0800
Message-Id: <1325806974-23486-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1325806974-23486-1-git-send-email-tj@kernel.org>
References: <1325806974-23486-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All file accesses from userland go through fcheck to map fd to struct
file, making it a very good location for peeking at what files
userland is accessing.  Add a tracepoint there.

This is part of tracepoint additions to improve visiblity into
dirtying / writeback operations for io tracer and userland.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/super.c                 |    2 ++
 include/linux/fdtable.h    |    3 +++
 include/trace/events/vfs.h |   40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/vfs.h

diff --git a/fs/super.c b/fs/super.c
index afd0f1a..7b70a2e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -34,6 +34,8 @@
 #include <linux/cleancache.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/vfs.h>
 
 LIST_HEAD(super_blocks);
 DEFINE_SPINLOCK(sb_lock);
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 82163c4..72df04b 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <trace/events/vfs.h>
 
 #include <linux/atomic.h>
 
@@ -87,6 +88,8 @@ static inline struct file * fcheck_files(struct files_struct *files, unsigned in
 
 	if (fd < fdt->max_fds)
 		file = rcu_dereference_check_fdtable(files, fdt->fd[fd]);
+
+	trace_vfs_fcheck(files, fd, file);
 	return file;
 }
 
diff --git a/include/trace/events/vfs.h b/include/trace/events/vfs.h
new file mode 100644
index 0000000..9a9bae4
--- /dev/null
+++ b/include/trace/events/vfs.h
@@ -0,0 +1,40 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vfs
+
+#if !defined(_TRACE_VFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VFS_H
+
+#include <linux/tracepoint.h>
+#include <linux/fs.h>
+
+TRACE_EVENT(vfs_fcheck,
+
+	TP_PROTO(struct files_struct *files, unsigned int fd,
+		 struct file *file),
+
+	TP_ARGS(files, fd, file),
+
+	TP_STRUCT__entry(
+		__field(unsigned int,	fd)
+		__field(umode_t,	mode)
+		__field(dev_t,		dev)
+		__field(ino_t,		ino)
+	),
+
+	TP_fast_assign(
+		__entry->fd = fd;
+		__entry->mode = file ? file->f_path.dentry->d_inode->i_mode : 0;
+		__entry->dev = file ? file->f_path.dentry->d_inode->i_sb->s_dev : 0;
+		__entry->ino = file ? file->f_path.dentry->d_inode->i_ino : 0;
+	),
+
+	TP_printk("fd %u mode 0x%x dev %d,%d ino %lu",
+		  __entry->fd, __entry->mode,
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long)__entry->ino)
+);
+
+#endif /* _TRACE_VFS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.3.1


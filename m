Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2KHJDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:03:46 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40265 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab2KHJDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:03:40 -0500
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        cmm@us.ibm.com, swhiteho@redhat.com, dave@jikos.cz,
        darrick.wong@oracle.com, andi@firstfloor.org, northrup.james@gmail.com,
        gregkh@linuxfoundation.org, linuxram@linux.vnet.ibm.com,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v1 hot_track 16/18] xfs: add hot tracking support
Date: Thu,  8 Nov 2012 17:01:23 +0800
Message-Id: <1352365285-32419-17-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
References: <1352365285-32419-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110809-9360-0000-0000-00000C8C8AD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

  Connect up the VFS hot tracking support
so XFS filesystems can make use of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index deee09e..96d93c2 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -217,6 +217,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
 						   must be synchronous except
 						   for space allocations */
+#define XFS_MOUNT_HOTTRACK      (1ULL << 1)     /* hot inode tracking */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 26a09bd..48b3bed 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -61,6 +61,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/parser.h>
+#include <linux/hot_tracking.h>
 
 static const struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
@@ -114,6 +115,7 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_NODELAYLOG  "nodelaylog"	/* Delayed logging disabled */
 #define MNTOPT_DISCARD	   "discard"	/* Discard unused blocks */
 #define MNTOPT_NODISCARD   "nodiscard"	/* Do not discard unused blocks */
+#define MNTOPT_HOTTRACK    "hot_track"  /* hot inode tracking */
 
 /*
  * Table driven mount option parser.
@@ -371,6 +373,8 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_DISCARD;
 		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
 			mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		} else if (!strcmp(this_char, MNTOPT_HOTTRACK)) {
+			mp->m_flags |= XFS_MOUNT_HOTTRACK;
 		} else if (!strcmp(this_char, "ihashsize")) {
 			xfs_warn(mp,
 	"ihashsize no longer used, option is deprecated.");
@@ -1005,6 +1009,9 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	if (mp->m_flags & XFS_MOUNT_HOTTRACK)
+		hot_track_exit(sb);
+
 	xfs_filestream_unmount(mp);
 	cancel_delayed_work_sync(&mp->m_sync_work);
 	xfs_unmountfs(mp);
@@ -1407,7 +1414,16 @@ xfs_fs_fill_super(
 		goto out_unmount;
 	}
 
+	if (mp->m_flags & XFS_MOUNT_HOTTRACK) {
+		error = hot_track_init(sb);
+		if (error)
+			goto out_free_root;
+	}
+
 	return 0;
+ out_free_root:
+	dput(sb->s_root);
+	sb->s_root = NULL;
  out_syncd_stop:
 	xfs_syncd_stop(mp);
  out_filestream_unmount:
-- 
1.7.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab1E1P1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:27:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:36903 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab1E1P0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:26:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,285,1304319600"; 
   d="scan'208";a="6224713"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, dchinner@redhat.com, aelder@sgi.com
Subject: [PATCH 4/4] XFS: Set NOSEC flag early when inode has no xattrs. v2
Date: Sat, 28 May 2011 08:25:54 -0700
Message-Id: <1306596354-18453-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Set the S_NOSEC flag early if the inode has no xattrs for XFS.
This avoids a single xattr lookup for the first write on every
file, if the file has no xattrs.

v2: Use helper
Cc: dchinner@redhat.com
Cc: aelder@sgi.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    3 +++
 fs/xfs/xfs_attr.c           |    2 +-
 fs/xfs/xfs_attr.h           |    1 +
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index dd21784..507505b 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -763,6 +763,9 @@ xfs_setup_inode(
 		break;
 	}
 
+	if (!xfs_inode_hasattr(ip))
+		inode_has_no_xattr(inode);
+
 	xfs_iflags_clear(ip, XFS_INEW);
 	barrier();
 
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index c863753..43140db 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -99,7 +99,7 @@ xfs_attr_name_to_xname(
 	return 0;
 }
 
-STATIC int
+int
 xfs_inode_hasattr(
 	struct xfs_inode	*ip)
 {
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index e920d68..20f4038 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -142,5 +142,6 @@ typedef struct xfs_attr_list_context {
 int xfs_attr_inactive(struct xfs_inode *dp);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
+int xfs_inode_hasattr(struct xfs_inode *ip);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
1.7.4.4


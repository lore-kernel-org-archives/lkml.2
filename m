Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab2AEIKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:10:00 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59297 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2AEIJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:09:58 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] fs/9p: v9fs_stat2inode should update suid/sgid bits.
Date: Thu,  5 Jan 2012 13:39:49 +0530
Message-Id: <1325750990-8149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8.1.362.g5d6df
x-cbid: 12010422-6102-0000-0000-00000094B0B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Create a new helper that update the permission bits and use
that, instead of opencoding the logic.

Reported and bisected by:  M. Mohan Kumar <mohan@in.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |   40 ++++++++++++++++++++++++++++------------
 1 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 879ed88..c330776 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -93,6 +93,32 @@ static int unixmode2p9mode(struct v9fs_session_info *v9ses, int mode)
 }
 
 /**
+ * p9mode2perm- convert plan9 mode bits to unix permission bits
+ * @v9ses: v9fs session information
+ * @stat: p9_wstat from which mode need to be derived
+ *
+ */
+static int p9mode2perm(struct v9fs_session_info *v9ses,
+		       struct p9_wstat *stat)
+{
+	int res;
+	int mode = stat->mode;
+
+	res = mode & S_IALLUGO;
+	if (v9fs_proto_dotu(v9ses)) {
+		if ((mode & P9_DMSETUID) == P9_DMSETUID)
+			res |= S_ISUID;
+
+		if ((mode & P9_DMSETGID) == P9_DMSETGID)
+			res |= S_ISGID;
+
+		if ((mode & P9_DMSETVTX) == P9_DMSETVTX)
+			res |= S_ISVTX;
+	}
+	return res;
+}
+
+/**
  * p9mode2unixmode- convert plan9 mode bits to unix mode bits
  * @v9ses: v9fs session information
  * @stat: p9_wstat from which mode need to be derived
@@ -105,8 +131,8 @@ static int p9mode2unixmode(struct v9fs_session_info *v9ses,
 	int res;
 	int mode = stat->mode;
 
-	res = mode & S_IALLUGO;
 	*rdev = 0;
+	res = p9mode2perm(v9ses, stat);
 
 	if ((mode & P9_DMDIR) == P9_DMDIR)
 		res |= S_IFDIR;
@@ -141,16 +167,6 @@ static int p9mode2unixmode(struct v9fs_session_info *v9ses,
 	} else
 		res |= S_IFREG;
 
-	if (v9fs_proto_dotu(v9ses)) {
-		if ((mode & P9_DMSETUID) == P9_DMSETUID)
-			res |= S_ISUID;
-
-		if ((mode & P9_DMSETGID) == P9_DMSETGID)
-			res |= S_ISGID;
-
-		if ((mode & P9_DMSETVTX) == P9_DMSETVTX)
-			res |= S_ISVTX;
-	}
 	return res;
 }
 
@@ -1167,7 +1183,7 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 				set_nlink(inode, i_nlink);
 		}
 	}
-	mode = stat->mode & S_IALLUGO;
+	mode = p9mode2perm(v9ses, stat);
 	mode |= inode->i_mode & ~S_IALLUGO;
 	inode->i_mode = mode;
 	i_size_write(inode, stat->length);
-- 
1.7.8.1.362.g5d6df


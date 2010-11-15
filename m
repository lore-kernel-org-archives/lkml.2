Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab0KORQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:16:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757977Ab0KOROx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:14:53 -0500
From: Josef Bacik <josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com
Subject: [PATCH 3/6] Ocfs2: handle hole punching via fallocate properly
Date: Mon, 15 Nov 2010 12:05:20 -0500
Message-Id: <1289840723-3056-4-git-send-email-josef@redhat.com>
In-Reply-To: <1289840723-3056-1-git-send-email-josef@redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just makes ocfs2 use its UNRESERVP ioctl when we get the hole punch
flag in fallocate.  I didn't test it, but it seems simple enough.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ocfs2/file.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 77b4c04..181ae52 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1992,6 +1992,7 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_space_resv sr;
 	int change_size = 1;
+	int cmd = OCFS2_IOC_RESVSP64;
 
 	if (!ocfs2_writes_unwritten_extents(osb))
 		return -EOPNOTSUPP;
@@ -2002,12 +2003,17 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		change_size = 0;
 
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		cmd = OCFS2_IOC_UNRESVSP64;
+		change_size = 0;
+	}
+
 	sr.l_whence = 0;
 	sr.l_start = (s64)offset;
 	sr.l_len = (s64)len;
 
-	return __ocfs2_change_file_space(NULL, inode, offset,
-					 OCFS2_IOC_RESVSP64, &sr, change_size);
+	return __ocfs2_change_file_space(NULL, inode, offset, cmd, &sr,
+					 change_size);
 }
 
 int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
-- 
1.6.6.1


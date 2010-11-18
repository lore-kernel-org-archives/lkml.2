Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0KRB4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:56:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab0KRB4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:56:21 -0500
From: Josef Bacik <josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, joel.becker@oracle.com, jack@suse.cz
Subject: [PATCH 3/6] Ocfs2: handle hole punching via fallocate properly
Date: Wed, 17 Nov 2010 20:46:17 -0500
Message-Id: <1290044780-2902-4-git-send-email-josef@redhat.com>
In-Reply-To: <1290044780-2902-1-git-send-email-josef@redhat.com>
References: <1290044780-2902-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just makes ocfs2 use its UNRESERVP ioctl when we get the hole punch
flag in fallocate.  I didn't test it, but it seems simple enough.  Thanks,

Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ocfs2/file.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 77b4c04..ad23a18 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1992,6 +1992,7 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_space_resv sr;
 	int change_size = 1;
+	int cmd = OCFS2_IOC_RESVSP64;
 
 	if (!ocfs2_writes_unwritten_extents(osb))
 		return -EOPNOTSUPP;
@@ -2002,12 +2003,15 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		change_size = 0;
 
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		cmd = OCFS2_IOC_UNRESVSP64;
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1GVJjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:39:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab1GVJjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:39:45 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 3/4] GFS2: Add S_NOSEC support
Date: Fri, 22 Jul 2011 10:16:53 +0100
Message-Id: <1311326214-3325-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1311326214-3325-1-git-send-email-swhiteho@redhat.com>
References: <1311326214-3325-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds S_NOSEC support to GFS2. We set/reset the flag either when
a user calls setattr or when we have just regained the glock
from another node. The flag is only set if there are no xattrs
on the inode and there is no suid bit set.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index a9f5cbe..bc2590e 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -174,7 +174,9 @@ void gfs2_set_inode_flags(struct inode *inode)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	unsigned int flags = inode->i_flags;
 
-	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
+	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_NOSEC);
+	if ((ip->i_eattr == 0) && !is_sxid(inode->i_mode))
+		inode->i_flags |= S_NOSEC;
 	if (ip->i_diskflags & GFS2_DIF_IMMUTABLE)
 		flags |= S_IMMUTABLE;
 	if (ip->i_diskflags & GFS2_DIF_APPENDONLY)
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index a4222c3..da21eca 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -318,6 +318,8 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_generation = be64_to_cpu(str->di_generation);
 
 	ip->i_diskflags = be32_to_cpu(str->di_flags);
+	ip->i_eattr = be64_to_cpu(str->di_eattr);
+	/* i_diskflags and i_eattr must be set before gfs2_set_inode_flags() */
 	gfs2_set_inode_flags(&ip->i_inode);
 	height = be16_to_cpu(str->di_height);
 	if (unlikely(height > GFS2_MAX_META_HEIGHT))
@@ -330,7 +332,6 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-	ip->i_eattr = be64_to_cpu(str->di_eattr);
 	if (S_ISREG(ip->i_inode.i_mode))
 		gfs2_set_aops(&ip->i_inode);
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 2a77071..516516e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1094,6 +1094,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	if (sdp->sd_args.ar_nobarrier)
 		set_bit(SDF_NOBARRIERS, &sdp->sd_flags);
 
+	sb->s_flags |= MS_NOSEC;
 	sb->s_magic = GFS2_MAGIC;
 	sb->s_op = &gfs2_super_ops;
 	sb->s_d_op = &gfs2_dops;
-- 
1.7.4


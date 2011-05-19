Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab1ESJKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab1ESJKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:35 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 23/32] GFS2: Remove gfs2_dinode_print() function
Date: Thu, 19 May 2011 09:47:18 +0100
Message-Id: <1305794847-3291-24-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was intended for debugging purposes, but it is not very
useful. If we want to know what is on disk then all we need is a
block number and gfs2_edit can give us much better information about
what is there. Otherwise, if we are interested in what is stored in
the in-core inode, it doesn't help us out there either.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index a8c14c9..7c2121f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -329,8 +329,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 
 	return 0;
 corrupt:
-	if (gfs2_consist_inode(ip))
-		gfs2_dinode_print(ip);
+	gfs2_consist_inode(ip);
 	return -EIO;
 }
 
@@ -901,24 +900,3 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_mtime_nsec = cpu_to_be32(ip->i_inode.i_mtime.tv_nsec);
 	str->di_ctime_nsec = cpu_to_be32(ip->i_inode.i_ctime.tv_nsec);
 }
-
-void gfs2_dinode_print(const struct gfs2_inode *ip)
-{
-	printk(KERN_INFO "  no_formal_ino = %llu\n",
-	       (unsigned long long)ip->i_no_formal_ino);
-	printk(KERN_INFO "  no_addr = %llu\n",
-	       (unsigned long long)ip->i_no_addr);
-	printk(KERN_INFO "  i_size = %llu\n",
-	       (unsigned long long)i_size_read(&ip->i_inode));
-	printk(KERN_INFO "  blocks = %llu\n",
-	       (unsigned long long)gfs2_get_inode_blocks(&ip->i_inode));
-	printk(KERN_INFO "  i_goal = %llu\n",
-	       (unsigned long long)ip->i_goal);
-	printk(KERN_INFO "  i_diskflags = 0x%.8X\n", ip->i_diskflags);
-	printk(KERN_INFO "  i_height = %u\n", ip->i_height);
-	printk(KERN_INFO "  i_depth = %u\n", ip->i_depth);
-	printk(KERN_INFO "  i_entries = %u\n", ip->i_entries);
-	printk(KERN_INFO "  i_eattr = %llu\n",
-	       (unsigned long long)ip->i_eattr);
-}
-
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index f9b8289..7ed60aa 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -115,7 +115,6 @@ extern int gfs2_permission(struct inode *inode, int mask, unsigned int flags);
 extern int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr);
 extern struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
 extern void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
-extern void gfs2_dinode_print(const struct gfs2_inode *ip);
 
 extern const struct inode_operations gfs2_file_iops;
 extern const struct inode_operations gfs2_dir_iops;
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 6b8c2bd..2607c2c 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -754,8 +754,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 
 		if (S_ISDIR(nip->i_inode.i_mode)) {
 			if (nip->i_entries < 2) {
-				if (gfs2_consist_inode(nip))
-					gfs2_dinode_print(nip);
+				gfs2_consist_inode(nip);
 				error = -EIO;
 				goto out_gunlock;
 			}
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 58fe3a4..3061ac6 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1341,8 +1341,7 @@ static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	int error;
 
 	if (gfs2_get_inode_blocks(&ip->i_inode) != 1) {
-		if (gfs2_consist_inode(ip))
-			gfs2_dinode_print(ip);
+		gfs2_consist_inode(ip);
 		return -EIO;
 	}
 
-- 
1.7.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2GWI1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:27:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab2GWI00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:26 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <steve@chygwyn.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/16] GFS2: Add "top dir" flag support
Date: Mon, 23 Jul 2012 09:00:53 +0100
Message-Id: <1343030466-3053-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <steve@chygwyn.com>

This patch adds support for the "top dir" flag. Currently this is unused
but a subsequent patch is planned which will add support for the
Orlov allocation policy when allocating subdirectories in a parent
with this flag set.

In order to ensure backward compatible behaviour, mkfs.gfs2 does
not currently tag the root directory with this flag, it must always be
set manually.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 26e2905..6fbf3cb 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -142,6 +142,7 @@ static const u32 fsflags_to_gfs2[32] = {
 	[7] = GFS2_DIF_NOATIME,
 	[12] = GFS2_DIF_EXHASH,
 	[14] = GFS2_DIF_INHERIT_JDATA,
+	[17] = GFS2_DIF_TOPDIR,
 };
 
 static const u32 gfs2_to_fsflags[32] = {
@@ -150,6 +151,7 @@ static const u32 gfs2_to_fsflags[32] = {
 	[gfs2fl_AppendOnly] = FS_APPEND_FL,
 	[gfs2fl_NoAtime] = FS_NOATIME_FL,
 	[gfs2fl_ExHash] = FS_INDEX_FL,
+	[gfs2fl_TopLevel] = FS_TOPDIR_FL,
 	[gfs2fl_InheritJdata] = FS_JOURNAL_DATA_FL,
 };
 
@@ -203,6 +205,7 @@ void gfs2_set_inode_flags(struct inode *inode)
 			     GFS2_DIF_NOATIME|			\
 			     GFS2_DIF_SYNC|			\
 			     GFS2_DIF_SYSTEM|			\
+			     GFS2_DIF_TOPDIR|			\
 			     GFS2_DIF_INHERIT_JDATA)
 
 /**
@@ -298,6 +301,7 @@ static int gfs2_set_flags(struct file *filp, u32 __user *ptr)
 
 	gfsflags = fsflags_cvt(fsflags_to_gfs2, fsflags);
 	if (!S_ISDIR(inode->i_mode)) {
+		gfsflags &= ~GFS2_DIF_TOPDIR;
 		if (gfsflags & GFS2_DIF_INHERIT_JDATA)
 			gfsflags ^= (GFS2_DIF_JDATA | GFS2_DIF_INHERIT_JDATA);
 		return do_gfs2_set_flags(filp, gfsflags, ~0);
diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index fa98bdb..e8ccf6f 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -214,6 +214,7 @@ enum {
 	gfs2fl_NoAtime		= 7,
 	gfs2fl_Sync		= 8,
 	gfs2fl_System		= 9,
+	gfs2fl_TopLevel		= 10,
 	gfs2fl_TruncInProg	= 29,
 	gfs2fl_InheritDirectio	= 30,
 	gfs2fl_InheritJdata	= 31,
@@ -230,8 +231,9 @@ enum {
 #define GFS2_DIF_NOATIME		0x00000080
 #define GFS2_DIF_SYNC			0x00000100
 #define GFS2_DIF_SYSTEM			0x00000200 /* New in gfs2 */
+#define GFS2_DIF_TOPDIR			0x00000400 /* New in gfs2 */
 #define GFS2_DIF_TRUNC_IN_PROG		0x20000000 /* New in gfs2 */
-#define GFS2_DIF_INHERIT_DIRECTIO	0x40000000
+#define GFS2_DIF_INHERIT_DIRECTIO	0x40000000 /* only in gfs1 */
 #define GFS2_DIF_INHERIT_JDATA		0x80000000
 
 struct gfs2_dinode {
-- 
1.7.4


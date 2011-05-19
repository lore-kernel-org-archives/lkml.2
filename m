Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab1ESJL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:11:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188Ab1ESJKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:44 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 29/32] GFS2: Use UUID field in generic superblock
Date: Thu, 19 May 2011 09:47:24 +0100
Message-Id: <1305794847-3291-30-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VFS superblock structure now has a UUID field, so we can use that
in preference to the UUID field in the GFS2 superblock now.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 69a6382..0a064e9 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -488,7 +488,6 @@ struct gfs2_sb_host {
 
 	char sb_lockproto[GFS2_LOCKNAME_LEN];
 	char sb_locktable[GFS2_LOCKNAME_LEN];
-	u8 sb_uuid[16];
 };
 
 /*
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index d3c69eb..8ac9ae1 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -126,8 +126,10 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
  * changed.
  */
 
-static int gfs2_check_sb(struct gfs2_sbd *sdp, struct gfs2_sb_host *sb, int silent)
+static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
 {
+	struct gfs2_sb_host *sb = &sdp->sd_sb;
+
 	if (sb->sb_magic != GFS2_MAGIC ||
 	    sb->sb_type != GFS2_METATYPE_SB) {
 		if (!silent)
@@ -157,8 +159,10 @@ static void end_bio_io_page(struct bio *bio, int error)
 	unlock_page(page);
 }
 
-static void gfs2_sb_in(struct gfs2_sb_host *sb, const void *buf)
+static void gfs2_sb_in(struct gfs2_sbd *sdp, const void *buf)
 {
+	struct gfs2_sb_host *sb = &sdp->sd_sb;
+	struct super_block *s = sdp->sd_vfs;
 	const struct gfs2_sb *str = buf;
 
 	sb->sb_magic = be32_to_cpu(str->sb_header.mh_magic);
@@ -175,7 +179,7 @@ static void gfs2_sb_in(struct gfs2_sb_host *sb, const void *buf)
 
 	memcpy(sb->sb_lockproto, str->sb_lockproto, GFS2_LOCKNAME_LEN);
 	memcpy(sb->sb_locktable, str->sb_locktable, GFS2_LOCKNAME_LEN);
-	memcpy(sb->sb_uuid, str->sb_uuid, 16);
+	memcpy(s->s_uuid, str->sb_uuid, 16);
 }
 
 /**
@@ -197,7 +201,7 @@ static void gfs2_sb_in(struct gfs2_sb_host *sb, const void *buf)
  * Returns: 0 on success or error
  */
 
-static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector)
+static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 {
 	struct super_block *sb = sdp->sd_vfs;
 	struct gfs2_sb *p;
@@ -227,10 +231,10 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector)
 		return -EIO;
 	}
 	p = kmap(page);
-	gfs2_sb_in(&sdp->sd_sb, p);
+	gfs2_sb_in(sdp, p);
 	kunmap(page);
 	__free_page(page);
-	return 0;
+	return gfs2_check_sb(sdp, silent);
 }
 
 /**
@@ -247,17 +251,13 @@ static int gfs2_read_sb(struct gfs2_sbd *sdp, int silent)
 	unsigned int x;
 	int error;
 
-	error = gfs2_read_super(sdp, GFS2_SB_ADDR >> sdp->sd_fsb2bb_shift);
+	error = gfs2_read_super(sdp, GFS2_SB_ADDR >> sdp->sd_fsb2bb_shift, silent);
 	if (error) {
 		if (!silent)
 			fs_err(sdp, "can't read superblock\n");
 		return error;
 	}
 
-	error = gfs2_check_sb(sdp, &sdp->sd_sb, silent);
-	if (error)
-		return error;
-
 	sdp->sd_fsb2bb_shift = sdp->sd_sb.sb_bsize_shift -
 			       GFS2_BASIC_BLOCK_SHIFT;
 	sdp->sd_fsb2bb = 1 << sdp->sd_fsb2bb_shift;
@@ -340,14 +340,10 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
 	/*  Try to autodetect  */
 
 	if (!proto[0] || !table[0]) {
-		error = gfs2_read_super(sdp, GFS2_SB_ADDR >> sdp->sd_fsb2bb_shift);
+		error = gfs2_read_super(sdp, GFS2_SB_ADDR >> sdp->sd_fsb2bb_shift, silent);
 		if (error)
 			return error;
 
-		error = gfs2_check_sb(sdp, &sdp->sd_sb, silent);
-		if (error)
-			goto out;
-
 		if (!proto[0])
 			proto = sdp->sd_sb.sb_lockproto;
 		if (!table[0])
@@ -364,7 +360,6 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
 	while ((table = strchr(table, '/')))
 		*table = '_';
 
-out:
 	return error;
 }
 
@@ -1119,8 +1114,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	if (sdp->sd_args.ar_statfs_quantum) {
 		sdp->sd_tune.gt_statfs_slow = 0;
 		sdp->sd_tune.gt_statfs_quantum = sdp->sd_args.ar_statfs_quantum;
-	}
-	else {
+	} else {
 		sdp->sd_tune.gt_statfs_slow = 1;
 		sdp->sd_tune.gt_statfs_quantum = 30;
 	}
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 748ccb5..e20eab3 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -81,7 +81,8 @@ static int gfs2_uuid_valid(const u8 *uuid)
 
 static ssize_t uuid_show(struct gfs2_sbd *sdp, char *buf)
 {
-	const u8 *uuid = sdp->sd_sb.sb_uuid;
+	struct super_block *s = sdp->sd_vfs;
+	const u8 *uuid = s->s_uuid;
 	buf[0] = '\0';
 	if (!gfs2_uuid_valid(uuid))
 		return 0;
@@ -616,7 +617,8 @@ static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
 		       struct kobj_uevent_env *env)
 {
 	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
-	const u8 *uuid = sdp->sd_sb.sb_uuid;
+	struct super_block *s = sdp->sd_vfs;
+	const u8 *uuid = s->s_uuid;
 
 	add_uevent_var(env, "LOCKTABLE=%s", sdp->sd_table_name);
 	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
-- 
1.7.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2GWI02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab2GWI00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:26 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/16] GFS2: Add kobject release method
Date: Mon, 23 Jul 2012 09:01:01 +0100
Message-Id: <1343030466-3053-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch adds a kobject release function that properly maintains
the kobject use count, so that accesses to the sysfs files do not
cause an access to freed kernel memory after an unmount.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index b8c250f..9b23897 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1118,20 +1118,33 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	}
 
 	error = init_names(sdp, silent);
-	if (error)
-		goto fail;
+	if (error) {
+		/* In this case, we haven't initialized sysfs, so we have to
+		   manually free the sdp. */
+		free_percpu(sdp->sd_lkstats);
+		kfree(sdp);
+		sb->s_fs_info = NULL;
+		return error;
+	}
 
 	snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s", sdp->sd_table_name);
 
-	gfs2_create_debugfs_file(sdp);
-
 	error = gfs2_sys_fs_add(sdp);
+	/*
+	 * If we hit an error here, gfs2_sys_fs_add will have called function
+	 * kobject_put which causes the sysfs usage count to go to zero, which
+	 * causes sysfs to call function gfs2_sbd_release, which frees sdp.
+	 * Subsequent error paths here will call gfs2_sys_fs_del, which also
+	 * kobject_put to free sdp.
+	 */
 	if (error)
-		goto fail;
+		return error;
+
+	gfs2_create_debugfs_file(sdp);
 
 	error = gfs2_lm_mount(sdp, silent);
 	if (error)
-		goto fail_sys;
+		goto fail_debug;
 
 	error = init_locking(sdp, &mount_gh, DO);
 	if (error)
@@ -1215,12 +1228,12 @@ fail_locking:
 fail_lm:
 	gfs2_gl_hash_clear(sdp);
 	gfs2_lm_unmount(sdp);
-fail_sys:
-	gfs2_sys_fs_del(sdp);
-fail:
+fail_debug:
 	gfs2_delete_debugfs_file(sdp);
 	free_percpu(sdp->sd_lkstats);
-	kfree(sdp);
+	/* gfs2_sys_fs_del must be the last thing we do, since it causes
+	 * sysfs to call function gfs2_sbd_release, which frees sdp. */
+	gfs2_sys_fs_del(sdp);
 	sb->s_fs_info = NULL;
 	return error;
 }
@@ -1390,10 +1403,9 @@ static void gfs2_kill_sb(struct super_block *sb)
 	sdp->sd_root_dir = NULL;
 	sdp->sd_master_dir = NULL;
 	shrink_dcache_sb(sb);
-	kill_block_super(sb);
 	gfs2_delete_debugfs_file(sdp);
 	free_percpu(sdp->sd_lkstats);
-	kfree(sdp);
+	kill_block_super(sb);
 }
 
 struct file_system_type gfs2_fs_type = {
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 9c2592b..e4bee4b 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -276,7 +276,15 @@ static struct attribute *gfs2_attrs[] = {
 	NULL,
 };
 
+static void gfs2_sbd_release(struct kobject *kobj)
+{
+	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
+
+	kfree(sdp);
+}
+
 static struct kobj_type gfs2_ktype = {
+	.release = gfs2_sbd_release,
 	.default_attrs = gfs2_attrs,
 	.sysfs_ops     = &gfs2_attr_ops,
 };
@@ -583,6 +591,7 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	char ro[20];
 	char spectator[20];
 	char *envp[] = { ro, spectator, NULL };
+	int sysfs_frees_sdp = 0;
 
 	sprintf(ro, "RDONLY=%d", (sb->s_flags & MS_RDONLY) ? 1 : 0);
 	sprintf(spectator, "SPECTATOR=%d", sdp->sd_args.ar_spectator ? 1 : 0);
@@ -591,8 +600,10 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	error = kobject_init_and_add(&sdp->sd_kobj, &gfs2_ktype, NULL,
 				     "%s", sdp->sd_table_name);
 	if (error)
-		goto fail;
+		goto fail_reg;
 
+	sysfs_frees_sdp = 1; /* Freeing sdp is now done by sysfs calling
+				function gfs2_sbd_release. */
 	error = sysfs_create_group(&sdp->sd_kobj, &tune_group);
 	if (error)
 		goto fail_reg;
@@ -615,9 +626,13 @@ fail_lock_module:
 fail_tune:
 	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
 fail_reg:
-	kobject_put(&sdp->sd_kobj);
-fail:
+	free_percpu(sdp->sd_lkstats);
 	fs_err(sdp, "error %d adding sysfs files", error);
+	if (sysfs_frees_sdp)
+		kobject_put(&sdp->sd_kobj);
+	else
+		kfree(sdp);
+	sb->s_fs_info = NULL;
 	return error;
 }
 
-- 
1.7.4


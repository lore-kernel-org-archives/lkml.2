Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab0EUQyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:54:47 -0400
Received: from kroah.org ([198.145.64.141]:39123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934250Ab0EUQyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/38] sysfs: Basic support for multiple super blocks
Date: Fri, 21 May 2010 09:53:48 -0700
Message-Id: <1274460848-11377-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Add all of the necessary bioler plate to support
multiple superblocks in sysfs.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/mount.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/sysfs/sysfs.h |    3 ++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 7761378..db0b1f2 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -72,16 +72,70 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	return 0;
 }
 
+static int sysfs_test_super(struct super_block *sb, void *data)
+{
+	struct sysfs_super_info *sb_info = sysfs_info(sb);
+	struct sysfs_super_info *info = data;
+	int found = 1;
+	return found;
+}
+
+static int sysfs_set_super(struct super_block *sb, void *data)
+{
+	int error;
+	error = set_anon_super(sb, data);
+	if (!error)
+		sb->s_fs_info = data;
+	return error;
+}
+
 static int sysfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_single(fs_type, flags, data, sysfs_fill_super, mnt);
+	struct sysfs_super_info *info;
+	struct super_block *sb;
+	int error;
+
+	error = -ENOMEM;
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		goto out;
+	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, info);
+	if (IS_ERR(sb) || sb->s_fs_info != info)
+		kfree(info);
+	if (IS_ERR(sb)) {
+		kfree(info);
+		error = PTR_ERR(sb);
+		goto out;
+	}
+	if (!sb->s_root) {
+		sb->s_flags = flags;
+		error = sysfs_fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
+		if (error) {
+			deactivate_locked_super(sb);
+			goto out;
+		}
+		sb->s_flags |= MS_ACTIVE;
+	}
+
+	simple_set_mnt(mnt, sb);
+	error = 0;
+out:
+	return error;
+}
+
+static void sysfs_kill_sb(struct super_block *sb)
+{
+	struct sysfs_super_info *info = sysfs_info(sb);
+
+	kill_anon_super(sb);
+	kfree(info);
 }
 
 static struct file_system_type sysfs_fs_type = {
 	.name		= "sysfs",
 	.get_sb		= sysfs_get_sb,
-	.kill_sb	= kill_anon_super,
+	.kill_sb	= sysfs_kill_sb,
 };
 
 int __init sysfs_init(void)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 30f5a44..030a39d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -114,6 +114,9 @@ struct sysfs_addrm_cxt {
 /*
  * mount.c
  */
+struct sysfs_super_info {
+};
+#define sysfs_info(SB) ((struct sysfs_super_info *)(SB->s_fs_info))
 extern struct sysfs_dirent sysfs_root;
 extern struct kmem_cache *sysfs_dir_cachep;
 
-- 
1.7.0.3


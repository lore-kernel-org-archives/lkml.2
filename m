Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0C3Sbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:31:40 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57387 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab0C3Sbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:31:38 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       <netdev@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 1/6] sysfs: Basic support for multiple super blocks
Date: Tue, 30 Mar 2010 11:31:24 -0700
Message-Id: <1269973889-25260-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1fx3hk6gw.fsf@fess.ebiederm.org>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gregkh@suse.de, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, eric.dumazet@gmail.com, bcrl@lhnet.ca, serue@us.ibm.com, netdev@vger.kernel.org, ebiederm@xmission.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Add all of the necessary bioler plate to support
multiple superblocks in sysfs.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/mount.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/sysfs/sysfs.h |    3 ++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 0cb1088..6a433ac 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -71,16 +71,70 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
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
1.6.5.2.143.g8cc62


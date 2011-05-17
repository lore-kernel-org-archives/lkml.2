Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1EQMbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:31:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57108 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab1EQMbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:31:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W0R3WkxdXJOoKK6v3DT+Uj7LGYoTUCJhG/H60gqkNVNmOsijgVtv5Fqtv9mLYAiNi1
         k8bu9D/vz2TsMmUD9/jzjoLld0j/nyKrtYcXYcXiFWkx6Vl9+/WqauGFoi4+cV3fuFN2
         XU5mA9mMTznF7nSJJioXvKPZpYU+jigKFyj+4=
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        mszeredi@suse.cz
Subject: [PATCH 6/7] overlayfs: add statfs support
Date: Tue, 17 May 2011 14:30:51 +0200
Message-Id: <1305635452-14835-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

Add support for statfs to the overlayfs filesystem.  As the upper layer
is the target of all write operations assume that the space in that
filesystem is the space in the overlayfs.  There will be some inaccuracy as
overwriting a file will copy it up and consume space we were not expecting,
but it is better than nothing.

Use the upper layer dentry and mount from the overlayfs root inode,
passing the statfs call to that filesystem.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/super.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0901eda..a9a09a6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -379,9 +379,29 @@ static int ovl_remount_fs(struct super_block *sb, int *flagsp, char *data)
 		return mnt_want_write(ufs->upper_mnt);
 }
 
+/**
+ * ovl_statfs
+ * @sb: The overlayfs super block
+ * @buf: The struct kstatfs to fill in with stats
+ *
+ * Get the filesystem statistics.  As writes always target the upper layer
+ * filesystem pass the statfs to the same filesystem.
+ */
+static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct dentry *root_dentry = dentry->d_sb->s_root;
+	struct path path;
+	ovl_path_upper(root_dentry, &path);
+
+	if (!path.dentry->d_sb->s_op->statfs)
+		return -ENOSYS;
+	return path.dentry->d_sb->s_op->statfs(path.dentry, buf);
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
 	.remount_fs	= ovl_remount_fs,
+	.statfs		= ovl_statfs,
 };
 
 struct ovl_config {
-- 
1.7.3.4


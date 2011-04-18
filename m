Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab1DRQCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:02:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab1DRQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Urt76wSAFBw0GUX8vZjwpWl4+rcVljWqewxBpfPf5olFy29IGMJAlTe5dSjySm0CM4
         DkY7FbHLyx9fLTzmYASNpHvT8lJPdPu4ZXVbgaYYWT/93OKCV2/edVdNb+q6SEyQF7ap
         yNCxXAPYv4++5eyjY/OwFZy11qIGNy1LuSIjs=
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 5/6] overlayfs: add statfs support
Date: Mon, 18 Apr 2011 18:00:39 +0200
Message-Id: <1303142440-26328-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
References: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
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
 fs/overlayfs/overlayfs.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index 0901eda..a9a09a6 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
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
1.7.1


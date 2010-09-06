Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab0IFAv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:51:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:50948 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab0IFAvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:51:25 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:28 +1000
Subject: [PATCH 02/10] ovl: minimal remount support.
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100906005028.20775.41803.stgit@localhost.localdomain>
In-Reply-To: <20100906004829.20775.68828.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As overlayfs reflects the 'readonly' mount status in write-access to
the upper filesystem, we must handle remount and either drop or take
write access when the ro status changes.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/overlayfs/overlayfs.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index 0ddfeec..4e032e8 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -1685,8 +1685,28 @@ static void ovl_put_super(struct super_block *sb)
 	kfree(ufs);
 }
 
+static int ovl_remount_fs(struct super_block *sb, int *flagsp, char *data)
+{
+	int flags = *flagsp;
+	struct ovl_fs *ufs = sb->s_fs_info;
+
+	/* When remounting rw or ro, we need to adjust the write access to the
+	 * upper fs.
+	 */
+	if (((flags ^ sb->s_flags) & MS_RDONLY) == 0)
+		/* No change to readonly status */
+		return 0;
+
+	if (flags & MS_RDONLY) {
+		mnt_drop_write(ufs->upper_mnt);
+		return 0;
+	} else
+		return mnt_want_write(ufs->upper_mnt);
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
+	.remount_fs	= ovl_remount_fs,
 };
 
 struct ovl_config {



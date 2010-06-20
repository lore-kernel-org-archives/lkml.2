Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab0FUJvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 05:51:01 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:48961 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab0FUJvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 05:51:00 -0400
Subject: [PATCH fs/ramfs] inode.c: Fix incorrect variable freeing.
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Jun 2010 15:27:37 -0400
Message-ID: <1277062057.14428.0.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In ramfs_fill_super(), if fsi's memory allocation fails, it will go to 'fail', 
which immediately tries to free the variable, potentially producing an Oops. 
This patch addresses this issue.

Thanks.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 fs/ramfs/inode.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index a5ebae7..40af7a2 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -219,7 +219,7 @@ int ramfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_fs_info = fsi;
 	if (!fsi) {
 		err = -ENOMEM;
-		goto fail;
+		goto fail2;
 	}
 
 	err = ramfs_parse_options(data, &fsi->mount_opts);
@@ -247,11 +247,13 @@ int ramfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	return 0;
-fail:
-	kfree(fsi);
+fail2:
 	sb->s_fs_info = NULL;
 	iput(inode);
 	return err;
+fail:
+	kfree(fsi);
+	goto fail2;
 }
 
 int ramfs_get_sb(struct file_system_type *fs_type,
-- 
1.7.0.4





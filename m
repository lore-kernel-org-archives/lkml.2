Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab2JKKdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:33:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53475 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466Ab2JKKc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:32:26 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] efivarfs: efivarfs_fill_super() fix inode reference counts
Date: Thu, 11 Oct 2012 11:32:19 +0100
Message-Id: <1349951541-20498-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349951541-20498-1-git-send-email-apw@canonical.com>
References: <1349416496.810727.310563927016.1.gpush@pecola>
 <1349951541-20498-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When d_make_root() fails it will automatically drop the reference
on the root inode.  We should not be doing so as well.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/firmware/efivars.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 0bbf742..79f3e4e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -948,7 +948,6 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct dentry *root;
 	struct efivar_entry *entry, *n;
 	struct efivars *efivars = &__efivars;
-	int err;
 
 	efivarfs_sb = sb;
 
@@ -960,18 +959,14 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran         = 1;
 
 	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
-	if (!inode) {
-		err = -ENOMEM;
-		goto fail;
-	}
+	if (!inode)
+		return -ENOMEM;
 	inode->i_op = &efivarfs_dir_inode_operations;
 
 	root = d_make_root(inode);
 	sb->s_root = root;
-	if (!root) {
-		err = -ENOMEM;
-		goto fail;
-	}
+	if (!root)
+		return -ENOMEM;
 
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
 		struct inode *inode;
@@ -1012,9 +1007,6 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	return 0;
-fail:
-	iput(inode);
-	return err;
 }
 
 static struct dentry *efivarfs_mount(struct file_system_type *fs_type,
-- 
1.7.9.5


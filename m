Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab2JKKdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:33:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53485 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758487Ab2JKKc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:32:27 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] efivarfs: efivarfs_fill_super() ensure we clean up correctly on error
Date: Thu, 11 Oct 2012 11:32:21 +0100
Message-Id: <1349951541-20498-6-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349951541-20498-1-git-send-email-apw@canonical.com>
References: <1349416496.810727.310563927016.1.gpush@pecola>
 <1349951541-20498-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we free both the name and inode on error when building the
individual variables.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/firmware/efivars.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index dcb34ae..0cad5d9 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -948,6 +948,7 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct dentry *root;
 	struct efivar_entry *entry, *n;
 	struct efivars *efivars = &__efivars;
+	char *name;
 
 	efivarfs_sb = sb;
 
@@ -969,16 +970,18 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 		return -ENOMEM;
 
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		struct inode *inode;
 		struct dentry *dentry, *root = efivarfs_sb->s_root;
-		char *name;
 		unsigned long size = 0;
 		int len, i;
 
+		inode = NULL;
+
 		len = utf16_strlen(entry->var.VariableName);
 
 		/* GUID plus trailing NULL */
 		name = kmalloc(len + 38, GFP_ATOMIC);
+		if (!name)
+			goto fail;
 
 		for (i = 0; i < len; i++)
 			name[i] = entry->var.VariableName[i] & 0xFF;
@@ -991,7 +994,13 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 
 		inode = efivarfs_get_inode(efivarfs_sb, root->d_inode,
 					  S_IFREG | 0644, 0);
+		if (!inode)
+			goto fail_name;
+			
 		dentry = d_alloc_name(root, name);
+		if (!dentry)
+			goto fail_inode;
+
 		/* copied by the above to local storage in the dentry. */
 		kfree(name);
 
@@ -1009,6 +1018,13 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	return 0;
+
+fail_inode:
+	iput(inode);
+fail_name:
+	kfree(name);
+fail:
+	return -ENOMEM;
 }
 
 static struct dentry *efivarfs_mount(struct file_system_type *fs_type,
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab2JKKcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:32:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab2JKKc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:32:26 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] efivarfs: efivarfs_create() ensure we drop our reference on inode on error
Date: Thu, 11 Oct 2012 11:32:18 +0100
Message-Id: <1349951541-20498-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349951541-20498-1-git-send-email-apw@canonical.com>
References: <1349416496.810727.310563927016.1.gpush@pecola>
 <1349951541-20498-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/firmware/efivars.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ae50d2f..0bbf742 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -866,7 +866,7 @@ static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
 static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 			  umode_t mode, bool excl)
 {
-	struct inode *inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
+	struct inode *inode;
 	struct efivars *efivars = &__efivars;
 	struct efivar_entry *var;
 	int namelen, i = 0, err = 0;
@@ -874,13 +874,15 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len < 38)
 		return -EINVAL;
 
+	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
 	if (!inode)
 		return -ENOSPC;
 
 	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
-
-	if (!var)
-		return -ENOMEM;
+	if (!var) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	namelen = dentry->d_name.len - GUID_LEN;
 
@@ -908,8 +910,10 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	d_instantiate(dentry, inode);
 	dget(dentry);
 out:
-	if (err)
+	if (err) {
 		kfree(var);
+		iput(inode);
+	}
 	return err;
 }
 
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab2JKNTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:19:25 -0400
Received: from ozlabs.org ([203.10.76.45]:38325 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758568Ab2JKNTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:19:18 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] efivarfs: Implement exclusive access for {get,set}_variable
Message-Id: <1349961551.174484.910885224391.1.gpush@pecola>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, Matthew Garrett <mjg@redhat.com>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Thu, 11 Oct 2012 21:19:11 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, efivarfs does not enforce exclusion over the get_variable and
set_variable operations. Section 7.1 of UEFI requires us to only allow a
single processor to enter {get,set}_variable services at once.

This change acquires the efivars->lock over calls to these operations
from the efivarfs paths.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 drivers/firmware/efivars.c |   68 +++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 25 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 5765664..a86eb55 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -679,35 +679,45 @@ static ssize_t efivarfs_file_write(struct file *file,
 		goto out;
 	}
 
+	/*
+	 * The lock here protects the get_variable call, the conditional
+	 * set_variable call, and removal of the variable from the efivars
+	 * list (in the case of an authenticated delete).
+	 */
+	spin_lock(&efivars->lock);
+
 	status = efivars->ops->set_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
 					    attributes, datasize,
 					    data);
 
-	switch (status) {
-	case EFI_SUCCESS:
-		break;
-	case EFI_INVALID_PARAMETER:
-		count = -EINVAL;
-		goto out;
-	case EFI_OUT_OF_RESOURCES:
-		count = -ENOSPC;
-		goto out;
-	case EFI_DEVICE_ERROR:
-		count = -EIO;
-		goto out;
-	case EFI_WRITE_PROTECTED:
-		count = -EROFS;
-		goto out;
-	case EFI_SECURITY_VIOLATION:
-		count = -EACCES;
-		goto out;
-	case EFI_NOT_FOUND:
-		count = -ENOENT;
-		goto out;
-	default:
-		count = -EINVAL;
-		goto out;
+	if (status != EFI_SUCCESS) {
+		spin_unlock(&efivars->lock);
+		kfree(data);
+
+		switch (status) {
+		case EFI_INVALID_PARAMETER:
+			count = -EINVAL;
+			break;
+		case EFI_OUT_OF_RESOURCES:
+			count = -ENOSPC;
+			break;
+		case EFI_DEVICE_ERROR:
+			count = -EIO;
+			break;
+		case EFI_WRITE_PROTECTED:
+			count = -EROFS;
+			break;
+		case EFI_SECURITY_VIOLATION:
+			count = -EACCES;
+			break;
+		case EFI_NOT_FOUND:
+			count = -ENOENT;
+			break;
+		default:
+			count = -EINVAL;
+		}
+		return count;
 	}
 
 	/*
@@ -723,12 +733,12 @@ static ssize_t efivarfs_file_write(struct file *file,
 					    NULL);
 
 	if (status == EFI_BUFFER_TOO_SMALL) {
+		spin_unlock(&efivars->lock);
 		mutex_lock(&inode->i_mutex);
 		i_size_write(inode, newdatasize + sizeof(attributes));
 		mutex_unlock(&inode->i_mutex);
 
 	} else if (status == EFI_NOT_FOUND) {
-		spin_lock(&efivars->lock);
 		list_del(&var->list);
 		spin_unlock(&efivars->lock);
 		efivar_unregister(var);
@@ -736,6 +746,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 		dput(file->f_dentry);
 
 	} else {
+		spin_unlock(&efivars->lock);
 		pr_warn("efivarfs: inconsistent EFI variable implementation? "
 				"status = %lx\n", status);
 	}
@@ -757,9 +768,11 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	void *data;
 	ssize_t size = 0;
 
+	spin_lock(&efivars->lock);
 	status = efivars->ops->get_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
 					    &attributes, &datasize, NULL);
+	spin_unlock(&efivars->lock);
 
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return 0;
@@ -769,10 +782,13 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	if (!data)
 		return 0;
 
+	spin_lock(&efivars->lock);
 	status = efivars->ops->get_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
 					    &attributes, &datasize,
 					    (data + 4));
+	spin_unlock(&efivars->lock);
+
 	if (status != EFI_SUCCESS)
 		goto out_free;
 
@@ -993,11 +1009,13 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 		/* copied by the above to local storage in the dentry. */
 		kfree(name);
 
+		spin_lock(&efivars->lock);
 		efivars->ops->get_variable(entry->var.VariableName,
 					   &entry->var.VendorGuid,
 					   &entry->var.Attributes,
 					   &size,
 					   NULL);
+		spin_unlock(&efivars->lock);
 
 		mutex_lock(&inode->i_mutex);
 		inode->i_private = entry;

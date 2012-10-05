Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2JEG4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:56:46 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39162 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab2JEG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:56:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3/3] efi: Handle deletions and size changes in
 efivarfs_write_file
Message-Id: <1349416496.810982.659496647274.3.gpush@pecola>
In-Reply-To: <1349416496.810727.310563927016.1.gpush@pecola>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: <glin@suse.com>, Lee@grenadilla.canonical.com, Chun-Yi <jlee@suse.com>,
        Matthew Garrett <mjg@redhat.com>, Peter Jones <pjones@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Fri, 05 Oct 2012 13:54:56 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A write to an efivarfs file will not always result in a variable of
'count' size after the EFI SetVariable() call. We may have appended to
the existing data (ie, with the EFI_VARIABLE_APPEND_WRITE attribute), or
even have deleted the variable (with an authenticated variable update,
with a zero datasize).

This change re-reads the updated variable from firmware, to check for
size changes and deletions. In the latter case, we need to drop the
dentry.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 drivers/firmware/efivars.c |   49 +++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index e1253d6..a422de3 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -647,6 +647,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	u32 attributes;
 	struct inode *inode = file->f_mapping->host;
 	int datasize = count - sizeof(attributes);
+	unsigned long newdatasize;
 
 	if (count < sizeof(attributes))
 		return -EINVAL;
@@ -685,32 +686,60 @@ static ssize_t efivarfs_file_write(struct file *file,
 
 	switch (status) {
 	case EFI_SUCCESS:
-		mutex_lock(&inode->i_mutex);
-		i_size_write(inode, count);
-		mutex_unlock(&inode->i_mutex);
 		break;
 	case EFI_INVALID_PARAMETER:
 		count = -EINVAL;
-		break;
+		goto out;
 	case EFI_OUT_OF_RESOURCES:
 		count = -ENOSPC;
-		break;
+		goto out;
 	case EFI_DEVICE_ERROR:
 		count = -EIO;
-		break;
+		goto out;
 	case EFI_WRITE_PROTECTED:
 		count = -EROFS;
-		break;
+		goto out;
 	case EFI_SECURITY_VIOLATION:
 		count = -EACCES;
-		break;
+		goto out;
 	case EFI_NOT_FOUND:
 		count = -ENOENT;
-		break;
+		goto out;
 	default:
 		count = -EINVAL;
-		break;
+		goto out;
 	}
+
+	/*
+	 * Writing to the variable may have caused a change in size (which
+	 * could either be an append or an overwrite), or the variable to be
+	 * deleted. Perform a GetVariable() so we can tell what actually
+	 * happened.
+	 */
+	newdatasize = 0;
+	status = efivars->ops->get_variable(var->var.VariableName,
+					    &var->var.VendorGuid,
+					    NULL, &newdatasize,
+					    NULL);
+
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		mutex_lock(&inode->i_mutex);
+		i_size_write(inode, newdatasize + sizeof(attributes));
+		mutex_unlock(&inode->i_mutex);
+
+	} else if (status == EFI_NOT_FOUND) {
+		spin_lock(&efivars->lock);
+		list_del(&var->list);
+		spin_unlock(&efivars->lock);
+		efivar_unregister(var);
+		drop_nlink(inode);
+		dput(file->f_dentry);
+
+	} else {
+		pr_warn("efivarfs: inconsistent EFI variable implementation? "
+				"status = %lx\n", status);
+	}
+
 out:
 	kfree(data);
 

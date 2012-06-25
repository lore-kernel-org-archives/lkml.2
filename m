Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2FYNM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:12:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2FYNMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:12:25 -0400
From: Peter Jones <pjones@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>
Subject: [PATCH] Support UEFI variable append and deleting authenticated variables.
Date: Mon, 25 Jun 2012 09:12:19 -0400
Message-Id: <1340629939-30048-1-git-send-email-pjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for appending to all UEFI variables, and also for
deleting authentication variables.

Signed-off-by: Peter Jones <pjones@redhat.com>
---
 drivers/firmware/efivars.c |   99 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 94 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 47408e8..b12a2f0 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -108,6 +108,27 @@ struct efi_variable {
 	__u32         Attributes;
 } __attribute__((packed));
 
+struct win_certificate {
+	__u32	dwLength;
+	__u16	wRevision;
+	__u16	wCertificateType;
+	__u8	wCertificate[];
+};
+
+struct win_certificate_uefi_guid {
+	struct win_certificate	Hdr;
+	efi_guid_t		CertType;
+};
+
+struct efi_variable_authentication {
+	__u64					MonotonicCount;
+	struct win_certificate_uefi_guid	AuthInfo;
+};
+
+struct efi_variable_authentication_2 {
+	efi_time_t				TimeStamp;
+	struct win_certificate_uefi_guid	AuthInfo;
+};
 
 struct efivar_entry {
 	struct efivars *efivars;
@@ -802,6 +823,54 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
+static int is_authenticated_delete(struct efi_variable *new_var)
+{
+	/* If we get a set_variable() call that's got an authenticated
+	 * variable attribute set, and its DataSize is the same size as
+	 * the AuthInfo descriptor, then it's really a delete. */
+	if (new_var->Attributes & EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS) {
+		struct efi_variable_authentication *eva;
+		__u32 size;
+
+		if (new_var->DataSize <
+				sizeof(struct efi_variable_authentication))
+			return 0;
+
+		eva = (struct efi_variable_authentication *)new_var->Data;
+
+		/* 27.2.4 says:
+		 * dwLength: The length of the entire certificate, including
+		 *           the length of the header, in bytes.
+		 */
+		size = sizeof(eva->AuthInfo.CertType) +
+		       eva->AuthInfo.Hdr.dwLength;
+
+		if (size == new_var->DataSize)
+			return 1;
+	} else if (new_var->Attributes
+			& EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS) {
+		struct efi_variable_authentication_2 *eva;
+		__u32 size;
+
+		if (new_var->DataSize <
+				sizeof(struct efi_variable_authentication_2))
+			return 0;
+
+		eva = (struct efi_variable_authentication_2 *)new_var->Data;
+
+		/* 27.2.4 says:
+		 * dwLength: The length of the entire certificate, including
+		 *           the length of the header, in bytes.
+		 */
+		size = sizeof(eva->AuthInfo.CertType) +
+		       eva->AuthInfo.Hdr.dwLength;
+
+		if (size == new_var->DataSize)
+			return 1;
+	}
+	return 0;
+}
+
 static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
@@ -812,6 +881,8 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	unsigned long strsize1, strsize2;
 	efi_status_t status = EFI_NOT_FOUND;
 	int found = 0;
+	int is_append = 0;
+	int is_delete = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -839,11 +910,20 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			break;
 		}
 	}
-	if (found) {
+	if (new_var->Attributes & EFI_VARIABLE_APPEND_WRITE) {
+		if (!found) {
+			spin_unlock(&efivars->lock);
+			return -EINVAL;
+		}
+		is_append = 1;
+	} else if (is_authenticated_delete(new_var)) {
+		is_delete = 1;
+	} else if (found) {
 		spin_unlock(&efivars->lock);
 		return -EINVAL;
 	}
 
+
 	/* now *really* create the variable via EFI */
 	status = efivars->ops->set_variable(new_var->VariableName,
 					    &new_var->VendorGuid,
@@ -857,16 +937,25 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		spin_unlock(&efivars->lock);
 		return -EIO;
 	}
-	spin_unlock(&efivars->lock);
 
 	/* Create the entry in sysfs.  Locking is not required here */
-	status = efivar_create_sysfs_entry(efivars,
+	if (is_delete) {
+		list_del(&search_efivar->list);
+
+		/* We need to release this lock before unregistering. */
+		spin_unlock(&efivars->lock);
+		efivar_unregister(search_efivar);
+	} else if (is_append) {
+		spin_unlock(&efivars->lock);
+	} else {
+		spin_unlock(&efivars->lock);
+		status = efivar_create_sysfs_entry(efivars,
 					   utf16_strsize(new_var->VariableName,
 							 1024),
 					   new_var->VariableName,
 					   &new_var->VendorGuid);
-	if (status) {
-		printk(KERN_WARNING "efivars: variable created, but sysfs entry wasn't.\n");
+		if (status)
+			pr_warn("efivars: variable created, but sysfs entry wasn't.\n");
 	}
 	return count;
 }
-- 
1.7.10.2


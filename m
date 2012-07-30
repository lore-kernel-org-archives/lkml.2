Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2G3OQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:16:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab2G3OQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:16:30 -0400
From: Peter Jones <pjones@redhat.com>
To: <linux-efi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg@redhat.com>, Peter Jones <pjones@redhat.com>
Subject: [PATCH] Support UEFI variable append and deleting authenticated variables.
Date: Mon, 30 Jul 2012 10:16:19 -0400
Message-Id: <1343657779-31319-1-git-send-email-pjones@redhat.com>
In-Reply-To: <1343645107.13958.7.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1343645107.13958.7.camel@mfleming-mobl1.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for appending to all UEFI variables, and also for
deleting authentication variables.

(Updated to address mfleming's concerns on 7/30/2012)

Signed-off-by: Peter Jones <pjones@redhat.com>
---
 drivers/firmware/efivars.c |   99 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 91 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 47408e8..ff8b524 100644
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
@@ -812,6 +833,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	unsigned long strsize1, strsize2;
 	efi_status_t status = EFI_NOT_FOUND;
 	int found = 0;
+	int is_append = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -839,7 +861,13 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
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
+	} else if (found) {
 		spin_unlock(&efivars->lock);
 		return -EINVAL;
 	}
@@ -857,20 +885,73 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		spin_unlock(&efivars->lock);
 		return -EIO;
 	}
-	spin_unlock(&efivars->lock);
 
 	/* Create the entry in sysfs.  Locking is not required here */
-	status = efivar_create_sysfs_entry(efivars,
+	if (is_append) {
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
 
+static int is_authenticated_delete(struct efi_variable *new_var)
+{
+	/*
+	 * If we get a set_variable() call that's got an authenticated
+	 * variable attribute set, and its DataSize is the same size as
+	 * the AuthInfo descriptor, then it's really a delete.
+	 */
+	if (new_var->Attributes & EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS) {
+		struct efi_variable_authentication *eva;
+		__u32 size;
+
+		if (new_var->DataSize < sizeof(*eva))
+			return 0;
+
+		eva = (struct efi_variable_authentication *)new_var->Data;
+
+		/*
+		 * 27.2.4 says:
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
+		if (new_var->DataSize < sizeof(*eva))
+			return 0;
+
+		eva = (struct efi_variable_authentication_2 *)new_var->Data;
+
+		/*
+		 * 27.2.4 says:
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
 static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
@@ -906,9 +987,11 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 		spin_unlock(&efivars->lock);
 		return -EINVAL;
 	}
-	/* force the Attributes/DataSize to 0 to ensure deletion */
-	del_var->Attributes = 0;
-	del_var->DataSize = 0;
+	if (!is_authenticated_delete(del_var)) {
+		/* force the Attributes/DataSize to 0 to ensure deletion */
+		del_var->DataSize = 0;
+		del_var->Attributes = 0;
+	}
 
 	status = efivars->ops->set_variable(del_var->VariableName,
 					    &del_var->VendorGuid,
-- 
1.7.10.4


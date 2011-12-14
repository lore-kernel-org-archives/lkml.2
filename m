Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab1LNVHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:07:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141Ab1LNVGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:06:54 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mikew@google.com, x86@kernel.org, hpa@zytor.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/4] EFI: Add support for QueryVariableInfo() call
Date: Wed, 14 Dec 2011 16:06:31 -0500
Message-Id: <1323896791-10858-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1323896791-10858-1-git-send-email-mjg@redhat.com>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UEFI 2.0 and later provides a call for identifying hardware variable
capabilities. Use this to work out the maximum size of the variables we
can store, and throw errors where appropriate.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/firmware/efivars.c     |   53 +++++++++++++++++++++++++++++++++++++---
 drivers/firmware/google/gsmi.c |    9 +++++++
 include/linux/efi.h            |    1 +
 3 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 1bef80c..805dba7 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -327,8 +327,9 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	struct extended_efi_variable *new_var, *var = entry->var;
 	struct efi_variable *tmp_var = NULL;
 	struct efivars *efivars = entry->efivars;
-	efi_status_t status = EFI_NOT_FOUND;
+	efi_status_t status;
 	int error = 0;
+	u64 storage_space, remaining_space, max_variable_size, size;
 
 	if (count == sizeof(struct efi_variable)) {
 		tmp_var = (struct efi_variable *)buf;
@@ -360,6 +361,22 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	}
 
 	spin_lock(&efivars->lock);
+
+	size = new_var->header.DataSize +
+		utf16_strnlen(new_var->header.VariableName, 512) * 2;
+
+	status = efivars->ops->query_variable_info(new_var->header.Attributes,
+						   &storage_space,
+						   &remaining_space,
+						   &max_variable_size);
+	if (status == EFI_SUCCESS) {
+		if (size > remaining_space || size > max_variable_size) {
+			spin_unlock(&efivars->lock);
+			error = -ENOSPC;
+			goto out;
+		}
+	}
+
 	status = efivars->ops->set_variable(new_var->header.VariableName,
 					    &new_var->header.VendorGuid,
 					    new_var->header.Attributes,
@@ -670,9 +687,10 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	struct efivars *efivars = bin_attr->private;
 	struct efivar_entry *search_efivar, *n;
 	unsigned long strsize1, strsize2;
-	efi_status_t status = EFI_NOT_FOUND;
+	efi_status_t status;
 	int found = 0;
 	int error = 0;
+	u64 storage_space, remaining_space, max_variable_size, size;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -693,6 +711,21 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		memcpy(ext_new_var->Data, new_var->Data, new_var->DataSize);
 	}
 
+	size = ext_new_var->header.DataSize +
+		utf16_strnlen(ext_new_var->header.VariableName, 512) * 2;
+
+	status = efivars->ops->query_variable_info(ext_new_var->header.Attributes,
+						   &storage_space,
+						   &remaining_space,
+						   &max_variable_size);
+	if (status == EFI_SUCCESS) {
+		if (size > remaining_space || size > max_variable_size) {
+			spin_unlock(&efivars->lock);
+			error = -ENOSPC;
+			goto out;
+		}
+	}
+
 	/*
 	 * Does this variable already exist?
 	 */
@@ -1009,6 +1042,7 @@ int register_efivars(struct efivars *efivars,
 	efi_char16_t *variable_name;
 	unsigned long variable_name_size = 1024;
 	int error = 0;
+	u64 storage_space, remaining_space, max_variable_size;
 
 	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
 	if (!variable_name) {
@@ -1056,9 +1090,19 @@ int register_efivars(struct efivars *efivars,
 
 	efivars->efi_pstore_info = efi_pstore_info;
 
-	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	status = efivars->ops->query_variable_info(PSTORE_EFI_ATTRIBUTES,
+						   &storage_space,
+						   &remaining_space,
+						   &max_variable_size);
+	if (status != EFI_SUCCESS)
+		max_variable_size = 1024;
+
+	max_variable_size -= DUMP_NAME_LEN * 2;
+
+	efivars->efi_pstore_info.buf = kmalloc(max_variable_size, GFP_KERNEL);
+
 	if (efivars->efi_pstore_info.buf) {
-		efivars->efi_pstore_info.bufsize = 1024;
+		efivars->efi_pstore_info.bufsize = max_variable_size;
 		efivars->efi_pstore_info.data = efivars;
 		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
 		pstore_register(&efivars->efi_pstore_info);
@@ -1103,6 +1147,7 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
+	ops.query_variable_info = efi.query_variable_info;
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
 		goto err_put;
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index c4e7c59..8600e3f 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -419,6 +419,14 @@ static efi_status_t gsmi_get_next_variable(unsigned long *name_size,
 	return ret;
 }
 
+static efi_status_t gsmi_query_variable_info(u32 attr,
+					     u64 *storage_space,
+					     u64 *remaining_space,
+					     u64 *max_variable_size)
+{
+	return EFI_UNSUPPORTED;
+}
+
 static efi_status_t gsmi_set_variable(efi_char16_t *name,
 				      efi_guid_t *vendor,
 				      u32 attr,
@@ -473,6 +481,7 @@ static const struct efivar_operations efivar_ops = {
 	.get_variable = gsmi_get_variable,
 	.set_variable = gsmi_set_variable,
 	.get_next_variable = gsmi_get_next_variable,
+	.query_variable_info = gsmi_query_variable_info,
 };
 
 static ssize_t eventlog_write(struct file *filp, struct kobject *kobj,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2362a0b..f3f3860 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -446,6 +446,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_query_variable_info_t *query_variable_info;
 };
 
 struct efivars {
-- 
1.7.7.1


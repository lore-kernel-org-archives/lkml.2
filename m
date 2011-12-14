Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab1LNVHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:07:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758136Ab1LNVGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:06:53 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mikew@google.com, x86@kernel.org, hpa@zytor.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/4] EFI: Add support for variables longer than 1024 bytes
Date: Wed, 14 Dec 2011 16:06:30 -0500
Message-Id: <1323896791-10858-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1323896791-10858-1-git-send-email-mjg@redhat.com>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EFI variables code has a hard limit of 1024 bytes for variable length.
This restriction only existed in version 0.99 of the EFI specification,
and is not relevant on any existing hardware. Add support for a longer
structure that incorporates the existing one, allowing old userspace to
carry on working while allowing newer userspace to write larger variables
via the same interface.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/firmware/efivars.c |  240 ++++++++++++++++++++++++++++----------------
 1 files changed, 154 insertions(+), 86 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index eb07f13..1bef80c 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -92,13 +92,6 @@ MODULE_VERSION(EFIVARS_VERSION);
 
 #define DUMP_NAME_LEN 52
 
-/*
- * The maximum size of VariableName + Data = 1024
- * Therefore, it's reasonable to save that much
- * space in each part of the structure,
- * and we use a page for reading/writing.
- */
-
 struct efi_variable {
 	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
 	efi_guid_t    VendorGuid;
@@ -108,10 +101,20 @@ struct efi_variable {
 	__u32         Attributes;
 } __attribute__((packed));
 
+/*
+ * Older versions of this driver had a fixed 1024-byte buffer. We need to
+ * maintain compatibility with old userspace, so we provide an extended
+ * structure to allow userspace to write larger variables
+ */
+
+struct extended_efi_variable {
+	struct efi_variable header;
+	__u8 Data[0];
+} __attribute__((packed));
 
 struct efivar_entry {
 	struct efivars *efivars;
-	struct efi_variable var;
+	struct extended_efi_variable *var;
 	struct list_head list;
 	struct kobject kobj;
 };
@@ -192,21 +195,41 @@ utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len)
 }
 
 static efi_status_t
-get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
+get_var_data_locked(struct efivars *efivars, struct extended_efi_variable **var)
 {
 	efi_status_t status;
+	unsigned long length;
+
+	if (!*var)
+		*var = kmalloc(sizeof(struct extended_efi_variable), GFP_KERNEL);
+
+	(*var)->header.DataSize = 0;
+	status = efivars->ops->get_variable((*var)->header.VariableName,
+					    &(*var)->header.VendorGuid,
+					    &(*var)->header.Attributes,
+					    &(*var)->header.DataSize,
+					    (*var)->Data);
+
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		*var = krealloc(*var, sizeof(struct extended_efi_variable) +
+				(*var)->header.DataSize, GFP_KERNEL);
+		status = efivars->ops->get_variable((*var)->header.VariableName,
+						    &(*var)->header.VendorGuid,
+						    &(*var)->header.Attributes,
+						    &(*var)->header.DataSize,
+						    (*var)->Data);
+	}
+
+	length = ((*var)->header.DataSize < 1024) ? (*var)->header.DataSize :
+		1024;
+
+	memcpy(&(*var)->header.Data, &(*var)->Data, length);
 
-	var->DataSize = 1024;
-	status = efivars->ops->get_variable(var->VariableName,
-					    &var->VendorGuid,
-					    &var->Attributes,
-					    &var->DataSize,
-					    var->Data);
 	return status;
 }
 
 static efi_status_t
-get_var_data(struct efivars *efivars, struct efi_variable *var)
+get_var_data(struct efivars *efivars, struct extended_efi_variable **var)
 {
 	efi_status_t status;
 
@@ -224,13 +247,13 @@ get_var_data(struct efivars *efivars, struct efi_variable *var)
 static ssize_t
 efivar_guid_read(struct efivar_entry *entry, char *buf)
 {
-	struct efi_variable *var = &entry->var;
+	struct extended_efi_variable *var = entry->var;
 	char *str = buf;
 
 	if (!entry || !buf)
 		return 0;
 
-	efi_guid_unparse(&var->VendorGuid, str);
+	efi_guid_unparse(&var->header.VendorGuid, str);
 	str += strlen(str);
 	str += sprintf(str, "\n");
 
@@ -240,22 +263,22 @@ efivar_guid_read(struct efivar_entry *entry, char *buf)
 static ssize_t
 efivar_attr_read(struct efivar_entry *entry, char *buf)
 {
-	struct efi_variable *var = &entry->var;
+	struct extended_efi_variable *var = entry->var;
 	char *str = buf;
 	efi_status_t status;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(entry->efivars, var);
+	status = get_var_data(entry->efivars, &var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
-	if (var->Attributes & 0x1)
+	if (var->header.Attributes & 0x1)
 		str += sprintf(str, "EFI_VARIABLE_NON_VOLATILE\n");
-	if (var->Attributes & 0x2)
+	if (var->header.Attributes & 0x2)
 		str += sprintf(str, "EFI_VARIABLE_BOOTSERVICE_ACCESS\n");
-	if (var->Attributes & 0x4)
+	if (var->header.Attributes & 0x4)
 		str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");
 	return str - buf;
 }
@@ -263,36 +286,36 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
 static ssize_t
 efivar_size_read(struct efivar_entry *entry, char *buf)
 {
-	struct efi_variable *var = &entry->var;
+	struct extended_efi_variable *var = entry->var;
 	char *str = buf;
 	efi_status_t status;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(entry->efivars, var);
+	status = get_var_data(entry->efivars, &var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
-	str += sprintf(str, "0x%lx\n", var->DataSize);
+	str += sprintf(str, "0x%lx\n", var->header.DataSize);
 	return str - buf;
 }
 
 static ssize_t
 efivar_data_read(struct efivar_entry *entry, char *buf)
 {
-	struct efi_variable *var = &entry->var;
+	struct extended_efi_variable *var = entry->var;
 	efi_status_t status;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(entry->efivars, var);
+	status = get_var_data(entry->efivars, &var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
-	memcpy(buf, var->Data, var->DataSize);
-	return var->DataSize;
+	memcpy(buf, var->Data, var->header.DataSize);
+	return var->header.DataSize;
 }
 /*
  * We allow each variable to be edited via rewriting the
@@ -301,34 +324,46 @@ efivar_data_read(struct efivar_entry *entry, char *buf)
 static ssize_t
 efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 {
-	struct efi_variable *new_var, *var = &entry->var;
+	struct extended_efi_variable *new_var, *var = entry->var;
+	struct efi_variable *tmp_var = NULL;
 	struct efivars *efivars = entry->efivars;
 	efi_status_t status = EFI_NOT_FOUND;
+	int error = 0;
 
-	if (count != sizeof(struct efi_variable))
+	if (count == sizeof(struct efi_variable)) {
+		tmp_var = (struct efi_variable *)buf;
+		new_var = kmalloc(sizeof(struct efi_variable) +
+				  tmp_var->DataSize, GFP_KERNEL);
+		memcpy(&new_var->header, tmp_var, sizeof(struct efi_variable));
+		memcpy(&new_var->Data, tmp_var->Data, tmp_var->DataSize);
+	} else if (count > sizeof(struct efi_variable)) {
+		new_var = (struct extended_efi_variable *)buf;
+	} else {
 		return -EINVAL;
+	}
 
-	new_var = (struct efi_variable *)buf;
 	/*
 	 * If only updating the variable data, then the name
 	 * and guid should remain the same
 	 */
-	if (memcmp(new_var->VariableName, var->VariableName, sizeof(var->VariableName)) ||
-		efi_guidcmp(new_var->VendorGuid, var->VendorGuid)) {
+	if (memcmp(new_var->header.VariableName, var->header.VariableName, sizeof(var->header.VariableName)) ||
+		efi_guidcmp(new_var->header.VendorGuid, var->header.VendorGuid)) {
 		printk(KERN_ERR "efivars: Cannot edit the wrong variable!\n");
-		return -EINVAL;
+		error = -EINVAL;
+		goto out;
 	}
 
-	if ((new_var->DataSize <= 0) || (new_var->Attributes == 0)){
+	if ((new_var->header.DataSize <= 0) || (new_var->header.Attributes == 0)) {
 		printk(KERN_ERR "efivars: DataSize & Attributes must be valid!\n");
-		return -EINVAL;
+		error = -EINVAL;
+		goto out;
 	}
 
 	spin_lock(&efivars->lock);
-	status = efivars->ops->set_variable(new_var->VariableName,
-					    &new_var->VendorGuid,
-					    new_var->Attributes,
-					    new_var->DataSize,
+	status = efivars->ops->set_variable(new_var->header.VariableName,
+					    &new_var->header.VendorGuid,
+					    new_var->header.Attributes,
+					    new_var->header.DataSize,
 					    new_var->Data);
 
 	spin_unlock(&efivars->lock);
@@ -336,28 +371,37 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
 			status);
-		return -EIO;
+		error = -EIO;
+		goto out;
 	}
 
-	memcpy(&entry->var, new_var, count);
+	memcpy(entry->var, new_var, count);
+out:
+	/* Free the extended structure if we needed to allocate it */
+	if (tmp_var && new_var)
+		kfree(new_var);
+
+	if (error)
+		return error;
+
 	return count;
 }
 
 static ssize_t
 efivar_show_raw(struct efivar_entry *entry, char *buf)
 {
-	struct efi_variable *var = &entry->var;
+	struct extended_efi_variable *var = entry->var;
 	efi_status_t status;
 
 	if (!entry || !buf)
 		return 0;
 
-	status = get_var_data(entry->efivars, var);
+	status = get_var_data(entry->efivars, &var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
-	memcpy(buf, var, sizeof(*var));
-	return sizeof(*var);
+	memcpy(buf, var, sizeof(*var) + var->header.DataSize);
+	return sizeof(*var) + var->header.DataSize;
 }
 
 /*
@@ -404,6 +448,7 @@ static const struct sysfs_ops efivar_attr_ops = {
 static void efivar_release(struct kobject *kobj)
 {
 	struct efivar_entry *var = container_of(kobj, struct efivar_entry, kobj);
+	kfree(var->var);
 	kfree(var);
 }
 
@@ -468,21 +513,21 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	unsigned long time;
 
 	while (&efivars->walk_entry->list != &efivars->list) {
-		if (!efi_guidcmp(efivars->walk_entry->var.VendorGuid,
+		if (!efi_guidcmp(efivars->walk_entry->var->header.VendorGuid,
 				 vendor)) {
 			for (i = 0; i < DUMP_NAME_LEN; i++) {
-				name[i] = efivars->walk_entry->var.VariableName[i];
+				name[i] = efivars->walk_entry->var->header.VariableName[i];
 			}
 			if (sscanf(name, "dump-type%u-%u-%lu", type, &part, &time) == 3) {
 				*id = part;
 				timespec->tv_sec = time;
 				timespec->tv_nsec = 0;
 				get_var_data_locked(efivars, &efivars->walk_entry->var);
-				size = efivars->walk_entry->var.DataSize;
+				size = efivars->walk_entry->var->header.DataSize;
 				*buf = kmalloc(size, GFP_KERNEL);
 				if (*buf == NULL)
 					return -ENOMEM;
-				memcpy(*buf, efivars->walk_entry->var.Data,
+				memcpy(*buf, efivars->walk_entry->var->Data,
 				       size);
 				efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
 					           struct efivar_entry, list);
@@ -521,19 +566,19 @@ static int efi_pstore_write(enum pstore_type_id type, u64 *id,
 	list_for_each_entry(entry, &efivars->list, list) {
 		get_var_data_locked(efivars, &entry->var);
 
-		if (efi_guidcmp(entry->var.VendorGuid, vendor))
+		if (efi_guidcmp(entry->var->header.VendorGuid, vendor))
 			continue;
-		if (utf16_strncmp(entry->var.VariableName, efi_name,
+		if (utf16_strncmp(entry->var->header.VariableName, efi_name,
 				  utf16_strlen(efi_name)))
 			continue;
 		/* Needs to be a prefix */
-		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
+		if (entry->var->header.VariableName[utf16_strlen(efi_name)] == 0)
 			continue;
 
 		/* found */
 		found = entry;
-		efivars->ops->set_variable(entry->var.VariableName,
-					   &entry->var.VendorGuid,
+		efivars->ops->set_variable(entry->var->header.VariableName,
+					   &entry->var->header.VendorGuid,
 					   PSTORE_EFI_ATTRIBUTES,
 					   0, NULL);
 	}
@@ -552,7 +597,7 @@ static int efi_pstore_write(enum pstore_type_id type, u64 *id,
 	if (found)
 		efivar_unregister(found);
 
-	if (size) {
+	if (size)
 		switch (system_state) {
 		case SYSTEM_BOOTING:
 		case SYSTEM_RUNNING:
@@ -563,7 +608,6 @@ static int efi_pstore_write(enum pstore_type_id type, u64 *id,
 		default:
 			break;
 		}
-	}
 
 	*id = part;
 	return ret;
@@ -621,62 +665,89 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
 {
-	struct efi_variable *new_var = (struct efi_variable *)buf;
+	struct efi_variable *new_var = NULL;
+	struct extended_efi_variable *ext_new_var = NULL;
 	struct efivars *efivars = bin_attr->private;
 	struct efivar_entry *search_efivar, *n;
 	unsigned long strsize1, strsize2;
 	efi_status_t status = EFI_NOT_FOUND;
 	int found = 0;
+	int error = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	if (count > sizeof(struct efi_variable))
+		ext_new_var = (struct extended_efi_variable *)buf;
+	else if (count == sizeof(struct efi_variable))
+		new_var = (struct efi_variable *)buf;
+	else
+		return -EINVAL;
+
 	spin_lock(&efivars->lock);
 
+	if (new_var) {
+		ext_new_var = kmalloc(sizeof(struct extended_efi_variable) +
+				      new_var->DataSize, GFP_KERNEL);
+		memcpy(&ext_new_var->header, new_var, sizeof(struct efi_variable));
+		memcpy(ext_new_var->Data, new_var->Data, new_var->DataSize);
+	}
+
 	/*
 	 * Does this variable already exist?
 	 */
 	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf16_strsize(new_var->VariableName, 1024);
+		strsize1 = utf16_strsize(search_efivar->var->header.VariableName, 1024);
+		strsize2 = utf16_strsize(ext_new_var->header.VariableName, 1024);
 		if (strsize1 == strsize2 &&
-			!memcmp(&(search_efivar->var.VariableName),
-				new_var->VariableName, strsize1) &&
-			!efi_guidcmp(search_efivar->var.VendorGuid,
-				new_var->VendorGuid)) {
+			!memcmp(&(search_efivar->var->header.VariableName),
+				ext_new_var->header.VariableName, strsize1) &&
+			!efi_guidcmp(search_efivar->var->header.VendorGuid,
+				ext_new_var->header.VendorGuid)) {
 			found = 1;
 			break;
 		}
 	}
 	if (found) {
 		spin_unlock(&efivars->lock);
-		return -EINVAL;
+		error = -EINVAL;
+		goto out;
 	}
 
 	/* now *really* create the variable via EFI */
-	status = efivars->ops->set_variable(new_var->VariableName,
-					    &new_var->VendorGuid,
-					    new_var->Attributes,
-					    new_var->DataSize,
-					    new_var->Data);
+	status = efivars->ops->set_variable(ext_new_var->header.VariableName,
+					    &ext_new_var->header.VendorGuid,
+					    ext_new_var->header.Attributes,
+					    ext_new_var->header.DataSize,
+					    ext_new_var->Data);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
 			status);
 		spin_unlock(&efivars->lock);
-		return -EIO;
+		error = -EIO;
+		goto out;
 	}
 	spin_unlock(&efivars->lock);
 
 	/* Create the entry in sysfs.  Locking is not required here */
 	status = efivar_create_sysfs_entry(efivars,
-					   utf16_strsize(new_var->VariableName,
+					   utf16_strsize(ext_new_var->header.VariableName,
 							 1024),
-					   new_var->VariableName,
-					   &new_var->VendorGuid);
+					   ext_new_var->header.VariableName,
+					   &ext_new_var->header.VendorGuid);
 	if (status) {
 		printk(KERN_WARNING "efivars: variable created, but sysfs entry wasn't.\n");
 	}
+
+out:
+	/* Free the temporary structure if we needed it */
+	if (new_var && ext_new_var)
+		kfree(ext_new_var);
+
+	if (error)
+		return error;
+
 	return count;
 }
 
@@ -700,12 +771,12 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	 * Does this variable already exist?
 	 */
 	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
+		strsize1 = utf16_strsize(search_efivar->var->header.VariableName, 1024);
 		strsize2 = utf16_strsize(del_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
-			!memcmp(&(search_efivar->var.VariableName),
+			!memcmp(&(search_efivar->var->header.VariableName),
 				del_var->VariableName, strsize1) &&
-			!efi_guidcmp(search_efivar->var.VendorGuid,
+			!efi_guidcmp(search_efivar->var->header.VendorGuid,
 				del_var->VendorGuid)) {
 			found = 1;
 			break;
@@ -813,9 +884,11 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	}
 
 	new_efivar->efivars = efivars;
-	memcpy(new_efivar->var.VariableName, variable_name,
+	new_efivar->var = kzalloc(sizeof(struct extended_efi_variable),
+				  GFP_KERNEL);
+	memcpy(new_efivar->var->header.VariableName, variable_name,
 		variable_name_size);
-	memcpy(&(new_efivar->var.VendorGuid), vendor_guid, sizeof(efi_guid_t));
+	memcpy(&(new_efivar->var->header.VendorGuid), vendor_guid, sizeof(efi_guid_t));
 
 	/* Convert Unicode to normal chars (assume top bits are 0),
 	   ala UTF-8 */
@@ -954,11 +1027,6 @@ int register_efivars(struct efivars *efivars,
 		goto out;
 	}
 
-	/*
-	 * Per EFI spec, the maximum storage allocated for both
-	 * the variable name and variable data is 1024 bytes.
-	 */
-
 	do {
 		variable_name_size = 1024;
 
-- 
1.7.7.1


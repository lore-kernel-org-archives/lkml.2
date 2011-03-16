Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1CPVNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:13:43 -0400
Received: from kroah.org ([198.145.64.141]:60929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab1CPVMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 45/50] efivars: parameterize efivars
Date: Wed, 16 Mar 2011 14:11:23 -0700
Message-Id: <1300309888-5028-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

Now that we all global variable state is encapsulated by struct efivars,
parameterize all functions to the efivars local to the control flow rather
than at file scope.  We do this by removing the variable "efivars" at file
scope and move its storage down to the end of the file.

Variables get at efivars by storing the efivars pointer within each
efivar_entry.  The "new_var" and "del_var" binary attribute files get at
the efivars through the private pointer.

Signed-off-by: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>,
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |   49 +++++++++++++++++++++++++++----------------
 1 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 528ce47..5633018 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -103,8 +103,6 @@ struct efivars {
 	struct kset *kset;
 	struct bin_attribute *new_var, *del_var;
 };
-static struct efivars __efivars;
-static struct efivars *efivars = &__efivars;
 
 /*
  * The maximum size of VariableName + Data = 1024
@@ -124,6 +122,7 @@ struct efi_variable {
 
 
 struct efivar_entry {
+	struct efivars *efivars;
 	struct efi_variable var;
 	struct list_head list;
 	struct kobject kobj;
@@ -150,9 +149,10 @@ struct efivar_attribute efivar_attr_##_name = { \
  * Prototype for sysfs creation function
  */
 static int
-efivar_create_sysfs_entry(unsigned long variable_name_size,
-				efi_char16_t *variable_name,
-				efi_guid_t *vendor_guid);
+efivar_create_sysfs_entry(struct efivars *efivars,
+			  unsigned long variable_name_size,
+			  efi_char16_t *variable_name,
+			  efi_guid_t *vendor_guid);
 
 /* Return the number of unicode characters in data */
 static unsigned long
@@ -176,7 +176,7 @@ utf8_strsize(efi_char16_t *data, unsigned long maxlength)
 }
 
 static efi_status_t
-get_var_data(struct efi_variable *var)
+get_var_data(struct efivars *efivars, struct efi_variable *var)
 {
 	efi_status_t status;
 
@@ -221,7 +221,7 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(var);
+	status = get_var_data(entry->efivars, var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
@@ -244,7 +244,7 @@ efivar_size_read(struct efivar_entry *entry, char *buf)
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(var);
+	status = get_var_data(entry->efivars, var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
@@ -261,7 +261,7 @@ efivar_data_read(struct efivar_entry *entry, char *buf)
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(var);
+	status = get_var_data(entry->efivars, var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
@@ -276,6 +276,7 @@ static ssize_t
 efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 {
 	struct efi_variable *new_var, *var = &entry->var;
+	struct efivars *efivars = entry->efivars;
 	efi_status_t status = EFI_NOT_FOUND;
 
 	if (count != sizeof(struct efi_variable))
@@ -325,7 +326,7 @@ efivar_show_raw(struct efivar_entry *entry, char *buf)
 	if (!entry || !buf)
 		return 0;
 
-	status = get_var_data(var);
+	status = get_var_data(entry->efivars, var);
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
@@ -413,6 +414,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *new_var = (struct efi_variable *)buf;
+	struct efivars *efivars = bin_attr->private;
 	struct efivar_entry *search_efivar, *n;
 	unsigned long strsize1, strsize2;
 	efi_status_t status = EFI_NOT_FOUND;
@@ -459,8 +461,11 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	spin_unlock(&efivars->lock);
 
 	/* Create the entry in sysfs.  Locking is not required here */
-	status = efivar_create_sysfs_entry(utf8_strsize(new_var->VariableName,
-			1024), new_var->VariableName, &new_var->VendorGuid);
+	status = efivar_create_sysfs_entry(efivars,
+					   utf8_strsize(new_var->VariableName,
+							1024),
+					   new_var->VariableName,
+					   &new_var->VendorGuid);
 	if (status) {
 		printk(KERN_WARNING "efivars: variable created, but sysfs entry wasn't.\n");
 	}
@@ -472,6 +477,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
+	struct efivars *efivars = bin_attr->private;
 	struct efivar_entry *search_efivar, *n;
 	unsigned long strsize1, strsize2;
 	efi_status_t status = EFI_NOT_FOUND;
@@ -580,9 +586,10 @@ static struct kobject *efi_kobj;
  * Returns 1 on failure, 0 on success
  */
 static int
-efivar_create_sysfs_entry(unsigned long variable_name_size,
-			efi_char16_t *variable_name,
-			efi_guid_t *vendor_guid)
+efivar_create_sysfs_entry(struct efivars *efivars,
+			  unsigned long variable_name_size,
+			  efi_char16_t *variable_name,
+			  efi_guid_t *vendor_guid)
 {
 	int i, short_name_size = variable_name_size / sizeof(efi_char16_t) + 38;
 	char *short_name;
@@ -597,6 +604,7 @@ efivar_create_sysfs_entry(unsigned long variable_name_size,
 		return 1;
 	}
 
+	new_efivar->efivars = efivars;
 	memcpy(new_efivar->var.VariableName, variable_name,
 		variable_name_size);
 	memcpy(&(new_efivar->var.VendorGuid), vendor_guid, sizeof(efi_guid_t));
@@ -691,6 +699,8 @@ out_free:
 	return error;
 }
 
+static struct efivars __efivars;
+
 /*
  * For now we register the efi subsystem with the firmware subsystem
  * and the vars subsystem with the efi subsystem.  In the future, it
@@ -706,6 +716,7 @@ efivars_init(void)
 	efi_guid_t vendor_guid;
 	efi_char16_t *variable_name;
 	unsigned long variable_name_size = 1024;
+	struct efivars *efivars = &__efivars;
 	int error = 0;
 
 	if (!efi_enabled)
@@ -751,9 +762,10 @@ efivars_init(void)
 						&vendor_guid);
 		switch (status) {
 		case EFI_SUCCESS:
-			efivar_create_sysfs_entry(variable_name_size,
-							variable_name,
-							&vendor_guid);
+			efivar_create_sysfs_entry(efivars,
+						  variable_name_size,
+						  variable_name,
+						  &vendor_guid);
 			break;
 		case EFI_NOT_FOUND:
 			break;
@@ -788,6 +800,7 @@ out_free:
 static void __exit
 efivars_exit(void)
 {
+	struct efivars *efivars = &__efivars;
 	struct efivar_entry *entry, *n;
 
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-- 
1.7.4.1


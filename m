Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1CPVVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:21:22 -0400
Received: from kroah.org ([198.145.64.141]:60972 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab1CPVM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 47/50] efivars: Parameterize operations.
Date: Wed, 16 Mar 2011 14:11:25 -0700
Message-Id: <1300309888-5028-47-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

Instead of letting efivars access struct efi directly when dealing with
variables, use an operations structure.  This allows a later change to
reuse the efivars logic without having to pretend to support everything
in struct efi.

Signed-off-by: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>,
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |   61 ++++++++++++++++++++++++++-----------------
 1 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index f22bfcf..b10b7d7 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -89,19 +89,26 @@ MODULE_DESCRIPTION("sysfs interface to EFI Variables");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EFIVARS_VERSION);
 
+struct efivar_operations {
+	efi_get_variable_t *get_variable;
+	efi_get_next_variable_t *get_next_variable;
+	efi_set_variable_t *set_variable;
+};
+
 struct efivars {
 	/*
 	 * ->lock protects two things:
 	 * 1) ->list - adds, removals, reads, writes
-	 * 2) efi.[gs]et_variable() calls.
+	 * 2) ops.[gs]et_variable() calls.
 	 * It must not be held when creating sysfs entries or calling kmalloc.
-	 * efi.get_next_variable() is only called from register_efivars(),
+	 * ops.get_next_variable() is only called from register_efivars(),
 	 * which is protected by the BKL, so that path is safe.
 	 */
 	spinlock_t lock;
 	struct list_head list;
 	struct kset *kset;
 	struct bin_attribute *new_var, *del_var;
+	const struct efivar_operations *ops;
 };
 
 /*
@@ -182,11 +189,11 @@ get_var_data(struct efivars *efivars, struct efi_variable *var)
 
 	spin_lock(&efivars->lock);
 	var->DataSize = 1024;
-	status = efi.get_variable(var->VariableName,
-				&var->VendorGuid,
-				&var->Attributes,
-				&var->DataSize,
-				var->Data);
+	status = efivars->ops->get_variable(var->VariableName,
+					    &var->VendorGuid,
+					    &var->Attributes,
+					    &var->DataSize,
+					    var->Data);
 	spin_unlock(&efivars->lock);
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: get_variable() failed 0x%lx!\n",
@@ -299,11 +306,11 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	}
 
 	spin_lock(&efivars->lock);
-	status = efi.set_variable(new_var->VariableName,
-					&new_var->VendorGuid,
-					new_var->Attributes,
-					new_var->DataSize,
-					new_var->Data);
+	status = efivars->ops->set_variable(new_var->VariableName,
+					    &new_var->VendorGuid,
+					    new_var->Attributes,
+					    new_var->DataSize,
+					    new_var->Data);
 
 	spin_unlock(&efivars->lock);
 
@@ -446,11 +453,11 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	}
 
 	/* now *really* create the variable via EFI */
-	status = efi.set_variable(new_var->VariableName,
-			&new_var->VendorGuid,
-			new_var->Attributes,
-			new_var->DataSize,
-			new_var->Data);
+	status = efivars->ops->set_variable(new_var->VariableName,
+					    &new_var->VendorGuid,
+					    new_var->Attributes,
+					    new_var->DataSize,
+					    new_var->Data);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
@@ -511,11 +518,11 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	del_var->Attributes = 0;
 	del_var->DataSize = 0;
 
-	status = efi.set_variable(del_var->VariableName,
-			&del_var->VendorGuid,
-			del_var->Attributes,
-			del_var->DataSize,
-			del_var->Data);
+	status = efivars->ops->set_variable(del_var->VariableName,
+					    &del_var->VendorGuid,
+					    del_var->Attributes,
+					    del_var->DataSize,
+					    del_var->Data);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
@@ -719,6 +726,7 @@ static void unregister_efivars(struct efivars *efivars)
 }
 
 static int register_efivars(struct efivars *efivars,
+			    const struct efivar_operations *ops,
 			    struct kobject *parent_kobj)
 {
 	efi_status_t status = EFI_NOT_FOUND;
@@ -735,6 +743,7 @@ static int register_efivars(struct efivars *efivars,
 
 	spin_lock_init(&efivars->lock);
 	INIT_LIST_HEAD(&efivars->list);
+	efivars->ops = ops;
 
 	efivars->kset = kset_create_and_add("vars", NULL, parent_kobj);
 	if (!efivars->kset) {
@@ -751,7 +760,7 @@ static int register_efivars(struct efivars *efivars,
 	do {
 		variable_name_size = 1024;
 
-		status = efi.get_next_variable(&variable_name_size,
+		status = ops->get_next_variable(&variable_name_size,
 						variable_name,
 						&vendor_guid);
 		switch (status) {
@@ -782,6 +791,7 @@ out:
 }
 
 static struct efivars __efivars;
+static struct efivar_operations ops;
 
 /*
  * For now we register the efi subsystem with the firmware subsystem
@@ -809,7 +819,10 @@ efivars_init(void)
 		return -ENOMEM;
 	}
 
-	error = register_efivars(&__efivars, efi_kobj);
+	ops.get_variable = efi.get_variable;
+	ops.set_variable = efi.set_variable;
+	ops.get_next_variable = efi.get_next_variable;
+	error = register_efivars(&__efivars, &ops, efi_kobj);
 
 	/* Don't forget the systab entry */
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
-- 
1.7.4.1


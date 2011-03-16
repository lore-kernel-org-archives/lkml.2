Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1CPVVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:21:16 -0400
Received: from kroah.org ([198.145.64.141]:60952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab1CPVMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 48/50] efivars: Expose efivars functionality to external drivers.
Date: Wed, 16 Mar 2011 14:11:26 -0700
Message-Id: <1300309888-5028-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

Signed-off-by: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>,
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |   34 +++++++---------------------------
 include/linux/efi.h        |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index b10b7d7..ff0c373 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -89,28 +89,6 @@ MODULE_DESCRIPTION("sysfs interface to EFI Variables");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EFIVARS_VERSION);
 
-struct efivar_operations {
-	efi_get_variable_t *get_variable;
-	efi_get_next_variable_t *get_next_variable;
-	efi_set_variable_t *set_variable;
-};
-
-struct efivars {
-	/*
-	 * ->lock protects two things:
-	 * 1) ->list - adds, removals, reads, writes
-	 * 2) ops.[gs]et_variable() calls.
-	 * It must not be held when creating sysfs entries or calling kmalloc.
-	 * ops.get_next_variable() is only called from register_efivars(),
-	 * which is protected by the BKL, so that path is safe.
-	 */
-	spinlock_t lock;
-	struct list_head list;
-	struct kset *kset;
-	struct bin_attribute *new_var, *del_var;
-	const struct efivar_operations *ops;
-};
-
 /*
  * The maximum size of VariableName + Data = 1024
  * Therefore, it's reasonable to save that much
@@ -706,7 +684,7 @@ out_free:
 	return error;
 }
 
-static void unregister_efivars(struct efivars *efivars)
+void unregister_efivars(struct efivars *efivars)
 {
 	struct efivar_entry *entry, *n;
 
@@ -724,10 +702,11 @@ static void unregister_efivars(struct efivars *efivars)
 	kfree(efivars->del_var);
 	kset_unregister(efivars->kset);
 }
+EXPORT_SYMBOL_GPL(unregister_efivars);
 
-static int register_efivars(struct efivars *efivars,
-			    const struct efivar_operations *ops,
-			    struct kobject *parent_kobj)
+int register_efivars(struct efivars *efivars,
+		     const struct efivar_operations *ops,
+		     struct kobject *parent_kobj)
 {
 	efi_status_t status = EFI_NOT_FOUND;
 	efi_guid_t vendor_guid;
@@ -789,6 +768,7 @@ out:
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(register_efivars);
 
 static struct efivars __efivars;
 static struct efivar_operations ops;
@@ -810,7 +790,7 @@ efivars_init(void)
 	       EFIVARS_DATE);
 
 	if (!efi_enabled)
-		return -ENODEV;
+		return 0;
 
 	/* For now we'll register the efi directory at /sys/firmware/efi */
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index fb737bc..33fa120 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -397,4 +397,41 @@ static inline void memrange_efi_to_native(u64 *addr, u64 *npages)
 	*addr &= PAGE_MASK;
 }
 
+#if defined(CONFIG_EFI_VARS) || defined(CONFIG_EFI_VARS_MODULE)
+/*
+ * EFI Variable support.
+ *
+ * Different firmware drivers can expose their EFI-like variables using
+ * the following.
+ */
+
+struct efivar_operations {
+	efi_get_variable_t *get_variable;
+	efi_get_next_variable_t *get_next_variable;
+	efi_set_variable_t *set_variable;
+};
+
+struct efivars {
+	/*
+	 * ->lock protects two things:
+	 * 1) ->list - adds, removals, reads, writes
+	 * 2) ops.[gs]et_variable() calls.
+	 * It must not be held when creating sysfs entries or calling kmalloc.
+	 * ops.get_next_variable() is only called from register_efivars(),
+	 * which is protected by the BKL, so that path is safe.
+	 */
+	spinlock_t lock;
+	struct list_head list;
+	struct kset *kset;
+	struct bin_attribute *new_var, *del_var;
+	const struct efivar_operations *ops;
+};
+
+int register_efivars(struct efivars *efivars,
+		     const struct efivar_operations *ops,
+		     struct kobject *parent_kobj);
+void unregister_efivars(struct efivars *efivars);
+
+#endif /* CONFIG_EFI_VARS */
+
 #endif /* _LINUX_EFI_H */
-- 
1.7.4.1


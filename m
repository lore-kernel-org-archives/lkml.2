Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1CLBnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:43:47 -0500
Received: from smtp-out.google.com ([216.239.44.51]:59384 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab1CLBnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:43:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=SLeqWCyDCQIJf33OzJ+LZcgjEPgbZzeFpDw0AUJnfBjpK9BGNB42BZcyY52YPtfOc
	OxA35oxrDFoIERS+oI+CQ==
Subject: [PATCH v2 06/12] efivars: Expose efivars functionality to external
	drivers.
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Fri, 11 Mar 2011 17:43:27 -0800
Message-ID: <20110312014326.6133.69475.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Waychison <mikew@google.com>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1CLBnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:43:39 -0500
Received: from smtp-out.google.com ([74.125.121.67]:30505 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab1CLBnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:43:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=IovSb0sm4iNnOY2YSipKzYXeqNC/8MWXv6SxWpHahHHVj8DwxNLwE59N6kJFpBMPd
	hP7c/PrfTLXGijECpSPpQ==
Subject: [PATCH v2 04/12] efivars: Split out variable registration
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Fri, 11 Mar 2011 17:43:16 -0800
Message-ID: <20110312014316.6133.41171.stgit@mike.mtv.corp.google.com>
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

In anticipation of re-using the variable facilities in efivars from
elsewhere, split out the registration and unregistration of struct
efivars from the rest of the EFI specific sysfs code.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |  122 ++++++++++++++++++++++++--------------------
 1 files changed, 67 insertions(+), 55 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 5633018..f22bfcf 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -95,7 +95,7 @@ struct efivars {
 	 * 1) ->list - adds, removals, reads, writes
 	 * 2) efi.[gs]et_variable() calls.
 	 * It must not be held when creating sysfs entries or calling kmalloc.
-	 * efi.get_next_variable() is only called from efivars_init(),
+	 * efi.get_next_variable() is only called from register_efivars(),
 	 * which is protected by the BKL, so that path is safe.
 	 */
 	spinlock_t lock;
@@ -699,54 +699,48 @@ out_free:
 	return error;
 }
 
-static struct efivars __efivars;
+static void unregister_efivars(struct efivars *efivars)
+{
+	struct efivar_entry *entry, *n;
 
-/*
- * For now we register the efi subsystem with the firmware subsystem
- * and the vars subsystem with the efi subsystem.  In the future, it
- * might make sense to split off the efi subsystem into its own
- * driver, but for now only efivars will register with it, so just
- * include it here.
- */
+	list_for_each_entry_safe(entry, n, &efivars->list, list) {
+		spin_lock(&efivars->lock);
+		list_del(&entry->list);
+		spin_unlock(&efivars->lock);
+		efivar_unregister(entry);
+	}
+	if (efivars->new_var)
+		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->new_var);
+	if (efivars->del_var)
+		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
+	kfree(efivars->new_var);
+	kfree(efivars->del_var);
+	kset_unregister(efivars->kset);
+}
 
-static int __init
-efivars_init(void)
+static int register_efivars(struct efivars *efivars,
+			    struct kobject *parent_kobj)
 {
 	efi_status_t status = EFI_NOT_FOUND;
 	efi_guid_t vendor_guid;
 	efi_char16_t *variable_name;
 	unsigned long variable_name_size = 1024;
-	struct efivars *efivars = &__efivars;
 	int error = 0;
 
-	if (!efi_enabled)
-		return -ENODEV;
-
 	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
 	if (!variable_name) {
 		printk(KERN_ERR "efivars: Memory allocation failed.\n");
 		return -ENOMEM;
 	}
 
-	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
-	       EFIVARS_DATE);
-
-	/* For now we'll register the efi directory at /sys/firmware/efi */
-	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
-	if (!efi_kobj) {
-		printk(KERN_ERR "efivars: Firmware registration failed.\n");
-		error = -ENOMEM;
-		goto out_free;
-	}
-
 	spin_lock_init(&efivars->lock);
 	INIT_LIST_HEAD(&efivars->list);
 
-	efivars->kset = kset_create_and_add("vars", NULL, efi_kobj);
+	efivars->kset = kset_create_and_add("vars", NULL, parent_kobj);
 	if (!efivars->kset) {
 		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
 		error = -ENOMEM;
-		goto out_firmware_unregister;
+		goto out;
 	}
 
 	/*
@@ -778,21 +772,54 @@ efivars_init(void)
 	} while (status != EFI_NOT_FOUND);
 
 	error = create_efivars_bin_attributes(efivars);
-
-	/* Don't forget the systab entry */
-	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
 	if (error)
-		printk(KERN_ERR "efivars: Sysfs attribute export failed with error %d.\n", error);
-	else
-		goto out_free;
+		unregister_efivars(efivars);
 
-	kset_unregister(efivars->kset);
+out:
+	kfree(variable_name);
 
-out_firmware_unregister:
-	kobject_put(efi_kobj);
+	return error;
+}
 
-out_free:
-	kfree(variable_name);
+static struct efivars __efivars;
+
+/*
+ * For now we register the efi subsystem with the firmware subsystem
+ * and the vars subsystem with the efi subsystem.  In the future, it
+ * might make sense to split off the efi subsystem into its own
+ * driver, but for now only efivars will register with it, so just
+ * include it here.
+ */
+
+static int __init
+efivars_init(void)
+{
+	int error = 0;
+
+	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
+	       EFIVARS_DATE);
+
+	if (!efi_enabled)
+		return -ENODEV;
+
+	/* For now we'll register the efi directory at /sys/firmware/efi */
+	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
+	if (!efi_kobj) {
+		printk(KERN_ERR "efivars: Firmware registration failed.\n");
+		return -ENOMEM;
+	}
+
+	error = register_efivars(&__efivars, efi_kobj);
+
+	/* Don't forget the systab entry */
+	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
+	if (error) {
+		printk(KERN_ERR
+		       "efivars: Sysfs attribute export failed with error %d.\n",
+		       error);
+		unregister_efivars(&__efivars);
+		kobject_put(efi_kobj);
+	}
 
 	return error;
 }
@@ -800,22 +827,7 @@ out_free:
 static void __exit
 efivars_exit(void)
 {
-	struct efivars *efivars = &__efivars;
-	struct efivar_entry *entry, *n;
-
-	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		spin_lock(&efivars->lock);
-		list_del(&entry->list);
-		spin_unlock(&efivars->lock);
-		efivar_unregister(entry);
-	}
-	if (efivars->new_var)
-		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->new_var);
-	if (efivars->del_var)
-		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
-	kfree(efivars->new_var);
-	kfree(efivars->del_var);
-	kset_unregister(efivars->kset);
+	unregister_efivars(&__efivars);
 	kobject_put(efi_kobj);
 }
 


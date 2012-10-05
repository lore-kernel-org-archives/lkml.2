Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab2JEG4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:56:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39162 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab2JEG4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:56:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2/3] efi: add efivars kobject to efi sysfs folder
Message-Id: <1349416496.810874.88263724621.2.gpush@pecola>
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

From: Lee, Chun-Yi <joeyli.kernel@gmail.com>

UEFI variable filesystem need a new mount point, so this patch add
efivars kobject to efi_kobj for create a /sys/firmware/efi/efivars
folder.

Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 drivers/firmware/efivars.c |   11 +++++++++++
 include/linux/efi.h        |    1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 4174f1b..e1253d6 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1487,6 +1487,7 @@ void unregister_efivars(struct efivars *efivars)
 		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
 	kfree(efivars->new_var);
 	kfree(efivars->del_var);
+	kobject_put(efivars->kobject);
 	kset_unregister(efivars->kset);
 }
 EXPORT_SYMBOL_GPL(unregister_efivars);
@@ -1518,6 +1519,13 @@ int register_efivars(struct efivars *efivars,
 		goto out;
 	}
 
+	efivars->kobject = kobject_create_and_add("efivars", parent_kobj);
+	if (!efivars->kobject) {
+		pr_err("efivars: Subsystem registration failed.\n");
+		error = -ENOMEM;
+		goto err_unreg_vars;
+	}
+
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
 	 * the variable name and variable data is 1024 bytes.
@@ -1562,6 +1570,9 @@ int register_efivars(struct efivars *efivars,
 
 	register_filesystem(&efivarfs_type);
 
+err_unreg_vars:
+	kset_unregister(efivars->kset);
+
 out:
 	kfree(variable_name);
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1829a97..c993f54 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -654,6 +654,7 @@ struct efivars {
 	spinlock_t lock;
 	struct list_head list;
 	struct kset *kset;
+	struct kobject *kobject;
 	struct bin_attribute *new_var, *del_var;
 	const struct efivar_operations *ops;
 	struct efivar_entry *walk_entry;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2JDCbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 22:31:37 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:49963 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2JDCbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 22:31:36 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, glin@suse.com,
        "Lee, Chun-Yi" <jlee@suse.com>, Matt Fleming <matt.fleming@intel.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] efi: add efivars kobject to efi sysfs folder
Date: Thu,  4 Oct 2012 10:24:46 +0800
Message-Id: <1349317486-30006-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UEFI variable filesystem need a new mount point, so this patch add
efivars kobject to efi_kobj for create a /sys/firmware/efi/efivars
folder.

Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/firmware/efivars.c |   11 +++++++++++
 include/linux/efi.h        |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 1e1aad0..7c1234e 100644
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
 
 	register_filesystem(&efivars_fs_type);
 
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
-- 
1.7.7


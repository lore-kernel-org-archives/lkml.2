Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab2JEG6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:58:22 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:54900 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2JEG6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:58:18 -0400
Subject: Re: [PATCH 2/3] efi: add efivars kobject to efi sysfs folder
From: joeyli <jlee@suse.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, glin@suse.com,
        Lee@grenadilla.canonical.com, Matthew Garrett <mjg@redhat.com>,
        Peter Jones <pjones@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
In-Reply-To: <1349416496.810874.88263724621.2.gpush@pecola>
References: <1349416496.810874.88263724621.2.gpush@pecola>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Oct 2012 14:51:18 +0800
Message-ID: <1349419878.7884.15.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy, 

於 五，2012-10-05 於 13:54 +0800，Jeremy Kerr 提到：
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 4174f1b..e1253d6 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -1487,6 +1487,7 @@ void unregister_efivars(struct efivars *efivars)
>                 sysfs_remove_bin_file(&efivars->kset->kobj,
> efivars->del_var);
>         kfree(efivars->new_var);
>         kfree(efivars->del_var);
> +       kobject_put(efivars->kobject);
>         kset_unregister(efivars->kset);
>  }
>  EXPORT_SYMBOL_GPL(unregister_efivars);
> @@ -1518,6 +1519,13 @@ int register_efivars(struct efivars *efivars,


Since more people prefer to use "efivarfs", so, I modified the patch for
replace "efivars" to "efivarfs" like following:


Thanks
Joey Lee


>From 5e64382a9a4ad538dd5ca94072d19c7a70e4c650 Mon Sep 17 00:00:00 2001
From: Lee, Chun-Yi <jlee@suse.com>
Date: Sat, 15 Sep 2012 10:33:46 +0800
Subject: [PATCH] efi: add efivarfs kobject to efi sysfs folder

UEFI variable filesystem need a new mount point, so this patch add
efivarfs kobject to efi_kobj for create a /sys/firmware/efi/efivarfs
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
 
+	efivars->kobject = kobject_create_and_add("efivarfs", parent_kobj);
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

 


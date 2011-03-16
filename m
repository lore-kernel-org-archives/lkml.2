Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1CPVVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:21:31 -0400
Received: from kroah.org ([198.145.64.141]:60920 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab1CPVMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/50] efivars: Make efivars bin_attributes dynamic
Date: Wed, 16 Mar 2011 14:11:22 -0700
Message-Id: <1300309888-5028-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

In preparation for encapsulating efivars, we need to have the
bin_attributes be dynamically allocated so that we can use their
->private fields to get back to the struct efivars structure.

Signed-off-by: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>,
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/efivars.c |   93 ++++++++++++++++++++++++++++++++------------
 1 files changed, 68 insertions(+), 25 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index f10ecb6..528ce47 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -101,6 +101,7 @@ struct efivars {
 	spinlock_t lock;
 	struct list_head list;
 	struct kset *kset;
+	struct bin_attribute *new_var, *del_var;
 };
 static struct efivars __efivars;
 static struct efivars *efivars = &__efivars;
@@ -525,16 +526,6 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute var_subsys_attr_new_var = {
-	.attr = {.name = "new_var", .mode = 0200},
-	.write = efivar_create,
-};
-
-static struct bin_attribute var_subsys_attr_del_var = {
-	.attr = {.name = "del_var", .mode = 0200},
-	.write = efivar_delete,
-};
-
 /*
  * Let's not leave out systab information that snuck into
  * the efivars driver
@@ -640,6 +631,66 @@ efivar_create_sysfs_entry(unsigned long variable_name_size,
 
 	return 0;
 }
+
+static int
+create_efivars_bin_attributes(struct efivars *efivars)
+{
+	struct bin_attribute *attr;
+	int error;
+
+	/* new_var */
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	attr->attr.name = "new_var";
+	attr->attr.mode = 0200;
+	attr->write = efivar_create;
+	attr->private = efivars;
+	efivars->new_var = attr;
+
+	/* del_var */
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr) {
+		error = -ENOMEM;
+		goto out_free;
+	}
+	attr->attr.name = "del_var";
+	attr->attr.mode = 0200;
+	attr->write = efivar_delete;
+	attr->private = efivars;
+	efivars->del_var = attr;
+
+	sysfs_bin_attr_init(efivars->new_var);
+	sysfs_bin_attr_init(efivars->del_var);
+
+	/* Register */
+	error = sysfs_create_bin_file(&efivars->kset->kobj,
+				      efivars->new_var);
+	if (error) {
+		printk(KERN_ERR "efivars: unable to create new_var sysfs file"
+			" due to error %d\n", error);
+		goto out_free;
+	}
+	error = sysfs_create_bin_file(&efivars->kset->kobj,
+				      efivars->del_var);
+	if (error) {
+		printk(KERN_ERR "efivars: unable to create del_var sysfs file"
+			" due to error %d\n", error);
+		sysfs_remove_bin_file(&efivars->kset->kobj,
+				      efivars->new_var);
+		goto out_free;
+	}
+
+	return 0;
+out_free:
+	kfree(efivars->new_var);
+	efivars->new_var = NULL;
+	kfree(efivars->new_var);
+	efivars->new_var = NULL;
+	return error;
+}
+
 /*
  * For now we register the efi subsystem with the firmware subsystem
  * and the vars subsystem with the efi subsystem.  In the future, it
@@ -714,20 +765,7 @@ efivars_init(void)
 		}
 	} while (status != EFI_NOT_FOUND);
 
-	/*
-	 * Now add attributes to allow creation of new vars
-	 * and deletion of existing ones...
-	 */
-	error = sysfs_create_bin_file(&efivars->kset->kobj,
-				      &var_subsys_attr_new_var);
-	if (error)
-		printk(KERN_ERR "efivars: unable to create new_var sysfs file"
-			" due to error %d\n", error);
-	error = sysfs_create_bin_file(&efivars->kset->kobj,
-				      &var_subsys_attr_del_var);
-	if (error)
-		printk(KERN_ERR "efivars: unable to create del_var sysfs file"
-			" due to error %d\n", error);
+	error = create_efivars_bin_attributes(efivars);
 
 	/* Don't forget the systab entry */
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
@@ -758,7 +796,12 @@ efivars_exit(void)
 		spin_unlock(&efivars->lock);
 		efivar_unregister(entry);
 	}
-
+	if (efivars->new_var)
+		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->new_var);
+	if (efivars->del_var)
+		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
+	kfree(efivars->new_var);
+	kfree(efivars->del_var);
 	kset_unregister(efivars->kset);
 	kobject_put(efi_kobj);
 }
-- 
1.7.4.1


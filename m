Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1CLBp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:45:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:59321 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab1CLBnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:43:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=WHJ3IZ84oazYa/qmFdXyuNYEBfX1mBtPre4Fced2aBjspmlQLc5NrmJPE5soGs0/q
	cE6G0RxreycIKCV8cojug==
Subject: [PATCH v2 02/12] efivars: Make efivars bin_attributes dynamic
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Fri, 11 Mar 2011 17:43:06 -0800
Message-ID: <20110312014305.6133.7681.stgit@mike.mtv.corp.google.com>
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

In preparation for encapsulating efivars, we need to have the
bin_attributes be dynamically allocated so that we can use their
->private fields to get back to the struct efivars structure.

Signed-off-by: Mike Waychison <mikew@google.com>
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


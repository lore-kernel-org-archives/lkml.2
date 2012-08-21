Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab2HUQxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:53:53 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:45756 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab2HUQxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:53:50 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [RFC][PATCH v3 1/3] efivars: Disable external interrupt while
 holding efivars->lock
Thread-Topic: [RFC][PATCH v3 1/3] efivars: Disable external interrupt while
 holding efivars->lock
Thread-Index: Ac1/vYJzsJqBOSy5SGSe5BIgm/JNLw==
Date: Tue, 21 Aug 2012 16:53:38 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413806C22@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-21_05:2012-08-21,2012-08-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208210163
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Problem]
 Currently, efivars doesn't disable interrupt while taking efivars->lock.
 So, there is a risk to be deadlocking in a write callback of efi_pstore
 if kernel panics in interrupt context while taking efivars->lock.

[Patch Description]
 This patch disables an external interruption while holding efivars->lock as follows

 - In efi_pstore_open()/efi_pstore_close(), replace spin_lock/spin_unlock with spin_lock_irq/spin_unlock_irq
   because they are called in a process context when users access to /dev/pstore.

 - In unregister_efivars(), replace them with spin_lock_irq/spin_unlock_irq
   because they are called in a process context when unloading this module.

 - Also, in efivar_create()/efivar_store_raw()/efivar_delete(), replace them with spin_lock_irq/spin_unlock_irq
   because they are called in a process context when users access to /sys/firmware/efi/vars/{new_var|del_var}.

 - In other function calls, replace spin_lock/spin_unlock them with spin_lock_irqsave/spin_unlock_irqrestore.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 drivers/firmware/efivars.c |   43 +++++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 47408e8..bd1df01 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -393,10 +393,11 @@ static efi_status_t
 get_var_data(struct efivars *efivars, struct efi_variable *var)
 {
 	efi_status_t status;
+	unsigned long flags;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 	status = get_var_data_locked(efivars, var);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: get_variable() failed 0x%lx!\n",
@@ -514,14 +515,14 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	status = efivars->ops->set_variable(new_var->VariableName,
 					    &new_var->VendorGuid,
 					    new_var->Attributes,
 					    new_var->DataSize,
 					    new_var->Data);
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
@@ -632,7 +633,7 @@ static int efi_pstore_open(struct pstore_info *psi)
 {
 	struct efivars *efivars = psi->data;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 	efivars->walk_entry = list_first_entry(&efivars->list,
 					       struct efivar_entry, list);
 	return 0;
@@ -642,7 +643,7 @@ static int efi_pstore_close(struct pstore_info *psi)
 {
 	struct efivars *efivars = psi->data;
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	return 0;
 }
 
@@ -696,11 +697,12 @@ static int efi_pstore_write(enum pstore_type_id type,
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
 	int i, ret = 0;
+	unsigned long flags;
 
 	sprintf(stub_name, "dump-type%u-%u-", type, part);
 	sprintf(name, "%s%lu", stub_name, get_seconds());
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = stub_name[i];
@@ -738,7 +740,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
 				   size, psi->buf);
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (found)
 		efivar_unregister(found);
@@ -822,7 +824,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	/*
 	 * Does this variable already exist?
@@ -840,7 +842,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		}
 	}
 	if (found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 
@@ -854,10 +856,10 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
 			status);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EIO;
 	}
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 
 	/* Create the entry in sysfs.  Locking is not required here */
 	status = efivar_create_sysfs_entry(efivars,
@@ -885,7 +887,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irq(&efivars->lock);
 
 	/*
 	 * Does this variable already exist?
@@ -903,7 +905,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 		}
 	}
 	if (!found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EINVAL;
 	}
 	/* force the Attributes/DataSize to 0 to ensure deletion */
@@ -919,12 +921,12 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
 			status);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		return -EIO;
 	}
 	list_del(&search_efivar->list);
 	/* We need to release this lock before unregistering. */
-	spin_unlock(&efivars->lock);
+	spin_unlock_irq(&efivars->lock);
 	efivar_unregister(search_efivar);
 
 	/* It's dead Jim.... */
@@ -993,6 +995,7 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	int i, short_name_size = variable_name_size / sizeof(efi_char16_t) + 38;
 	char *short_name;
 	struct efivar_entry *new_efivar;
+	unsigned long flags;
 
 	short_name = kzalloc(short_name_size + 1, GFP_KERNEL);
 	new_efivar = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
@@ -1032,9 +1035,9 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	kfree(short_name);
 	short_name = NULL;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 	list_add(&new_efivar->list, &efivars->list);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	return 0;
 }
@@ -1103,9 +1106,9 @@ void unregister_efivars(struct efivars *efivars)
 	struct efivar_entry *entry, *n;
 
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		spin_lock(&efivars->lock);
+		spin_lock_irq(&efivars->lock);
 		list_del(&entry->list);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irq(&efivars->lock);
 		efivar_unregister(entry);
 	}
 	if (efivars->new_var)
-- 1.7.1 


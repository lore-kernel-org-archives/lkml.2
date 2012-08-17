Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab2HQTmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:42:44 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:36488 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab2HQTmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:42:35 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [RFC][PATCH 1/2] efivars: Disable external interrupt while holding
 efivars->lock 
Thread-Topic: [RFC][PATCH 1/2] efivars: Disable external interrupt while
 holding efivars->lock 
Thread-Index: Ac18sFlJoz2zbuxGTki/L0FDmmhr2w==
Date: Fri, 17 Aug 2012 19:42:21 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41380007C@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-17_03:2012-08-17,2012-08-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208170207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Problem]
 Currently, efivars doesn't disable interrupt while taking efivars->lock.
 So, there is a risk to be deadlocking in a write callback of efi_pstore
 if kernel panics in interrupt context while taking efivars->lock.

[Patch Description]
 This patch disables an external interruption while holding efivars->lock by
 replacing spin_lock/spin_unlock with spin_lock_irqsave/spin_unlock_irqrestore.

 As for spin_locks in open/close callbacks of efi_pstore, they moved to a read callback
 to pass a flags argument to spin_lock_irqsave/spin_unlock_irqrestore.

 Even if spin_locks in open/close callbacks are erased, a whole process of open/read/close 
 is still serialized by psinfo->read_mutex which is taken in a pstore layer.

 Also, initialization of efivars->walk_entry moved to a read callback to protect list_first_entry() 
 with efivars->lock. And some comments about efivars->walk_entry are added to avoid using it 
 without taking psinfo->read_mutex.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 drivers/firmware/efivars.c |   66 ++++++++++++++++++++++++++-----------------
 include/linux/efi.h        |    3 ++
 2 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 47408e8..b6a813e 100644
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
@@ -488,6 +489,7 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	struct efi_variable *new_var, *var = &entry->var;
 	struct efivars *efivars = entry->efivars;
 	efi_status_t status = EFI_NOT_FOUND;
+	unsigned long flags;
 
 	if (count != sizeof(struct efi_variable))
 		return -EINVAL;
@@ -514,14 +516,14 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 	status = efivars->ops->set_variable(new_var->VariableName,
 					    &new_var->VendorGuid,
 					    new_var->Attributes,
 					    new_var->DataSize,
 					    new_var->Data);
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
@@ -630,19 +632,11 @@ efivar_unregister(struct efivar_entry *var)
 
 static int efi_pstore_open(struct pstore_info *psi)
 {
-	struct efivars *efivars = psi->data;
-
-	spin_lock(&efivars->lock);
-	efivars->walk_entry = list_first_entry(&efivars->list,
-					       struct efivar_entry, list);
 	return 0;
 }
 
 static int efi_pstore_close(struct pstore_info *psi)
 {
-	struct efivars *efivars = psi->data;
-
-	spin_unlock(&efivars->lock);
 	return 0;
 }
 
@@ -656,6 +650,17 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	int i;
 	unsigned int part, size;
 	unsigned long time;
+	static unsigned long flags;
+
+	/*
+	 * efivars->walk_entry is protected by pstore_info.read_mutex
+	 */
+	if (!efivars->walk_entry) {
+		spin_lock_irqsave(&efivars->lock, flags);
+		efivars->walk_entry = list_first_entry(&efivars->list,
+						       struct efivar_entry,
+						       list);
+	}
 
 	while (&efivars->walk_entry->list != &efivars->list) {
 		if (!efi_guidcmp(efivars->walk_entry->var.VendorGuid,
@@ -682,6 +687,10 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 		efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
 						 struct efivar_entry, list);
 	}
+
+	efivars->walk_entry = NULL;
+	spin_unlock_irqrestore(&efivars->lock, flags);
+
 	return 0;
 }
 
@@ -696,11 +705,12 @@ static int efi_pstore_write(enum pstore_type_id type,
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
@@ -738,7 +748,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
 				   size, psi->buf);
 
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	if (found)
 		efivar_unregister(found);
@@ -812,6 +822,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	unsigned long strsize1, strsize2;
 	efi_status_t status = EFI_NOT_FOUND;
 	int found = 0;
+	unsigned long flags;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -822,7 +833,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 
 	/*
 	 * Does this variable already exist?
@@ -840,7 +851,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 		}
 	}
 	if (found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irqrestore(&efivars->lock, flags);
 		return -EINVAL;
 	}
 
@@ -854,10 +865,10 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
 			status);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irqrestore(&efivars->lock, flags);
 		return -EIO;
 	}
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	/* Create the entry in sysfs.  Locking is not required here */
 	status = efivar_create_sysfs_entry(efivars,
@@ -881,11 +892,12 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	unsigned long strsize1, strsize2;
 	efi_status_t status = EFI_NOT_FOUND;
 	int found = 0;
+	unsigned long flags;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 
 	/*
 	 * Does this variable already exist?
@@ -903,7 +915,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 		}
 	}
 	if (!found) {
-		spin_unlock(&efivars->lock);
+		spin_unlock_irqrestore(&efivars->lock, flags);
 		return -EINVAL;
 	}
 	/* force the Attributes/DataSize to 0 to ensure deletion */
@@ -919,12 +931,12 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (status != EFI_SUCCESS) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
 			status);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irqrestore(&efivars->lock, flags);
 		return -EIO;
 	}
 	list_del(&search_efivar->list);
 	/* We need to release this lock before unregistering. */
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 	efivar_unregister(search_efivar);
 
 	/* It's dead Jim.... */
@@ -993,6 +1005,7 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	int i, short_name_size = variable_name_size / sizeof(efi_char16_t) + 38;
 	char *short_name;
 	struct efivar_entry *new_efivar;
+	unsigned long flags;
 
 	short_name = kzalloc(short_name_size + 1, GFP_KERNEL);
 	new_efivar = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
@@ -1032,9 +1045,9 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	kfree(short_name);
 	short_name = NULL;
 
-	spin_lock(&efivars->lock);
+	spin_lock_irqsave(&efivars->lock, flags);
 	list_add(&new_efivar->list, &efivars->list);
-	spin_unlock(&efivars->lock);
+	spin_unlock_irqrestore(&efivars->lock, flags);
 
 	return 0;
 }
@@ -1101,11 +1114,12 @@ out_free:
 void unregister_efivars(struct efivars *efivars)
 {
 	struct efivar_entry *entry, *n;
+	unsigned long flags;
 
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		spin_lock(&efivars->lock);
+		spin_lock_irqsave(&efivars->lock, flags);
 		list_del(&entry->list);
-		spin_unlock(&efivars->lock);
+		spin_unlock_irqrestore(&efivars->lock, flags);
 		efivar_unregister(entry);
 	}
 	if (efivars->new_var)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 103adc6..f1f5703 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -649,6 +649,9 @@ struct efivars {
 	struct kset *kset;
 	struct bin_attribute *new_var, *del_var;
 	const struct efivar_operations *ops;
+	/*
+	 * walk_entry is protected by pstore_info.read_mutex
+	 */
 	struct efivar_entry *walk_entry;
 	struct pstore_info efi_pstore_info;
 };
-- 1.7.1

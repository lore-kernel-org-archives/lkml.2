Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1ICF3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 01:29:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:12948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1ICF3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 01:29:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,323,1312182000"; 
   d="scan'208";a="45235521"
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com, mjg59@srcf.ucam.org
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 2/2] pstore: update the policy of the UEFI-based backend
Date: Sat,  3 Sep 2011 13:30:17 +0800
Message-Id: <1315027817-5316-3-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.7.rc0.70.g82660
In-Reply-To: <1315027817-5316-1-git-send-email-gong.chen@linux.intel.com>
References: <1315027817-5316-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UEFI-based backend only employs one group records to save
dumped information, which means new log will overwrite old one.
It doesn't make sense because in fact the older log is nearer
to the truth. Update its policy to comply with ERST logic.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 drivers/firmware/efivars.c |  108 +++++++++++++++++++++++++------------------
 1 files changed, 63 insertions(+), 45 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index fe07673..f33302d 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -463,8 +463,7 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	struct efivars *efivars = psi->data;
 	char name[DUMP_NAME_LEN];
 	int i;
-	unsigned int part, size;
-	unsigned long time;
+	unsigned int size;
 
 	while (&efivars->walk_entry->list != &efivars->list) {
 		if (!efi_guidcmp(efivars->walk_entry->var.VendorGuid,
@@ -472,9 +471,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			for (i = 0; i < DUMP_NAME_LEN; i++) {
 				name[i] = efivars->walk_entry->var.VariableName[i];
 			}
-			if (sscanf(name, "dump-type%u-%u-%lu", type, &part, &time) == 3) {
-				*id = part;
-				timespec->tv_sec = time;
+			if (sscanf(name, "dump-type%u-%llu", type, id) == 2) {
+				timespec->tv_sec = *id;
 				timespec->tv_nsec = 0;
 				get_var_data_locked(efivars, &efivars->walk_entry->var);
 				size = efivars->walk_entry->var.DataSize;
@@ -494,24 +492,59 @@ static int efi_pstore_write(enum pstore_type_id type, u64 *id,
 		unsigned int part, size_t size, struct pstore_info *psi)
 {
 	char name[DUMP_NAME_LEN];
+	efi_char16_t efi_name[DUMP_NAME_LEN];
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	struct efivars *efivars = psi->data;
+	efi_status_t status = EFI_NOT_FOUND;
+	int i, ret;
+	unsigned int time;
+
+	if (size == 0)
+		return -1;
+
+	time = get_seconds();
+	/* assume time + part = monotonic increasing */
+	*id = time + part;
+	sprintf(name, "dump-type%u-%llu", type, *id);
+
+	spin_lock(&efivars->lock);
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = name[i];
+
+	status = efivars->ops->set_variable(efi_name, &vendor,
+		PSTORE_EFI_ATTRIBUTES, size, psi->buf);
+	spin_unlock(&efivars->lock);
+
+	if (status != EFI_SUCCESS) {
+		printk(KERN_WARNING "efivars: set_variable() failed: "
+			"status=%lx\n", status);
+		return -EIO;
+	}
+
+	ret = efivar_create_sysfs_entry(efivars,
+		utf16_strsize(efi_name, DUMP_NAME_LEN * 2), efi_name, &vendor);
+
+	return ret;
+};
+
+static int efi_pstore_erase(enum pstore_type_id type, u64 id,
+			    struct pstore_info *psi)
+{
 	char stub_name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
-	int i, ret = 0;
-
-	sprintf(stub_name, "dump-type%u-%u-", type, part);
-	sprintf(name, "%s%lu", stub_name, get_seconds());
+	efi_status_t status = EFI_NOT_FOUND;
+	int i;
 
-	spin_lock(&efivars->lock);
+	sprintf(stub_name, "dump-type%u-%llu", type, id);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = stub_name[i];
 
-	/*
-	 * Clean up any entries with the same name
-	 */
+	spin_lock(&efivars->lock);
 
 	list_for_each_entry(entry, &efivars->list, list) {
 		get_var_data_locked(efivars, &entry->var);
@@ -521,46 +554,31 @@ static int efi_pstore_write(enum pstore_type_id type, u64 *id,
 		if (utf16_strncmp(entry->var.VariableName, efi_name,
 				  utf16_strlen(efi_name)))
 			continue;
-		/* Needs to be a prefix */
-		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
-			continue;
 
 		/* found */
 		found = entry;
-		efivars->ops->set_variable(entry->var.VariableName,
-					   &entry->var.VendorGuid,
-					   PSTORE_EFI_ATTRIBUTES,
-					   0, NULL);
+		break;
 	}
 
-	if (found)
-		list_del(&found->list);
-
-	for (i = 0; i < DUMP_NAME_LEN; i++)
-		efi_name[i] = name[i];
+	if (!found) {
+		spin_unlock(&efivars->lock);
+		return -EINVAL;
+	}
 
-	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
-				   size, psi->buf);
+	status = efivars->ops->set_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid,
+				   PSTORE_EFI_ATTRIBUTES,
+				   0, NULL);
+	if (status != EFI_SUCCESS) {
+		printk(KERN_WARNING "efivars: set_variable() failed: "
+			"status=%lx\n", status);
+		spin_unlock(&efivars->lock);
+		return -EIO;
+	}
 
+	list_del(&found->list);
 	spin_unlock(&efivars->lock);
-
-	if (found)
-		efivar_unregister(found);
-
-	if (size)
-		ret = efivar_create_sysfs_entry(efivars,
-					  utf16_strsize(efi_name,
-							DUMP_NAME_LEN * 2),
-					  efi_name, &vendor);
-
-	*id = part;
-	return ret;
-};
-
-static int efi_pstore_erase(enum pstore_type_id type, u64 id,
-			    struct pstore_info *psi)
-{
-	efi_pstore_write(type, &id, (unsigned int)id, 0, psi);
+	efivar_unregister(found);
 
 	return 0;
 }
-- 
1.7.7.rc0.70.g82660


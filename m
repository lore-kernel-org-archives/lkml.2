Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab1FGPsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:48:50 -0400
Received: from usindmx01.hds.com ([207.126.252.12]:59967 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1FGPst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:48:49 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matthew Garrett <mjg@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>
Date: Tue, 7 Jun 2011 11:47:38 -0400
Subject: RE: [PATCH 3/3] efi: Add support for using efivars as a pstore
 backend
Thread-Topic: [PATCH 3/3] efi: Add support for using efivars as a pstore
 backend
Thread-Index: AcwkgXRl/obUDSELRuiTwDzgoptlwgAqHVIg
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C17497E04@USINDEVS01.corp.hds.com>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
 <1307389135-8150-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1307389135-8150-3-git-send-email-mjg@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, I have suggested similar patches.
Does your patch satisfy my purpose?


[RFC][PATCH] kmsg_dumper for NVRAM
http://choon.net/forum/read.php?21,84718


[RFC][PATCH] pstore: EFI Support
http://choon.net/forum/read.php?21,84718,85162

Seiji

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Matthew Garrett
>Sent: Monday, June 06, 2011 3:39 PM
>To: tony.luck@intel.com
>Cc: linux-kernel@vger.kernel.org; Matt_Domsch@dell.com; Matthew Garrett
>Subject: [PATCH 3/3] efi: Add support for using efivars as a pstore backend
>
>EFI provides an area of nonvolatile storage managed by the firmware. We
>can use this as a pstore backend to maintain copies of oopses, aiding
>diagnosis.
>
>Signed-off-by: Matthew Garrett <mjg@redhat.com>
>---
> drivers/firmware/efivars.c |  158 +++++++++++++++++++++++++++++++++++++++++++-
> include/linux/efi.h        |    3 +
> 2 files changed, 159 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
>index 5f29aaf..89e6a3a 100644
>--- a/drivers/firmware/efivars.c
>+++ b/drivers/firmware/efivars.c
>@@ -78,6 +78,7 @@
> #include <linux/kobject.h>
> #include <linux/device.h>
> #include <linux/slab.h>
>+#include <linux/pstore.h>
>
> #include <asm/uaccess.h>
>
>@@ -89,6 +90,8 @@ MODULE_DESCRIPTION("sysfs interface to EFI Variables");
> MODULE_LICENSE("GPL");
> MODULE_VERSION(EFIVARS_VERSION);
>
>+#define DUMP_NAME_LEN 52
>+
> /*
>  * The maximum size of VariableName + Data = 1024
>  * Therefore, it's reasonable to save that much
>@@ -161,18 +164,28 @@ utf8_strsize(efi_char16_t *data, unsigned long maxlength)
> }
>
> static efi_status_t
>-get_var_data(struct efivars *efivars, struct efi_variable *var)
>+get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
> {
> 	efi_status_t status;
>
>-	spin_lock(&efivars->lock);
> 	var->DataSize = 1024;
> 	status = efivars->ops->get_variable(var->VariableName,
> 					    &var->VendorGuid,
> 					    &var->Attributes,
> 					    &var->DataSize,
> 					    var->Data);
>+	return status;
>+}
>+
>+static efi_status_t
>+get_var_data(struct efivars *efivars, struct efi_variable *var)
>+{
>+	efi_status_t status;
>+
>+	spin_lock(&efivars->lock);
>+	status = get_var_data_locked(efivars, var);
> 	spin_unlock(&efivars->lock);
>+
> 	if (status != EFI_SUCCESS) {
> 		printk(KERN_WARNING "efivars: get_variable() failed 0x%lx!\n",
> 			status);
>@@ -387,12 +400,145 @@ static struct kobj_type efivar_ktype = {
> 	.default_attrs = def_attrs,
> };
>
>+static struct efivar_entry *walk_entry;
>+
>+static struct pstore_info efi_pstore_info;
>+
> static inline void
> efivar_unregister(struct efivar_entry *var)
> {
> 	kobject_put(&var->kobj);
> }
>
>+static int efi_pstore_open(struct pstore_info *psi)
>+{
>+	struct efivars *efivars = psi->data;
>+
>+	spin_lock(&efivars->lock);
>+	walk_entry = list_first_entry(&efivars->list, struct efivar_entry,
>+				      list);
>+	return 0;
>+}
>+
>+static int efi_pstore_close(struct pstore_info *psi)
>+{
>+	struct efivars *efivars = psi->data;
>+
>+	spin_unlock(&efivars->lock);
>+	return 0;
>+}
>+
>+static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>+			       struct timespec *timespec, struct pstore_info *psi)
>+{
>+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
>+	struct efivars *efivars = psi->data;
>+	char name[DUMP_NAME_LEN];
>+	int i;
>+	unsigned int part, size;
>+	unsigned long time;
>+
>+	while (&walk_entry->list != &efivars->list) {
>+		if (!efi_guidcmp(walk_entry->var.VendorGuid, vendor)) {
>+			for (i = 0; i < DUMP_NAME_LEN; i++) {
>+				name[i] = walk_entry->var.VariableName[i];
>+			}
>+			if (sscanf(name, "dump-type%u-%u-%lu", type, &part, &time) == 3) {
>+				*id = part;
>+				timespec->tv_sec = time;
>+				timespec->tv_nsec = 0;
>+				get_var_data_locked(efivars, &walk_entry->var);
>+				size = walk_entry->var.DataSize;
>+				memcpy(psi->buf, walk_entry->var.Data, size);
>+				walk_entry = list_entry(walk_entry->list.next,
>+					           struct efivar_entry, list);
>+				return size;
>+			}
>+		}
>+		walk_entry = list_entry(walk_entry->list.next,
>+					struct efivar_entry, list);
>+	}
>+	return 0;
>+}
>+
>+static u64 efi_pstore_write(enum pstore_type_id type, int part, size_t size,
>+			    struct pstore_info *psi)
>+{
>+	char name[DUMP_NAME_LEN];
>+	char stub_name[DUMP_NAME_LEN];
>+	efi_char16_t efi_name[DUMP_NAME_LEN];
>+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
>+	struct efivars *efivars = psi->data;
>+	struct efivar_entry *entry, *found = NULL;
>+	int i;
>+
>+	sprintf(stub_name, "dump-type%u-%u-", type, part);
>+	sprintf(name, "%s%lu", stub_name, get_seconds());
>+
>+	spin_lock(&efivars->lock);
>+
>+	for (i = 0; i < DUMP_NAME_LEN; i++)
>+		efi_name[i] = stub_name[i];
>+
>+	/*
>+	 * Clean up any entries with the same name
>+	 */
>+
>+	list_for_each_entry(entry, &efivars->list, list) {
>+		get_var_data_locked(efivars, &entry->var);
>+
>+		for (i = 0; i < DUMP_NAME_LEN; i++) {
>+			if (efi_name[i] == 0) {
>+				found = entry;
>+				efi.set_variable(entry->var.VariableName, &entry->var.VendorGuid,
>+						 EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS |
>EFI_VARIABLE_RUNTIME_ACCESS,
>+						 0, NULL);
>+				break;
>+			} else if (efi_name[i] != entry->var.VariableName[i]) {
>+				break;
>+			}
>+		}
>+	}
>+
>+	if (found)
>+		list_del(&found->list);
>+
>+	for (i = 0; i < DUMP_NAME_LEN; i++)
>+		efi_name[i] = name[i];
>+
>+	efi.set_variable(efi_name, &vendor,
>+			 EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
>+			 size, psi->buf);
>+
>+	spin_unlock(&efivars->lock);
>+
>+	if (found)
>+		efivar_unregister(found);
>+
>+	if (size)
>+		efivar_create_sysfs_entry(efivars, utf8_strsize(efi_name, DUMP_NAME_LEN * 2),
>+					  efi_name, &vendor);
>+
>+	return part;
>+};
>+
>+static int efi_pstore_erase(enum pstore_type_id type, u64 id,
>+			    struct pstore_info *psi)
>+{
>+	efi_pstore_write(type, id, 0, psi);
>+
>+	return 0;
>+}
>+
>+static struct pstore_info efi_pstore_info = {
>+	.owner		= THIS_MODULE,
>+	.name		= "efi",
>+	.open		= efi_pstore_open,
>+	.close		= efi_pstore_close,
>+	.read		= efi_pstore_read,
>+	.write		= efi_pstore_write,
>+	.erase		= efi_pstore_erase,
>+};
>
> static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
> 			     struct bin_attribute *bin_attr,
>@@ -763,6 +909,14 @@ int register_efivars(struct efivars *efivars,
> 	if (error)
> 		unregister_efivars(efivars);
>
>+	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
>+	if (efi_pstore_info.buf) {
>+		efi_pstore_info.bufsize = 1024;
>+		efi_pstore_info.data = efivars;
>+		mutex_init(&efi_pstore_info.buf_mutex);
>+		pstore_register(&efi_pstore_info);
>+	}
>+
> out:
> 	kfree(variable_name);
>
>diff --git a/include/linux/efi.h b/include/linux/efi.h
>index ec25726..8dd9a01 100644
>--- a/include/linux/efi.h
>+++ b/include/linux/efi.h
>@@ -232,6 +232,9 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
> #define UV_SYSTEM_TABLE_GUID \
>     EFI_GUID(  0x3b13a7d4, 0x633e, 0x11dd, 0x93, 0xec, 0xda, 0x25, 0x56, 0xd8, 0x95, 0x93 )
>
>+#define LINUX_EFI_CRASH_GUID \
>+    EFI_GUID(  0xcfc8fc79, 0xbe2e, 0x4ddc, 0x97, 0xf0, 0x9f, 0x98, 0xbf, 0xe2, 0x98, 0xa0 )
>+
> typedef struct {
> 	efi_guid_t guid;
> 	unsigned long table;
>--
>1.7.5.2
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

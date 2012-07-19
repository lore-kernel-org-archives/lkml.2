Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab2GSVNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:13:11 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:36607 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2GSVNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:13:09 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [RFC][PATCH v2 1/3] Avoid overwriting existing entry
Thread-Topic: [RFC][PATCH v2 1/3] Avoid overwriting existing entry
Thread-Index: Ac1l8ziceLtw2nPrTa6+aYK+rjGozw==
Date: Thu, 19 Jul 2012 21:12:57 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FBF@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-19_06:2012-07-19,2012-07-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207190250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Problem]
 Currently, efi_pstore driver simply overwrites existing panic messages in NVRAM.
 So, in the following scenario, we will lose 1st panic messages.

 1. kernel panics.
 2. efi_pstore is kicked and write panic messages to NVRAM.
 3. system reboots.
 4. kernel panics again before a user checks the 1st panic messages in NVRAM.

[Solution]
This patch remove a logic erasing existing entries from write callback to
avoid losing an existing critical message.

[Patch Description]
 - Remove a logic erasing existing entries from write callback
 - Add the logic above to erase callback.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 drivers/firmware/efivars.c |   92 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 69 insertions(+), 23 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 47408e8..75a7c82 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -685,6 +685,30 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	return 0;
 }
 
+static unsigned long get_current_log_num(efi_char16_t *efi_name,
+					 struct efivars *efivars)
+{
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	struct efivar_entry *entry;
+	unsigned long current_log_num = 0;
+
+	list_for_each_entry(entry, &efivars->list, list) {
+		get_var_data_locked(efivars, &entry->var);
+
+		if (efi_guidcmp(entry->var.VendorGuid, vendor))
+			continue;
+		if (utf16_strncmp(entry->var.VariableName, efi_name,
+				  utf16_strlen(efi_name)))
+			continue;
+		/* Needs to be a prefix */
+		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
+			continue;
+		current_log_num++;
+	}
+
+	return current_log_num;
+}
+
 static int efi_pstore_write(enum pstore_type_id type,
 		enum kmsg_dump_reason reason, u64 *id,
 		unsigned int part, size_t size, struct pstore_info *psi)
@@ -694,8 +718,8 @@ static int efi_pstore_write(enum pstore_type_id type,
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
-	struct efivar_entry *entry, *found = NULL;
 	int i, ret = 0;
+	unsigned long current_log_num;
 
 	sprintf(stub_name, "dump-type%u-%u-", type, part);
 	sprintf(name, "%s%lu", stub_name, get_seconds());
@@ -705,6 +729,48 @@ static int efi_pstore_write(enum pstore_type_id type,
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = stub_name[i];
 
+	current_log_num = get_current_log_num(efi_name, efivars);
+
+	if (current_log_num >= 1) {
+		spin_unlock(&efivars->lock);
+		*id = part;
+		return -EEXIST;
+	}
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = name[i];
+
+	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
+				   size, psi->buf);
+
+	spin_unlock(&efivars->lock);
+
+	if (size)
+		ret = efivar_create_sysfs_entry(efivars,
+					  utf16_strsize(efi_name,
+							DUMP_NAME_LEN * 2),
+					  efi_name, &vendor);
+
+	*id = part;
+	return ret;
+};
+
+static int efi_pstore_erase(enum pstore_type_id type, u64 id,
+			    struct pstore_info *psi)
+{
+	char stub_name[DUMP_NAME_LEN];
+	efi_char16_t efi_name[DUMP_NAME_LEN];
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	struct efivars *efivars = psi->data;
+	struct efivar_entry *entry, *found = NULL;
+	int i;
+
+	sprintf(stub_name, "dump-type%u-%llu-", type, id);
+
+	spin_lock(&efivars->lock);
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = stub_name[i];
 	/*
 	 * Clean up any entries with the same name
 	 */
@@ -718,7 +784,8 @@ static int efi_pstore_write(enum pstore_type_id type,
 				  utf16_strlen(efi_name)))
 			continue;
 		/* Needs to be a prefix */
-		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
+		if (entry->var.VariableName[utf16_strlen(efi_name)]
+		    == 0)
 			continue;
 
 		/* found */
@@ -732,32 +799,11 @@ static int efi_pstore_write(enum pstore_type_id type,
 	if (found)
 		list_del(&found->list);
 
-	for (i = 0; i < DUMP_NAME_LEN; i++)
-		efi_name[i] = name[i];
-
-	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
-				   size, psi->buf);
-
 	spin_unlock(&efivars->lock);
 
 	if (found)
 		efivar_unregister(found);
 
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
-	efi_pstore_write(type, 0, &id, (unsigned int)id, 0, psi);
-
 	return 0;
 }
 #else
-- 1.7.1 


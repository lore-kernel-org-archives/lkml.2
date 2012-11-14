Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423370Ab2KNU1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:27:12 -0500
Received: from usindpps05.hds.com ([207.126.252.18]:47754 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161280Ab2KNU1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:27:09 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH v6 3/7] efi_pstore: Remove a logic erasing entries from a
 write callback to hold multiple logs
Thread-Topic: [PATCH v6 3/7] efi_pstore: Remove a logic erasing entries from
 a write callback to hold multiple logs
Thread-Index: Ac3Cplpbet7rrNOVRNmSvUFFhz9bRA==
Date: Wed, 14 Nov 2012 20:26:46 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138CA6C1@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-14_06:2012-11-14,2012-11-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1211140199
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Issue]

Currently, efi_pstore driver simply overwrites existing panic messages in NVRAM.
So, in the following scenario, we will lose 1st panic messages.

1. kernel panics.
2. efi_pstore is kicked and writes panic messages to NVRAM.
3. system reboots.
4. kernel panics again before a user checks the 1st panic messages in NVRAM.

[Solution]

A reasonable solution to fix the issue is just holding multiple logs without erasing
existing entries.
This patch removes a logic erasing existing entries in a write callback
because the logic is not needed in the write callback to support holding multiple logs.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |   39 ++-------------------------------------
 1 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index bee14cc..fbe9202 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -701,18 +701,13 @@ static int efi_pstore_write(enum pstore_type_id type,
 		unsigned int part, size_t size, struct pstore_info *psi)
 {
 	char name[DUMP_NAME_LEN];
-	char stub_name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
-	struct efivar_entry *entry, *found = NULL;
 	int i, ret = 0;
 	u64 storage_space, remaining_space, max_variable_size;
 	efi_status_t status = EFI_NOT_FOUND;
 
-	sprintf(stub_name, "dump-type%u-%u-", type, part);
-	sprintf(name, "%s%lu", stub_name, get_seconds());
-
 	spin_lock(&efivars->lock);
 
 	/*
@@ -730,35 +725,8 @@ static int efi_pstore_write(enum pstore_type_id type,
 		return -ENOSPC;
 	}
 
-	for (i = 0; i < DUMP_NAME_LEN; i++)
-		efi_name[i] = stub_name[i];
-
-	/*
-	 * Clean up any entries with the same name
-	 */
-
-	list_for_each_entry(entry, &efivars->list, list) {
-		get_var_data_locked(efivars, &entry->var);
-
-		if (efi_guidcmp(entry->var.VendorGuid, vendor))
-			continue;
-		if (utf16_strncmp(entry->var.VariableName, efi_name,
-				  utf16_strlen(efi_name)))
-			continue;
-		/* Needs to be a prefix */
-		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
-			continue;
-
-		/* found */
-		found = entry;
-		efivars->ops->set_variable(entry->var.VariableName,
-					   &entry->var.VendorGuid,
-					   PSTORE_EFI_ATTRIBUTES,
-					   0, NULL);
-	}
-
-	if (found)
-		list_del(&found->list);
+	sprintf(name, "dump-type%u-%u-%lu", type, part,
+		get_seconds());
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
@@ -768,9 +736,6 @@ static int efi_pstore_write(enum pstore_type_id type,
 
 	spin_unlock(&efivars->lock);
 
-	if (found)
-		efivar_unregister(found);
-
 	if (size)
 		ret = efivar_create_sysfs_entry(efivars,
 					  utf16_strsize(efi_name,
-- 
1.7.1


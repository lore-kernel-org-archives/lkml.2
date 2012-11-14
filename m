Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423330Ab2KNU0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:26:39 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:50101 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab2KNU0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:26:34 -0500
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
Subject: [PATCH v6 2/7] efi_pstore: Add a logic erasing entries to an erase
 callback
Thread-Topic: [PATCH v6 2/7] efi_pstore: Add a logic erasing entries to an
 erase callback
Thread-Index: Ac3CpkdcGFWFRVtEQNyc3x9KsJfHVA==
Date: Wed, 14 Nov 2012 20:26:21 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138CA6B9@USINDEM103.corp.hds.com>
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

This patch freshly adds a logic erasing existing entries, which shared with a write callback,
to an erase callback.
To support holding multiple logs, the write callback doesn't need to erase any entries and
it will be removed in a subsequent patch.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |   46 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 37ac21a..bee14cc 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -784,7 +784,51 @@ static int efi_pstore_write(enum pstore_type_id type,
 static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 			    struct pstore_info *psi)
 {
-	efi_pstore_write(type, 0, &id, (unsigned int)id, 0, psi);
+	char stub_name[DUMP_NAME_LEN];
+	efi_char16_t efi_name[DUMP_NAME_LEN];
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	struct efivars *efivars = psi->data;
+	struct efivar_entry *entry, *found = NULL;
+	int i;
+
+	sprintf(stub_name, "dump-type%u-%u-", type, (unsigned int)id);
+
+	spin_lock(&efivars->lock);
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = stub_name[i];
+
+	/*
+	 * Clean up any entries with the same name
+	 */
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
+
+		/* found */
+		found = entry;
+		efivars->ops->set_variable(entry->var.VariableName,
+					   &entry->var.VendorGuid,
+					   PSTORE_EFI_ATTRIBUTES,
+					   0, NULL);
+	}
+
+	if (found)
+		list_del(&found->list);
+
+	spin_unlock(&efivars->lock);
+
+	if (found)
+		efivar_unregister(found);
 
 	return 0;
 }
-- 
1.7.1


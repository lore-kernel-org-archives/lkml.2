Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443Ab2J3UE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:04:28 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:34923 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933850Ab2J3UE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:04:26 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH v4 7/7] efi_pstore: Add a format check for an existing
 variable name at erasing time
Thread-Topic: [PATCH v4 7/7] efi_pstore: Add a format check for an existing
 variable name at erasing time
Thread-Index: Ac222a8Hb1nksXa1SZ+wp6xG+0iHQQ==
Date: Tue, 30 Oct 2012 20:04:14 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138B1E8C@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-30_06:2012-10-30,2012-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210300230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Issue]

a format of variable name has been updated to type, id, count and ctime
to support holding multiple logs.

Format of current variable name
  dump-type0-1-2-12345678

  type:0
  id:1
  count:2
  ctime:12345678

On the other hand, if an old variable name before being updated
remains, users can't erase it via /dev/pstore.

Format of old variable name
  dump-type0-1-12345678

  type:0
  id:1
  ctime:12345678

[Solution]

This patch add a format check for the old variable name in a erase callback to make it erasable.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 drivers/firmware/efivars.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index bf7a6f9..6e51c1e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -773,6 +773,8 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 {
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
+	char name_old[DUMP_NAME_LEN];
+	efi_char16_t efi_name_old[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
@@ -796,8 +798,22 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 		if (efi_guidcmp(entry->var.VendorGuid, vendor))
 			continue;
 		if (utf16_strncmp(entry->var.VariableName, efi_name,
-				  utf16_strlen(efi_name)))
-			continue;
+				  utf16_strlen(efi_name))) {
+			/*
+			 * Check if an old format,
+			 * which doesn't support holding
+			 * multiple logs, remains.
+			 */
+			sprintf(name_old, "dump-type%u-%u-%lu", type,
+				(unsigned int)id, time.tv_sec);
+
+			for (i = 0; i < DUMP_NAME_LEN; i++)
+				efi_name_old[i] = name_old[i];
+
+			if (utf16_strncmp(entry->var.VariableName, efi_name_old,
+					  utf16_strlen(efi_name_old)))
+				continue;
+		}
 
 		/* found */
 		found = entry;
-- 
1.7.1

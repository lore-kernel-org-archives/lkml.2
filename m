Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423421Ab2KNU3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:29:33 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:51607 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423232Ab2KNU3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:29:31 -0500
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
Subject: [PATCH v6 7/7] efi_pstore: Add a format check for an existing
 variable name at erasing time
Thread-Topic: [PATCH v6 7/7] efi_pstore: Add a format check for an existing
 variable name at erasing time
Thread-Index: Ac3CprBzEjVfsWknT2CEOdGk6+53GA==
Date: Wed, 14 Nov 2012 20:29:21 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138CA736@USINDEM103.corp.hds.com>
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
Acked-by: Mike Waychison <mikew@google.com>
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


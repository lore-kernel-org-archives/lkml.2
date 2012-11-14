Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab2KNUZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:25:51 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:49693 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab2KNUZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:25:49 -0500
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
Subject: [PATCH v6 1/7] efi_pstore: Check remaining space with
 QueryVariableInfo() before writing data
Thread-Topic: [PATCH v6 1/7] efi_pstore: Check remaining space with
 QueryVariableInfo() before writing data
Thread-Index: Ac3Cpi2kqIXbPNItRlufiXvx40rfvQ==
Date: Wed, 14 Nov 2012 20:25:37 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138CA69F@USINDEM103.corp.hds.com>
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
 ipscore=0 suspectscore=11 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1211140199
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Issue]

As discussed in a thread below, Running out of space in EFI isn't a well-tested scenario.
And we wouldn't expect all firmware to handle it gracefully.
http://marc.info/?l=linux-kernel&m=134305325801789&w=2

On the other hand, current efi_pstore doesn't check a remaining space of storage at writing time.
Therefore, efi_pstore may not work if it tries to write a large amount of data.

[Patch Description]

To avoid handling the situation above, this patch checks if there is a space enough to log with
QueryVariableInfo() before writing data.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |   18 ++++++++++++++++++
 include/linux/efi.h        |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d10c987..37ac21a 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -707,12 +707,29 @@ static int efi_pstore_write(enum pstore_type_id type,
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
 	int i, ret = 0;
+	u64 storage_space, remaining_space, max_variable_size;
+	efi_status_t status = EFI_NOT_FOUND;
 
 	sprintf(stub_name, "dump-type%u-%u-", type, part);
 	sprintf(name, "%s%lu", stub_name, get_seconds());
 
 	spin_lock(&efivars->lock);
 
+	/*
+	 * Check if there is a space enough to log.
+	 * size: a size of logging data
+	 * DUMP_NAME_LEN * 2: a maximum size of variable name
+	 */
+	status = efivars->ops->query_variable_info(PSTORE_EFI_ATTRIBUTES,
+						   &storage_space,
+						   &remaining_space,
+						   &max_variable_size);
+	if (status || remaining_space < size + DUMP_NAME_LEN * 2) {
+		spin_unlock(&efivars->lock);
+		*id = part;
+		return -ENOSPC;
+	}
+
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = stub_name[i];
 
@@ -1237,6 +1254,7 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
+	ops.query_variable_info = efi.query_variable_info;
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
 		goto err_put;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 8670eb1..c47ec36 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -643,6 +643,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_query_variable_info_t *query_variable_info;
 };
 
 struct efivars {
-- 
1.7.1


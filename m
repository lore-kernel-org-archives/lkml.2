Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2FMNnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:43:32 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:54141 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2FMNna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:43:30 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "rob@landley.net" <rob@landley.net>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 13 Jun 2012 09:42:56 -0400
Subject: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite parameter
 to avoid missing messages in NVRAM
Thread-Topic: [RFC][Patch]efi_pstore:Introduce an efi_pstore_overwrite
 parameter to avoid missing messages in NVRAM
Thread-Index: Ac1Jaf3kQfy2nRzQSNG3UORn8S5p+A==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E5A4DB2B8@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1206130109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Currently, efi_pstore driver simply overwrites existing panic messages in NVRAM.
    So, in the following scenario, we will lose 1st panic messages.

    1. kernel panics.
    2. efi_pstore is kicked and writes panic messages to NVRAM.
    3. system shutdowns and boots up.
    4. kernel panics again before a user checks the 1st panic messages in NVRAM.

    
    To avoid missing 1st panic messages, this patch adds a new parameter ,efi_pstore_overwrite,
    to efi_pstore so that we can specify whether efi_pstore overwrites existing entries in NVRAM or not.


 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 Documentation/kernel-parameters.txt |    6 ++++
 drivers/firmware/efivars.c          |   55 +++++++++++++++++++---------------
 2 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a92c5eb..990befa 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -786,6 +786,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}
 
+	efivars.efi_pstore_overwrite=
+			Specify whether efi_pstore overwrites existing entries
+			in NVRAM
+			Format: <bool>  (1/Y/y=yes, 0/N/n=no)
+			default: yes
+
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c index 47408e8..94fbd1d 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -685,6 +685,10 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	return 0;
 }
 
+static bool efi_pstore_overwrite = 1;
+module_param_named(efi_pstore_overwrite, efi_pstore_overwrite,
+		   bool, S_IRUGO | S_IWUSR);
+
 static int efi_pstore_write(enum pstore_type_id type,
 		enum kmsg_dump_reason reason, u64 *id,
 		unsigned int part, size_t size, struct pstore_info *psi) @@ -705,33 +709,36 @@ static int efi_pstore_write(enum pstore_type_id type,
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = stub_name[i];
 
-	/*
-	 * Clean up any entries with the same name
-	 */
+	if (efi_pstore_overwrite) {
+		/*
+		 * Clean up any entries with the same name
+		 */
+
+		list_for_each_entry(entry, &efivars->list, list) {
+			get_var_data_locked(efivars, &entry->var);
+
+			if (efi_guidcmp(entry->var.VendorGuid, vendor))
+				continue;
+			if (utf16_strncmp(entry->var.VariableName, efi_name,
+					  utf16_strlen(efi_name)))
+				continue;
+			/* Needs to be a prefix */
+			if (entry->var.VariableName[utf16_strlen(efi_name)]
+			    == 0)
+				continue;
+
+			/* found */
+			found = entry;
+			efivars->ops->set_variable(entry->var.VariableName,
+						   &entry->var.VendorGuid,
+						   PSTORE_EFI_ATTRIBUTES,
+						   0, NULL);
+		}
 
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
+		if (found)
+			list_del(&found->list);
 	}
 
-	if (found)
-		list_del(&found->list);
-
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
--
1.7.1

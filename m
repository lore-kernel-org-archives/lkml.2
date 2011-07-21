Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1GUVBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:01:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab1GUVAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:00:00 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mikew@google.com, tony.luck@intel.com
Subject: [PATCH V2 6/9] efivars: String functions
Date: Thu, 21 Jul 2011 16:57:57 -0400
Message-Id: <1311281880-28041-7-git-send-email-mjg@redhat.com>
In-Reply-To: <1311281880-28041-1-git-send-email-mjg@redhat.com>
References: <1311281880-28041-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

Fix the string functions in the efivars driver to be called utf16_*
instead of utf8_* as the encoding is utf16, not utf8.

As well, rename utf16_strlen to utf16_strnlen as it takes a maxlength
argument and the name should be consistent with the standard C function
names.  utf16_strlen is still provided for convenience in a subsequent
patch.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 2bbb226..4202a31 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -144,23 +144,29 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 
 /* Return the number of unicode characters in data */
 static unsigned long
-utf8_strlen(efi_char16_t *data, unsigned long maxlength)
+utf16_strnlen(efi_char16_t *s, size_t maxlength)
 {
 	unsigned long length = 0;
 
-	while (*data++ != 0 && length < maxlength)
+	while (*s++ != 0 && length < maxlength)
 		length++;
 	return length;
 }
 
+static unsigned long
+utf16_strlen(efi_char16_t *s)
+{
+	return utf16_strnlen(s, ~0UL);
+}
+
 /*
  * Return the number of bytes is the length of this string
  * Note: this is NOT the same as the number of unicode characters
  */
 static inline unsigned long
-utf8_strsize(efi_char16_t *data, unsigned long maxlength)
+utf16_strsize(efi_char16_t *data, unsigned long maxlength)
 {
-	return utf8_strlen(data, maxlength/sizeof(efi_char16_t)) * sizeof(efi_char16_t);
+	return utf16_strnlen(data, maxlength/sizeof(efi_char16_t)) * sizeof(efi_char16_t);
 }
 
 static efi_status_t
@@ -518,7 +524,9 @@ static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
 		efivar_unregister(found);
 
 	if (size)
-		efivar_create_sysfs_entry(efivars, utf8_strsize(efi_name, DUMP_NAME_LEN * 2),
+		efivar_create_sysfs_entry(efivars,
+					  utf16_strsize(efi_name,
+							DUMP_NAME_LEN * 2),
 					  efi_name, &vendor);
 
 	return part;
@@ -591,8 +599,8 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	 * Does this variable already exist?
 	 */
 	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf8_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf8_strsize(new_var->VariableName, 1024);
+		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
+		strsize2 = utf16_strsize(new_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
 			!memcmp(&(search_efivar->var.VariableName),
 				new_var->VariableName, strsize1) &&
@@ -624,8 +632,8 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 
 	/* Create the entry in sysfs.  Locking is not required here */
 	status = efivar_create_sysfs_entry(efivars,
-					   utf8_strsize(new_var->VariableName,
-							1024),
+					   utf16_strsize(new_var->VariableName,
+							 1024),
 					   new_var->VariableName,
 					   &new_var->VendorGuid);
 	if (status) {
@@ -654,8 +662,8 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	 * Does this variable already exist?
 	 */
 	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf8_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf8_strsize(del_var->VariableName, 1024);
+		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
+		strsize2 = utf16_strsize(del_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
 			!memcmp(&(search_efivar->var.VariableName),
 				del_var->VariableName, strsize1) &&
-- 
1.7.6


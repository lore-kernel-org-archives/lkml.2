Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab1FUUTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:19:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:14178 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab1FUUSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:18:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=ZIK2i0AfxDcr223dWUSYcD5EN0d8kk6+Wd6iQ2W5JlYcKM0p0HdL83iygvZxl+aHd
	TSTBeplxQgfBf3yu47nVw==
From: Mike Waychison <mikew@google.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, Matt_Domsch@dell.com,
        Mike Waychison <mikew@google.com>
Subject: [PATCH 1/4] efivars: String functions
Date: Tue, 21 Jun 2011 13:18:29 -0700
Message-Id: <1308687512-11649-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <BANLkTi=qmS090MK=sx=xMN95zD5AtNkuLG_g092oVXJezoRCYA@mail.gmail.com>
References: <BANLkTi=qmS090MK=sx=xMN95zD5AtNkuLG_g092oVXJezoRCYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 89e6a3a..f10c760 100644
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
@@ -516,7 +522,9 @@ static u64 efi_pstore_write(enum pstore_type_id type, int part, size_t size,
 		efivar_unregister(found);
 
 	if (size)
-		efivar_create_sysfs_entry(efivars, utf8_strsize(efi_name, DUMP_NAME_LEN * 2),
+		efivar_create_sysfs_entry(efivars,
+					  utf16_strsize(efi_name,
+							DUMP_NAME_LEN * 2),
 					  efi_name, &vendor);
 
 	return part;
@@ -560,8 +568,8 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
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
@@ -593,8 +601,8 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 
 	/* Create the entry in sysfs.  Locking is not required here */
 	status = efivar_create_sysfs_entry(efivars,
-					   utf8_strsize(new_var->VariableName,
-							1024),
+					   utf16_strsize(new_var->VariableName,
+							 1024),
 					   new_var->VariableName,
 					   &new_var->VendorGuid);
 	if (status) {
@@ -623,8 +631,8 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
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
1.7.3.1


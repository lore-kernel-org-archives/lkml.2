Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106Ab2EDUxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:53:52 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:38140 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759974Ab2EDUtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:49:40 -0400
Message-Id: <20120504204247.793292677@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Waychison <mikew@google.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [ 34/47] efivars: String functions
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Waychison <mikew@google.com>

commit a2940908391f3cee72e38769b30e829b22742b5b upstream.

Fix the string functions in the efivars driver to be called utf16_*
instead of utf8_* as the encoding is utf16, not utf8.

As well, rename utf16_strlen to utf16_strnlen as it takes a maxlength
argument and the name should be consistent with the standard C function
names.  utf16_strlen is still provided for convenience in a subsequent
patch.

Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efivars.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -141,23 +141,29 @@ efivar_create_sysfs_entry(struct efivars
 
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
@@ -414,8 +420,8 @@ static ssize_t efivar_create(struct file
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
@@ -447,8 +453,8 @@ static ssize_t efivar_create(struct file
 
 	/* Create the entry in sysfs.  Locking is not required here */
 	status = efivar_create_sysfs_entry(efivars,
-					   utf8_strsize(new_var->VariableName,
-							1024),
+					   utf16_strsize(new_var->VariableName,
+							 1024),
 					   new_var->VariableName,
 					   &new_var->VendorGuid);
 	if (status) {
@@ -477,8 +483,8 @@ static ssize_t efivar_delete(struct file
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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab2EDUvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:51:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57129 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043Ab2EDUuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:50:19 -0400
Message-Id: <20120504204248.042257249@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>
Subject: [ 37/47] efivars: Improve variable validation
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit 54b3a4d311c98ad94b737802a8b5f2c8c6bfd627 upstream.

Ben Hutchings pointed out that the validation in efivars was inadequate -
most obviously, an entry with size 0 would server as a DoS against the
kernel. Improve this based on his suggestions.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efivars.c |   46 +++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -167,18 +167,21 @@ utf16_strsize(efi_char16_t *data, unsign
 }
 
 static bool
-validate_device_path(struct efi_variable *var, int match, u8 *buffer, int len)
+validate_device_path(struct efi_variable *var, int match, u8 *buffer,
+		     unsigned long len)
 {
 	struct efi_generic_dev_path *node;
 	int offset = 0;
 
 	node = (struct efi_generic_dev_path *)buffer;
 
-	while (offset < len) {
-		offset += node->length;
+	if (len < sizeof(*node))
+		return false;
 
-		if (offset > len)
-			return false;
+	while (offset <= len - sizeof(*node) &&
+	       node->length >= sizeof(*node) &&
+		node->length <= len - offset) {
+		offset += node->length;
 
 		if ((node->type == EFI_DEV_END_PATH ||
 		     node->type == EFI_DEV_END_PATH2) &&
@@ -197,7 +200,8 @@ validate_device_path(struct efi_variable
 }
 
 static bool
-validate_boot_order(struct efi_variable *var, int match, u8 *buffer, int len)
+validate_boot_order(struct efi_variable *var, int match, u8 *buffer,
+		    unsigned long len)
 {
 	/* An array of 16-bit integers */
 	if ((len % 2) != 0)
@@ -207,19 +211,27 @@ validate_boot_order(struct efi_variable
 }
 
 static bool
-validate_load_option(struct efi_variable *var, int match, u8 *buffer, int len)
+validate_load_option(struct efi_variable *var, int match, u8 *buffer,
+		     unsigned long len)
 {
 	u16 filepathlength;
-	int i, desclength = 0;
+	int i, desclength = 0, namelen;
+
+	namelen = utf16_strnlen(var->VariableName, sizeof(var->VariableName));
 
 	/* Either "Boot" or "Driver" followed by four digits of hex */
 	for (i = match; i < match+4; i++) {
-		if (hex_to_bin(var->VariableName[i] & 0xff) < 0)
+		if (var->VariableName[i] > 127 ||
+		    hex_to_bin(var->VariableName[i] & 0xff) < 0)
 			return true;
 	}
 
-	/* A valid entry must be at least 6 bytes */
-	if (len < 6)
+	/* Reject it if there's 4 digits of hex and then further content */
+	if (namelen > match + 4)
+		return false;
+
+	/* A valid entry must be at least 8 bytes */
+	if (len < 8)
 		return false;
 
 	filepathlength = buffer[4] | buffer[5] << 8;
@@ -228,7 +240,7 @@ validate_load_option(struct efi_variable
 	 * There's no stored length for the description, so it has to be
 	 * found by hand
 	 */
-	desclength = utf16_strsize((efi_char16_t *)(buffer + 6), len) + 2;
+	desclength = utf16_strsize((efi_char16_t *)(buffer + 6), len - 6) + 2;
 
 	/* Each boot entry must have a descriptor */
 	if (!desclength)
@@ -250,7 +262,8 @@ validate_load_option(struct efi_variable
 }
 
 static bool
-validate_uint16(struct efi_variable *var, int match, u8 *buffer, int len)
+validate_uint16(struct efi_variable *var, int match, u8 *buffer,
+		unsigned long len)
 {
 	/* A single 16-bit integer */
 	if (len != 2)
@@ -260,7 +273,8 @@ validate_uint16(struct efi_variable *var
 }
 
 static bool
-validate_ascii_string(struct efi_variable *var, int match, u8 *buffer, int len)
+validate_ascii_string(struct efi_variable *var, int match, u8 *buffer,
+		      unsigned long len)
 {
 	int i;
 
@@ -278,7 +292,7 @@ validate_ascii_string(struct efi_variabl
 struct variable_validate {
 	char *name;
 	bool (*validate)(struct efi_variable *var, int match, u8 *data,
-			 int len);
+			 unsigned long len);
 };
 
 static const struct variable_validate variable_validate[] = {
@@ -300,7 +314,7 @@ static const struct variable_validate va
 };
 
 static bool
-validate_var(struct efi_variable *var, u8 *data, int len)
+validate_var(struct efi_variable *var, u8 *data, unsigned long len)
 {
 	int i;
 	u16 *unicode_name = var->VariableName;



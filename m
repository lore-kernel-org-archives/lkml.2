Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2EIF5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:57:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39022 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756439Ab2EIFxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:50 -0400
Message-Id: <20120509055048.109998155@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>
Subject: [ 134/167] [PATCH] efivars: Improve variable validation
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit 54b3a4d311c98ad94b737802a8b5f2c8c6bfd627 upstream.

Ben Hutchings pointed out that the validation in efivars was inadequate -
most obviously, an entry with size 0 would server as a DoS against the
kernel. Improve this based on his suggestions.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/efivars.c |   46 +++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 891e467..47408e8 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -192,18 +192,21 @@ utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len)
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
@@ -222,7 +225,8 @@ validate_device_path(struct efi_variable *var, int match, u8 *buffer, int len)
 }
 
 static bool
-validate_boot_order(struct efi_variable *var, int match, u8 *buffer, int len)
+validate_boot_order(struct efi_variable *var, int match, u8 *buffer,
+		    unsigned long len)
 {
 	/* An array of 16-bit integers */
 	if ((len % 2) != 0)
@@ -232,19 +236,27 @@ validate_boot_order(struct efi_variable *var, int match, u8 *buffer, int len)
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
@@ -253,7 +265,7 @@ validate_load_option(struct efi_variable *var, int match, u8 *buffer, int len)
 	 * There's no stored length for the description, so it has to be
 	 * found by hand
 	 */
-	desclength = utf16_strsize((efi_char16_t *)(buffer + 6), len) + 2;
+	desclength = utf16_strsize((efi_char16_t *)(buffer + 6), len - 6) + 2;
 
 	/* Each boot entry must have a descriptor */
 	if (!desclength)
@@ -275,7 +287,8 @@ validate_load_option(struct efi_variable *var, int match, u8 *buffer, int len)
 }
 
 static bool
-validate_uint16(struct efi_variable *var, int match, u8 *buffer, int len)
+validate_uint16(struct efi_variable *var, int match, u8 *buffer,
+		unsigned long len)
 {
 	/* A single 16-bit integer */
 	if (len != 2)
@@ -285,7 +298,8 @@ validate_uint16(struct efi_variable *var, int match, u8 *buffer, int len)
 }
 
 static bool
-validate_ascii_string(struct efi_variable *var, int match, u8 *buffer, int len)
+validate_ascii_string(struct efi_variable *var, int match, u8 *buffer,
+		      unsigned long len)
 {
 	int i;
 
@@ -303,7 +317,7 @@ validate_ascii_string(struct efi_variable *var, int match, u8 *buffer, int len)
 struct variable_validate {
 	char *name;
 	bool (*validate)(struct efi_variable *var, int match, u8 *data,
-			 int len);
+			 unsigned long len);
 };
 
 static const struct variable_validate variable_validate[] = {
@@ -325,7 +339,7 @@ static const struct variable_validate variable_validate[] = {
 };
 
 static bool
-validate_var(struct efi_variable *var, u8 *data, int len)
+validate_var(struct efi_variable *var, u8 *data, unsigned long len)
 {
 	int i;
 	u16 *unicode_name = var->VariableName;
-- 
1.7.10




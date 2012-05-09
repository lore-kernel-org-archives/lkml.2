Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab2EIGCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:02:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39004 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756359Ab2EIFxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:41 -0400
Message-Id: <20120509055047.576938749@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>
Subject: [ 130/167] [PATCH] efi: Validate UEFI boot variables
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

commit fec6c20b570bcf541e581fc97f2e0cbdb9725b98 upstream.

A common flaw in UEFI systems is a refusal to POST triggered by a malformed
boot variable. Once in this state, machines may only be restored by
reflashing their firmware with an external hardware device. While this is
obviously a firmware bug, the serious nature of the outcome suggests that
operating systems should filter their variable writes in order to prevent
a malicious user from rendering the machine unusable.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/efivars.c |  182 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 182 insertions(+)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d25599f..891e467 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -191,6 +191,176 @@ utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len)
 	}
 }
 
+static bool
+validate_device_path(struct efi_variable *var, int match, u8 *buffer, int len)
+{
+	struct efi_generic_dev_path *node;
+	int offset = 0;
+
+	node = (struct efi_generic_dev_path *)buffer;
+
+	while (offset < len) {
+		offset += node->length;
+
+		if (offset > len)
+			return false;
+
+		if ((node->type == EFI_DEV_END_PATH ||
+		     node->type == EFI_DEV_END_PATH2) &&
+		    node->sub_type == EFI_DEV_END_ENTIRE)
+			return true;
+
+		node = (struct efi_generic_dev_path *)(buffer + offset);
+	}
+
+	/*
+	 * If we're here then either node->length pointed past the end
+	 * of the buffer or we reached the end of the buffer without
+	 * finding a device path end node.
+	 */
+	return false;
+}
+
+static bool
+validate_boot_order(struct efi_variable *var, int match, u8 *buffer, int len)
+{
+	/* An array of 16-bit integers */
+	if ((len % 2) != 0)
+		return false;
+
+	return true;
+}
+
+static bool
+validate_load_option(struct efi_variable *var, int match, u8 *buffer, int len)
+{
+	u16 filepathlength;
+	int i, desclength = 0;
+
+	/* Either "Boot" or "Driver" followed by four digits of hex */
+	for (i = match; i < match+4; i++) {
+		if (hex_to_bin(var->VariableName[i] & 0xff) < 0)
+			return true;
+	}
+
+	/* A valid entry must be at least 6 bytes */
+	if (len < 6)
+		return false;
+
+	filepathlength = buffer[4] | buffer[5] << 8;
+
+	/*
+	 * There's no stored length for the description, so it has to be
+	 * found by hand
+	 */
+	desclength = utf16_strsize((efi_char16_t *)(buffer + 6), len) + 2;
+
+	/* Each boot entry must have a descriptor */
+	if (!desclength)
+		return false;
+
+	/*
+	 * If the sum of the length of the description, the claimed filepath
+	 * length and the original header are greater than the length of the
+	 * variable, it's malformed
+	 */
+	if ((desclength + filepathlength + 6) > len)
+		return false;
+
+	/*
+	 * And, finally, check the filepath
+	 */
+	return validate_device_path(var, match, buffer + desclength + 6,
+				    filepathlength);
+}
+
+static bool
+validate_uint16(struct efi_variable *var, int match, u8 *buffer, int len)
+{
+	/* A single 16-bit integer */
+	if (len != 2)
+		return false;
+
+	return true;
+}
+
+static bool
+validate_ascii_string(struct efi_variable *var, int match, u8 *buffer, int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++) {
+		if (buffer[i] > 127)
+			return false;
+
+		if (buffer[i] == 0)
+			return true;
+	}
+
+	return false;
+}
+
+struct variable_validate {
+	char *name;
+	bool (*validate)(struct efi_variable *var, int match, u8 *data,
+			 int len);
+};
+
+static const struct variable_validate variable_validate[] = {
+	{ "BootNext", validate_uint16 },
+	{ "BootOrder", validate_boot_order },
+	{ "DriverOrder", validate_boot_order },
+	{ "Boot*", validate_load_option },
+	{ "Driver*", validate_load_option },
+	{ "ConIn", validate_device_path },
+	{ "ConInDev", validate_device_path },
+	{ "ConOut", validate_device_path },
+	{ "ConOutDev", validate_device_path },
+	{ "ErrOut", validate_device_path },
+	{ "ErrOutDev", validate_device_path },
+	{ "Timeout", validate_uint16 },
+	{ "Lang", validate_ascii_string },
+	{ "PlatformLang", validate_ascii_string },
+	{ "", NULL },
+};
+
+static bool
+validate_var(struct efi_variable *var, u8 *data, int len)
+{
+	int i;
+	u16 *unicode_name = var->VariableName;
+
+	for (i = 0; variable_validate[i].validate != NULL; i++) {
+		const char *name = variable_validate[i].name;
+		int match;
+
+		for (match = 0; ; match++) {
+			char c = name[match];
+			u16 u = unicode_name[match];
+
+			/* All special variables are plain ascii */
+			if (u > 127)
+				return true;
+
+			/* Wildcard in the matching name means we've matched */
+			if (c == '*')
+				return variable_validate[i].validate(var,
+							     match, data, len);
+
+			/* Case sensitive match */
+			if (c != u)
+				break;
+
+			/* Reached the end of the string while matching */
+			if (!c)
+				return variable_validate[i].validate(var,
+							     match, data, len);
+		}
+	}
+
+	return true;
+}
+
 static efi_status_t
 get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
 {
@@ -324,6 +494,12 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 		return -EINVAL;
 	}
 
+	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
+	    validate_var(new_var, new_var->Data, new_var->DataSize) == false) {
+		printk(KERN_ERR "efivars: Malformed variable content\n");
+		return -EINVAL;
+	}
+
 	spin_lock(&efivars->lock);
 	status = efivars->ops->set_variable(new_var->VariableName,
 					    &new_var->VendorGuid,
@@ -626,6 +802,12 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
+	    validate_var(new_var, new_var->Data, new_var->DataSize) == false) {
+		printk(KERN_ERR "efivars: Malformed variable content\n");
+		return -EINVAL;
+	}
+
 	spin_lock(&efivars->lock);
 
 	/*
-- 
1.7.10




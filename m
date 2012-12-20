Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2LTLe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:34:56 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65082 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2LTLet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:34:49 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: matt.fleming@intel.com
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86, efi: Allow slash in file path of initrd
Date: Thu, 20 Dec 2012 19:33:22 +0800
Message-Id: <1356003202-29516-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When initrd file didn't put at the same place with stub kernel, we
need give the file path of initrd, but need use backslash to separate
directory and file. It's not friendly to unix/linux user, and not so
intuitive for bootloader forward paramters to efi stub kernel by
chainloading.

This patch add support to handle_ramdisks for allow slash in file path
of initrd, it convert slash to backlash when parsing path.

In additional, this patch also separates print code of efi_char16_t from
efi_printk, and print out the path/filename of initrd when failed to open
initrd file. It's good for debug and discover typo.

Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com> 
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/eboot.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b1942e2..e360288 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -19,23 +19,28 @@
 
 static efi_system_table_t *sys_table;
 
+static void efi_char16_printk(efi_char16_t *str)
+{
+	struct efi_simple_text_output_protocol *out;
+
+	out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
+	efi_call_phys2(out->output_string, out, str);
+}
+
 static void efi_printk(char *str)
 {
 	char *s8;
 
 	for (s8 = str; *s8; s8++) {
-		struct efi_simple_text_output_protocol *out;
 		efi_char16_t ch[2] = { 0 };
 
 		ch[0] = *s8;
-		out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
-
 		if (*s8 == '\n') {
 			efi_char16_t nl[2] = { '\r', 0 };
-			efi_call_phys2(out->output_string, out, nl);
+			efi_char16_printk(nl);
 		}
 
-		efi_call_phys2(out->output_string, out, ch);
+		efi_char16_printk(ch);
 	}
 }
 
@@ -708,7 +713,12 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 			if ((u8 *)p >= (u8 *)filename_16 + sizeof(filename_16))
 				break;
 
-			*p++ = *str++;
+			if (*str == '/') {
+				*p++ = '\\';
+				*str++;
+			} else {
+				*p++ = *str++;
+			}
 		}
 
 		*p = '\0';
@@ -736,7 +746,9 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to open initrd file\n");
+			efi_printk("Failed to open initrd file: ");
+			efi_char16_printk(filename_16);
+			efi_printk("\n");
 			goto close_handles;
 		}
 
-- 
1.6.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2FNUsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:48:12 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36070 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352Ab2FNUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:48:11 -0400
From: Marko Kohtala <marko.kohtala@gmail.com>
To: Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>
Cc: Marko Kohtala <marko.kohtala@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] efivars: prevent Oops if efi_enabled but no EFI runtime
Date: Thu, 14 Jun 2012 23:47:30 +0300
Message-Id: <1339706851-10618-1-git-send-email-marko.kohtala@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v3.3-rc4-5-g1adbfa3, there has been an Oops in register_efivars
calling ops->get_next_variable and ending up at EIP 0 during module init.

I boot 32-bit x86 kernel from 64-bit EFI bootloader.

The efi_enabled is true, but runtime is not available. The functions
are NULL due to 32/64-bit mismatch between kernel and EFI.

Signed-off-by: Marko Kohtala <marko.kohtala@gmail.com>
---
I currently see this on v3.4.2.

I could not figure out how I'm supposed to detect lack of runtime, so
I ended up with this quick and overly precise check that all required
functions are available. There may be other drivers that need to take
this new condition into account, so maybe Olof wants to make a better
fix.

 drivers/firmware/efivars.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 47408e8..612a097 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1223,12 +1223,16 @@ efivars_init(void)
 		return -ENOMEM;
 	}
 
-	ops.get_variable = efi.get_variable;
-	ops.set_variable = efi.set_variable;
-	ops.get_next_variable = efi.get_next_variable;
-	error = register_efivars(&__efivars, &ops, efi_kobj);
-	if (error)
-		goto err_put;
+	/* We may have efi_enabled for systab, but no runtime for variables.
+	 * Check the functions we need before proceeding. */
+	if (efi.get_variable && efi.set_variable && efi.get_next_variable) {
+		ops.get_variable = efi.get_variable;
+		ops.set_variable = efi.set_variable;
+		ops.get_next_variable = efi.get_next_variable;
+		error = register_efivars(&__efivars, &ops, efi_kobj);
+		if (error)
+			goto err_put;
+	}
 
 	/* Don't forget the systab entry */
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
@@ -1251,10 +1255,10 @@ err_put:
 static void __exit
 efivars_exit(void)
 {
-	if (efi_enabled) {
+	if (__efivars.kset)
 		unregister_efivars(&__efivars);
+	if (efi_kobj)
 		kobject_put(efi_kobj);
-	}
 }
 
 module_init(efivars_init);
-- 
1.7.10.4


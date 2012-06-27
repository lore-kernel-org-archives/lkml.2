Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab2F0VgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:36:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58635 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2F0VgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:36:01 -0400
From: Olof Johansson <olof@lixom.net>
To: hpa@zytor.com
Cc: Marko Kohtala <marko.kohtala@gmail.com>, linux-kernel@vger.kernel.org,
        mjg@redhat.com, Olof Johansson <olof@lixom.net>
Subject: [PATCH] efi: add efi_runtime state checking
Date: Wed, 27 Jun 2012 14:35:57 -0700
Message-Id: <1340832957-7386-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <CAJ0yFaxO-ZU7d_RNbQ3y1cfB5EJL9wgvmgZk-nmkVOLoBRH88A@mail.gmail.com>
References: <CAJ0yFaxO-ZU7d_RNbQ3y1cfB5EJL9wgvmgZk-nmkVOLoBRH88A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an efi_runtime variable indicating whether the
efi runtime services are available. The only time they are
expected to not be available is when a 32-bit kernel has been
booted using 64-but EFI and vice versa.

It also adds checking to the two locations where functions are
called; x86 reboot and efivars.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: stable@kernel.org # 3.4
---

Marko,

This should solve the issue for you, I hope. I've verified that it works
here on my 64-bit EFI / 32-bit kernel systems (first-gen Chromebook).

Peter, let me know if you want this split up across several patches. I
preserved the previous probe/return behaviour for efivars, I suppose
it could be switched to -ENXIO return instead but this smaller change
seemed more suitable for -stable.


-Olof

 arch/x86/kernel/reboot.c    | 2 +-
 arch/x86/platform/efi/efi.c | 6 ++++++
 drivers/firmware/efivars.c  | 2 +-
 include/linux/efi.h         | 3 +++
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 52190a9..fa5bb6c 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -592,7 +592,7 @@ static void native_machine_emergency_restart(void)
 			break;
 
 		case BOOT_EFI:
-			if (efi_enabled)
+			if (efi_runtime)
 				efi.reset_system(reboot_mode ?
 						 EFI_RESET_WARM :
 						 EFI_RESET_COLD,
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2dc29f5..cc2bc12 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -53,6 +53,9 @@
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
 
+bool efi_runtime;
+EXPORT_SYMBOL(efi_runtime);
+
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
@@ -77,6 +80,7 @@ static efi_system_table_t efi_systab __initdata;
 static int __init setup_noefi(char *arg)
 {
 	efi_enabled = 0;
+	efi_runtime = 0;
 	return 0;
 }
 early_param("noefi", setup_noefi);
@@ -615,6 +619,8 @@ static int __init efi_runtime_init(void)
 
 	early_iounmap(runtime, sizeof(efi_runtime_services_t));
 
+	efi_runtime = 1;
+
 	return 0;
 }
 
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 47408e8..265449a 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1213,7 +1213,7 @@ efivars_init(void)
 	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
 	       EFIVARS_DATE);
 
-	if (!efi_enabled)
+	if (!efi_runtime)
 		return 0;
 
 	/* For now we'll register the efi directory at /sys/firmware/efi */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 103adc6..ac9c28d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -539,11 +539,14 @@ extern int __init efi_setup_pcdp_console(char *);
 # ifdef CONFIG_X86
    extern int efi_enabled;
    extern bool efi_64bit;
+   extern bool efi_runtime;
 # else
 #  define efi_enabled 1
+#  define efi_runtime 1
 # endif
 #else
 # define efi_enabled 0
+# define efi_runtime 0
 #endif
 
 /*
-- 
1.7.10.1.488.g05fbf7a


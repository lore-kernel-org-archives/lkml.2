Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2HSVs5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 17:48:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42212 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2HSVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 17:48:55 -0400
From: Olof Johansson <olof@lixom.net>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, mk@dee.su,
        Marko Kohtala <marko.kohtala@gmail.com>,
        Olof Johansson <olof@lixom.net>, Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
Date: Sun, 19 Aug 2012 14:48:40 -0700
Message-Id: <1345412920-10906-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 32-bit EFI is used with 64-bit kernel (or vice versa), turn off
efi_enabled once setup is done. Beyond setup, it is normally used to
determine if runtime services are available and we will have none.

This will resolve issues stemming from efivars modprobe panicking on a
32/64-bit setup, as well as some reboot issues on similar setups.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: stable@kernel.org # 3.4 and 3.5
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/kernel/setup.c     | 11 +++++++++++
 arch/x86/platform/efi/efi.c | 14 ++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..dad38ac 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1034,6 +1034,17 @@ void __init setup_arch(char **cmdline_p)
 	mcheck_init();
 
 	arch_init_ideal_nops();
+
+#ifdef CONFIG_EFI
+	/* Once setup is done above, disable efi_enabled on mismatched
+	 * firmware/kernel archtectures since there is no support for
+	 * runtime services.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64) ^ efi_64bit) {
+		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
+		efi_enabled = 0;
+	}
+#endif
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2dc29f5..17d7d50 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -69,11 +69,15 @@ EXPORT_SYMBOL(efi);
 struct efi_memory_map memmap;
 
 bool efi_64bit;
-static bool efi_native;
 
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
+static inline bool efi_is_native(void)
+{
+	return !(IS_ENABLED(CONFIG_X86_64) ^ efi_64bit);
+}
+
 static int __init setup_noefi(char *arg)
 {
 	efi_enabled = 0;
@@ -650,12 +654,10 @@ void __init efi_init(void)
 		return;
 	}
 	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
-	efi_native = !efi_64bit;
 #else
 	efi_phys.systab = (efi_system_table_t *)
 			  (boot_params.efi_info.efi_systab |
 			  ((__u64)boot_params.efi_info.efi_systab_hi<<32));
-	efi_native = efi_64bit;
 #endif
 
 	if (efi_systab_init(efi_phys.systab)) {
@@ -689,7 +691,7 @@ void __init efi_init(void)
 	 * that doesn't match the kernel 32/64-bit mode.
 	 */
 
-	if (!efi_native)
+	if (!efi_is_native())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else if (efi_runtime_init()) {
 		efi_enabled = 0;
@@ -700,7 +702,7 @@ void __init efi_init(void)
 		efi_enabled = 0;
 		return;
 	}
-	if (efi_native) {
+	if (efi_is_native()) {
 		x86_platform.get_wallclock = efi_get_time;
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
@@ -765,7 +767,7 @@ void __init efi_enter_virtual_mode(void)
 	 * non-native EFI
 	 */
 
-	if (!efi_native)
+	if (!efi_is_native())
 		goto out;
 
 	/* Merge contiguous regions of the same type and attribute */
-- 
1.7.10.1.488.g05fbf7a


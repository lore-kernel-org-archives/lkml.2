Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab2JXRAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:00:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59472 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab2JXRAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:00:51 -0400
From: Olof Johansson <olof@lixom.net>
To: matt@console-pimps.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, marko.kohtala@gmail.com,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH v3] x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
Date: Wed, 24 Oct 2012 10:00:44 -0700
Message-Id: <1351098044-4586-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1351059878-28795-1-git-send-email-olof@lixom.net>
References: <1351059878-28795-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 32-bit EFI is used with 64-bit kernel (or vice versa), turn off
efi_enabled once setup is done. Beyond setup, it is normally used to
determine if runtime services are available and we will have none.

This will resolve issues stemming from efivars modprobe panicking on a
32/64-bit setup, as well as some reboot issues on similar setups.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=45991

Reported-by: Marko Kohtala <marko.kohtala@gmail.com>
Reported-by: Maxim Kammerer <mk@dee.su>
Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: stable@kernel.org # 3.4 - 3.6
Cc: Matthew Garrett <mjg@redhat.com>
---

v3: Don't print disable warning if EFI was never enabled in the first place
v2: rebase due to context diffs, and simplified efi_is_native() logic.

 arch/x86/kernel/setup.c     | 11 +++++++++++
 arch/x86/platform/efi/efi.c | 16 +++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 468e98d..745d68f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1048,6 +1048,17 @@ void __init setup_arch(char **cmdline_p)
 	arch_init_ideal_nops();
 
 	register_refined_jiffies(CLOCK_TICK_RATE);
+
+#ifdef CONFIG_EFI
+	/* Once setup is done above, disable efi_enabled on mismatched
+	 * firmware/kernel archtectures since there is no support for
+	 * runtime services.
+	 */
+	if (efi_enabled && IS_ENABLED(CONFIG_X86_64) != efi_64bit) {
+		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
+		efi_enabled = 0;
+	}
+#endif
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index aded2a9..6e620f1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -70,11 +70,15 @@ EXPORT_SYMBOL(efi);
 struct efi_memory_map memmap;
 
 bool efi_64bit;
-static bool efi_native;
 
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
+static inline bool efi_is_native(void)
+{
+	return IS_ENABLED(CONFIG_X86_64) == efi_64bit;
+}
+
 static int __init setup_noefi(char *arg)
 {
 	efi_enabled = 0;
@@ -432,7 +436,7 @@ void __init efi_free_boot_services(void)
 {
 	void *p;
 
-	if (!efi_native)
+	if (!efi_is_native())
 		return;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -684,12 +688,10 @@ void __init efi_init(void)
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
@@ -723,7 +725,7 @@ void __init efi_init(void)
 	 * that doesn't match the kernel 32/64-bit mode.
 	 */
 
-	if (!efi_native)
+	if (!efi_is_native())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else if (efi_runtime_init()) {
 		efi_enabled = 0;
@@ -735,7 +737,7 @@ void __init efi_init(void)
 		return;
 	}
 #ifdef CONFIG_X86_32
-	if (efi_native) {
+	if (efi_is_native()) {
 		x86_platform.get_wallclock = efi_get_time;
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
@@ -834,7 +836,7 @@ void __init efi_enter_virtual_mode(void)
 	 * non-native EFI
 	 */
 
-	if (!efi_native) {
+	if (!efi_is_native()) {
 		efi_unmap_memmap();
 		return;
 	}
-- 
1.7.10.1.488.g05fbf7a


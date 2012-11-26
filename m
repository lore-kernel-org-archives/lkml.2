Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262Ab2KZRQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:16:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934251Ab2KZRQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:16:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 263/270] x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
Date: Mon, 26 Nov 2012 14:59:13 -0200
Message-Id: <1353949160-26803-264-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olof Johansson <olof@lixom.net>

commit 5189c2a7c7769ee9d037d76c1a7b8550ccf3481c upstream.

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
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/include/asm/efi.h  |    1 +
 arch/x86/kernel/setup.c     |   12 ++++++++++++
 arch/x86/platform/efi/efi.c |   18 ++++++++++--------
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index c9dcc18..029189d 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -98,6 +98,7 @@ extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
+extern void efi_unmap_memmap(void);
 
 #ifndef CONFIG_EFI
 /*
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6cafbcd..e860517 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1050,6 +1050,18 @@ void __init setup_arch(char **cmdline_p)
 	mcheck_init();
 
 	arch_init_ideal_nops();
+
+#ifdef CONFIG_EFI
+	/* Once setup is done above, disable efi_enabled on mismatched
+	 * firmware/kernel archtectures since there is no support for
+	 * runtime services.
+	 */
+	if (efi_enabled && IS_ENABLED(CONFIG_X86_64) != efi_64bit) {
+		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
+		efi_unmap_memmap();
+		efi_enabled = 0;
+	}
+#endif
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b3dbbdb..72d8899 100644
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
+	return IS_ENABLED(CONFIG_X86_64) == efi_64bit;
+}
+
 static int __init setup_noefi(char *arg)
 {
 	efi_enabled = 0;
@@ -419,7 +423,7 @@ void __init efi_reserve_boot_services(void)
 	}
 }
 
-static void __init efi_unmap_memmap(void)
+void __init efi_unmap_memmap(void)
 {
 	if (memmap.map) {
 		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
@@ -431,7 +435,7 @@ void __init efi_free_boot_services(void)
 {
 	void *p;
 
-	if (!efi_native)
+	if (!efi_is_native())
 		return;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -683,12 +687,10 @@ void __init efi_init(void)
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
@@ -722,7 +724,7 @@ void __init efi_init(void)
 	 * that doesn't match the kernel 32/64-bit mode.
 	 */
 
-	if (!efi_native)
+	if (!efi_is_native())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else if (efi_runtime_init()) {
 		efi_enabled = 0;
@@ -734,7 +736,7 @@ void __init efi_init(void)
 		return;
 	}
 #ifdef CONFIG_X86_32
-	if (efi_native) {
+	if (efi_is_native()) {
 		x86_platform.get_wallclock = efi_get_time;
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
@@ -800,7 +802,7 @@ void __init efi_enter_virtual_mode(void)
 	 * non-native EFI
 	 */
 
-	if (!efi_native) {
+	if (!efi_is_native()) {
 		efi_unmap_memmap();
 		return;
 	}
-- 
1.7.9.5


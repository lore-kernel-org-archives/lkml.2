Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab2J2VmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:42:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:48945 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933150Ab2J2VmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:42:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marko Kohtala <marko.kohtala@gmail.com>, Maxim Kammerer <mk@dee.su>,
        Olof Johansson <olof@lixom.net>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 51/54] x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
Date: Mon, 29 Oct 2012 14:40:52 -0700
Message-Id: <20121029213808.456967567@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/efi.h  |    1 +
 arch/x86/kernel/setup.c     |   12 ++++++++++++
 arch/x86/platform/efi/efi.c |   18 ++++++++++--------
 3 files changed, 23 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -98,6 +98,7 @@ extern void efi_set_executable(efi_memor
 extern int efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
+extern void efi_unmap_memmap(void);
 
 #ifndef CONFIG_EFI
 /*
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1053,6 +1053,18 @@ void __init setup_arch(char **cmdline_p)
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
@@ -419,7 +423,7 @@ void __init efi_reserve_boot_services(vo
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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314Ab2KZRTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:19:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48316 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934140Ab2KZRQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:16:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 262/270] efi: Defer freeing boot services memory until after ACPI init
Date: Mon, 26 Nov 2012 14:59:12 -0200
Message-Id: <1353949160-26803-263-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Triplett <josh@joshtriplett.org>

commit 785107923a83d8456bbd8564e288a24d84109a46 upstream.

Some new ACPI 5.0 tables reference resources stored in boot services
memory, so keep that memory around until we have ACPI and can extract
data from it.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Link: http://lkml.kernel.org/r/baaa6d44bdc4eb0c58e5d1b4ccd2c729f854ac55.1348876882.git.josh@joshtriplett.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/platform/efi/efi.c |   31 ++++++++++++++++++-------------
 include/linux/efi.h         |    5 +++++
 init/main.c                 |    3 +++
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f55a4ce..b3dbbdb 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -419,10 +419,21 @@ void __init efi_reserve_boot_services(void)
 	}
 }
 
-static void __init efi_free_boot_services(void)
+static void __init efi_unmap_memmap(void)
+{
+	if (memmap.map) {
+		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
+		memmap.map = NULL;
+	}
+}
+
+void __init efi_free_boot_services(void)
 {
 	void *p;
 
+	if (!efi_native)
+		return;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
 		unsigned long long start = md->phys_addr;
@@ -438,6 +449,8 @@ static void __init efi_free_boot_services(void)
 
 		free_bootmem_late(start, size);
 	}
+
+	efi_unmap_memmap();
 }
 
 static int __init efi_systab_init(void *phys)
@@ -787,8 +800,10 @@ void __init efi_enter_virtual_mode(void)
 	 * non-native EFI
 	 */
 
-	if (!efi_native)
-		goto out;
+	if (!efi_native) {
+		efi_unmap_memmap();
+		return;
+	}
 
 	/* Merge contiguous regions of the same type and attribute */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -878,13 +893,6 @@ void __init efi_enter_virtual_mode(void)
 	}
 
 	/*
-	 * Thankfully, it does seem that no runtime services other than
-	 * SetVirtualAddressMap() will touch boot services code, so we can
-	 * get rid of it all at this point
-	 */
-	efi_free_boot_services();
-
-	/*
 	 * Now that EFI is in virtual mode, update the function
 	 * pointers in the runtime service table to the new virtual addresses.
 	 *
@@ -907,9 +915,6 @@ void __init efi_enter_virtual_mode(void)
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
 
-out:
-	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
-	memmap.map = NULL;
 	kfree(new_memmap);
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec45ccd..5782114 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -496,6 +496,11 @@ extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+#ifdef CONFIG_X86
+extern void efi_free_boot_services(void);
+#else
+static inline void efi_free_boot_services(void) {}
+#endif
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
diff --git a/init/main.c b/init/main.c
index b5cc0a7..593c8b6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -630,6 +630,9 @@ asmlinkage void __init start_kernel(void)
 	acpi_early_init(); /* before LAPIC and SMP init */
 	sfi_init_late();
 
+	if (efi_enabled)
+		efi_free_boot_services();
+
 	ftrace_init();
 
 	/* Do the rest non-__init'ed, we're now alive */
-- 
1.7.9.5


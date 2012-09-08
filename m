Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2IHWHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:07:11 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:58104 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab2IHWHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:07:04 -0400
X-Originating-IP: 217.70.178.150
X-Originating-IP: 50.43.46.74
Date: Sat, 8 Sep 2012 15:06:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org
Subject: [PATCHv3 2/4] efi: Defer freeing boot services memory until after
 ACPI init
Message-ID: <575b74a90571493561bf7bcf6fc0bdc12779fe35.1347141698.git.josh@joshtriplett.org>
References: <cover.1347141698.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1347141698.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some new ACPI 5.0 tables reference resources stored in boot services
memory, so keep that memory around until we have ACPI and can extract
data from it.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/platform/efi/efi.c |   31 ++++++++++++++++++-------------
 include/linux/efi.h         |    2 ++
 init/main.c                 |    3 +++
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 92660eda..ab2cfe8 100644
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
@@ -906,9 +914,6 @@ void __init efi_enter_virtual_mode(void)
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
 
-out:
-	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
-	memmap.map = NULL;
 	kfree(new_memmap);
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 52fbedf..3c72c27 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -497,8 +497,10 @@ extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 #ifdef CONFIG_X86
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+extern void efi_free_boot_services(void);
 #else
 static void efi_enter_virtual_mode(void) {}
+static void efi_free_boot_services(void) {}
 #endif
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
diff --git a/init/main.c b/init/main.c
index ebb1ba5..78e5491 100644
--- a/init/main.c
+++ b/init/main.c
@@ -629,6 +629,9 @@ asmlinkage void __init start_kernel(void)
 	acpi_early_init(); /* before LAPIC and SMP init */
 	sfi_init_late();
 
+	if (efi_enabled)
+		efi_free_boot_services();
+
 	ftrace_init();
 
 	/* Do the rest non-__init'ed, we're now alive */
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab2I2XNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 19:13:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2I2XNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 19:13:40 -0400
Date: Sat, 29 Sep 2012 16:13:20 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-785107923a83d8456bbd8564e288a24d84109a46@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        josh@joshtriplett.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, josh@joshtriplett.org, hpa@linux.intel.com
In-Reply-To: <baaa6d44bdc4eb0c58e5d1b4ccd2c729f854ac55.1348876882.git.josh@joshtriplett.org>
References: <baaa6d44bdc4eb0c58e5d1b4ccd2c729f854ac55.1348876882.git.josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] efi:
  Defer freeing boot services memory until after ACPI init
Git-Commit-ID: 785107923a83d8456bbd8564e288a24d84109a46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 29 Sep 2012 16:13:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  785107923a83d8456bbd8564e288a24d84109a46
Gitweb:     http://git.kernel.org/tip/785107923a83d8456bbd8564e288a24d84109a46
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Fri, 28 Sep 2012 17:55:44 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 29 Sep 2012 12:21:01 -0700

efi: Defer freeing boot services memory until after ACPI init

Some new ACPI 5.0 tables reference resources stored in boot services
memory, so keep that memory around until we have ACPI and can extract
data from it.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Link: http://lkml.kernel.org/r/baaa6d44bdc4eb0c58e5d1b4ccd2c729f854ac55.1348876882.git.josh@joshtriplett.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index b286730..d61ec54 100644
--- a/init/main.c
+++ b/init/main.c
@@ -631,6 +631,9 @@ asmlinkage void __init start_kernel(void)
 	acpi_early_init(); /* before LAPIC and SMP init */
 	sfi_init_late();
 
+	if (efi_enabled)
+		efi_free_boot_services();
+
 	ftrace_init();
 
 	/* Do the rest non-__init'ed, we're now alive */

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab1EZCHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 22:07:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:46212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab1EZCHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 22:07:15 -0400
Date: Thu, 26 May 2011 02:07:06 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Message-ID: <tip-916f676f8dc016103f983c7ec54c18ecdbb6e349@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, stable@kernel.org, tony.luck@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, hpa@linux.intel.com
In-Reply-To: <1306331593-28715-1-git-send-email-mjg@redhat.com>
References: <1306331593-28715-1-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, efi: Retain boot service code until after switching to virtual mode
Git-Commit-ID: 916f676f8dc016103f983c7ec54c18ecdbb6e349
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 May 2011 02:07:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  916f676f8dc016103f983c7ec54c18ecdbb6e349
Gitweb:     http://git.kernel.org/tip/916f676f8dc016103f983c7ec54c18ecdbb6e349
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Wed, 25 May 2011 09:53:13 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 25 May 2011 17:03:53 -0700

x86, efi: Retain boot service code until after switching to virtual mode

UEFI stands for "Unified Extensible Firmware Interface", where "Firmware"
is an ancient African word meaning "Why do something right when you can
do it so wrong that children will weep and brave adults will cower before
you", and "UEI" is Celtic for "We missed DOS so we burned it into your
ROMs". The UEFI specification provides for runtime services (ie, another
way for the operating system to be forced to depend on the firmware) and
we rely on these for certain trivial tasks such as setting up the
bootloader. But some hardware fails to work if we attempt to use these
runtime services from physical mode, and so we have to switch into virtual
mode. So far so dreadful.

The specification makes it clear that the operating system is free to do
whatever it wants with boot services code after ExitBootServices() has been
called. SetVirtualAddressMap() can't be called until ExitBootServices() has
been. So, obviously, a whole bunch of EFI implementations call into boot
services code when we do that. Since we've been charmingly naive and
trusted that the specification may be somehow relevant to the real world,
we've already stuffed a picture of a penguin or something in that address
space. And just to make things more entertaining, we've also marked it
non-executable.

This patch allocates the boot services regions during EFI init and makes
sure that they're executable. Then, after SetVirtualAddressMap(), it
discards them and everyone lives happily ever after. Except for the ones
who have to work on EFI, who live sad lives haunted by the knowledge that
someone's eventually going to write yet another firmware specification.

[ hpa: adding this to urgent with a stable tag since it fixes currently-broken
  hardware.  However, I do not know what the dependencies are and so I do
  not know which -stable versions this may be a candidate for. ]

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Link: http://lkml.kernel.org/r/1306331593-28715-1-git-send-email-mjg@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/setup.c        |    7 ++++++
 arch/x86/platform/efi/efi.c    |   45 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/platform/efi/efi_64.c |    5 ++-
 include/linux/efi.h            |    1 +
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 605e5ae..b9ca498 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -910,6 +910,13 @@ void __init setup_arch(char **cmdline_p)
 	memblock.current_limit = get_max_mapped();
 	memblock_x86_fill();
 
+	/*
+	 * The EFI specification says that boot service code won't be called
+	 * after ExitBootServices(). This is, in fact, a lie.
+	 */
+	if (efi_enabled)
+		efi_reserve_boot_services();
+
 	/* preallocate 4k for mptable mpc */
 	early_reserve_e820_mpc_new();
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b30aa26..0d3a4fa 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -304,6 +304,40 @@ static void __init print_efi_memmap(void)
 }
 #endif  /*  EFI_DEBUG  */
 
+void __init efi_reserve_boot_services(void)
+{
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		unsigned long long start = md->phys_addr;
+		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		memblock_x86_reserve_range(start, start + size, "EFI Boot");
+	}
+}
+
+static void __init efi_free_boot_services(void)
+{
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		unsigned long long start = md->phys_addr;
+		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		free_bootmem_late(start, size);
+	}
+}
+
 void __init efi_init(void)
 {
 	efi_config_table_t *config_tables;
@@ -536,7 +570,9 @@ void __init efi_enter_virtual_mode(void)
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
@@ -593,6 +629,13 @@ void __init efi_enter_virtual_mode(void)
 	}
 
 	/*
+	 * Thankfully, it does seem that no runtime services other than
+	 * SetVirtualAddressMap() will touch boot services code, so we can
+	 * get rid of it all at this point
+	 */
+	efi_free_boot_services();
+
+	/*
 	 * Now that EFI is in virtual mode, update the function
 	 * pointers in the runtime service table to the new virtual addresses.
 	 *
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 2649426..ac3aa54 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -49,10 +49,11 @@ static void __init early_code_mapping_set_exec(int executable)
 	if (!(__supported_pte_mask & _PAGE_NX))
 		return;
 
-	/* Make EFI runtime service code area executable */
+	/* Make EFI service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (md->type == EFI_RUNTIME_SERVICES_CODE)
+		if (md->type == EFI_RUNTIME_SERVICES_CODE ||
+		    md->type == EFI_BOOT_SERVICES_CODE)
 			efi_set_executable(md, executable);
 	}
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 33fa120..e376270 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -299,6 +299,7 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
+extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
 /**

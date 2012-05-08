Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab2EHW2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:28:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2EHW23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:28:29 -0400
Date: Tue, 8 May 2012 15:28:18 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-b429dbf6e866bd6dadb56fae66f61f611cde57ff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jarkko.sakkinen@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jarkko.sakkinen@intel.com, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-19-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-19-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode: don't copy real_mode_header
Git-Commit-ID: b429dbf6e866bd6dadb56fae66f61f611cde57ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:28:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b429dbf6e866bd6dadb56fae66f61f611cde57ff
Gitweb:     http://git.kernel.org/tip/b429dbf6e866bd6dadb56fae66f61f611cde57ff
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Tue, 8 May 2012 21:22:41 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:48:45 -0700

x86, realmode: don't copy real_mode_header

Replaced copying of real_mode_header with a pointer
to beginning of RM memory.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-19-git-send-email-jarkko.sakkinen@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/realmode.h     |    5 +--
 arch/x86/kernel/acpi/sleep.c        |    2 +-
 arch/x86/kernel/realmode.c          |   57 +++++++++++++++-------------------
 arch/x86/kernel/reboot.c            |    2 +-
 arch/x86/kernel/smpboot.c           |    4 +-
 arch/x86/kernel/tboot.c             |    2 +-
 arch/x86/realmode/rm/header.S       |    1 -
 arch/x86/realmode/rm/realmode.lds.S |    1 -
 arch/x86/realmode/rmpiggy.S         |    2 +
 drivers/acpi/sleep.c                |    2 +-
 10 files changed, 35 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 1bfc74d..d3ae49f 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -8,7 +8,6 @@
 struct real_mode_header {
 	u32	text_start;
 	u32	ro_end;
-	u32	end;
 	/* reboot */
 #ifdef CONFIG_X86_32
 	u32	machine_real_restart_asm;
@@ -30,8 +29,8 @@ struct real_mode_header {
 #endif
 } __attribute__((__packed__));
 
-extern struct real_mode_header real_mode_header;
-extern unsigned char *real_mode_base;
+extern struct real_mode_header *real_mode_header;
+extern unsigned char real_mode_blob_end[];
 
 extern unsigned long init_rsp;
 extern unsigned long initial_code;
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index d941b62..6ca3f54 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -38,7 +38,7 @@ asmlinkage void acpi_enter_s3(void)
 int acpi_suspend_lowlevel(void)
 {
 	struct wakeup_header *header =
-		(struct wakeup_header *) __va(real_mode_header.wakeup_header);
+		(struct wakeup_header *) __va(real_mode_header->wakeup_header);
 
 	if (header->signature != WAKEUP_HEADER_SIGNATURE) {
 		printk(KERN_ERR "wakeup header does not match\n");
diff --git a/arch/x86/kernel/realmode.c b/arch/x86/kernel/realmode.c
index e7bf82a..632c810 100644
--- a/arch/x86/kernel/realmode.c
+++ b/arch/x86/kernel/realmode.c
@@ -5,8 +5,7 @@
 #include <asm/pgtable.h>
 #include <asm/realmode.h>
 
-unsigned char *real_mode_base;
-struct real_mode_header real_mode_header;
+struct real_mode_header *real_mode_header;
 
 void __init setup_real_mode(void)
 {
@@ -17,33 +16,32 @@ void __init setup_real_mode(void)
 	u32 *ptr;
 	u16 *seg;
 	int i;
+	unsigned char *base;
 
-	struct real_mode_header *header =
-		(struct real_mode_header *) real_mode_blob;
-
-	size_t size = PAGE_ALIGN(header->end);
+	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
 
 	/* Has to be in very low memory so we can execute real-mode AP code. */
 	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
 	if (!mem)
 		panic("Cannot allocate trampoline\n");
 
-	real_mode_base = __va(mem);
+	base = __va(mem);
 	memblock_reserve(mem, size);
+	real_mode_header = (struct real_mode_header *) base;
 
 	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
-	       real_mode_base, (unsigned long long)mem, size);
+	       base, (unsigned long long)mem, size);
 
-	memcpy(real_mode_base, real_mode_blob, size);
+	memcpy(base, real_mode_blob, size);
 
-	real_mode_seg = __pa(real_mode_base) >> 4;
+	real_mode_seg = __pa(base) >> 4;
 	rel = (u32 *) real_mode_relocs;
 
 	/* 16-bit segment relocations. */
 	count = rel[0];
 	rel = &rel[1];
 	for (i = 0; i < count; i++) {
-		seg = (u16 *) (real_mode_base + rel[i]);
+		seg = (u16 *) (base + rel[i]);
 		*seg = real_mode_seg;
 	}
 
@@ -51,25 +49,21 @@ void __init setup_real_mode(void)
 	count = rel[i];
 	rel =  &rel[i + 1];
 	for (i = 0; i < count; i++) {
-		ptr = (u32 *) (real_mode_base + rel[i]);
-		*ptr += __pa(real_mode_base);
+		ptr = (u32 *) (base + rel[i]);
+		*ptr += __pa(base);
 	}
 
-	/* Copied header will contain relocated physical addresses. */
-	memcpy(&real_mode_header, real_mode_base,
-	       sizeof(struct real_mode_header));
-
 #ifdef CONFIG_X86_32
-	*((u32 *)__va(real_mode_header.startup_32_smp)) = __pa(startup_32_smp);
-	*((u32 *)__va(real_mode_header.boot_gdt)) = __pa(boot_gdt);
+	*((u32 *)__va(real_mode_header->startup_32_smp)) = __pa(startup_32_smp);
+	*((u32 *)__va(real_mode_header->boot_gdt)) = __pa(boot_gdt);
 #else
-	*((u64 *) __va(real_mode_header.startup_64_smp)) =
+	*((u64 *) __va(real_mode_header->startup_64_smp)) =
 		(u64)secondary_startup_64;
 
-	*((u64 *) __va(real_mode_header.level3_ident_pgt)) =
+	*((u64 *) __va(real_mode_header->level3_ident_pgt)) =
 		__pa(level3_ident_pgt) + _KERNPG_TABLE;
 
-	*((u64 *) __va(real_mode_header.level3_kernel_pgt)) =
+	*((u64 *) __va(real_mode_header->level3_kernel_pgt)) =
 		__pa(level3_kernel_pgt) + _KERNPG_TABLE;
 #endif
 }
@@ -82,23 +76,22 @@ void __init setup_real_mode(void)
  */
 static int __init set_real_mode_permissions(void)
 {
-	size_t all_size =
-		PAGE_ALIGN(real_mode_header.end) -
-		__pa(real_mode_base);
+	unsigned char *base = (unsigned char *) real_mode_header;
+	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
 
 	size_t ro_size =
-		PAGE_ALIGN(real_mode_header.ro_end) -
-		__pa(real_mode_base);
+		PAGE_ALIGN(real_mode_header->ro_end) -
+		__pa(base);
 
 	size_t text_size =
-		PAGE_ALIGN(real_mode_header.ro_end) -
-		real_mode_header.text_start;
+		PAGE_ALIGN(real_mode_header->ro_end) -
+		real_mode_header->text_start;
 
 	unsigned long text_start =
-		(unsigned long) __va(real_mode_header.text_start);
+		(unsigned long) __va(real_mode_header->text_start);
 
-	set_memory_nx((unsigned long) real_mode_base, all_size >> PAGE_SHIFT);
-	set_memory_ro((unsigned long) real_mode_base, ro_size >> PAGE_SHIFT);
+	set_memory_nx((unsigned long) base, size >> PAGE_SHIFT);
+	set_memory_ro((unsigned long) base, ro_size >> PAGE_SHIFT);
 	set_memory_x((unsigned long) text_start, text_size >> PAGE_SHIFT);
 
 	return 0;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 050eff2..658f856 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -336,7 +336,7 @@ core_initcall(reboot_init);
 void machine_real_restart(unsigned int type)
 {
 	void (*restart_lowmem)(unsigned int) = (void (*)(unsigned int))
-		real_mode_header.machine_real_restart_asm;
+		real_mode_header->machine_real_restart_asm;
 
 	local_irq_disable();
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c7971ea..b8c0661 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -665,9 +665,9 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 {
 	volatile u32 *trampoline_status =
-		(volatile u32 *) __va(real_mode_header.trampoline_status);
+		(volatile u32 *) __va(real_mode_header->trampoline_status);
 	/* start_ip had better be page-aligned! */
-	unsigned long start_ip = real_mode_header.trampoline_data;
+	unsigned long start_ip = real_mode_header->trampoline_data;
 
 	unsigned long boot_error = 0;
 	int timeout;
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index c136e23..65adda4 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -202,7 +202,7 @@ static int tboot_setup_sleep(void)
 	}
 
 	tboot->acpi_sinfo.kernel_s3_resume_vector =
-		real_mode_header.wakeup_start;
+		real_mode_header->wakeup_start;
 
 	return 0;
 }
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index a91ec8f..c83005c 100644
--- a/arch/x86/realmode/rm/header.S
+++ b/arch/x86/realmode/rm/header.S
@@ -12,7 +12,6 @@
 GLOBAL(real_mode_header)
 		.long	pa_text_start
 		.long	pa_ro_end
-		.long	pa_end
 #ifdef CONFIG_X86_32
 		.long	pa_machine_real_restart_asm
 #endif
diff --git a/arch/x86/realmode/rm/realmode.lds.S b/arch/x86/realmode/rm/realmode.lds.S
index 4d4afca..86b2e8d 100644
--- a/arch/x86/realmode/rm/realmode.lds.S
+++ b/arch/x86/realmode/rm/realmode.lds.S
@@ -65,7 +65,6 @@ SECTIONS
 	.signature : {
 		*(.signature)
 	}
-	pa_end = .;
 
 	/DISCARD/ : {
 		*(.note*)
diff --git a/arch/x86/realmode/rmpiggy.S b/arch/x86/realmode/rmpiggy.S
index fd72a99..204c6ec 100644
--- a/arch/x86/realmode/rmpiggy.S
+++ b/arch/x86/realmode/rmpiggy.S
@@ -13,6 +13,8 @@ GLOBAL(real_mode_blob)
 	.incbin	"arch/x86/realmode/rm/realmode.bin"
 END(real_mode_blob)
 
+GLOBAL(real_mode_blob_end);
+
 GLOBAL(real_mode_relocs)
 	.incbin	"arch/x86/realmode/rm/realmode.relocs"
 END(real_mode_relocs)
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index e77aa4a..0613900 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -93,7 +93,7 @@ static struct notifier_block tts_notifier = {
 static int acpi_sleep_prepare(u32 acpi_state)
 {
 #ifdef CONFIG_ACPI_SLEEP
-	unsigned long wakeup_pa = real_mode_header.wakeup_start;
+	unsigned long wakeup_pa = real_mode_header->wakeup_start;
 	/* do we have a wakeup address for S2 and S3? */
 	if (acpi_state == ACPI_STATE_S3) {
 		if (!wakeup_pa)

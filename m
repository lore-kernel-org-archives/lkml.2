Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1GGSZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:25:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33556 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab1GGSY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:24:59 -0400
Date: Thu, 7 Jul 2011 20:24:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110707182455.GA15863@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

 Thanks,

	Ingo

------------------>
Kees Cook (1):
      x86, suspend: Restore MISC_ENABLE MSR in realmode wakeup

Matthew Garrett (1):
      x86: Don't use the EFI reboot method by default

Peter Chubb (1):
      x86, reboot: Acer Aspire One A110 reboot quirk

Tejun Heo (1):
      x86-32, NUMA: Fix boot regression caused by NUMA init unification on highmem machines


 arch/x86/include/asm/mmzone_32.h       |    2 ++
 arch/x86/kernel/acpi/realmode/wakeup.S |   14 ++++++++++++++
 arch/x86/kernel/acpi/realmode/wakeup.h |    6 ++++++
 arch/x86/kernel/acpi/sleep.c           |    6 ++++++
 arch/x86/kernel/reboot.c               |    8 ++++++++
 arch/x86/platform/efi/efi.c            |    3 ---
 6 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 224e8c5..ffa037f 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -57,6 +57,8 @@ static inline int pfn_valid(int pfn)
 	return 0;
 }
 
+#define early_pfn_valid(pfn)	pfn_valid((pfn))
+
 #endif /* CONFIG_DISCONTIGMEM */
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index ead21b6..b4fd836 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -28,6 +28,8 @@ pmode_cr3:	.long	0	/* Saved %cr3 */
 pmode_cr4:	.long	0	/* Saved %cr4 */
 pmode_efer:	.quad	0	/* Saved EFER */
 pmode_gdt:	.quad	0
+pmode_misc_en:	.quad	0	/* Saved MISC_ENABLE MSR */
+pmode_behavior:	.long	0	/* Wakeup behavior flags */
 realmode_flags:	.long	0
 real_magic:	.long	0
 trampoline_segment:	.word 0
@@ -91,6 +93,18 @@ wakeup_code:
 	/* Call the C code */
 	calll	main
 
+	/* Restore MISC_ENABLE before entering protected mode, in case
+	   BIOS decided to clear XD_DISABLE during S3. */
+	movl	pmode_behavior, %eax
+	btl	$WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE, %eax
+	jnc	1f
+
+	movl	pmode_misc_en, %eax
+	movl	pmode_misc_en + 4, %edx
+	movl	$MSR_IA32_MISC_ENABLE, %ecx
+	wrmsr
+1:
+
 	/* Do any other stuff... */
 
 #ifndef CONFIG_64BIT
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/kernel/acpi/realmode/wakeup.h
index e1828c0..97a29e1 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -21,6 +21,9 @@ struct wakeup_header {
 	u32 pmode_efer_low;	/* Protected mode EFER */
 	u32 pmode_efer_high;
 	u64 pmode_gdt;
+	u32 pmode_misc_en_low;	/* Protected mode MISC_ENABLE */
+	u32 pmode_misc_en_high;
+	u32 pmode_behavior;	/* Wakeup routine behavior flags */
 	u32 realmode_flags;
 	u32 real_magic;
 	u16 trampoline_segment;	/* segment with trampoline code, 64-bit only */
@@ -39,4 +42,7 @@ extern struct wakeup_header wakeup_header;
 #define WAKEUP_HEADER_SIGNATURE 0x51ee1111
 #define WAKEUP_END_SIGNATURE	0x65a22c82
 
+/* Wakeup behavior bits */
+#define WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE     0
+
 #endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 18a857b..103b6ab 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -77,6 +77,12 @@ int acpi_suspend_lowlevel(void)
 
 	header->pmode_cr0 = read_cr0();
 	header->pmode_cr4 = read_cr4_safe();
+	header->pmode_behavior = 0;
+	if (!rdmsr_safe(MSR_IA32_MISC_ENABLE,
+			&header->pmode_misc_en_low,
+			&header->pmode_misc_en_high))
+		header->pmode_behavior |=
+			(1 << WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE);
 	header->realmode_flags = acpi_realmode_flags;
 	header->real_magic = 0x12345678;
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 0c016f7..4f0d46f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -294,6 +294,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "VersaLogic Menlow board"),
 		},
 	},
+	{ /* Handle reboot issue on Acer Aspire one */
+		.callback = set_bios_reboot,
+		.ident = "Acer Aspire One A110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 474356b..899e393 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -504,9 +504,6 @@ void __init efi_init(void)
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
 #endif
 
-	/* Setup for EFI runtime service */
-	reboot_type = BOOT_EFI;
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif

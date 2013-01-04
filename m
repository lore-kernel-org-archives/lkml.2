Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab3ADAyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:54:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26846 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3ADAt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:59 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 11/31] x86: Merge early_reserve_initrd for 32bit and 64bit
Date: Thu,  3 Jan 2013 16:48:31 -0800
Message-Id: <1357260531-11115-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the same, could move them out from head32/64.c to setup.c.

We are using memblock, and it could handle overlapping properly, so
we don't need to reserve some at first to hold the location, and just
need to make sure we reserve them before we are using memblock to find
free mem to use.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/kernel/head32.c |   11 -----------
 arch/x86/kernel/head64.c |   11 -----------
 arch/x86/kernel/setup.c  |   22 ++++++++++++++++++----
 3 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index e175548..b071d41 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -33,17 +33,6 @@ void __init i386_start_kernel(void)
 	memblock_reserve(__pa_symbol(_text),
 			 (unsigned long)__bss_stop - (unsigned long)_text);
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	/* Reserve INITRD */
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
-		/* Assume only end is not page aligned */
-		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-		u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
-	}
-#endif
-
 	/* Call the subarch specific early setup function */
 	switch (boot_params.hdr.hardware_subarch) {
 	case X86_SUBARCH_MRST:
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 7061d8b..c463725 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -176,17 +176,6 @@ void __init x86_64_start_reservations(char *real_mode_data)
 	memblock_reserve(__pa_symbol(_text),
 			 (unsigned long)__bss_stop - (unsigned long)_text);
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	/* Reserve INITRD */
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
-		/* Assume only end is not page aligned */
-		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
-		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-		unsigned long ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
-	}
-#endif
-
 	reserve_ebda_region();
 
 	/*
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 04797e78..1b8a8cc 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -360,6 +360,19 @@ static u64 __init get_mem_size(unsigned long limit_pfn)
 
 	return mapped_pages << PAGE_SHIFT;
 }
+static void __init early_reserve_initrd(void)
+{
+	/* Assume only end is not page aligned */
+	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
+
+	if (!boot_params.hdr.type_of_loader ||
+	    !ramdisk_image || !ramdisk_size)
+		return;		/* No initrd provided by bootloader */
+
+	memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
+}
 static void __init reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
@@ -386,10 +399,6 @@ static void __init reserve_initrd(void)
 	if (pfn_range_is_mapped(PFN_DOWN(ramdisk_image),
 				PFN_DOWN(ramdisk_end))) {
 		/* All are mapped, easy case */
-		/*
-		 * don't need to reserve again, already reserved early
-		 * in i386_start_kernel
-		 */
 		initrd_start = ramdisk_image + PAGE_OFFSET;
 		initrd_end = initrd_start + ramdisk_size;
 		return;
@@ -400,6 +409,9 @@ static void __init reserve_initrd(void)
 	memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
 }
 #else
+static void __init early_reserve_initrd(void)
+{
+}
 static void __init reserve_initrd(void)
 {
 }
@@ -661,6 +673,8 @@ early_param("reservelow", parse_reservelow);
 
 void __init setup_arch(char **cmdline_p)
 {
+	early_reserve_initrd();
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
-- 
1.7.10.4


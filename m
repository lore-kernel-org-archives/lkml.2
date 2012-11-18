Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab2KRHMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 02:12:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17142 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2KRHJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 02:09:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 06/13] x86: Merge early_reserve_initrd for 32bit and 64bit
Date: Sat, 17 Nov 2012 23:09:24 -0800
Message-Id: <1353222571-31544-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
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
---
 arch/x86/kernel/head32.c |   11 -----------
 arch/x86/kernel/head64.c |   11 -----------
 arch/x86/kernel/setup.c  |   22 ++++++++++++++++++----
 3 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index c18f59d..4c52efc 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -33,17 +33,6 @@ void __init i386_start_kernel(void)
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
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
index 037df57..00e612a 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -100,17 +100,6 @@ void __init x86_64_start_reservations(char *real_mode_data)
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
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
index 6d29d1f..ee6d267 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -364,6 +364,19 @@ static u64 __init get_mem_size(unsigned long limit_pfn)
 
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
@@ -390,10 +403,6 @@ static void __init reserve_initrd(void)
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
@@ -404,6 +413,9 @@ static void __init reserve_initrd(void)
 	memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
 }
 #else
+static void __init early_reserve_initrd(void)
+{
+}
 static void __init reserve_initrd(void)
 {
 }
@@ -665,6 +677,8 @@ early_param("reservelow", parse_reservelow);
 
 void __init setup_arch(char **cmdline_p)
 {
+	early_reserve_initrd();
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
-- 
1.7.7


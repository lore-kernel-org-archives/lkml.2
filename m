Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab2KPIxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:53:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41373 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2KPIxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:53:33 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 6/9] x86: add get_ramdisk_image/size
Date: Fri, 16 Nov 2012 00:53:06 -0800
Message-Id: <1353055989-31939-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There several places to find ramdisk early for reserving and relocating.

use functions to make code more readable and consistent.

later will add ext_ramdisk_image/size with those functions to support
loading ramdisk above 4g.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ee6d267..194e151 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -298,12 +298,25 @@ static void __init reserve_brk(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
+static u64 __init get_ramdisk_image(void)
+{
+	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+
+	return ramdisk_image;
+}
+static u64 __init get_ramdisk_size(void)
+{
+	u64 ramdisk_size = boot_params.hdr.ramdisk_size;
+
+	return ramdisk_size;
+}
+
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 static void __init relocate_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_image = get_ramdisk_image();
+	u64 ramdisk_size  = get_ramdisk_size();
 	u64 area_size     = PAGE_ALIGN(ramdisk_size);
 	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
@@ -342,8 +355,8 @@ static void __init relocate_initrd(void)
 		ramdisk_size  -= clen;
 	}
 
-	ramdisk_image = boot_params.hdr.ramdisk_image;
-	ramdisk_size  = boot_params.hdr.ramdisk_size;
+	ramdisk_image = get_ramdisk_image();
+	ramdisk_size  = get_ramdisk_size();
 	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
 		" [mem %#010llx-%#010llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
@@ -367,8 +380,8 @@ static u64 __init get_mem_size(unsigned long limit_pfn)
 static void __init early_reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_image = get_ramdisk_image();
+	u64 ramdisk_size  = get_ramdisk_size();
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 
 	if (!boot_params.hdr.type_of_loader ||
@@ -380,8 +393,8 @@ static void __init early_reserve_initrd(void)
 static void __init reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_image = get_ramdisk_image();
+	u64 ramdisk_size  = get_ramdisk_size();
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 	u64 mapped_size;
 
-- 
1.7.7


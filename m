Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2A3DfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:35:06 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:44106 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab2A3DfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:35:03 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, mm: Probe memory block size for generic x86 64bit
Date: Sun, 29 Jan 2012 19:34:16 -0800
Message-Id: <1327894456-30412-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F260FD2.0096,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually if the system support memory remapping to get back memory for mmio
range, we will have 128M ... 2G at the end.

Try to probe that size.

So we can get less entries in /sys/devices/system/memory/

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -890,17 +890,33 @@ const char *arch_vma_name(struct vm_area
 	return NULL;
 }
 
-#ifdef CONFIG_X86_UV
 unsigned long memory_block_size_bytes(void)
 {
+	/* start from 2g */
+	unsigned long bz = 1UL<<31;
+
+#ifdef CONFIG_X86_UV
 	if (is_uv_system()) {
 		printk(KERN_INFO "UV: memory block size 2GB\n");
 		return 2UL * 1024 * 1024 * 1024;
 	}
-	return MIN_MEMORY_BLOCK_SIZE;
-}
 #endif
 
+	/* less than 4g installed */
+	if ((max_pfn << PAGE_SHIFT) < (1UL << 32))
+		return MIN_MEMORY_BLOCK_SIZE * 2;
+
+	/* get the tail size */
+	while (bz > MIN_MEMORY_BLOCK_SIZE) {
+		if (!((max_pfn << PAGE_SHIFT) & (bz - 1)))
+			break;
+		bz >>= 1;
+	}
+	printk(KERN_DEBUG "memory block size : %ldMB\n", bz >> 20);
+
+	return bz;
+}
+
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.

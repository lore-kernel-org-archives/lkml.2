Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0CXKiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:38:03 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:21156 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab0CXKiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:38:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 7/8] early_res: prepare for other platform to use it
Date: Wed, 24 Mar 2010 03:34:20 -0700
Message-Id: <1269426861-20903-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269426861-20903-1-git-send-email-yinghai@kernel.org>
References: <1269426861-20903-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BA9EB6B.00F9,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@@kernel.org>

add weak reserver_bootmem_generic()

also clean up x86 64 bit one.

add include for linux/early_res.h

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_32.c |    5 -----
 arch/x86/mm/init_64.c |   18 ------------------
 mm/bootmem.c          |    7 +++++++
 mm/page_alloc.c       |    1 +
 4 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index a7625d5..16001e1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1070,8 +1070,3 @@ void mark_rodata_ro(void)
 }
 #endif
 
-int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
-				   int flags)
-{
-	return reserve_bootmem(phys, len, flags);
-}
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index dd88ef9..cc3627b 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -801,10 +801,6 @@ void mark_rodata_ro(void)
 int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 				   int flags)
 {
-#ifdef CONFIG_NUMA
-	int nid, next_nid;
-	int ret;
-#endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
 
 	if (pfn >= max_pfn) {
@@ -820,21 +816,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 		return -EFAULT;
 	}
 
-	/* Should check here against the e820 map to avoid double free */
-#ifdef CONFIG_NUMA
-	nid = phys_to_nid(phys);
-	next_nid = phys_to_nid(phys + len - 1);
-	if (nid == next_nid)
-		ret = reserve_bootmem_node(NODE_DATA(nid), phys, len, flags);
-	else
-		ret = reserve_bootmem(phys, len, flags);
-
-	if (ret != 0)
-		return ret;
-
-#else
 	reserve_bootmem(phys, len, flags);
-#endif
 
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
 		dma_reserve += len / PAGE_SIZE;
diff --git a/mm/bootmem.c b/mm/bootmem.c
index d7c791e..760c279 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/kmemleak.h>
 #include <linux/range.h>
+#include <linux/early_res.h>
 
 #include <asm/bug.h>
 #include <asm/io.h>
@@ -525,6 +526,12 @@ int __init reserve_bootmem(unsigned long addr, unsigned long size,
 }
 
 #ifndef CONFIG_NO_BOOTMEM
+int __weak __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
+				   int flags)
+{
+	return reserve_bootmem(phys, len, flags);
+}
+
 static unsigned long __init align_idx(struct bootmem_data *bdata,
 				      unsigned long idx, unsigned long step)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 04c241a..e7b1d72 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -21,6 +21,7 @@
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
 #include <linux/bootmem.h>
+#include <linux/early_res.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/kmemcheck.h>
-- 
1.6.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab0C2Cv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:51:57 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:43234 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab0C2Cqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:46:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/31] bootmem, x86: Add weak version of reserve_bootmem_generic
Date: Sun, 28 Mar 2010 19:43:02 -0700
Message-Id: <1269830604-26214-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0205.4BB01462.00FA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be used lmb_to_bootmem converting

It is an wrapper for reserve_bootmem, and x86 64bit is using special one.

Also clean up that version for x86_64. We don't need to take care of numa
path for that, bootmem can handle it how

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_32.c |    6 ------
 arch/x86/mm/init_64.c |   20 ++------------------
 mm/bootmem.c          |    6 ++++++
 3 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5cb3f0f..804bbe9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1069,9 +1069,3 @@ void mark_rodata_ro(void)
 #endif
 }
 #endif
-
-int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
-				   int flags)
-{
-	return reserve_bootmem(phys, len, flags);
-}
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e9b040e..5ba6b0e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -798,13 +798,10 @@ void mark_rodata_ro(void)
 
 #endif
 
+#ifndef CONFIG_NO_BOOTMEM
 int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 				   int flags)
 {
-#ifdef CONFIG_NUMA
-	int nid, next_nid;
-	int ret;
-#endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
 
 	if (pfn >= max_pfn) {
@@ -820,21 +817,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
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
@@ -843,6 +826,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 
 	return 0;
 }
+#endif
 
 int kern_addr_valid(unsigned long addr)
 {
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 9b13446..fadbc3b 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -512,6 +512,12 @@ int __init reserve_bootmem(unsigned long addr, unsigned long size,
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
-- 
1.6.4.2


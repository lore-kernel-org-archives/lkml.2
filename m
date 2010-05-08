Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0EHPUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:20:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63624 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0EHPUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:20:02 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/22] bootmem, x86: Add weak version of reserve_bootmem_generic
Date: Sat,  8 May 2010 08:17:24 -0700
Message-Id: <1273331860-14325-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090204.4BE58101.0122,ss=1,fgs=0
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
index bca7909..90e0545 100644
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
index ee41bba..634fa08 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -799,13 +799,10 @@ void mark_rodata_ro(void)
 
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
@@ -821,21 +818,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
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
@@ -844,6 +827,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 
 	return 0;
 }
+#endif
 
 int kern_addr_valid(unsigned long addr)
 {
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 58c66cc..ee31b95 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -526,6 +526,12 @@ int __init reserve_bootmem(unsigned long addr, unsigned long size,
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


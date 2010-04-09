Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0DIGJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:09:18 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:28489 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab0DIGJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:09:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 39/39] x86: have nobootmem version setup_bootmem_allocator()
Date: Thu,  8 Apr 2010 23:04:08 -0700
Message-Id: <1270793048-23796-40-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BBEC463.0117,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can reduce #ifdef number from 3 to one in init_32.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_32.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c01c711..dfdd035 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -771,11 +771,9 @@ static unsigned long __init setup_node_bootmem(int nodeid,
 
 	return bootmap + bootmap_size;
 }
-#endif
 
 void __init setup_bootmem_allocator(void)
 {
-#ifndef CONFIG_NO_BOOTMEM
 	int nodeid;
 	unsigned long bootmap_size, bootmap;
 	/*
@@ -787,13 +785,11 @@ void __init setup_bootmem_allocator(void)
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
 	lmb_reserve_area(bootmap, bootmap + bootmap_size, "BOOTMAP");
-#endif
 
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
 	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
 
-#ifndef CONFIG_NO_BOOTMEM
 	for_each_online_node(nodeid) {
 		 unsigned long start_pfn, end_pfn;
 
@@ -811,10 +807,19 @@ void __init setup_bootmem_allocator(void)
 		bootmap = setup_node_bootmem(nodeid, start_pfn, end_pfn,
 						 bootmap);
 	}
-#endif
 
 	after_bootmem = 1;
 }
+#else
+void __init setup_bootmem_allocator(void)
+{
+	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
+		 max_pfn_mapped<<PAGE_SHIFT);
+	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
+
+	after_bootmem = 1;
+}
+#endif
 
 /*
  * paging_init() sets up the page tables - note that the first 8MB are
-- 
1.6.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab0ENTwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:52:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17326 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab0ENTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:49:59 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 27/37] x86: Have nobootmem version setup_bootmem_allocator()
Date: Fri, 14 May 2010 12:45:53 -0700
Message-Id: <1273866363-14249-28-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090202.4BEDA94C.007F,ss=1,fgs=0
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


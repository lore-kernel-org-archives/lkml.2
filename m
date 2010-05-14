Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0ENA1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:27:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53681 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab0ENAY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:24:26 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 23/35] mm: move contig_page_data define to bootmem.c/nobootmem.c
Date: Thu, 13 May 2010 17:19:44 -0700
Message-Id: <1273796396-29649-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BEC97CB.017F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can remove #ifdef in mm/page_alloc.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/bootmem.c    |    7 +++++++
 mm/nobootmem.c  |    5 +++++
 mm/page_alloc.c |    9 ---------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 2741c34..ff55ad7 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -23,6 +23,13 @@
 
 #include "internal.h"
 
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+struct pglist_data __refdata contig_page_data = {
+ .bdata = &bootmem_node_data[0]
+ };
+EXPORT_SYMBOL(contig_page_data);
+#endif
+
 unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 283673e..abaec96 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -23,6 +23,11 @@
 
 #include "internal.h"
 
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+struct pglist_data __refdata contig_page_data;
+EXPORT_SYMBOL(contig_page_data);
+#endif
+
 unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 631d2fc..867a3a8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4496,15 +4496,6 @@ void __init set_dma_reserve(unsigned long new_dma_reserve)
 	dma_reserve = new_dma_reserve;
 }
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
-struct pglist_data __refdata contig_page_data = {
-#ifndef CONFIG_NO_BOOTMEM
- .bdata = &bootmem_node_data[0]
-#endif
- };
-EXPORT_SYMBOL(contig_page_data);
-#endif
-
 void __init free_area_init(unsigned long *zones_size)
 {
 	free_area_init_node(0, zones_size,
-- 
1.6.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab0FPFrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:47:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28729 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab0FPFqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:46:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 25/37] mm: move contig_page_data define to bootmem.c/nobootmem.c
Date: Tue, 15 Jun 2010 22:42:34 -0700
Message-Id: <1276666966-14259-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
References: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C18650A.00D4,ss=1,fgs=0
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
index b385871..c17b5d0 100644
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
index f67a09d..ed53402 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4722,15 +4722,6 @@ void __init set_dma_reserve(unsigned long new_dma_reserve)
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


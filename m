Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2LRHQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:16:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22842 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2LRHQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:16:38 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7 22/27] mm: Add alloc_bootmem_low_pages_nopanic()
Date: Mon, 17 Dec 2012 23:15:54 -0800
Message-Id: <1355814959-10573-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to panic in some case, like for swiotlb preallocating.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/bootmem.h |    5 +++++
 mm/bootmem.c            |    8 ++++++++
 mm/nobootmem.c          |    8 ++++++++
 3 files changed, 21 insertions(+)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 3f778c2..3cd16ba 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -99,6 +99,9 @@ void *___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 extern void *__alloc_bootmem_low(unsigned long size,
 				 unsigned long align,
 				 unsigned long goal);
+void *__alloc_bootmem_low_nopanic(unsigned long size,
+				 unsigned long align,
+				 unsigned long goal);
 extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 				      unsigned long size,
 				      unsigned long align,
@@ -132,6 +135,8 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
+#define alloc_bootmem_low_pages_nopanic(x) \
+	__alloc_bootmem_low_nopanic(x, PAGE_SIZE, 0)
 #define alloc_bootmem_low_pages(x) \
 	__alloc_bootmem_low(x, PAGE_SIZE, 0)
 #define alloc_bootmem_low_pages_node(pgdat, x) \
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 1324cd7..315d253 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -821,6 +821,14 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
 }
 
+void * __init __alloc_bootmem_low_nopanic(unsigned long size,
+					  unsigned long align,
+					  unsigned long goal)
+{
+	return ___alloc_bootmem_nopanic(size, align, goal,
+					ARCH_LOW_ADDRESS_LIMIT);
+}
+
 /**
  * __alloc_bootmem_low_node - allocate low boot memory from a specific node
  * @pgdat: node to allocate from
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 03d152a..5e07d36 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -391,6 +391,14 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
 }
 
+void * __init __alloc_bootmem_low_nopanic(unsigned long size,
+					  unsigned long align,
+					  unsigned long goal)
+{
+	return ___alloc_bootmem_nopanic(size, align, goal,
+					ARCH_LOW_ADDRESS_LIMIT);
+}
+
 /**
  * __alloc_bootmem_low_node - allocate low boot memory from a specific node
  * @pgdat: node to allocate from
-- 
1.7.10.4


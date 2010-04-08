Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0DHEMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:12:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:53238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab0DHEMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:12:20 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, graff.yang@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       sonic.adi@gmail.com, cl@linux-foundation.org, mingo@elte.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] percpu: implement kernel memory based chunk allocation
Date: Thu,  8 Apr 2010 13:11:05 +0900
Message-Id: <1270699865-16954-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270699865-16954-1-git-send-email-tj@kernel.org>
References: <1270699865-16954-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Apr 2010 04:11:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement an alternate percpu chunk management based on kernel memeory
for nommu SMP architectures.  Instead of mapping into vmalloc area,
chunks are allocated as a contiguous kernel memory using
alloc_pages().  As such, percpu allocator on nommu will have the
following restrictions.

* It can't fill chunks on-demand page-by-page.  It has to allocate
  each chunk fully upfront.

* It can't support sparse chunk for NUMA configurations.  SMP w/o mmu
  is crazy enough.  Let's hope no one does NUMA w/o mmu.  :-P

* If chunk size isn't power-of-two multiple of PAGE_SIZE, the
  unaligned amount will be wasted on each chunk.  So, archs which use
  this better align chunk size.

For instructions on how to use this, read the comment on top of
mm/percpu-km.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Graff Yang <graff.yang@gmail.com>
Cc: Sonic Zhang <sonic.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>
---
 mm/percpu-km.c |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/percpu.c    |    4 ++
 2 files changed, 108 insertions(+), 0 deletions(-)
 create mode 100644 mm/percpu-km.c

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
new file mode 100644
index 0000000..df68085
--- /dev/null
+++ b/mm/percpu-km.c
@@ -0,0 +1,104 @@
+/*
+ * mm/percpu-km.c - kernel memory based chunk allocation
+ *
+ * Copyright (C) 2010		SUSE Linux Products GmbH
+ * Copyright (C) 2010		Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ *
+ * Chunks are allocated as a contiguous kernel memory using gfp
+ * allocation.  This is to be used on nommu architectures.
+ *
+ * To use percpu-km,
+ *
+ * - define CONFIG_NEED_PER_CPU_KM from the arch Kconfig.
+ *
+ * - CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK must not be defined.  It's
+ *   not compatible with PER_CPU_KM.  EMBED_FIRST_CHUNK should work
+ *   fine.
+ *
+ * - NUMA is not supported.  When setting up the first chunk,
+ *   @cpu_distance_fn should be NULL or report all CPUs to be nearer
+ *   than or at LOCAL_DISTANCE.
+ *
+ * - It's best if the chunk size is power of two multiple of
+ *   PAGE_SIZE.  Because each chunk is allocated as a contiguous
+ *   kernel memory block using alloc_pages(), memory will be wasted if
+ *   chunk size is not aligned.  percpu-km code will whine about it.
+ */
+
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+#error "contiguous percpu allocation is incompatible with paged first chunk"
+#endif
+
+#include <linux/log2.h>
+
+static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
+{
+	/* noop */
+	return 0;
+}
+
+static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
+{
+	/* nada */
+}
+
+static struct pcpu_chunk *pcpu_create_chunk(void)
+{
+	const int nr_pages = pcpu_group_sizes[0] >> PAGE_SHIFT;
+	struct pcpu_chunk *chunk;
+	struct page *pages;
+	int i;
+
+	chunk = pcpu_alloc_chunk();
+	if (!chunk)
+		return NULL;
+
+	pages = alloc_pages(GFP_KERNEL, order_base_2(nr_pages));
+	if (!pages) {
+		pcpu_free_chunk(chunk);
+		return NULL;
+	}
+
+	for (i = 0; i < nr_pages; i++)
+		pcpu_set_page_chunk(nth_page(pages, i), chunk);
+
+	chunk->data = pages;
+	chunk->base_addr = page_address(pages) - pcpu_group_offsets[0];
+	return chunk;
+}
+
+static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
+{
+	const int nr_pages = pcpu_group_sizes[0] >> PAGE_SHIFT;
+
+	if (chunk && chunk->data)
+		__free_pages(chunk->data, order_base_2(nr_pages));
+	pcpu_free_chunk(chunk);
+}
+
+static struct page *pcpu_addr_to_page(void *addr)
+{
+	return virt_to_page(addr);
+}
+
+static int __init pcpu_verify_alloc_info(const struct pcpu_alloc_info *ai)
+{
+	size_t nr_pages, alloc_pages;
+
+	/* all units must be in a single group */
+	if (ai->nr_groups != 1) {
+		printk(KERN_CRIT "percpu: can't handle more than one groups\n");
+		return -EINVAL;
+	}
+
+	nr_pages = (ai->groups[0].nr_units * ai->unit_size) >> PAGE_SHIFT;
+	alloc_pages = roundup_pow_of_two(nr_pages);
+
+	if (alloc_pages > nr_pages)
+		printk(KERN_WARNING "percpu: wasting %zu pages per chunk\n",
+		       alloc_pages - nr_pages);
+
+	return 0;
+}
diff --git a/mm/percpu.c b/mm/percpu.c
index 4c5b074..5dacce2 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -649,7 +649,11 @@ static void pcpu_destroy_chunk(struct pcpu_chunk *chunk);
 static struct page *pcpu_addr_to_page(void *addr);
 static int __init pcpu_verify_alloc_info(const struct pcpu_alloc_info *ai);
 
+#ifdef CONFIG_NEED_PER_CPU_KM
+#include "percpu-km.c"
+#else
 #include "percpu-vm.c"
+#endif
 
 /**
  * pcpu_chunk_addr_search - determine chunk containing specified address
-- 
1.6.4.2


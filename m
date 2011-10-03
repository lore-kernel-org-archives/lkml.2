Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab1JCPZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:25:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43167 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756436Ab1JCPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:25:26 -0400
Date: Mon, 3 Oct 2011 16:21:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li.lee@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] kmemleak: Handle percpu memory allocation
Message-ID: <20111003152126.GM18195@e102109-lin.cambridge.arm.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
 <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
 <20110929192818.GB10425@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929192818.GB10425@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thu, Sep 29, 2011 at 08:28:18PM +0100, Tejun Heo wrote:
> If we want to track percpu memory leak properly, I think we'll need
> more invasive changes.  If kmemleak is enabled, we can offset percpu
> pointer so that the scanner can tell percpu pointers and then kmemleak
> should properly account for all percpu areas pointed to by the percpu
> pointer.  Hmmm... or, alternatively, we can make kmemleak only track
> allocations for the first possible cpu and ignore all the rest and
> modify percpu such that percpu pointer points to the actual address of
> the first cpu if kmemleak is enabled.

I had a look at the latter variant and we don't end up with clean code.
I'm not even sure it's worth the hassle as most leaks come from slab
allocations.

The updated patch below adds specific kmemleak API for percpu pointers
so that it only logs one call per allocation rather than the number of
possible cpus (could be split in two, though the patch is relatively
simple):

----------------8<---------------------------------
kmemleak: Handle percpu memory allocation

From: Catalin Marinas <catalin.marinas@arm.com>

This patch adds kmemleak callbacks from the percpu allocator, reducing a
number of false positives caused by kmemleak not scanning such memory
blocks. The percpu chunks are never reported as leaks because of current
kmemleak limitations with the __percpu pointer not pointing directly to
the actual chunks.

Reported-by: Huajun Li <huajun.li.lee@gmail.com>
Cc: Tejun Heo <tj@kernel.org>,
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/kmemleak.txt |    3 ++
 include/linux/kmemleak.h   |    8 +++++
 mm/kmemleak.c              |   72 ++++++++++++++++++++++++++++++++++++++++++++
 mm/percpu.c                |   12 +++++++
 4 files changed, 94 insertions(+), 1 deletions(-)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index 51063e6..b6e3973 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -127,7 +127,10 @@ See the include/linux/kmemleak.h header for the functions prototype.
 
 kmemleak_init		 - initialize kmemleak
 kmemleak_alloc		 - notify of a memory block allocation
+kmemleak_alloc_percpu	 - notify of a percpu memory block allocation
 kmemleak_free		 - notify of a memory block freeing
+kmemleak_free_part	 - notify of a partial memory block freeing
+kmemleak_free_percpu	 - notify of a percpu memory block freeing
 kmemleak_not_leak	 - mark an object as not a leak
 kmemleak_ignore		 - do not scan or report an object as leak
 kmemleak_scan_area	 - add scan areas inside a memory block
diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index 99d9a67..2a5e554 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -26,8 +26,10 @@
 extern void kmemleak_init(void) __ref;
 extern void kmemleak_alloc(const void *ptr, size_t size, int min_count,
 			   gfp_t gfp) __ref;
+extern void kmemleak_alloc_percpu(const void __percpu *ptr, size_t size) __ref;
 extern void kmemleak_free(const void *ptr) __ref;
 extern void kmemleak_free_part(const void *ptr, size_t size) __ref;
+extern void kmemleak_free_percpu(const void __percpu *ptr) __ref;
 extern void kmemleak_padding(const void *ptr, unsigned long offset,
 			     size_t size) __ref;
 extern void kmemleak_not_leak(const void *ptr) __ref;
@@ -68,6 +70,9 @@ static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
 					    gfp_t gfp)
 {
 }
+static inline void kmemleak_alloc_percpu(const void __percpu *ptr, size_t size)
+{
+}
 static inline void kmemleak_free(const void *ptr)
 {
 }
@@ -77,6 +82,9 @@ static inline void kmemleak_free_part(const void *ptr, size_t size)
 static inline void kmemleak_free_recursive(const void *ptr, unsigned long flags)
 {
 }
+static inline void kmemleak_free_percpu(const void __percpu *ptr)
+{
+}
 static inline void kmemleak_not_leak(const void *ptr)
 {
 }
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 381b67a..1d2b896 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -230,8 +230,10 @@ static int kmemleak_skip_disable;
 /* kmemleak operation type for early logging */
 enum {
 	KMEMLEAK_ALLOC,
+	KMEMLEAK_ALLOC_PERCPU,
 	KMEMLEAK_FREE,
 	KMEMLEAK_FREE_PART,
+	KMEMLEAK_FREE_PERCPU,
 	KMEMLEAK_NOT_LEAK,
 	KMEMLEAK_IGNORE,
 	KMEMLEAK_SCAN_AREA,
@@ -852,6 +854,20 @@ out:
 	rcu_read_unlock();
 }
 
+/*
+ * Log an early allocated block and populate the stack trace.
+ */
+static void early_alloc_percpu(struct early_log *log)
+{
+	unsigned int cpu;
+	const void __percpu *ptr = log->ptr;
+
+	for_each_possible_cpu(cpu) {
+		log->ptr = per_cpu_ptr(ptr, cpu);
+		early_alloc(log);
+	}
+}
+
 /**
  * kmemleak_alloc - register a newly allocated object
  * @ptr:	pointer to beginning of the object
@@ -879,6 +895,34 @@ void __ref kmemleak_alloc(const void *ptr, size_t size, int min_count,
 EXPORT_SYMBOL_GPL(kmemleak_alloc);
 
 /**
+ * kmemleak_alloc_percpu - register a newly allocated __percpu object
+ * @ptr:	__percpu pointer to beginning of the object
+ * @size:	size of the object
+ *
+ * This function is called from the kernel percpu allocator when a new object
+ * (memory block) is allocated (alloc_percpu). It assumes GFP_KERNEL
+ * allocation.
+ */
+void __ref kmemleak_alloc_percpu(const void __percpu *ptr, size_t size)
+{
+	unsigned int cpu;
+
+	pr_debug("%s(0x%p, %zu)\n", __func__, ptr, size);
+
+	/*
+	 * Percpu allocations are only scanned and not reported as leaks
+	 * (min_count is set to 0).
+	 */
+	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+		for_each_possible_cpu(cpu)
+			create_object((unsigned long)per_cpu_ptr(ptr, cpu),
+				      size, 0, GFP_KERNEL);
+	else if (atomic_read(&kmemleak_early_log))
+		log_early(KMEMLEAK_ALLOC_PERCPU, ptr, size, 0);
+}
+EXPORT_SYMBOL_GPL(kmemleak_alloc_percpu);
+
+/**
  * kmemleak_free - unregister a previously registered object
  * @ptr:	pointer to beginning of the object
  *
@@ -917,6 +961,28 @@ void __ref kmemleak_free_part(const void *ptr, size_t size)
 EXPORT_SYMBOL_GPL(kmemleak_free_part);
 
 /**
+ * kmemleak_free_percpu - unregister a previously registered __percpu object
+ * @ptr:	__percpu pointer to beginning of the object
+ *
+ * This function is called from the kernel percpu allocator when an object
+ * (memory block) is freed (free_percpu).
+ */
+void __ref kmemleak_free_percpu(const void __percpu *ptr)
+{
+	unsigned int cpu;
+
+	pr_debug("%s(0x%p)\n", __func__, ptr);
+
+	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
+		for_each_possible_cpu(cpu)
+			delete_object_full((unsigned long)per_cpu_ptr(ptr,
+								      cpu));
+	else if (atomic_read(&kmemleak_early_log))
+		log_early(KMEMLEAK_FREE, ptr, 0, 0);
+}
+EXPORT_SYMBOL_GPL(kmemleak_free_percpu);
+
+/**
  * kmemleak_not_leak - mark an allocated object as false positive
  * @ptr:	pointer to beginning of the object
  *
@@ -1727,12 +1793,18 @@ void __init kmemleak_init(void)
 		case KMEMLEAK_ALLOC:
 			early_alloc(log);
 			break;
+		case KMEMLEAK_ALLOC_PERCPU:
+			early_alloc_percpu(log);
+			break;
 		case KMEMLEAK_FREE:
 			kmemleak_free(log->ptr);
 			break;
 		case KMEMLEAK_FREE_PART:
 			kmemleak_free_part(log->ptr, log->size);
 			break;
+		case KMEMLEAK_FREE_PERCPU:
+			kmemleak_free_percpu(log->ptr);
+			break;
 		case KMEMLEAK_NOT_LEAK:
 			kmemleak_not_leak(log->ptr);
 			break;
diff --git a/mm/percpu.c b/mm/percpu.c
index bf80e55..ce3b6cb 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -67,6 +67,7 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
+#include <linux/kmemleak.h>
 
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -709,6 +710,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	const char *err;
 	int slot, off, new_alloc;
 	unsigned long flags;
+	void __percpu *ptr;
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
@@ -801,7 +803,9 @@ area_found:
 	mutex_unlock(&pcpu_alloc_mutex);
 
 	/* return address relative to base address */
-	return __addr_to_pcpu_ptr(chunk->base_addr + off);
+	ptr = __addr_to_pcpu_ptr(chunk->base_addr + off);
+	kmemleak_alloc_percpu(ptr, size);
+	return ptr;
 
 fail_unlock:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
@@ -915,6 +919,8 @@ void free_percpu(void __percpu *ptr)
 	if (!ptr)
 		return;
 
+	kmemleak_free_percpu(ptr);
+
 	addr = __pcpu_ptr_to_addr(ptr);
 
 	spin_lock_irqsave(&pcpu_lock, flags);
@@ -1619,6 +1625,8 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 			rc = -ENOMEM;
 			goto out_free_areas;
 		}
+		/* kmemleak tracks the percpu allocations separately */
+		kmemleak_free(ptr);
 		areas[group] = ptr;
 
 		base = min(ptr, base);
@@ -1733,6 +1741,8 @@ int __init pcpu_page_first_chunk(size_t reserved_size,
 					   "for cpu%u\n", psize_str, cpu);
 				goto enomem;
 			}
+			/* kmemleak tracks the percpu allocations separately */
+			kmemleak_free(ptr);
 			pages[j++] = virt_to_page(ptr);
 		}
 

-- 
Catalin

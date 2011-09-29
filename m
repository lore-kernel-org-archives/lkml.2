Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1I2LCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:02:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34653 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755291Ab1I2LCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:02:44 -0400
Subject: [PATCH 2/4] kmemleak: Handle percpu memory allocation
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Huajun Li <huajun.li.lee@gmail.com>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Date: Thu, 29 Sep 2011 12:02:28 +0100
Message-ID: <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-118-g0cb4
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Sep 2011 11:02:37.0019 (UTC) FILETIME=[4C2EAAB0:01CC7E97]
X-MC-Unique: 111092912024002401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 mm/percpu.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index bf80e55..ece9f85 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -67,6 +67,7 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
+#include <linux/kmemleak.h>
 
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -709,6 +710,8 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	const char *err;
 	int slot, off, new_alloc;
 	unsigned long flags;
+	void __percpu *ptr;
+	unsigned int cpu;
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
@@ -801,7 +804,16 @@ area_found:
 	mutex_unlock(&pcpu_alloc_mutex);
 
 	/* return address relative to base address */
-	return __addr_to_pcpu_ptr(chunk->base_addr + off);
+	ptr = __addr_to_pcpu_ptr(chunk->base_addr + off);
+
+	/*
+	 * Percpu allocations are currently reported as leaks (kmemleak false
+	 * positives). To avoid this, just set min_count to 0.
+	 */
+	for_each_possible_cpu(cpu)
+		kmemleak_alloc(per_cpu_ptr(ptr, cpu), size, 0, GFP_KERNEL);
+
+	return ptr;
 
 fail_unlock:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
@@ -911,10 +923,14 @@ void free_percpu(void __percpu *ptr)
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
 	int off;
+	unsigned int cpu;
 
 	if (!ptr)
 		return;
 
+	for_each_possible_cpu(cpu)
+		kmemleak_free(per_cpu_ptr(ptr, cpu));
+
 	addr = __pcpu_ptr_to_addr(ptr);
 
 	spin_lock_irqsave(&pcpu_lock, flags);
@@ -1619,6 +1635,8 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 			rc = -ENOMEM;
 			goto out_free_areas;
 		}
+		/* kmemleak tracks the percpu allocations separately */
+		kmemleak_free(ptr);
 		areas[group] = ptr;
 
 		base = min(ptr, base);
@@ -1733,6 +1751,8 @@ int __init pcpu_page_first_chunk(size_t reserved_size,
 					   "for cpu%u\n", psize_str, cpu);
 				goto enomem;
 			}
+			/* kmemleak tracks the percpu allocations separately */
+			kmemleak_free(ptr);
 			pages[j++] = virt_to_page(ptr);
 		}
 



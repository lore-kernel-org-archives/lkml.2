Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0CXItx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:49:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:59681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab0CXItk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:49:40 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       cl@linux-foundation.org, mingo@elte.hu, adobriyan@gmail.com,
       tglx@linutronix.de, hpa@zytor.com, yi.zhu@intel.com,
       reinette.chatre@intel.com, ilw@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 4/4] percpu: don't implicitly include slab.h from percpu.h
Date: Wed, 24 Mar 2010 17:48:58 +0900
Message-Id: <1269420538-18039-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269420538-18039-1-git-send-email-tj@kernel.org>
References: <1269420538-18039-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Mar 2010 08:49:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu.h has always been including slab.h to get k[mz]alloc/free() for
UP inline implementation.  percpu.h being used by very low level
headers including module.h and sched.h, this meant that a lot files
unintentionally got slab.h inclusion.

Lee Schermerhorn was trying to make topology.h use percpu.h and got
bitten by this implicit inclusion.  The right thing to do is break
this ultimately unnecessary dependency.  The previous patch added
explicit inclusion of either gfp.h or slab.h to the source files using
them.  This patch updates percpu.h such that slab.h is no longer
included from percpu.h.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu.h |   30 +++++-------------------------
 mm/Makefile            |    6 +++++-
 mm/percpu_up.c         |   30 ++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 26 deletions(-)
 create mode 100644 mm/percpu_up.c

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index a93e5bf..c784513 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -2,10 +2,10 @@
 #define __LINUX_PERCPU_H
 
 #include <linux/preempt.h>
-#include <linux/slab.h> /* For kmalloc() */
 #include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/pfn.h>
+#include <linux/init.h>
 
 #include <asm/percpu.h>
 
@@ -135,9 +135,6 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
 #define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
 
 extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align);
-extern void __percpu *__alloc_percpu(size_t size, size_t align);
-extern void free_percpu(void __percpu *__pdata);
-extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void __init setup_per_cpu_areas(void);
@@ -147,27 +144,6 @@ extern void __init setup_per_cpu_areas(void);
 
 #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
-static inline void __percpu *__alloc_percpu(size_t size, size_t align)
-{
-	/*
-	 * Can't easily make larger alignment work with kmalloc.  WARN
-	 * on it.  Larger alignment should only be used for module
-	 * percpu sections on SMP for which this path isn't used.
-	 */
-	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
-	return kzalloc(size, GFP_KERNEL);
-}
-
-static inline void free_percpu(void __percpu *p)
-{
-	kfree(p);
-}
-
-static inline phys_addr_t per_cpu_ptr_to_phys(void *addr)
-{
-	return __pa(addr);
-}
-
 static inline void __init setup_per_cpu_areas(void) { }
 
 static inline void *pcpu_lpage_remapped(void *kaddr)
@@ -177,6 +153,10 @@ static inline void *pcpu_lpage_remapped(void *kaddr)
 
 #endif /* CONFIG_SMP */
 
+extern void __percpu *__alloc_percpu(size_t size, size_t align);
+extern void free_percpu(void __percpu *__pdata);
+extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
+
 #define alloc_percpu(type)	\
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
 
diff --git a/mm/Makefile b/mm/Makefile
index 7a68d2a..6c2a73a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -33,7 +33,11 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
-obj-$(CONFIG_SMP) += percpu.o
+ifdef CONFIG_SMP
+obj-y += percpu.o
+else
+obj-y += percpu_up.o
+endif
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
diff --git a/mm/percpu_up.c b/mm/percpu_up.c
new file mode 100644
index 0000000..c4351c7
--- /dev/null
+++ b/mm/percpu_up.c
@@ -0,0 +1,30 @@
+/*
+ * mm/percpu_up.c - dummy percpu memory allocator implementation for UP
+ */
+
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/slab.h>
+
+void __percpu *__alloc_percpu(size_t size, size_t align)
+{
+	/*
+	 * Can't easily make larger alignment work with kmalloc.  WARN
+	 * on it.  Larger alignment should only be used for module
+	 * percpu sections on SMP for which this path isn't used.
+	 */
+	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
+	return kzalloc(size, GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(__alloc_percpu);
+
+void free_percpu(void __percpu *p)
+{
+	kfree(p);
+}
+EXPORT_SYMBOL_GPL(free_percpu);
+
+phys_addr_t per_cpu_ptr_to_phys(void *addr)
+{
+	return __pa(addr);
+}
-- 
1.6.4.2


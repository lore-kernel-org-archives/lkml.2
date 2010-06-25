Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0FYND3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:03:29 -0400
Received: from ozlabs.org ([203.10.76.45]:38653 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab0FYND1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:03:27 -0400
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       anton@samba.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <201006252233.21346.rusty@rustcorp.com.au>
Date: Fri, 25 Jun 2010 22:33:20 +0930
Subject: [PATCH 1/5] cpumask: truncate mm_struct.cpu_vm_mask for CONFIG_CPUMASK_OFFSTACK
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: anton@samba.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns cpu_vm_mask into a bitmap, and truncate it to nr_cpu_ids if
CONFIG_CPUMASK_OFFSTACK is set.

I do this rather than the classic [0] dangling array trick, because of
init_mm, which is static and widely referenced.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: anton@samba.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/tboot.c  |    2 +-
 include/linux/mm_types.h |   26 +++++++++++++++++++++++---
 kernel/fork.c            |    6 +++---
 mm/init-mm.c             |    2 +-
 4 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -110,7 +110,7 @@ static struct mm_struct tboot_mm = {
 	.mmap_sem       = __RWSEM_INITIALIZER(init_mm.mmap_sem),
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist         = LIST_HEAD_INIT(init_mm.mmlist),
-	.cpu_vm_mask    = CPU_MASK_ALL,
+	.cpu_vm_mask    = CPU_BITS_ALL,
 };
 
 static inline void switch_to_tboot_pt(void)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -265,8 +265,6 @@ struct mm_struct {
 
 	struct linux_binfmt *binfmt;
 
-	cpumask_t cpu_vm_mask;
-
 	/* Architecture-specific MM context */
 	mm_context_t context;
 
@@ -310,9 +308,31 @@ struct mm_struct {
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
+
+	/* This has to go at the end: if CONFIG_CPUMASK_OFFSTACK=y, only
+	 * nr_cpu_ids bits will actually be allocated. */
+	DECLARE_BITMAP(cpu_vm_mask, CONFIG_NR_CPUS);
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
-#define mm_cpumask(mm) (&(mm)->cpu_vm_mask)
+#define mm_cpumask(mm) (to_cpumask((mm)->cpu_vm_mask))
+
+static inline size_t mm_struct_size(void)
+{
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	/*
+	 * We restrict mm_struct allocations so cpu_vm_mask is only
+	 * nr_cpu_ids long.  cpu_vm_mask must be a NR_CPUS bitmap at
+	 * end for this to work.
+	 */
+	BUILD_BUG_ON(offsetof(struct mm_struct, cpu_vm_mask)
+		     + BITS_TO_LONGS(CONFIG_NR_CPUS)*sizeof(long)
+		     != sizeof(struct mm_struct));
+	return offsetof(struct mm_struct, cpu_vm_mask) +
+		BITS_TO_LONGS(nr_cpu_ids) * sizeof(long);
+#else
+	return sizeof(struct mm_struct);
+#endif
+}
 
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -505,7 +505,7 @@ struct mm_struct * mm_alloc(void)
 
 	mm = allocate_mm();
 	if (mm) {
-		memset(mm, 0, sizeof(*mm));
+		memset(mm, 0, mm_struct_size());
 		mm = mm_init(mm, current);
 	}
 	return mm;
@@ -656,7 +656,7 @@ struct mm_struct *dup_mm(struct task_str
 	if (!mm)
 		goto fail_nomem;
 
-	memcpy(mm, oldmm, sizeof(*mm));
+	memcpy(mm, oldmm, mm_struct_size());
 
 	/* Initializing for Swap token stuff */
 	mm->token_priority = 0;
@@ -1500,7 +1500,7 @@ void __init proc_caches_init(void)
 			sizeof(struct fs_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	mm_cachep = kmem_cache_create("mm_struct",
-			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
+			mm_struct_size(), ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC);
 	mmap_init();
diff --git a/mm/init-mm.c b/mm/init-mm.c
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -16,5 +16,5 @@ struct mm_struct init_mm = {
 	.mmap_sem	= __RWSEM_INITIALIZER(init_mm.mmap_sem),
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
-	.cpu_vm_mask	= CPU_MASK_ALL,
+	.cpu_vm_mask	= CPU_BITS_ALL,
 };


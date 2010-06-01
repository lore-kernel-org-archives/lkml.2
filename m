Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0FAK0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:26:22 -0400
Received: from smtp.nokia.com ([192.100.122.230]:38654 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab0FAK0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:26:18 -0400
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, ext-phil.2.carmody@nokia.com,
       linux-omap@vger.kernel.org, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH v2 1/3] kmemleak: Fix false positives with special scan
Date: Tue,  1 Jun 2010 13:25:09 +0300
Message-Id: <1275387911-13030-2-git-send-email-Hiroshi.DOYU@nokia.com>
X-Mailer: git-send-email 1.7.1.rc1
In-Reply-To: <1273821401-26578-2-git-send-email-Hiroshi.DOYU@nokia.com>
References: <1273821401-26578-2-git-send-email-Hiroshi.DOYU@nokia.com>
X-OriginalArrivalTime: 01 Jun 2010 10:25:29.0707 (UTC) FILETIME=[C24113B0:01CB0174]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

There is a false positive case that a pointer is calculated by other
methods than the usual container_of macro. "kmemleak_ignore" can cover
such a false positive, but it would loose the advantage of memory leak
detection. This patch allows kmemleak to work with such false
positives by introducing a new special memory block with a specified
calculation formula. A client module can register its area with a
function, which kmemleak could scan and calculate a pointer with a
registered special function.

To avoid client being unloaded before unregistering special
conversion, module reference is introduced. This was pointed by Phil
Carmody.

A typical use case could be the IOMMU pagetable allocation which
stores pointers to the second level of page tables with some
conversion, for example, a physical address with attribution bits.

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 include/linux/kmemleak.h |    5 ++
 mm/kmemleak.c            |  114 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 116 insertions(+), 3 deletions(-)

diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index 99d9a67..1ff1cbc 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -35,6 +35,11 @@ extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
 
+extern int kmemleak_special_scan(const void *ptr, size_t size,
+		 unsigned long (*fn)(void *, unsigned long), void *data,
+				 struct module *owner) __ref;
+extern void kmemleak_no_special(const void *ptr) __ref;
+
 static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
 					    int min_count, unsigned long flags,
 					    gfp_t gfp)
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2c0d032..872d5f3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -249,6 +249,88 @@ static struct early_log
 	early_log[CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE] __initdata;
 static int crt_early_log __initdata;
 
+/* scan area which requires special conversion */
+struct special_block {
+	void *start;
+	void *end;
+	unsigned long (*fn)(void *, unsigned long);
+	void *data;
+	struct module *owner;
+};
+#define SPECIAL_MAX (PAGE_SIZE / sizeof(struct special_block))
+static struct special_block special_block[SPECIAL_MAX];
+static DEFINE_SPINLOCK(special_block_lock);
+
+int kmemleak_special_scan(const void *ptr, size_t size,
+		  unsigned long (*fn)(void *, unsigned long), void *data,
+		  struct module *owner)
+{
+	struct special_block *sp;
+	int i, err = 0;
+
+	if (!ptr || (size == 0) || !fn)
+		return -EINVAL;
+
+	spin_lock(&special_block_lock);
+
+	if (!try_module_get(owner)) {
+		err = -ENODEV;
+		goto err_module_get;
+	}
+
+	sp = special_block;
+	for (i = 0; i < SPECIAL_MAX; i++, sp++) {
+		if (!sp->start)
+			break;
+	}
+
+	if (i == SPECIAL_MAX) {
+		err = -ENOMEM;
+		goto err_no_entry;
+	}
+	sp->start = (void *)ptr;
+	sp->end = (void *)ptr + size;
+	sp->fn = fn;
+	sp->data = data;
+	sp->owner = owner;
+
+	spin_unlock(&special_block_lock);
+
+	return 0;
+
+err_no_entry:
+	module_put(owner);
+err_module_get:
+	spin_unlock(&special_block_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(kmemleak_special_scan);
+
+void kmemleak_no_special(const void *ptr)
+{
+	int i;
+
+	spin_lock(&special_block_lock);
+
+	for (i = 0; i < SPECIAL_MAX; i++) {
+		struct special_block *sp;
+
+		sp = &special_block[i];
+		if (sp->start == ptr) {
+			module_put(sp->owner);
+			memset(sp, 0, sizeof(*sp));
+			break;
+		}
+	}
+
+	if (i == SPECIAL_MAX)
+		pr_warning("Couldn't find entry\n");
+
+	spin_unlock(&special_block_lock);
+}
+EXPORT_SYMBOL_GPL(kmemleak_no_special);
+
 static void kmemleak_disable(void);
 
 /*
@@ -983,8 +1065,9 @@ static int scan_should_stop(void)
  * Scan a memory block (exclusive range) for valid pointers and add those
  * found to the gray list.
  */
-static void scan_block(void *_start, void *_end,
-		       struct kmemleak_object *scanned, int allow_resched)
+static void __scan_block(void *_start, void *_end,
+			 struct kmemleak_object *scanned, int allow_resched,
+			 struct special_block *sp)
 {
 	unsigned long *ptr;
 	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
@@ -1005,7 +1088,10 @@ static void scan_block(void *_start, void *_end,
 						  BYTES_PER_POINTER))
 			continue;
 
-		pointer = *ptr;
+		if (sp && sp->fn)
+			pointer = sp->fn(sp->data, *ptr);
+		else
+			pointer = *ptr;
 
 		object = find_and_get_object(pointer, 1);
 		if (!object)
@@ -1048,6 +1134,26 @@ static void scan_block(void *_start, void *_end,
 	}
 }
 
+static inline void scan_block(void *_start, void *_end,
+		      struct kmemleak_object *scanned, int allow_resched)
+{
+	__scan_block(_start, _end, scanned, allow_resched, NULL);
+}
+
+/* Scan area which requires special conversion of address */
+static void scan_special_block(void)
+{
+	int i;
+	struct special_block *sp;
+
+	sp = special_block;
+	for (i = 0; i < ARRAY_SIZE(special_block); i++, sp++) {
+		if (!sp->start)
+			continue;
+		__scan_block(sp->start, sp->end, NULL, 1, sp);
+	}
+}
+
 /*
  * Scan a memory block corresponding to a kmemleak_object. A condition is
  * that object->use_count >= 1.
@@ -1166,6 +1272,8 @@ static void kmemleak_scan(void)
 	scan_block(_sdata, _edata, NULL, 1);
 	scan_block(__bss_start, __bss_stop, NULL, 1);
 
+	scan_special_block();
+
 #ifdef CONFIG_SMP
 	/* per-cpu sections scanning */
 	for_each_possible_cpu(i)
-- 
1.7.1.rc1


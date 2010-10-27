Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831Ab0J0KeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:34:18 -0400
Received: from fep13.mx.upcmail.net ([62.179.121.33]:65240 "EHLO
	fep13.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab0J0KeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:34:16 -0400
X-SourceIP: 80.56.199.130
Subject: [PATCH] mm,x86: fix kmap_atomic_push vs ioremap_32.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <849307$a582r7@azsmga001.ch.intel.com>
References: <20100918155326.478277313@chello.nl>
	 <849307$a582r7@azsmga001.ch.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 12:33:58 +0200
Message-ID: <1288175638.15336.1538.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.1 cv=XCVXOBqlCPU5N10w5kBzDuedWCKZPpIJSEs1endkdVI= c=1 sm=0 a=TD51X9_j-7cA:10 a=IkcTkHD0fZMA:10 a=mz-4lECuHB3QnkbsA4YA:9 a=3K_LsSTDlfoyQr5s1ycA:7 a=0FZtfgFAkRVa-wVjzIGpvIQ77jYA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 11:27 +0100, Chris Wilson wrote:
> On Sat, 18 Sep 2010 17:53:26 +0200, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Next version of the kmap_atomic rework using Andrew's fancy CPP trickery to
> > avoid having to convert the whole tree at once.
> > 
> > This is compile tested for i386-allmodconfig, frv, mips-sb1250-swarm,
> > powerpc-ppc6xx_defconfig, sparc32_defconfig, arm-omap3 (all with
> > HIGHEM=y).
> 
> This break on x86, HIGHMEM=n:
> 
> arch/x86/mm/iomap_32.c: In function ‘kmap_atomic_prot_pfn’:
> arch/x86/mm/iomap_32.c:64: error: implicit declaration of function
> ‘kmap_atomic_idx_push’
> arch/x86/mm/iomap_32.c: In function ‘iounmap_atomic’:
> arch/x86/mm/iomap_32.c:101: error: implicit declaration of function
> ‘kmap_atomic_idx_pop’

Christoph just complained about the same on IRC, the below seems to cure
things for i386-defconfig with CONFIG_HIGHMEM=n

---
Subject: mm,x86: fix kmap_atomic_push vs ioremap_32.c

It appears i386 uses kmap_atomic infrastructure regardless of
CONFIG_HIGHMEM which results in a compile error when highmem is
disabled.

Cure this by providing the needed few bits for both CONFIG_HIGHMEM and
CONFIG_X86_32.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/highmem.h |   46 +++++++++++++++++++++++++---------------------
 mm/highmem.c            |    6 +++++-
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 8a85ec1..102f76b 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -37,27 +37,6 @@ extern unsigned long totalhigh_pages;
 
 void kmap_flush_unused(void);
 
-DECLARE_PER_CPU(int, __kmap_atomic_idx);
-
-static inline int kmap_atomic_idx_push(void)
-{
-	int idx = __get_cpu_var(__kmap_atomic_idx)++;
-#ifdef CONFIG_DEBUG_HIGHMEM
-	WARN_ON_ONCE(in_irq() && !irqs_disabled());
-	BUG_ON(idx > KM_TYPE_NR);
-#endif
-	return idx;
-}
-
-static inline int kmap_atomic_idx_pop(void)
-{
-	int idx = --__get_cpu_var(__kmap_atomic_idx);
-#ifdef CONFIG_DEBUG_HIGHMEM
-	BUG_ON(idx < 0);
-#endif
-	return idx;
-}
-
 #else /* CONFIG_HIGHMEM */
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
@@ -95,6 +74,31 @@ static inline void __kunmap_atomic(void *addr)
 
 #endif /* CONFIG_HIGHMEM */
 
+#if defined(CONFIG_HIGHMEM) || defined(CONFIG_X86_32)
+
+DECLARE_PER_CPU(int, __kmap_atomic_idx);
+
+static inline int kmap_atomic_idx_push(void)
+{
+	int idx = __get_cpu_var(__kmap_atomic_idx)++;
+#ifdef CONFIG_DEBUG_HIGHMEM
+	WARN_ON_ONCE(in_irq() && !irqs_disabled());
+	BUG_ON(idx > KM_TYPE_NR);
+#endif
+	return idx;
+}
+
+static inline int kmap_atomic_idx_pop(void)
+{
+	int idx = --__get_cpu_var(__kmap_atomic_idx);
+#ifdef CONFIG_DEBUG_HIGHMEM
+	BUG_ON(idx < 0);
+#endif
+	return idx;
+}
+
+#endif
+
 /*
  * Make both: kmap_atomic(page, idx) and kmap_atomic(page) work.
  */
diff --git a/mm/highmem.c b/mm/highmem.c
index 781e754..693394d 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -29,6 +29,11 @@
 #include <linux/kgdb.h>
 #include <asm/tlbflush.h>
 
+
+#if defined(CONFIG_HIGHMEM) || defined(CONFIG_X86_32)
+DEFINE_PER_CPU(int, __kmap_atomic_idx);
+#endif
+
 /*
  * Virtual_count is not a pure "count".
  *  0 means that it is not mapped, and has not been mapped
@@ -43,7 +48,6 @@ unsigned long totalhigh_pages __read_mostly;
 EXPORT_SYMBOL(totalhigh_pages);
 
 
-DEFINE_PER_CPU(int, __kmap_atomic_idx);
 EXPORT_PER_CPU_SYMBOL(__kmap_atomic_idx);
 
 unsigned int nr_free_highpages (void)



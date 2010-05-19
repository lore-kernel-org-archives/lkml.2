Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab0ESLC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:02:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:42944 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab0ESLCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:02:24 -0400
Subject: [PATCH 1/4] mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN
 to <linux/slab_def.h>
From: David Woodhouse <dwmw2@infradead.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>, manfred@colorfullife.com
Cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
In-Reply-To: <1274266725.6930.9823.camel@macbook.infradead.org>
References: <1274266725.6930.9823.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 12:01:42 +0100
Message-ID: <1274266902.6930.9834.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 include/linux/slab_def.h |   24 ++++++++++++++++++++++++
 mm/slab.c                |   24 ------------------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index ca6b2b3..1812dac 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -16,6 +16,30 @@
 #include <linux/compiler.h>
 #include <linux/kmemtrace.h>
 
+#ifndef ARCH_KMALLOC_MINALIGN
+/*
+ * Enforce a minimum alignment for the kmalloc caches.
+ * Usually, the kmalloc caches are cache_line_size() aligned, except when
+ * DEBUG and FORCED_DEBUG are enabled, then they are BYTES_PER_WORD aligned.
+ * Some archs want to perform DMA into kmalloc caches and need a guaranteed
+ * alignment larger than the alignment of a 64-bit integer.
+ * ARCH_KMALLOC_MINALIGN allows that.
+ * Note that increasing this value may disable some debug features.
+ */
+#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
+#endif
+
+#ifndef ARCH_SLAB_MINALIGN
+/*
+ * Enforce a minimum alignment for all caches.
+ * Intended for archs that get misalignment faults even for BYTES_PER_WORD
+ * aligned buffers. Includes ARCH_KMALLOC_MINALIGN.
+ * If possible: Do not enable this flag for CONFIG_DEBUG_SLAB, it disables
+ * some debug features.
+ */
+#define ARCH_SLAB_MINALIGN 0
+#endif
+
 /*
  * struct kmem_cache
  *
diff --git a/mm/slab.c b/mm/slab.c
index bac0f4f..7401ddc 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -144,30 +144,6 @@
 #define	BYTES_PER_WORD		sizeof(void *)
 #define	REDZONE_ALIGN		max(BYTES_PER_WORD, __alignof__(unsigned long long))
 
-#ifndef ARCH_KMALLOC_MINALIGN
-/*
- * Enforce a minimum alignment for the kmalloc caches.
- * Usually, the kmalloc caches are cache_line_size() aligned, except when
- * DEBUG and FORCED_DEBUG are enabled, then they are BYTES_PER_WORD aligned.
- * Some archs want to perform DMA into kmalloc caches and need a guaranteed
- * alignment larger than the alignment of a 64-bit integer.
- * ARCH_KMALLOC_MINALIGN allows that.
- * Note that increasing this value may disable some debug features.
- */
-#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
-#endif
-
-#ifndef ARCH_SLAB_MINALIGN
-/*
- * Enforce a minimum alignment for all caches.
- * Intended for archs that get misalignment faults even for BYTES_PER_WORD
- * aligned buffers. Includes ARCH_KMALLOC_MINALIGN.
- * If possible: Do not enable this flag for CONFIG_DEBUG_SLAB, it disables
- * some debug features.
- */
-#define ARCH_SLAB_MINALIGN 0
-#endif
-
 #ifndef ARCH_KMALLOC_FLAGS
 #define ARCH_KMALLOC_FLAGS SLAB_HWCACHE_ALIGN
 #endif
-- 
1.6.6.1




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1LKWKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 17:10:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44214 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab1LKWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 17:10:34 -0500
From: Brian Gerst <brgerst@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, tim@klingt.org, hpa@zytor.com,
        torvalds@linux-foundation.org
Subject: [PATCH] x86: Split off mem*io functions
Date: Sun, 11 Dec 2011 17:10:36 -0500
Message-Id: <1323641436-12249-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <CAMzpN2jiZn3=Og9EVhnWbEhZkvi6eebEJpR7qYn00OyJnZgcFQ@mail.gmail.com>
References: <CAMzpN2jiZn3=Og9EVhnWbEhZkvi6eebEJpR7qYn00OyJnZgcFQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6175ddf06b6172046a329e3abfd9c901a43efd2e changed the mem*io
functions to use the standard memcpy/memset routines, but there were
unintended consequences.  Some devices cannot cope with 64-bit or
non-sequential accesses that the optimized routines do.  Change them
back to simple 32-bit sequential writes.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/io.h |   20 +++-----------------
 arch/x86/lib/Makefile     |    1 +
 arch/x86/lib/io.c         |   41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/lib/io.c

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index d8e8eef..8115978 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -199,23 +199,9 @@ extern void set_iounmap_nonlazy(void);
  */
 #define xlate_dev_kmem_ptr(p)	p
 
-static inline void
-memset_io(volatile void __iomem *addr, unsigned char val, size_t count)
-{
-	memset((void __force *)addr, val, count);
-}
-
-static inline void
-memcpy_fromio(void *dst, const volatile void __iomem *src, size_t count)
-{
-	memcpy(dst, (const void __force *)src, count);
-}
-
-static inline void
-memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
-{
-	memcpy((void __force *)dst, src, count);
-}
+extern void memset_io(volatile void __iomem *addr, unsigned char val, size_t count);
+extern void memcpy_fromio(void *dst, const volatile void __iomem *src, size_t count);
+extern void memcpy_toio(volatile void __iomem *dst, const void *src, size_t count);
 
 /*
  * ISA space is 'always mapped' on a typical x86 system, no need to
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index b00f678..160d934 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -17,6 +17,7 @@ clean-files := inat-tables.c
 obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
 lib-y := delay.o
+lib-y += io.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
diff --git a/arch/x86/lib/io.c b/arch/x86/lib/io.c
new file mode 100644
index 0000000..7acdd6d
--- /dev/null
+++ b/arch/x86/lib/io.c
@@ -0,0 +1,41 @@
+#include <asm/io.h>
+#include <asm/types.h>
+#include <linux/module.h>
+
+/*
+ * Some devices can't handle 64-bit or non-sequential accesses.
+ * Use simple string instructions here instead of the normal optimized
+ * memcpy/menset functions.
+ */
+
+void memset_io(volatile void __iomem *addr, unsigned char val, size_t count)
+{
+	unsigned int v = val * 0x01010101;
+	size_t c = count / 4;
+	asm volatile("rep; stosl" : "+D" (addr), "+c" (c) : "a" (v) : "memory");
+	c = count & 3;
+	if (c)
+		asm volatile("rep; stosb" : "+D" (addr), "+c" (c) : "a" (v) : "memory");
+}
+EXPORT_SYMBOL(memset_io);
+
+static void __memcpy_io(void *dst, const void *src, size_t count)
+{
+	size_t c = count / 4;
+	asm volatile("rep; movsl" : "+S" (src), "+D" (dst), "+c" (c) : : "memory");
+	c = count & 3;
+	if (c)
+		asm volatile("rep; movsb" : "+S" (src), "+D" (dst), "+c" (c) : : "memory");
+}
+
+void memcpy_fromio(void *dst, const volatile void __iomem *src, size_t count)
+{
+        __memcpy_io(dst, (const void __force *)src, count);
+}
+EXPORT_SYMBOL(memcpy_fromio);
+
+void memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
+{
+        __memcpy_io((void __force *)dst, src, count);
+}
+EXPORT_SYMBOL(memcpy_toio);
-- 
1.7.4.4


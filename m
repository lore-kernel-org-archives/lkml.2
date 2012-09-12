Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2ILVOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:14:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52066 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141Ab2ILVOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:14:14 -0400
Date: Wed, 12 Sep 2012 22:12:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 26/31] arm64: Miscellaneous library functions
Message-ID: <20120912211259.GA8252@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-27-git-send-email-catalin.marinas@arm.com>
 <201209071952.14309.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209071952.14309.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 08:52:13PM +0100, Arnd Bergmann wrote:
> On Friday 07 September 2012, Catalin Marinas wrote:
> > +/*
> > + * Use compiler builtins for simple inline operations.
> > + */
> > +static inline unsigned long __ffs(unsigned long word)
> > +{
> > +	return __builtin_ffsl(word) - 1;
> > +}
> > +
> > +static inline int ffs(int x)
> > +{
> > +	return __builtin_ffs(x);
> > +}
> > +
> > +static inline unsigned long __fls(unsigned long word)
> > +{
> > +	return BITS_PER_LONG - 1 - __builtin_clzl(word);
> > +}
> > +
> > +static inline int fls(int x)
> > +{
> > +	return x ? sizeof(x) * BITS_PER_BYTE - __builtin_clz(x) : 0;
> > +}
> 
> Still waiting for the generic version of these.

What about these:


>From 64ec78a2fce931e0148db90747c69688f248a531 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 12 Sep 2012 22:00:53 +0100
Subject: [PATCH 1/2] Implement generic ffs/fls using __builtin_* functions

This patch implements ffs, __ffs, fls, __fls using __builtin_* gcc
functions. These header files can be used by other architectures that
rely on the gcc builtins.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/bitops/builtin-__ffs.h |   15 +++++++++++++++
 include/asm-generic/bitops/builtin-__fls.h |   15 +++++++++++++++
 include/asm-generic/bitops/builtin-ffs.h   |   17 +++++++++++++++++
 include/asm-generic/bitops/builtin-fls.h   |   16 ++++++++++++++++
 4 files changed, 63 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/bitops/builtin-__ffs.h
 create mode 100644 include/asm-generic/bitops/builtin-__fls.h
 create mode 100644 include/asm-generic/bitops/builtin-ffs.h
 create mode 100644 include/asm-generic/bitops/builtin-fls.h

diff --git a/include/asm-generic/bitops/builtin-__ffs.h b/include/asm-generic/bitops/builtin-__ffs.h
new file mode 100644
index 0000000..90041e3
--- /dev/null
+++ b/include/asm-generic/bitops/builtin-__ffs.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_GENERIC_BITOPS_BUILTIN___FFS_H_
+#define _ASM_GENERIC_BITOPS_BUILTIN___FFS_H_
+
+/**
+ * __ffs - find first bit in word.
+ * @word: The word to search
+ *
+ * Undefined if no bit exists, so code should check against 0 first.
+ */
+static __always_inline unsigned long __ffs(unsigned long word)
+{
+	return __builtin_ctzl(word);
+}
+
+#endif
diff --git a/include/asm-generic/bitops/builtin-__fls.h b/include/asm-generic/bitops/builtin-__fls.h
new file mode 100644
index 0000000..0248f38
--- /dev/null
+++ b/include/asm-generic/bitops/builtin-__fls.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_GENERIC_BITOPS_BUILTIN___FLS_H_
+#define _ASM_GENERIC_BITOPS_BUILTIN___FLS_H_
+
+/**
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static __always_inline unsigned long __fls(unsigned long word)
+{
+	return (sizeof(word) * 8) - 1 - __builtin_clzl(word);
+}
+
+#endif
diff --git a/include/asm-generic/bitops/builtin-ffs.h b/include/asm-generic/bitops/builtin-ffs.h
new file mode 100644
index 0000000..0648258
--- /dev/null
+++ b/include/asm-generic/bitops/builtin-ffs.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_GENERIC_BITOPS_BUILTIN_FFS_H_
+#define _ASM_GENERIC_BITOPS_BUILTIN_FFS_H_
+
+/**
+ * ffs - find first bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as
+ * the libc and compiler builtin ffs routines, therefore
+ * differs in spirit from the above ffz (man ffs).
+ */
+static __always_inline int ffs(int x)
+{
+	return __builtin_ffs(x);
+}
+
+#endif
diff --git a/include/asm-generic/bitops/builtin-fls.h b/include/asm-generic/bitops/builtin-fls.h
new file mode 100644
index 0000000..eda652d
--- /dev/null
+++ b/include/asm-generic/bitops/builtin-fls.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_GENERIC_BITOPS_BUILTIN_FLS_H_
+#define _ASM_GENERIC_BITOPS_BUILTIN_FLS_H_
+
+/**
+ * fls - find last (most-significant) bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as ffs.
+ * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
+ */
+static __always_inline int fls(int x)
+{
+	return x ? sizeof(x) * 8 - __builtin_clz(x) : 0;
+}
+
+#endif


>From 542f0b34b5674d8472b820f1ce751118ecdf9470 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 12 Sep 2012 22:06:22 +0100
Subject: [PATCH 2/2] arm64: Use the generic builtin-* ffs/fls implementation

This patch removes the arm64-specific ffs/fls implementation and
includes the generic gcc builtins implementation.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/bitops.h |   31 +++++--------------------------
 1 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/bitops.h b/arch/arm64/include/asm/bitops.h
index 67df4d2..5e69307 100644
--- a/arch/arm64/include/asm/bitops.h
+++ b/arch/arm64/include/asm/bitops.h
@@ -28,36 +28,15 @@
 #define smp_mb__after_clear_bit()	smp_mb()
 #endif
 
-/*
- * Use compiler builtins for simple inline operations.
- */
-static inline unsigned long __ffs(unsigned long word)
-{
-	return __builtin_ffsl(word) - 1;
-}
-
-static inline int ffs(int x)
-{
-	return __builtin_ffs(x);
-}
-
-static inline unsigned long __fls(unsigned long word)
-{
-	return BITS_PER_LONG - 1 - __builtin_clzl(word);
-}
-
-static inline int fls(int x)
-{
-	return x ? sizeof(x) * BITS_PER_BYTE - __builtin_clz(x) : 0;
-}
-
-/*
- * Mainly use the generic routines for now.
- */
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
 #endif
 
+#include <asm-generic/bitops/builtin-__ffs.h>
+#include <asm-generic/bitops/builtin-ffs.h>
+#include <asm-generic/bitops/builtin-__fls.h>
+#include <asm-generic/bitops/builtin-fls.h>
+
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/find.h>

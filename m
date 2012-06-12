Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2FLDIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 23:08:46 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:41717 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2FLDIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 23:08:43 -0400
From: T Makphaibulchoke <tmac@hp.com>
To: linux@arm.linux.org.uk, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux390@de.ibm.com, lethal@linux-sh.org, hpa@zytor.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kaloz@openwrt.org, nicolas.pitre@linaro.org, jj@chaosbits.net,
        matt.fleming@intel.com, lasse.collin@tukaani.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Cc: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH v2] lib/decompress_unxz.c: removing all memory helper functions
Date: Mon, 11 Jun 2012 21:05:07 -0600
Message-Id: <1339470307-28223-1-git-send-email-tmac@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up the file lib/decompress_unxz.c, moving all memory helper functions,
e.g. memmove, to a new common source file, lib/boot/mem.c.

In additon to including the decompressor, any architecture supporting the XZ
decompression needs to also include this new source file.

Also moving some other duplicated memory helper functions to this new source
file from the arm, s390, sh and x86 preboot environments.  All 4 architectures
build without error when using any compression.

Adding a new file lib/boot/mem.c, containing memory helper functions required
by different compression types.

Adding memcmp declaration workaround and removing the memmove and memcpy
defines workaround from arch/arm/boot/compressed/decompress.c

Removing the common functions, memmove, memcmp and memset, and adding the new
source file include to arch/arm/boot/compressed/string.c.

Removing the memcpy and memmove functions and adding the new source file
include to arch/s390/boot/compressed/misc.c.

Removing the memset function and adding the new source file include to
arch/sh/boot/compressed/misc.c

Removing the memset function from arch/x86/boot/compressed/misc.c and move
the memcpy function to the file arch/x86/boot/compressed/string.c

Adding the memcpy function and the new source file include to
arch/x86/boot/compressed/string.c

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>

--
Change since v1:
* created and moved common memory helper functions to a new file.
---
 arch/arm/boot/compressed/decompress.c |    3 +-
 arch/arm/boot/compressed/string.c     |   41 ++-----------------
 arch/s390/boot/compressed/misc.c      |   23 ++---------
 arch/sh/boot/compressed/misc.c        |   11 +----
 arch/x86/boot/compressed/misc.c       |   39 ------------------
 arch/x86/boot/compressed/string.c     |   35 ++++++++++++++++
 lib/boot/mem.c                        |   58 +++++++++++++++++++++++++++
 lib/decompress_unxz.c                 |   70 +--------------------------------
 lib/xz/xz_private.h                   |    7 ++-
 9 files changed, 112 insertions(+), 175 deletions(-)
 create mode 100644 lib/boot/mem.c

diff --git a/arch/arm/boot/compressed/decompress.c b/arch/arm/boot/compressed/decompress.c
index f41b38c..80a2219 100644
--- a/arch/arm/boot/compressed/decompress.c
+++ b/arch/arm/boot/compressed/decompress.c
@@ -9,6 +9,7 @@
 extern unsigned long free_mem_ptr;
 extern unsigned long free_mem_end_ptr;
 extern void error(char *);
+extern int memcmp(const void *, const void *, size_t);
 
 #define STATIC static
 #define STATIC_RW_DATA	/* non-static please */
@@ -45,8 +46,6 @@ extern void error(char *);
 #endif
 
 #ifdef CONFIG_KERNEL_XZ
-#define memmove memmove
-#define memcpy memcpy
 #include "../../../../lib/decompress_unxz.c"
 #endif
 
diff --git a/arch/arm/boot/compressed/string.c b/arch/arm/boot/compressed/string.c
index 36e53ef..269258d 100644
--- a/arch/arm/boot/compressed/string.c
+++ b/arch/arm/boot/compressed/string.c
@@ -6,6 +6,7 @@
 
 #include <linux/string.h>
 
+#define	__HAVE_PREBOOT_ARCH_MEMCPY
 void *memcpy(void *__dest, __const void *__src, size_t __n)
 {
 	int i = 0;
@@ -40,22 +41,6 @@ void *memcpy(void *__dest, __const void *__src, size_t __n)
 	return __dest;
 }
 
-void *memmove(void *__dest, __const void *__src, size_t count)
-{
-	unsigned char *d = __dest;
-	const unsigned char *s = __src;
-
-	if (__dest == __src)
-		return __dest;
-
-	if (__dest < __src)
-		return memcpy(__dest, __src, count);
-
-	while (count--)
-		d[count] = s[count];
-	return __dest;
-}
-
 size_t strlen(const char *s)
 {
 	const char *sc = s;
@@ -65,19 +50,6 @@ size_t strlen(const char *s)
 	return sc - s;
 }
 
-int memcmp(const void *cs, const void *ct, size_t count)
-{
-	const unsigned char *su1 = cs, *su2 = ct, *end = su1 + count;
-	int res = 0;
-
-	while (su1 < end) {
-		res = *su1++ - *su2++;
-		if (res)
-			break;
-	}
-	return res;
-}
-
 int strcmp(const char *cs, const char *ct)
 {
 	unsigned char c1, c2;
@@ -113,15 +85,10 @@ char *strchr(const char *s, int c)
 
 #undef memset
 
-void *memset(void *s, int c, size_t count)
-{
-	char *xs = s;
-	while (count--)
-		*xs++ = c;
-	return s;
-}
-
 void __memzero(void *s, size_t count)
 {
 	memset(s, 0, count);
 }
+
+#include "../../../../lib/boot/mem.c"
+
diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
index 465eca7..7169232 100644
--- a/arch/s390/boot/compressed/misc.c
+++ b/arch/s390/boot/compressed/misc.c
@@ -67,6 +67,8 @@ static int puts(const char *s)
 	return 0;
 }
 
+#define __HAVE_PREBOOT_ARCH_MEMSET
+
 void *memset(void *s, int c, size_t n)
 {
 	char *xs;
@@ -82,25 +84,6 @@ void *memset(void *s, int c, size_t n)
 	return s;
 }
 
-void *memcpy(void *__dest, __const void *__src, size_t __n)
-{
-	return __builtin_memcpy(__dest, __src, __n);
-}
-
-void *memmove(void *__dest, __const void *__src, size_t __n)
-{
-	char *d;
-	const char *s;
-
-	if (__dest <= __src)
-		return __builtin_memcpy(__dest, __src, __n);
-	d = __dest + __n;
-	s = __src + __n;
-	while (__n--)
-		*--d = *--s;
-	return __dest;
-}
-
 static void error(char *x)
 {
 	unsigned long long psw = 0x000a0000deadbeefULL;
@@ -166,3 +149,5 @@ unsigned long decompress_kernel(void)
 	return (unsigned long) output;
 }
 
+#include "../../../../lib/boot/mem.c"
+
diff --git a/arch/sh/boot/compressed/misc.c b/arch/sh/boot/compressed/misc.c
index 95470a4..b1dde68 100644
--- a/arch/sh/boot/compressed/misc.c
+++ b/arch/sh/boot/compressed/misc.c
@@ -75,14 +75,7 @@ int puts(const char *s)
 	return 0;
 }
 
-void* memset(void* s, int c, size_t n)
-{
-	int i;
-	char *ss = (char*)s;
-
-	for (i=0;i<n;i++) ss[i] = c;
-	return s;
-}
+#define __HAVE_PREBOOT_ARCH_MEMCPY
 
 void* memcpy(void* __dest, __const void* __src,
 			    size_t __n)
@@ -136,3 +129,5 @@ void decompress_kernel(void)
 	cache_control(CACHE_DISABLE);
 	puts("Ok, booting the kernel.\n");
 }
+
+#include "../../../../lib/boot/mem.c"
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7116dcb..ac07fbb 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -224,45 +224,6 @@ void __putstr(int error, const char *s)
 	outb(0xff & (pos >> 1), vidport+1);
 }
 
-void *memset(void *s, int c, size_t n)
-{
-	int i;
-	char *ss = s;
-
-	for (i = 0; i < n; i++)
-		ss[i] = c;
-	return s;
-}
-#ifdef CONFIG_X86_32
-void *memcpy(void *dest, const void *src, size_t n)
-{
-	int d0, d1, d2;
-	asm volatile(
-		"rep ; movsl\n\t"
-		"movl %4,%%ecx\n\t"
-		"rep ; movsb\n\t"
-		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
-		: "0" (n >> 2), "g" (n & 3), "1" (dest), "2" (src)
-		: "memory");
-
-	return dest;
-}
-#else
-void *memcpy(void *dest, const void *src, size_t n)
-{
-	long d0, d1, d2;
-	asm volatile(
-		"rep ; movsq\n\t"
-		"movq %4,%%rcx\n\t"
-		"rep ; movsb\n\t"
-		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
-		: "0" (n >> 3), "g" (n & 7), "1" (dest), "2" (src)
-		: "memory");
-
-	return dest;
-}
-#endif
-
 static void error(char *x)
 {
 	__putstr(1, "\n\n");
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index ffb9c5c..d6b8784 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -1,5 +1,7 @@
 #include "misc.h"
 
+#define __HAVE_PREBOOT_ARCH_MEMCMP
+
 int memcmp(const void *s1, const void *s2, size_t len)
 {
 	u8 diff;
@@ -8,4 +10,37 @@ int memcmp(const void *s1, const void *s2, size_t len)
 	return diff;
 }
 
+#define __HAVE_PREBOOT_ARCH_MEMCPY
+
+#ifdef CONFIG_X86_32
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	int d0, d1, d2;
+	asm volatile(
+		"rep ; movsl\n\t"
+		"movl %4,%%ecx\n\t"
+		"rep ; movsb\n\t"
+		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		: "0" (n >> 2), "g" (n & 3), "1" (dest), "2" (src)
+		: "memory");
+
+	return dest;
+}
+#else
+void *memcpy(void *dest, const void *src, size_t n)
+{
+	long d0, d1, d2;
+	asm volatile(
+		"rep ; movsq\n\t"
+		"movq %4,%%rcx\n\t"
+		"rep ; movsb\n\t"
+		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		: "0" (n >> 3), "g" (n & 7), "1" (dest), "2" (src)
+		: "memory");
+
+	return dest;
+}
+#endif
+
+#include "../../../../lib/boot/mem.c"
 #include "../string.c"
diff --git a/lib/boot/mem.c b/lib/boot/mem.c
new file mode 100644
index 0000000..a27381f
--- /dev/null
+++ b/lib/boot/mem.c
@@ -0,0 +1,58 @@
+/*
+ * Small subset of simple memory helper functions required by different
+ * compressors for preboot environment.
+ */
+
+#include <linux/string.h>
+
+#ifndef __HAVE_PREBOOT_ARCH_MEMCPY
+void *memcpy(void *__dest, __const void *__src, size_t __n)
+{
+	return __builtin_memcpy(__dest, __src, __n);
+}
+#endif
+
+#ifndef __HAVE_PREBOOT_ARCH_MEMMOVE
+void *memmove(void *__dest, __const void *__src, size_t count)
+{
+	unsigned char *d = __dest;
+	const unsigned char *s = __src;
+
+	if (__dest == __src)
+		return __dest;
+
+	if (__dest < __src)
+		return memcpy(__dest, __src, count);
+
+	while (count--)
+		d[count] = s[count];
+	return __dest;
+}
+#endif
+
+#ifndef __HAVE_PREBOOT_ARCH_MEMCMP
+int memcmp(const void *cs, const void *ct, size_t count)
+{
+	const unsigned char *su1 = cs, *su2 = ct, *end = su1 + count;
+	int res = 0;
+
+	while (su1 < end) {
+		res = *su1++ - *su2++;
+		if (res)
+			break;
+	}
+	return res;
+}
+#endif
+
+#ifndef __HAVE_PREBOOT_ARCH_MEMSET
+void *memset(void *s, int c, size_t count)
+{
+	char *xs = s;
+
+	while (count--)
+		*xs++ = c;
+	return s;
+}
+#endif
+
diff --git a/lib/decompress_unxz.c b/lib/decompress_unxz.c
index 9f34eb5..97c9fb5 100644
--- a/lib/decompress_unxz.c
+++ b/lib/decompress_unxz.c
@@ -160,76 +160,10 @@
 #define vfree(ptr) do { if (ptr != NULL) free(ptr); } while (0)
 
 /*
- * FIXME: Not all basic memory functions are provided in architecture-specific
- * files (yet). We define our own versions here for now, but this should be
- * only a temporary solution.
- *
- * memeq and memzero are not used much and any remotely sane implementation
- * is fast enough. memcpy/memmove speed matters in multi-call mode, but
- * the kernel image is decompressed in single-call mode, in which only
- * memcpy speed can matter and only if there is a lot of uncompressible data
- * (LZMA2 stores uncompressible chunks in uncompressed form). Thus, the
- * functions below should just be kept small; it's probably not worth
- * optimizing for speed.
+ * To support XZ-decompressed file in preboot environment, include the file
+ * lib/boot/mem.c, to bring in all the required memory helper functions.
  */
 
-#ifndef memeq
-static bool memeq(const void *a, const void *b, size_t size)
-{
-	const uint8_t *x = a;
-	const uint8_t *y = b;
-	size_t i;
-
-	for (i = 0; i < size; ++i)
-		if (x[i] != y[i])
-			return false;
-
-	return true;
-}
-#endif
-
-#ifndef memzero
-static void memzero(void *buf, size_t size)
-{
-	uint8_t *b = buf;
-	uint8_t *e = b + size;
-
-	while (b != e)
-		*b++ = '\0';
-}
-#endif
-
-#ifndef memmove
-/* Not static to avoid a conflict with the prototype in the Linux headers. */
-void *memmove(void *dest, const void *src, size_t size)
-{
-	uint8_t *d = dest;
-	const uint8_t *s = src;
-	size_t i;
-
-	if (d < s) {
-		for (i = 0; i < size; ++i)
-			d[i] = s[i];
-	} else if (d > s) {
-		i = size;
-		while (i-- > 0)
-			d[i] = s[i];
-	}
-
-	return dest;
-}
-#endif
-
-/*
- * Since we need memmove anyway, would use it as memcpy too.
- * Commented out for now to avoid breaking things.
- */
-/*
-#ifndef memcpy
-#	define memcpy memmove
-#endif
-*/
-
 #include "xz/xz_crc32.c"
 #include "xz/xz_dec_stream.c"
 #include "xz/xz_dec_lzma2.c"
diff --git a/lib/xz/xz_private.h b/lib/xz/xz_private.h
index 482b90f..a997dca 100644
--- a/lib/xz/xz_private.h
+++ b/lib/xz/xz_private.h
@@ -37,9 +37,12 @@
 #		ifdef CONFIG_XZ_DEC_SPARC
 #			define XZ_DEC_SPARC
 #		endif
-#		define memeq(a, b, size) (memcmp(a, b, size) == 0)
-#		define memzero(buf, size) memset(buf, 0, size)
 #	endif
+	/* Make all environments, including preboot, use memcmp for memeq */
+#	define memeq(a, b, size) (memcmp(a, b, size) == 0)
+	/* To suppress redefine warning in some architecture's preboot */
+#	undef memzero
+#	define memzero(buf, size) memset(buf, 0, size)
 #	define get_le32(p) le32_to_cpup((const uint32_t *)(p))
 #else
 	/*
-- 
1.7.1


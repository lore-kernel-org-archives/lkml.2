Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab2IJUYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:24:17 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:47449 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2IJUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:24:14 -0400
From: T Makphaibulchoke <tmac@hp.com>
To: linux@arm.linux.org.uk, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux390@de.ibm.com, lethal@linux-sh.org, hpa@zytor.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kaloz@openwrt.org, nicolas.pitre@linaro.org, caushik1@gmail.com,
        josh@joshtriplett.org, jmillenbach@gmail.com, jj@chaosbits.net,
        matt.fleming@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org
Cc: T Makphaibulchoke <tmac@hp.com>
Subject: [PATH v3] Cleaning up the file lib/decompress_unxz.c, moving all memory helper functions, e.g. memmove, to a new common source file, lib/boot/mem.c
Date: Mon, 10 Sep 2012 14:24:05 -0600
Message-Id: <1347308645-329-1-git-send-email-tmac@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In additon to including the decompressor, any architecture supporting the XZ
decompression needs to also include this new source file.

Also moving some other duplicated memory helper functions to this new source
file from the arm, s390, sh and x86 preboot environments.  All 4 architectures
build without error when using any compression methods.

Adding a new file lib/boot/mem.c, containing the weak version of the memory
helper functions required by different compression types.  Any architecture
could override any of the functions with a non-weak more optimized version
in a separate memory utility file.

Removing the memmove and memcpy defines workaround and adding the new source
file include to arch/arm/boot/compressed/decompress.c

Removing the common functions, memmove and memcmp, from
arch/arm/boot/compressed/string.c.

Removing the memset, memcpy and memmove functions and adding the new source file
include to arch/s390/boot/compressed/misc.c.

Removing the memset and memcpy functions and adding the new source file
include to arch/sh/boot/compressed/misc.c

Removing the memcpy and memset functions and adding the new source
file include to arch/x86/boot/compressed/misc.c

Adding the memcpy functions, removed from misc.c, to
arch/x86/boot/compressed/string.c

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>

--
Change since v2:
* Instead of calling memcpy, memmove manually copying data to ensure data
  integrity.
* Replacing ifdef HAVE_PREBOOT_XXX with architecture specific weak functions.
* Replacing __builtin_memcpy call in memcpy with a generic implementation.

Change since v1:
* created and moved common memory helper functions to a new file.
---
 arch/arm/boot/compressed/decompress.c |    5 +-
 arch/arm/boot/compressed/string.c     |   38 +-----------------
 arch/s390/boot/compressed/misc.c      |   36 +----------------
 arch/sh/boot/compressed/misc.c        |   21 +---------
 arch/x86/boot/compressed/misc.c       |   41 +------------------
 arch/x86/boot/compressed/string.c     |   30 ++++++++++++++
 lib/boot/mem.c                        |   67 +++++++++++++++++++++++++++++++
 lib/decompress_unxz.c                 |   70 +--------------------------------
 lib/xz/xz_private.h                   |    7 ++-
 9 files changed, 114 insertions(+), 201 deletions(-)
 create mode 100644 lib/boot/mem.c

diff --git a/arch/arm/boot/compressed/decompress.c b/arch/arm/boot/compressed/decompress.c
index f41b38c..5024f76 100644
--- a/arch/arm/boot/compressed/decompress.c
+++ b/arch/arm/boot/compressed/decompress.c
@@ -10,6 +10,8 @@ extern unsigned long free_mem_ptr;
 extern unsigned long free_mem_end_ptr;
 extern void error(char *);
 
+#include "../../../../lib/boot/mem.c"
+
 #define STATIC static
 #define STATIC_RW_DATA	/* non-static please */
 
@@ -45,8 +47,6 @@ extern void error(char *);
 #endif
 
 #ifdef CONFIG_KERNEL_XZ
-#define memmove memmove
-#define memcpy memcpy
 #include "../../../../lib/decompress_unxz.c"
 #endif
 
@@ -54,3 +54,4 @@ int do_decompress(u8 *input, int len, u8 *output, void (*error)(char *x))
 {
 	return decompress(input, len, NULL, NULL, output, NULL, error);
 }
+
diff --git a/arch/arm/boot/compressed/string.c b/arch/arm/boot/compressed/string.c
index 36e53ef..4ce2508 100644
--- a/arch/arm/boot/compressed/string.c
+++ b/arch/arm/boot/compressed/string.c
@@ -40,22 +40,6 @@ void *memcpy(void *__dest, __const void *__src, size_t __n)
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
@@ -65,19 +49,6 @@ size_t strlen(const char *s)
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
@@ -113,15 +84,8 @@ char *strchr(const char *s, int c)
 
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
diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
index 465eca7..0fde064 100644
--- a/arch/s390/boot/compressed/misc.c
+++ b/arch/s390/boot/compressed/misc.c
@@ -67,40 +67,6 @@ static int puts(const char *s)
 	return 0;
 }
 
-void *memset(void *s, int c, size_t n)
-{
-	char *xs;
-
-	if (c == 0)
-		return __builtin_memset(s, 0, n);
-
-	xs = (char *) s;
-	if (n > 0)
-		do {
-			*xs++ = c;
-		} while (--n > 0);
-	return s;
-}
-
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
@@ -166,3 +132,5 @@ unsigned long decompress_kernel(void)
 	return (unsigned long) output;
 }
 
+#include "../../../../lib/boot/mem.c"
+
diff --git a/arch/sh/boot/compressed/misc.c b/arch/sh/boot/compressed/misc.c
index 95470a4..b8ba7e6 100644
--- a/arch/sh/boot/compressed/misc.c
+++ b/arch/sh/boot/compressed/misc.c
@@ -15,6 +15,8 @@
 #include <asm/addrspace.h>
 #include <asm/page.h>
 
+#include "../../../../lib/boot/mem.c"
+
 /*
  * gzip declarations
  */
@@ -75,25 +77,6 @@ int puts(const char *s)
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
-
-void* memcpy(void* __dest, __const void* __src,
-			    size_t __n)
-{
-	int i;
-	char *d = (char *)__dest, *s = (char *)__src;
-
-	for (i=0;i<__n;i++) d[i] = s[i];
-	return __dest;
-}
-
 static void error(char *x)
 {
 	puts("\n\n");
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 88f7ff6..94bb591 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -218,45 +218,6 @@ void __putstr(const char *s)
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
 	error_putstr("\n\n");
@@ -362,3 +323,5 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	debug_putstr("done.\nBooting the kernel.\n");
 	return;
 }
+
+#include "../../../../lib/boot/mem.c"
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index ffb9c5c..5adf16a 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -8,4 +8,34 @@ int memcmp(const void *s1, const void *s2, size_t len)
 	return diff;
 }
 
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
 #include "../string.c"
diff --git a/lib/boot/mem.c b/lib/boot/mem.c
new file mode 100644
index 0000000..b8b9375
--- /dev/null
+++ b/lib/boot/mem.c
@@ -0,0 +1,67 @@
+/*
+ * Small subset of simple memory helper functions required by different
+ * compressors for preboot environment.
+ * They are defined as weak so that any architecture could overwrite any of
+ * them with a more optimized version.
+ */
+
+#include <linux/string.h>
+
+__attribute__((weak)) void *memcpy(void *__dest, __const void *__src,
+				   size_t __n)
+{
+	char *tmp = __dest;
+	const char *s = __src;
+
+	while (__n--)
+		*tmp++ = *s++;
+	return __dest;
+}
+
+__attribute__((weak)) void *memmove(void *__dest, __const void *__src,
+				    size_t count)
+{
+	unsigned char *d = __dest;
+	const unsigned char *s = __src;
+
+	if (__dest == __src)
+		return __dest;
+
+	if (__dest < __src) {
+		size_t i;
+
+		for (i = 0; i < count; i++)
+			d[i] = s[i];
+	} else {
+		while (count--)
+			d[count] = s[count];
+	}
+
+	return __dest;
+}
+
+__attribute__((weak)) int memcmp(const void *cs, const void *ct, size_t count)
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
+
+# undef memset
+
+__attribute__((weak)) void *memset(void *s, int c, size_t n)
+{
+	int i;
+	char *ss = s;
+
+	for (i = 0; i < n; i++)
+		ss[i] = c;
+	return s;
+}
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


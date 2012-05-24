Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2EXQF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:05:57 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:9536 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab2EXQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:05:55 -0400
From: T Makphaibulchoke <tmac@hp.com>
To: lethal@linux-sh.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kaloz@openwrt.org, matt.fleming@intel.com,
        lasse.collin@tukaani.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux@arm.linux.org.uk,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com
Cc: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH] lib/decompress_unxz.c: removing all memory helper functions
Date: Thu, 24 May 2012 10:03:56 -0600
Message-Id: <1337875436-27640-1-git-send-email-tmac@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch cleans up the file lib/decompress_unxz.c by removing all memory
helper functions, e.g., memmove.  By doing so, any architecture's preboot
environment supporting the XZ decompression needs to define its own copy of
any of the missing memory helper functions.

The patch makes sure that all 4 architectures' preboot currently supporting
the XZ decompressor, arm, s390, sh and x86, build without error when using
the XZ compression.

Adding a prototype for the memcmp function required by the XZ decompressor to
workaround compiler's implicit type error.  Also removing both the memmove and
memcpy defines workaround, to disable lib/decompress_unxz.c from duplicating
both functions.

Adding the missing memcmp function, required by the XZ decompressor, to the
s390 preboot environment.

Adding both the missing memmove and memcmp functions, required by the XZ
decompressor, to the sh preboot environment.

Adding the missing memmove function, required by XZ decompressor, to the x86
preboot environment.

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
---
 arch/arm/boot/compressed/decompress.c |    3 +-
 arch/s390/boot/compressed/misc.c      |   14 +++++
 arch/sh/boot/compressed/misc.c        |   32 ++++++++++++
 arch/x86/boot/compressed/string.c     |   18 +++++++
 lib/decompress_unxz.c                 |   85 +++++++--------------------------
 lib/xz/xz_private.h                   |    7 ++-
 6 files changed, 87 insertions(+), 72 deletions(-)

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
 
diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
index 465eca7..b966af3 100644
--- a/arch/s390/boot/compressed/misc.c
+++ b/arch/s390/boot/compressed/misc.c
@@ -87,6 +87,20 @@ void *memcpy(void *__dest, __const void *__src, size_t __n)
 	return __builtin_memcpy(__dest, __src, __n);
 }
 
+int memcmp(const void *cs, const void *ct, size_t count)
+{
+	const unsigned char *su1, *su2;
+	int res = 0;
+
+	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--) {
+		res = *su1 - *su2;
+		if (res != 0)
+			break;
+	}
+
+	return res;
+}
+
 void *memmove(void *__dest, __const void *__src, size_t __n)
 {
 	char *d;
diff --git a/arch/sh/boot/compressed/misc.c b/arch/sh/boot/compressed/misc.c
index 95470a4..09e740d 100644
--- a/arch/sh/boot/compressed/misc.c
+++ b/arch/sh/boot/compressed/misc.c
@@ -94,6 +94,38 @@ void* memcpy(void* __dest, __const void* __src,
 	return __dest;
 }
 
+void *memmove(void *dest, const void *src, size_t size)
+{
+	uint8_t *d = dest;
+	const uint8_t *s = src;
+	size_t i;
+
+	if (d < s) {
+		for (i = 0; i < size; ++i)
+			d[i] = s[i];
+	} else if (d > s) {
+		i = size;
+		while (i-- > 0)
+			d[i] = s[i];
+	}
+
+	return dest;
+}
+
+int memcmp(const void *cs, const void *ct, size_t count)
+{
+	const unsigned char *su1, *su2;
+	int res = 0;
+
+	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--) {
+		res = *su1 - *su2;
+		if (res != 0)
+			break;
+	}
+
+	return res;
+}
+
 static void error(char *x)
 {
 	puts("\n\n");
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index ffb9c5c..2f4fdfa 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -8,4 +8,22 @@ int memcmp(const void *s1, const void *s2, size_t len)
 	return diff;
 }
 
+void *memmove(void *dest, const void *src, size_t size)
+{
+	uint8_t *d = dest;
+	const uint8_t *s = src;
+	size_t i;
+
+	if (d < s) {
+		for (i = 0; i < size; ++i)
+			d[i] = s[i];
+	} else if (d > s) {
+		i = size;
+		while (i-- > 0)
+			d[i] = s[i];
+	}
+
+	return dest;
+}
+
 #include "../string.c"
diff --git a/lib/decompress_unxz.c b/lib/decompress_unxz.c
index 9f34eb5..bd09c2f 100644
--- a/lib/decompress_unxz.c
+++ b/lib/decompress_unxz.c
@@ -160,75 +160,24 @@
 #define vfree(ptr) do { if (ptr != NULL) free(ptr); } while (0)
 
 /*
- * FIXME: Not all basic memory functions are provided in architecture-specific
- * files (yet). We define our own versions here for now, but this should be
- * only a temporary solution.
+ * To support XZ-decompressed file in preboot environment, the following
+ * functions, memcmp, memset, memcpy and memmove, needed to be defined in
+ * architecture-specific preboot environment.
+ *
+ * Not all architecture-specific preboot environment currently support all of
+ * the above functions.
+ *
+ * If your architecture does not support any of the above functions, simply
+ * add the missing function(s) to the architecture-specific preboot string.c
+ * or misc.c file, for example arch/x86/boot/compressed/string.c for the x86
+ * architecture.
+ *
+ * memcmp is not used much and any remotely sane implementation is fast enough.
+ * memmove speed matters in multi-call mode.  Any missing memory helper
+ * functions, including a decent implementation of an in-place memmove function
+ * could be found in lib/string.c
  *
- * memeq and memzero are not used much and any remotely sane implementation
- * is fast enough. memcpy/memmove speed matters in multi-call mode, but
- * the kernel image is decompressed in single-call mode, in which only
- * memcpy speed can matter and only if there is a lot of uncompressible data
- * (LZMA2 stores uncompressible chunks in uncompressed form). Thus, the
- * functions below should just be kept small; it's probably not worth
- * optimizing for speed.
- */
-
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
  */
-/*
-#ifndef memcpy
-#	define memcpy memmove
-#endif
-*/
 
 #include "xz/xz_crc32.c"
 #include "xz/xz_dec_stream.c"
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


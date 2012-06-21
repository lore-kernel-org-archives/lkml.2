Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab2FULl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:41:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45288 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759390Ab2FULl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:41:57 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -mm] string: fix build error caused by memweight() introduction
Date: Thu, 21 Jun 2012 20:41:37 +0900
Message-Id: <1340278897-2055-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck reports a build error on the ia64 sim_defconfig:

 LD      arch/ia64/hp/sim/boot/bootloader
lib/lib.a(string.o): In function `bitmap_weight':
.../linux-next/include/linux/bitmap.h:280: undefined reference to `__bitmap_weight'

It fails because it pulls in lib/lib.a(string.o) to get some
innocuous function like strcpy() ... but it also gets
given memweight() which relies on __bitmap_weight()
which it doesn't have, because it doesn't include lib/built-in.o
(which is where bitmap.o, the definer of __bitmap_weight(), has
been linked).

This build error is introduced by the patch string-introduce-memweight.patch
in -mm tree.  Fix it by creating own file lib/memweight.c.

Reported-by: Tony Luck <tony.luck@gmail.com>
Suggested-by: Tony Luck <tony.luck@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/Makefile    |    2 +-
 lib/memweight.c |   38 ++++++++++++++++++++++++++++++++++++++
 lib/string.c    |   36 ------------------------------------
 3 files changed, 39 insertions(+), 37 deletions(-)
 create mode 100644 lib/memweight.c

diff --git a/lib/Makefile b/lib/Makefile
index 8c31a0c..df663cc 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -22,7 +22,7 @@ lib-y	+= kobject.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
-	 bsearch.o find_last_bit.o find_next_bit.o llist.o
+	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
diff --git a/lib/memweight.c b/lib/memweight.c
new file mode 100644
index 0000000..e35fc87
--- /dev/null
+++ b/lib/memweight.c
@@ -0,0 +1,38 @@
+#include <linux/export.h>
+#include <linux/bug.h>
+#include <linux/bitmap.h>
+
+/**
+ * memweight - count the total number of bits set in memory area
+ * @ptr: pointer to the start of the area
+ * @bytes: the size of the area
+ */
+size_t memweight(const void *ptr, size_t bytes)
+{
+	size_t ret = 0;
+	size_t longs;
+	const unsigned char *bitmap = ptr;
+
+	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
+			bytes--, bitmap++)
+		ret += hweight8(*bitmap);
+
+	longs = bytes / sizeof(long);
+	if (longs) {
+		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
+		ret += bitmap_weight((unsigned long *)bitmap,
+				longs * BITS_PER_LONG);
+		bytes -= longs * sizeof(long);
+		bitmap += longs * sizeof(long);
+	}
+	/*
+	 * The reason that this last loop is distinct from the preceding
+	 * bitmap_weight() call is to compute 1-bits in the last region smaller
+	 * than sizeof(long) properly on big-endian systems.
+	 */
+	for (; bytes > 0; bytes--, bitmap++)
+		ret += hweight8(*bitmap);
+
+	return ret;
+}
+EXPORT_SYMBOL(memweight);
diff --git a/lib/string.c b/lib/string.c
index e948176..e5878de 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -26,7 +26,6 @@
 #include <linux/export.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
-#include <linux/bitmap.h>
 
 #ifndef __HAVE_ARCH_STRNICMP
 /**
@@ -825,38 +824,3 @@ void *memchr_inv(const void *start, int c, size_t bytes)
 	return check_bytes8(start, value, bytes % 8);
 }
 EXPORT_SYMBOL(memchr_inv);
-
-/**
- * memweight - count the total number of bits set in memory area
- * @ptr: pointer to the start of the area
- * @bytes: the size of the area
- */
-size_t memweight(const void *ptr, size_t bytes)
-{
-	size_t ret = 0;
-	size_t longs;
-	const unsigned char *bitmap = ptr;
-
-	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
-			bytes--, bitmap++)
-		ret += hweight8(*bitmap);
-
-	longs = bytes / sizeof(long);
-	if (longs) {
-		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
-		ret += bitmap_weight((unsigned long *)bitmap,
-				longs * BITS_PER_LONG);
-		bytes -= longs * sizeof(long);
-		bitmap += longs * sizeof(long);
-	}
-	/*
-	 * The reason that this last loop is distinct from the preceding
-	 * bitmap_weight() call is to compute 1-bits in the last region smaller
-	 * than sizeof(long) properly on big-endian systems.
-	 */
-	for (; bytes > 0; bytes--, bitmap++)
-		ret += hweight8(*bitmap);
-
-	return ret;
-}
-EXPORT_SYMBOL(memweight);
-- 
1.7.10.2


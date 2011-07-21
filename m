Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1GUMyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:54:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38626 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab1GUMx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:53:57 -0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Brian Gerst <brgerst@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC v3 5/5] x86: implement RUNTIME_USER_COPY_CHECK
Date: Thu, 21 Jul 2011 16:53:50 +0400
Message-Id: <1311252832-6892-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kernel_access_ok() checks in {,__}copy_{to,from}_user().
Implement x86 variant of arch_check_object_on_stack_frame(), which
checks whether the copied buffer doesn't overflow a single stack frame.
The boundaries of the frame are the saved return address and the saved
EBP/RBP register.  This information is available in case of
CONFIG_FRAME_POINTERS=y only, otherwise don't check anything and simply
return true.

v3 - Used __always_inline.
   - Now log the copy direction (from/to user) on overflows.
   - Used #ifdef instead of #if defined().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 arch/x86/include/asm/uaccess.h    |   49 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/uaccess_32.h |   32 ++++++++++++++++++++++--
 arch/x86/include/asm/uaccess_64.h |   38 +++++++++++++++++++++++++++-
 arch/x86/lib/usercopy_32.c        |    2 +-
 4 files changed, 115 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 99ddd14..f81a1d6 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -9,6 +9,7 @@
 #include <linux/string.h>
 #include <asm/asm.h>
 #include <asm/page.h>
+#include <linux/uaccess-check.h>
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
@@ -78,6 +79,54 @@
  */
 #define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
 
+#ifdef CONFIG_FRAME_POINTER
+/*
+ * MUST be always_inline to correctly count stack frame numbers.
+ *
+ * low ----------------------------------------------> high
+ * [saved bp][saved ip][args][local vars][saved bp][saved ip]
+ *		       ^----------------^
+ *		  allow copies only within here
+*/
+#undef arch_check_object_on_stack_frame
+static __always_inline bool arch_check_object_on_stack_frame(const void *stack,
+	     const void *stackend, const void *obj, unsigned long len)
+{
+	const void *frame = NULL;
+	const void *oldframe;
+
+	/*
+	 * Get the kernel_access_ok() caller frame.
+	 * __builtin_frame_address(0) returns __kernel_access_ok() frame
+	 * as arch_ and stack_ are inline and __kernel_ is noinline.
+	 */
+	oldframe = __builtin_frame_address(0);
+	if (oldframe)
+		frame = __builtin_frame_address(1);
+
+	while (stack <= frame && frame < stackend) {
+		/*
+		 * If obj + len extends past the last frame, this
+		 * check won't pass and the next frame will be 0,
+		 * causing us to bail out and correctly report
+		 * the copy as invalid.
+		 */
+		if (obj + len <= frame) {
+			/* EBP + EIP (or RBP + RIP for x86-64) */
+			size_t protected_regs_size = 2*sizeof(void *);
+
+			if (obj >= oldframe + protected_regs_size)
+				return true;
+			return false;
+		}
+		oldframe = frame;
+		frame = *(const void * const *)frame;
+	}
+	return false;
+}
+#define arch_check_object_on_stack_frame arch_check_object_on_stack_frame
+#endif /* CONFIG_FRAME_POINTER */
+
 /*
  * The exception table consists of pairs of addresses: the first is the
  * address of an instruction that is allowed to fault, and the second is
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 566e803..669a2b6 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -82,6 +82,8 @@ static __always_inline unsigned long __must_check
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
+	if (!kernel_access_ok(from, n, true))
+		return n;
 	return __copy_to_user_inatomic(to, from, n);
 }
 
@@ -152,6 +154,8 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 			return ret;
 		}
 	}
+	if (!kernel_access_ok(to, n, false))
+		return n;
 	return __copy_from_user_ll(to, from, n);
 }
 
@@ -205,13 +209,35 @@ static inline unsigned long __must_check copy_from_user(void *to,
 {
 	int sz = __compiletime_object_size(to);
 
-	if (likely(sz == -1 || sz >= n))
-		n = _copy_from_user(to, from, n);
-	else
+	if (likely(sz == -1 || sz >= n)) {
+		if (kernel_access_ok(to, n, false))
+			n = _copy_from_user(to, from, n);
+	} else {
 		copy_from_user_overflow();
+	}
+
+	return n;
+}
 
+#undef copy_from_user_unchecked
+static inline unsigned long __must_check copy_from_user_unchecked(void *to,
+					  const void __user *from,
+					  unsigned long n)
+{
+	return _copy_from_user(to, from, n);
+}
+#define copy_from_user_unchecked copy_from_user_unchecked
+
+#undef copy_to_user_unchecked
+static inline unsigned long copy_to_user_unchecked(void __user *to,
+					  const void *from,
+					  unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		n = __copy_to_user(to, from, n);
 	return n;
 }
+#define copy_to_user_unchecked copy_to_user_unchecked
 
 long __must_check strncpy_from_user(char *dst, const char __user *src,
 				    long count);
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 1c66d30..407facb 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -50,8 +50,10 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	int sz = __compiletime_object_size(to);
 
 	might_fault();
-	if (likely(sz == -1 || sz >= n))
-		n = _copy_from_user(to, from, n);
+	if (likely(sz == -1 || sz >= n)) {
+		if (kernel_access_ok(to, n, false))
+			n = _copy_from_user(to, from, n);
+	}
 #ifdef CONFIG_DEBUG_VM
 	else
 		WARN(1, "Buffer overflow detected!\n");
@@ -59,13 +61,37 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	return n;
 }
 
+#undef copy_from_user_unchecked
+static inline unsigned long __must_check copy_from_user_unchecked(void *to,
+					  const void __user *from,
+					  unsigned long n)
+{
+	might_fault();
+
+	return _copy_from_user(to, from, n);
+}
+#define copy_from_user_unchecked copy_from_user_unchecked
+
 static __always_inline __must_check
 int copy_to_user(void __user *dst, const void *src, unsigned size)
 {
 	might_fault();
 
+	if (!kernel_access_ok(src, size, true))
+		return size;
+
+	return _copy_to_user(dst, src, size);
+}
+
+#undef copy_to_user_unchecked
+static __always_inline __must_check
+int copy_to_user_unchecked(void __user *dst, const void *src, unsigned size)
+{
+	might_fault();
+
 	return _copy_to_user(dst, src, size);
 }
+#define copy_to_user_unchecked copy_to_user_unchecked
 
 static __always_inline __must_check
 int __copy_from_user(void *dst, const void __user *src, unsigned size)
@@ -73,8 +99,12 @@ int __copy_from_user(void *dst, const void __user *src, unsigned size)
 	int ret = 0;
 
 	might_fault();
+	if (!kernel_access_ok(dst, size, false))
+		return size;
+
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
+
 	switch (size) {
 	case 1:__get_user_asm(*(u8 *)dst, (u8 __user *)src,
 			      ret, "b", "b", "=q", 1);
@@ -117,8 +147,12 @@ int __copy_to_user(void __user *dst, const void *src, unsigned size)
 	int ret = 0;
 
 	might_fault();
+	if (!kernel_access_ok(dst, size, true))
+		return size;
+
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst, src, size);
+
 	switch (size) {
 	case 1:__put_user_asm(*(u8 *)src, (u8 __user *)dst,
 			      ret, "b", "b", "iq", 1);
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index e218d5d..4c8b5b5 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -851,7 +851,7 @@ EXPORT_SYMBOL(__copy_from_user_ll_nocache_nozero);
 unsigned long
 copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-	if (access_ok(VERIFY_WRITE, to, n))
+	if (access_ok(VERIFY_WRITE, to, n) && kernel_access_ok(from, n, true))
 		n = __copy_to_user(to, from, n);
 	return n;
 }
--

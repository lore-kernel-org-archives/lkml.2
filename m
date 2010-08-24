Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab0HXXdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:33:18 -0400
Received: from kroah.org ([198.145.64.141]:40447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947Ab0HXW7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:00 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:16 2010
Message-Id: <20100824224216.017352832@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [46/91] x86, asm: Clean up and simplify set_64bit()
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 69309a05907546fb686b251d4ab041c26afe1e1d upstream.

Clean up and simplify set_64bit().  This code is quite old (1.3.11)
and contains a fair bit of auxilliary machinery that current versions
of gcc handle just fine automatically.  Worse, the auxilliary
machinery can actually cause an unnecessary spill to memory.

Furthermore, the loading of the old value inside the loop in the
32-bit case is unnecessary: if the value doesn't match, the CMPXCHG8B
instruction will already have loaded the "new previous" value for us.

Clean up the comment, too, and remove page references to obsolete
versions of the Intel SDM.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <tip-*@vger.kernel.org>
Tested-by: Mark Stanovich <mrktimber@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/cmpxchg_32.h |   67 +++++++++++---------------------------
 arch/x86/include/asm/cmpxchg_64.h |    4 --
 2 files changed, 21 insertions(+), 50 deletions(-)

--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -53,60 +53,33 @@ struct __xchg_dummy {
 	__xchg((v), (ptr), sizeof(*ptr))
 
 /*
- * The semantics of XCHGCMP8B are a bit strange, this is why
- * there is a loop and the loading of %%eax and %%edx has to
- * be inside. This inlines well in most cases, the cached
- * cost is around ~38 cycles. (in the future we might want
- * to do an SIMD/3DNOW!/MMX/FPU 64-bit store here, but that
- * might have an implicit FPU-save as a cost, so it's not
- * clear which path to go.)
+ * CMPXCHG8B only writes to the target if we had the previous
+ * value in registers, otherwise it acts as a read and gives us the
+ * "new previous" value.  That is why there is a loop.  Preloading
+ * EDX:EAX is a performance optimization: in the common case it means
+ * we need only one locked operation.
  *
- * cmpxchg8b must be used with the lock prefix here to allow
- * the instruction to be executed atomically, see page 3-102
- * of the instruction set reference 24319102.pdf. We need
- * the reader side to see the coherent 64bit value.
+ * A SIMD/3DNOW!/MMX/FPU 64-bit store here would require at the very
+ * least an FPU save and/or %cr0.ts manipulation.
+ *
+ * cmpxchg8b must be used with the lock prefix here to allow the
+ * instruction to be executed atomically.  We need to have the reader
+ * side to see the coherent 64bit value.
  */
-static inline void __set_64bit(unsigned long long *ptr,
-			       unsigned int low, unsigned int high)
+static inline void set_64bit(volatile u64 *ptr, u64 value)
 {
+	u32 low  = value;
+	u32 high = value >> 32;
+	u64 prev = *ptr;
+
 	asm volatile("\n1:\t"
-		     "movl (%1), %%eax\n\t"
-		     "movl 4(%1), %%edx\n\t"
-		     LOCK_PREFIX "cmpxchg8b (%1)\n\t"
+		     LOCK_PREFIX "cmpxchg8b %0\n\t"
 		     "jnz 1b"
-		     : "=m" (*ptr)
-		     : "D" (ptr),
-		       "b" (low),
-		       "c" (high)
-		     : "ax", "dx", "memory");
-}
-
-static inline void __set_64bit_constant(unsigned long long *ptr,
-					unsigned long long value)
-{
-	__set_64bit(ptr, (unsigned int)value, (unsigned int)(value >> 32));
+		     : "=m" (*ptr), "+A" (prev)
+		     : "b" (low), "c" (high)
+		     : "memory");
 }
 
-#define ll_low(x)	*(((unsigned int *)&(x)) + 0)
-#define ll_high(x)	*(((unsigned int *)&(x)) + 1)
-
-static inline void __set_64bit_var(unsigned long long *ptr,
-				   unsigned long long value)
-{
-	__set_64bit(ptr, ll_low(value), ll_high(value));
-}
-
-#define set_64bit(ptr, value)			\
-	(__builtin_constant_p((value))		\
-	 ? __set_64bit_constant((ptr), (value))	\
-	 : __set_64bit_var((ptr), (value)))
-
-#define _set_64bit(ptr, value)						\
-	(__builtin_constant_p(value)					\
-	 ? __set_64bit(ptr, (unsigned int)(value),			\
-		       (unsigned int)((value) >> 32))			\
-	 : __set_64bit(ptr, ll_low((value)), ll_high((value))))
-
 extern void __cmpxchg_wrong_size(void);
 
 /*
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -5,13 +5,11 @@
 
 #define __xg(x) ((volatile long *)(x))
 
-static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
+static inline void set_64bit(volatile u64 *ptr, u64 val)
 {
 	*ptr = val;
 }
 
-#define _set_64bit set_64bit
-
 extern void __xchg_wrong_size(void);
 extern void __cmpxchg_wrong_size(void);
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab0IXQgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:36:10 -0400
Received: from kroah.org ([198.145.64.141]:37497 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab0IXQgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:36:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:50 2010
Message-Id: <20100924163350.038425916@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@zytor.com>, Glauber Costa <glommer@redhat.com>,
        Avi Kivity <avi@redhat.com>, Peter Palfrader <peter@palfrader.org>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [68/68] x86: Add memory modify constraints to xchg() and cmpxchg()
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 113fc5a6e8c2288619ff7e8187a6f556b7e0d372 upstream.

[ Backport to .32 by Tomáš Janoušek <tomi@nomi.cz> ]

xchg() and cmpxchg() modify their memory operands, not merely read
them.  For some versions of gcc the "memory" clobber has apparently
dealt with the situation, but not for all.

Originally-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Glauber Costa <glommer@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Palfrader <peter@palfrader.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Zachary Amsden <zamsden@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
LKML-Reference: <4C4F7277.8050306@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/cmpxchg_32.h |   65 +++++++++++---------------------------
 arch/x86/include/asm/cmpxchg_64.h |    4 --
 2 files changed, 20 insertions(+), 49 deletions(-)

--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -17,60 +17,33 @@ struct __xchg_dummy {
 #define __xg(x) ((struct __xchg_dummy *)(x))
 
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
 		     LOCK_PREFIX "cmpxchg8b %0\n\t"
 		     "jnz 1b"
-		     : "=m"(*ptr)
-		     : "D" (ptr),
-		       "b"(low),
-		       "c"(high)
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
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
  * Note 2: xchg has side effect, so that attribute volatile is necessary,
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -8,13 +8,11 @@
 
 #define __xg(x) ((volatile long *)(x))
 
-static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
+static inline void set_64bit(volatile u64 *ptr, u64 val)
 {
 	*ptr = val;
 }
 
-#define _set_64bit set_64bit
-
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
  * Note 2: xchg has side effect, so that attribute volatile is necessary,



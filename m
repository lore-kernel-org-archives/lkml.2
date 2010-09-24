Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0IXHRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:17:40 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:36468 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab0IXHRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:17:39 -0400
Date: Fri, 24 Sep 2010 09:17:36 +0200
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Greg KH <greg@kroah.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, glommer@redhat.com,
        alan@lxorguk.ukuu.org.uk, zamsden@redhat.com, stable@kernel.org,
        mtosatti@redhat.com, gregkh@suse.de, peter@palfrader.org,
        tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [stable] [tip:x86/urgent] x86: Add memory modify constraints
	to xchg() and cmpxchg()
Message-ID: <20100924071736.GA11988@nomi.cz>
References: <4C4F7277.8050306@zytor.com> <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org> <4C5759FF.1000807@goop.org> <20100802235950.GA662@kroah.com> <20100909195301.GA18291@nomi.cz> <4C894E64.3050800@zytor.com> <20100910131035.GA16636@nomi.cz> <20100923183724.GS23040@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100923183724.GS23040@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

On Thu, Sep 23, 2010 at 11:37:24AM -0700, Greg KH wrote:
> Hm, that patch doesn't apply to the latest .32-stable tree.  Can someone
> provide me with a backported version so I make sure I get it correct?

I'm attaching the one I used and tested.

-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="0001-x86-asm-Clean-up-and-simplify-set_64bit.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 48a45b4cd701520435188fcf9ef0c04e73c79172 Mon Sep 17 00:00:00 2001
=46rom: H. Peter Anvin <hpa@zytor.com>
Date: Tue, 27 Jul 2010 23:29:52 -0700
Subject: [PATCH] x86, asm: Clean up and simplify set_64bit()

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
---
 arch/x86/include/asm/cmpxchg_32.h |   65 +++++++++++----------------------=
----
 arch/x86/include/asm/cmpxchg_64.h |    4 +--
 2 files changed, 20 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxc=
hg_32.h
index 5af5051..9873a5f 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -17,60 +17,33 @@ struct __xchg_dummy {
 #define __xg(x) ((struct __xchg_dummy *)(x))
=20
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
+	u32 low  =3D value;
+	u32 high =3D value >> 32;
+	u64 prev =3D *ptr;
+
 	asm volatile("\n1:\t"
-		     "movl (%1), %%eax\n\t"
-		     "movl 4(%1), %%edx\n\t"
 		     LOCK_PREFIX "cmpxchg8b %0\n\t"
 		     "jnz 1b"
-		     : "=3Dm"(*ptr)
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
-}
-
-#define ll_low(x)	*(((unsigned int *)&(x)) + 0)
-#define ll_high(x)	*(((unsigned int *)&(x)) + 1)
-
-static inline void __set_64bit_var(unsigned long long *ptr,
-				   unsigned long long value)
-{
-	__set_64bit(ptr, ll_low(value), ll_high(value));
+		     : "=3Dm" (*ptr), "+A" (prev)
+		     : "b" (low), "c" (high)
+		     : "memory");
 }
=20
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
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxc=
hg_64.h
index 1871cb0..e8cb051 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -8,13 +8,11 @@
=20
 #define __xg(x) ((volatile long *)(x))
=20
-static inline void set_64bit(volatile unsigned long *ptr, unsigned long va=
l)
+static inline void set_64bit(volatile u64 *ptr, u64 val)
 {
 	*ptr =3D val;
 }
=20
-#define _set_64bit set_64bit
-
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
  * Note 2: xchg has side effect, so that attribute volatile is necessary,
--=20
1.7.1


--sdtB3X0nJg68CQEu--

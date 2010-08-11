Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab0HKX5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:57:30 -0400
Received: from kroah.org ([198.145.64.141]:40017 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521Ab0HKX50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:26 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:56 2010
Message-Id: <20100811235455.972827670@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:53:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@zytor.com>, Glauber Costa <glommer@redhat.com>,
        Avi Kivity <avi@redhat.com>, Peter Palfrader <peter@palfrader.org>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [004/111] x86: Add memory modify constraints to xchg() and cmpxchg()
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 113fc5a6e8c2288619ff7e8187a6f556b7e0d372 upstream.

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
 arch/x86/include/asm/cmpxchg_32.h |   86 ++++++++++++++++++-------------------
 arch/x86/include/asm/cmpxchg_64.h |   88 ++++++++++++++++++++------------------
 2 files changed, 89 insertions(+), 85 deletions(-)

--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -34,12 +34,12 @@ static inline void __set_64bit(unsigned
 			       unsigned int low, unsigned int high)
 {
 	asm volatile("\n1:\t"
-		     "movl (%0), %%eax\n\t"
-		     "movl 4(%0), %%edx\n\t"
-		     LOCK_PREFIX "cmpxchg8b (%0)\n\t"
+		     "movl (%1), %%eax\n\t"
+		     "movl 4(%1), %%edx\n\t"
+		     LOCK_PREFIX "cmpxchg8b %0\n\t"
 		     "jnz 1b"
-		     : /* no outputs */
-		     : "D"(ptr),
+		     : "=m"(*ptr)
+		     : "D" (ptr),
 		       "b"(low),
 		       "c"(high)
 		     : "ax", "dx", "memory");
@@ -82,20 +82,20 @@ static inline unsigned long __xchg(unsig
 	switch (size) {
 	case 1:
 		asm volatile("xchgb %b0,%1"
-			     : "=q" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=q" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	case 2:
 		asm volatile("xchgw %w0,%1"
-			     : "=r" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=r" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	case 4:
 		asm volatile("xchgl %0,%1"
-			     : "=r" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=r" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	}
@@ -139,21 +139,21 @@ static inline unsigned long __cmpxchg(vo
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgb %b2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgw %w2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile(LOCK_PREFIX "cmpxchgl %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgl %2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
@@ -172,21 +172,21 @@ static inline unsigned long __sync_cmpxc
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile("lock; cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgb %b2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile("lock; cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgw %w2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile("lock; cmpxchgl %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgl %2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
@@ -200,21 +200,21 @@ static inline unsigned long __cmpxchg_lo
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile("cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgb %b2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile("cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgw %w2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile("cmpxchgl %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgl %2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
@@ -226,11 +226,10 @@ static inline unsigned long long __cmpxc
 					     unsigned long long new)
 {
 	unsigned long long prev;
-	asm volatile(LOCK_PREFIX "cmpxchg8b %3"
-		     : "=A"(prev)
+	asm volatile(LOCK_PREFIX "cmpxchg8b %1"
+		     : "=A"(prev), "+m" (*__xg(ptr))
 		     : "b"((unsigned long)new),
 		       "c"((unsigned long)(new >> 32)),
-		       "m"(*__xg(ptr)),
 		       "0"(old)
 		     : "memory");
 	return prev;
@@ -241,11 +240,10 @@ static inline unsigned long long __cmpxc
 						   unsigned long long new)
 {
 	unsigned long long prev;
-	asm volatile("cmpxchg8b %3"
-		     : "=A"(prev)
+	asm volatile("cmpxchg8b %1"
+		     : "=A"(prev), "+m"(*__xg(ptr))
 		     : "b"((unsigned long)new),
 		       "c"((unsigned long)(new >> 32)),
-		       "m"(*__xg(ptr)),
 		       "0"(old)
 		     : "memory");
 	return prev;
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -26,26 +26,26 @@ static inline unsigned long __xchg(unsig
 	switch (size) {
 	case 1:
 		asm volatile("xchgb %b0,%1"
-			     : "=q" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=q" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	case 2:
 		asm volatile("xchgw %w0,%1"
-			     : "=r" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=r" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	case 4:
 		asm volatile("xchgl %k0,%1"
-			     : "=r" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=r" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	case 8:
 		asm volatile("xchgq %0,%1"
-			     : "=r" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=r" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	}
@@ -66,27 +66,27 @@ static inline unsigned long __cmpxchg(vo
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgb %b2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgw %w2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile(LOCK_PREFIX "cmpxchgl %k1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgl %k2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 8:
-		asm volatile(LOCK_PREFIX "cmpxchgq %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgq %2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
@@ -105,21 +105,27 @@ static inline unsigned long __sync_cmpxc
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile("lock; cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgb %b2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile("lock; cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgw %w2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile("lock; cmpxchgl %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgl %k2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
+			     : "memory");
+		return prev;
+	case 8:
+		asm volatile("lock; cmpxchgq %2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
@@ -133,27 +139,27 @@ static inline unsigned long __cmpxchg_lo
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile("cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgb %b2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile("cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgw %w2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile("cmpxchgl %k1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgl %k2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 8:
-		asm volatile("cmpxchgq %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgq %2,%1"
+			     : "=a"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}



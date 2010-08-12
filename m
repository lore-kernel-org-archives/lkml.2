Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab0HLAIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:08:00 -0400
Received: from kroah.org ([198.145.64.141]:60461 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab0HLAHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:07:52 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:13 2010
Message-Id: <20100812000613.413371932@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@zytor.com>, Glauber Costa <glommer@redhat.com>,
        Avi Kivity <avi@redhat.com>, Peter Palfrader <peter@palfrader.org>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [08/67] x86: Add memory modify constraints to xchg() and cmpxchg()
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
 arch/x86/include/asm/cmpxchg_32.h |   68 +++++++++++++++++++-------------------
 arch/x86/include/asm/cmpxchg_64.h |   40 +++++++++++-----------
 2 files changed, 54 insertions(+), 54 deletions(-)

--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -27,20 +27,20 @@ struct __xchg_dummy {
 	switch (size) {							\
 	case 1:								\
 		asm volatile("xchgb %b0,%1"				\
-			     : "=q" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "=q" (__x), "+m" (*__xg(ptr))		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
 	case 2:								\
 		asm volatile("xchgw %w0,%1"				\
-			     : "=r" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "=r" (__x), "+m" (*__xg(ptr))		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
 	case 4:								\
 		asm volatile("xchgl %0,%1"				\
-			     : "=r" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "=r" (__x), "+m" (*__xg(ptr))		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
 	default:							\
@@ -70,14 +70,14 @@ static inline void __set_64bit(unsigned
 			       unsigned int low, unsigned int high)
 {
 	asm volatile("\n1:\t"
-		     "movl (%0), %%eax\n\t"
-		     "movl 4(%0), %%edx\n\t"
-		     LOCK_PREFIX "cmpxchg8b (%0)\n\t"
+		     "movl (%1), %%eax\n\t"
+		     "movl 4(%1), %%edx\n\t"
+		     LOCK_PREFIX "cmpxchg8b (%1)\n\t"
 		     "jnz 1b"
-		     : /* no outputs */
-		     : "D"(ptr),
-		       "b"(low),
-		       "c"(high)
+		     : "=m" (*ptr)
+		     : "D" (ptr),
+		       "b" (low),
+		       "c" (high)
 		     : "ax", "dx", "memory");
 }
 
@@ -121,21 +121,21 @@ extern void __cmpxchg_wrong_size(void);
 	__typeof__(*(ptr)) __new = (new);				\
 	switch (size) {							\
 	case 1:								\
-		asm volatile(lock "cmpxchgb %b1,%2"			\
-			     : "=a"(__ret)				\
-			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+		asm volatile(lock "cmpxchgb %b2,%1"			\
+			     : "=a" (__ret), "+m" (*__xg(ptr))		\
+			     : "q" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
 	case 2:								\
-		asm volatile(lock "cmpxchgw %w1,%2"			\
-			     : "=a"(__ret)				\
-			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+		asm volatile(lock "cmpxchgw %w2,%1"			\
+			     : "=a" (__ret), "+m" (*__xg(ptr))		\
+			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
 	case 4:								\
-		asm volatile(lock "cmpxchgl %1,%2"			\
-			     : "=a"(__ret)				\
-			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+		asm volatile(lock "cmpxchgl %2,%1"			\
+			     : "=a" (__ret), "+m" (*__xg(ptr))		\
+			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
 	default:							\
@@ -180,12 +180,12 @@ static inline unsigned long long __cmpxc
 					     unsigned long long new)
 {
 	unsigned long long prev;
-	asm volatile(LOCK_PREFIX "cmpxchg8b %3"
-		     : "=A"(prev)
-		     : "b"((unsigned long)new),
-		       "c"((unsigned long)(new >> 32)),
-		       "m"(*__xg(ptr)),
-		       "0"(old)
+	asm volatile(LOCK_PREFIX "cmpxchg8b %1"
+		     : "=A" (prev),
+		       "+m" (*__xg(ptr))
+		     : "b" ((unsigned long)new),
+		       "c" ((unsigned long)(new >> 32)),
+		       "0" (old)
 		     : "memory");
 	return prev;
 }
@@ -195,12 +195,12 @@ static inline unsigned long long __cmpxc
 						   unsigned long long new)
 {
 	unsigned long long prev;
-	asm volatile("cmpxchg8b %3"
-		     : "=A"(prev)
-		     : "b"((unsigned long)new),
-		       "c"((unsigned long)(new >> 32)),
-		       "m"(*__xg(ptr)),
-		       "0"(old)
+	asm volatile("cmpxchg8b %1"
+		     : "=A" (prev),
+		       "+m" (*__xg(ptr))
+		     : "b" ((unsigned long)new),
+		       "c" ((unsigned long)(new >> 32)),
+		       "0" (old)
 		     : "memory");
 	return prev;
 }
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -26,26 +26,26 @@ extern void __cmpxchg_wrong_size(void);
 	switch (size) {							\
 	case 1:								\
 		asm volatile("xchgb %b0,%1"				\
-			     : "=q" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "=q" (__x), "+m" (*__xg(ptr))		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
 	case 2:								\
 		asm volatile("xchgw %w0,%1"				\
-			     : "=r" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "=r" (__x), "+m" (*__xg(ptr))		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
 	case 4:								\
 		asm volatile("xchgl %k0,%1"				\
-			     : "=r" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "=r" (__x), "+m" (*__xg(ptr))		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
 	case 8:								\
 		asm volatile("xchgq %0,%1"				\
-			     : "=r" (__x)				\
-			     : "m" (*__xg(ptr)), "0" (__x)		\
+			     : "=r" (__x), "+m" (*__xg(ptr))		\
+			     : "0" (__x)				\
 			     : "memory");				\
 		break;							\
 	default:							\
@@ -71,27 +71,27 @@ extern void __cmpxchg_wrong_size(void);
 	__typeof__(*(ptr)) __new = (new);				\
 	switch (size) {							\
 	case 1:								\
-		asm volatile(lock "cmpxchgb %b1,%2"			\
-			     : "=a"(__ret)				\
-			     : "q"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+		asm volatile(lock "cmpxchgb %b2,%1"			\
+			     : "=a" (__ret), "+m" (*__xg(ptr))		\
+			     : "q" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
 	case 2:								\
-		asm volatile(lock "cmpxchgw %w1,%2"			\
-			     : "=a"(__ret)				\
-			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+		asm volatile(lock "cmpxchgw %w2,%1"			\
+			     : "=a" (__ret), "+m" (*__xg(ptr))		\
+			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
 	case 4:								\
-		asm volatile(lock "cmpxchgl %k1,%2"			\
-			     : "=a"(__ret)				\
-			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+		asm volatile(lock "cmpxchgl %k2,%1"			\
+			     : "=a" (__ret), "+m" (*__xg(ptr))		\
+			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
 	case 8:								\
-		asm volatile(lock "cmpxchgq %1,%2"			\
-			     : "=a"(__ret)				\
-			     : "r"(__new), "m"(*__xg(ptr)), "0"(__old)	\
+		asm volatile(lock "cmpxchgq %2,%1"			\
+			     : "=a" (__ret), "+m" (*__xg(ptr))		\
+			     : "r" (__new), "0" (__old)			\
 			     : "memory");				\
 		break;							\
 	default:							\



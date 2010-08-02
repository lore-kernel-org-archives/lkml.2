Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0HBXvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:51:32 -0400
Received: from claw.goop.org ([74.207.240.146]:40163 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab0HBXva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:51:30 -0400
Message-ID: <4C5759FF.1000807@goop.org>
Date: Mon, 02 Aug 2010 16:51:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        glommer@redhat.com, alan@lxorguk.ukuu.org.uk, zamsden@redhat.com,
        stable@kernel.org, mtosatti@redhat.com, gregkh@suse.de,
        peter@palfrader.org, tglx@linutronix.de, avi@redhat.com
CC: linux-tip-commits@vger.kernel.org, Stable Kernel <stable@kernel.org>
Subject: Re: [tip:x86/urgent] x86: Add memory modify constraints to xchg()
 and cmpxchg()
References: <4C4F7277.8050306@zytor.com> <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org>
In-Reply-To: <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/27/2010 10:33 PM, tip-bot for H. Peter Anvin wrote:
> Commit-ID:  113fc5a6e8c2288619ff7e8187a6f556b7e0d372
> Gitweb:     http://git.kernel.org/tip/113fc5a6e8c2288619ff7e8187a6f556b7e0d372
> Author:     H. Peter Anvin<hpa@zytor.com>
> AuthorDate: Tue, 27 Jul 2010 17:01:49 -0700
> Committer:  H. Peter Anvin<hpa@zytor.com>
> CommitDate: Tue, 27 Jul 2010 17:14:02 -0700
>
> x86: Add memory modify constraints to xchg() and cmpxchg()

Here's the 2.6.32 version for stable.

     J

From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
Date: Tue, 27 Jul 2010 23:03:58 -0700
Subject: [PATCH] x86: Add memory modify constraints to xchg() and cmpxchg()

xchg() and cmpxchg() modify their memory operands, not merely read
them.  For some versions of gcc the "memory" clobber has apparently
dealt with the situation, but not for all.

Also adds the missing 8-byte case for __sync_cmpxchg().

Based on HPA's patch.

Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
Cc: "H. Peter Anvin"<hpa@zytor.com>
Cc: Stable Kernel<stable@kernel.org>

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index ee1931b..5af5051 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -34,12 +34,12 @@ static inline void __set_64bit(unsigned long long *ptr,
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
@@ -82,20 +82,20 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
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
@@ -139,21 +139,21 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
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
@@ -172,21 +172,21 @@ static inline unsigned long __sync_cmpxchg(volatile void *ptr,
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
@@ -200,21 +200,21 @@ static inline unsigned long __cmpxchg_local(volatile void *ptr,
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
@@ -226,11 +226,10 @@ static inline unsigned long long __cmpxchg64(volatile void *ptr,
  					     unsigned long long new)
  {
  	unsigned long long prev;
-	asm volatile(LOCK_PREFIX "cmpxchg8b %3"
-		     : "=A"(prev)
+	asm volatile(LOCK_PREFIX "cmpxchg8b %1"
+		     : "=A"(prev), "+m" (*__xg(ptr))
  		     : "b"((unsigned long)new),
  		       "c"((unsigned long)(new>>  32)),
-		       "m"(*__xg(ptr)),
  		       "0"(old)
  		     : "memory");
  	return prev;
@@ -241,11 +240,10 @@ static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
  						   unsigned long long new)
  {
  	unsigned long long prev;
-	asm volatile("cmpxchg8b %3"
-		     : "=A"(prev)
+	asm volatile("cmpxchg8b %1"
+		     : "=A"(prev), "+m"(*__xg(ptr))
  		     : "b"((unsigned long)new),
  		       "c"((unsigned long)(new>>  32)),
-		       "m"(*__xg(ptr)),
  		       "0"(old)
  		     : "memory");
  	return prev;
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 52de72e..1871cb0 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -26,26 +26,26 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
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
@@ -66,27 +66,27 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
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
@@ -105,21 +105,27 @@ static inline unsigned long __sync_cmpxchg(volatile void *ptr,
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
@@ -133,27 +139,27 @@ static inline unsigned long __cmpxchg_local(volatile void *ptr,
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



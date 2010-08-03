Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0HCMny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:43:54 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:45153 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab0HCMnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 08:43:53 -0400
Date: Tue, 3 Aug 2010 14:43:51 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        glommer@redhat.com, alan@lxorguk.ukuu.org.uk, zamsden@redhat.com,
        stable@kernel.org, mtosatti@redhat.com, gregkh@suse.de,
        tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Add memory modify constraints to xchg()
	and cmpxchg()
Message-ID: <20100803124351.GJ27199@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, mingo@redhat.com,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, glommer@redhat.com,
	alan@lxorguk.ukuu.org.uk, zamsden@redhat.com, stable@kernel.org,
	mtosatti@redhat.com, gregkh@suse.de, tglx@linutronix.de,
	avi@redhat.com, linux-tip-commits@vger.kernel.org
References: <4C4F7277.8050306@zytor.com> <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org> <4C5759FF.1000807@goop.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <4C5759FF.1000807@goop.org>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

On Mon, 02 Aug 2010, Jeremy Fitzhardinge wrote:

>> Commit-ID:  113fc5a6e8c2288619ff7e8187a6f556b7e0d372
>> Gitweb:     http://git.kernel.org/tip/113fc5a6e8c2288619ff7e8187a6f556b7e0d372
>> Author:     H. Peter Anvin<hpa@zytor.com>
>> AuthorDate: Tue, 27 Jul 2010 17:01:49 -0700
>> Committer:  H. Peter Anvin<hpa@zytor.com>
>> CommitDate: Tue, 27 Jul 2010 17:14:02 -0700
>>
>> x86: Add memory modify constraints to xchg() and cmpxchg()
>
> Here's the 2.6.32 version for stable.

Thanks a lot everyone.  This patch resolves the issue for me on top
of 2.6.32.17.

(I had some whitespace issue with applying the patch, so I've attached
the cleaned up version in case it wasn't just me.)

Cheers,
Peter
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/

--QKdGvSO+nmPlgiQ/
Content-Type: text/x-diff; charset=iso-8859-15
Content-Disposition: attachment; filename="0001-x86-Add-memory-modify-constraints-to-xchg-and-cmp.patch"
Content-Transfer-Encoding: quoted-printable

=46rom f6fd342ddae3f7edecd0254e5c4e6795d4fba4a9 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
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
---
 arch/x86/include/asm/cmpxchg_32.h |   86 +++++++++++++++++----------------=
--
 arch/x86/include/asm/cmpxchg_64.h |   88 ++++++++++++++++++++-------------=
----
 2 files changed, 89 insertions(+), 85 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxc=
hg_32.h
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
+		     : "=3Dm"(*ptr)
+		     : "D" (ptr),
 		       "b"(low),
 		       "c"(high)
 		     : "ax", "dx", "memory");
@@ -82,20 +82,20 @@ static inline unsigned long __xchg(unsigned long x, vol=
atile void *ptr,
 	switch (size) {
 	case 1:
 		asm volatile("xchgb %b0,%1"
-			     : "=3Dq" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=3Dq" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	case 2:
 		asm volatile("xchgw %w0,%1"
-			     : "=3Dr" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=3Dr" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	case 4:
 		asm volatile("xchgl %0,%1"
-			     : "=3Dr" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=3Dr" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	}
@@ -139,21 +139,21 @@ static inline unsigned long __cmpxchg(volatile void *=
ptr, unsigned long old,
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"
-			     : "=3Da"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgb %b2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgw %w2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile(LOCK_PREFIX "cmpxchgl %1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgl %2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
@@ -172,21 +172,21 @@ static inline unsigned long __sync_cmpxchg(volatile v=
oid *ptr,
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile("lock; cmpxchgb %b1,%2"
-			     : "=3Da"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgb %b2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile("lock; cmpxchgw %w1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgw %w2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile("lock; cmpxchgl %1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgl %2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
@@ -200,21 +200,21 @@ static inline unsigned long __cmpxchg_local(volatile =
void *ptr,
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile("cmpxchgb %b1,%2"
-			     : "=3Da"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgb %b2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile("cmpxchgw %w1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgw %w2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile("cmpxchgl %1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgl %2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
@@ -226,11 +226,10 @@ static inline unsigned long long __cmpxchg64(volatile=
 void *ptr,
 					     unsigned long long new)
 {
 	unsigned long long prev;
-	asm volatile(LOCK_PREFIX "cmpxchg8b %3"
-		     : "=3DA"(prev)
+	asm volatile(LOCK_PREFIX "cmpxchg8b %1"
+		     : "=3DA"(prev), "+m" (*__xg(ptr))
 		     : "b"((unsigned long)new),
 		       "c"((unsigned long)(new >> 32)),
-		       "m"(*__xg(ptr)),
 		       "0"(old)
 		     : "memory");
 	return prev;
@@ -241,11 +240,10 @@ static inline unsigned long long __cmpxchg64_local(vo=
latile void *ptr,
 						   unsigned long long new)
 {
 	unsigned long long prev;
-	asm volatile("cmpxchg8b %3"
-		     : "=3DA"(prev)
+	asm volatile("cmpxchg8b %1"
+		     : "=3DA"(prev), "+m"(*__xg(ptr))
 		     : "b"((unsigned long)new),
 		       "c"((unsigned long)(new >> 32)),
-		       "m"(*__xg(ptr)),
 		       "0"(old)
 		     : "memory");
 	return prev;
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxc=
hg_64.h
index 52de72e..1871cb0 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -26,26 +26,26 @@ static inline unsigned long __xchg(unsigned long x, vol=
atile void *ptr,
 	switch (size) {
 	case 1:
 		asm volatile("xchgb %b0,%1"
-			     : "=3Dq" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=3Dq" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	case 2:
 		asm volatile("xchgw %w0,%1"
-			     : "=3Dr" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=3Dr" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	case 4:
 		asm volatile("xchgl %k0,%1"
-			     : "=3Dr" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=3Dr" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	case 8:
 		asm volatile("xchgq %0,%1"
-			     : "=3Dr" (x)
-			     : "m" (*__xg(ptr)), "0" (x)
+			     : "=3Dr" (x), "+m" (*__xg(ptr))
+			     : "0" (x)
 			     : "memory");
 		break;
 	}
@@ -66,27 +66,27 @@ static inline unsigned long __cmpxchg(volatile void *pt=
r, unsigned long old,
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"
-			     : "=3Da"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgb %b2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgw %w2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile(LOCK_PREFIX "cmpxchgl %k1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgl %k2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 8:
-		asm volatile(LOCK_PREFIX "cmpxchgq %1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile(LOCK_PREFIX "cmpxchgq %2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
@@ -105,21 +105,27 @@ static inline unsigned long __sync_cmpxchg(volatile v=
oid *ptr,
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile("lock; cmpxchgb %b1,%2"
-			     : "=3Da"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgb %b2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile("lock; cmpxchgw %w1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgw %w2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile("lock; cmpxchgl %1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("lock; cmpxchgl %k2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
+			     : "memory");
+		return prev;
+	case 8:
+		asm volatile("lock; cmpxchgq %2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
@@ -133,27 +139,27 @@ static inline unsigned long __cmpxchg_local(volatile =
void *ptr,
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile("cmpxchgb %b1,%2"
-			     : "=3Da"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgb %b2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "q"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 2:
-		asm volatile("cmpxchgw %w1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgw %w2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 4:
-		asm volatile("cmpxchgl %k1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgl %k2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	case 8:
-		asm volatile("cmpxchgq %1,%2"
-			     : "=3Da"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+		asm volatile("cmpxchgq %2,%1"
+			     : "=3Da"(prev), "+m"(*__xg(ptr))
+			     : "r"(new), "0"(old)
 			     : "memory");
 		return prev;
 	}
--=20
1.5.6.5


--QKdGvSO+nmPlgiQ/--

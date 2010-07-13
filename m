Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0GMSXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:23:36 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:33853 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0GMSXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:23:35 -0400
Date: Tue, 13 Jul 2010 20:23:34 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization
	point for pvclock
Message-ID: <20100713182333.GF15122@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	stable-review@kernel.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
	Zachary Amsden <zamsden@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <4C3C68C8.4060409@redhat.com> <20100713141902.GB15122@anguilla.noreply.org> <4C3C8CE5.1080705@redhat.com> <20100713162207.GC15122@anguilla.noreply.org> <4C3C9589.4090602@redhat.com> <4C3C96EC.8060901@redhat.com> <4C3C9839.4090404@redhat.com> <20100713172526.GE15122@anguilla.noreply.org> <AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com> <AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

On Tue, 13 Jul 2010, Linus Torvalds wrote:

> On Tue, Jul 13, 2010 at 10:50 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > No, you didn't back-port it wrong. I just didn't fix the right part. I
> > thought the PV code used xchg, not cmpxchg, so I only patched that.
> > But cmpxchg has the exact same issue.
> >
> > Does this fix it?

It appears to, thanks a lot.

[git|v2.6.32.16] weasel@thelma:/scratch/kernel/2.6.32.16$ nm arch/x86/kernel/pvclock.o
0000000000000000 b last_value
..

And it did boot too.

> Btw, this second patch was a bit more aggressive than the first one,
> and actually removes the "memory" clobber entirely, and the fake cast
> of the target type.

Without the cast gcc spews a fair amount of warnings.  About four every
time it hits the include file.


Just for completeness' sake I attached the patch on top of 2.6.32.16
that I built with.
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: attachment; filename="linus.diff.backported"

diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 52de72e..f0551c5 100644
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
@@ -66,28 +66,24 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 	unsigned long prev;
 	switch (size) {
 	case 1:
-		asm volatile(LOCK_PREFIX "cmpxchgb %b1,%2"
-			     : "=a"(prev)
-			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgb %b2,%1"
+			     : "=a"(prev), "+m" (*__xg(ptr))
+			     : "q"(new), "0"(old));
 		return prev;
 	case 2:
-		asm volatile(LOCK_PREFIX "cmpxchgw %w1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgw %w2,%1"
+			     : "=a"(prev), "+m" (*__xg(ptr))
+			     : "r"(new), "0"(old));
 		return prev;
 	case 4:
-		asm volatile(LOCK_PREFIX "cmpxchgl %k1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgl %k2,%1"
+			     : "=a"(prev), "+m" (*__xg(ptr))
+			     : "r"(new), "0"(old));
 		return prev;
 	case 8:
-		asm volatile(LOCK_PREFIX "cmpxchgq %1,%2"
-			     : "=a"(prev)
-			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-			     : "memory");
+		asm volatile(LOCK_PREFIX "cmpxchgq %2,%1"
+			     : "=a"(prev), "+m" (*__xg(ptr))
+			     : "r"(new), "0"(old));
 		return prev;
 	}
 	return old;

--Dxnq1zWXvFF0Q93v--

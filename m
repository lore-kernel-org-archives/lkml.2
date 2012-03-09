Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030554Ab2CITrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:47:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030526Ab2CITqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:46:52 -0500
Message-Id: <20120309190204.447488691@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Cree <mcree@orcon.net.nz>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Richard Henderson <rth@twiddle.net>,
        Michel Lespinasse <walken@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [ 26/95] alpha: fix 32/64-bit bug in futex support
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 62aca403657fe30e5235c5331e9871e676d9ea0a upstream.

Michael Cree said:

: : I have noticed some user space problems (pulseaudio crashes in pthread
: : code, glibc/nptl test suite failures, java compiler freezes on SMP alpha
: : systems) that arise when using a 2.6.39 or later kernel on Alpha.
: : Bisecting between 2.6.38 and 2.6.39 (using glibc/nptl test suite as
: : criterion for good/bad kernel) eventually leads to:
: :
: : 8d7718aa082aaf30a0b4989e1f04858952f941bc is the first bad commit
: : commit 8d7718aa082aaf30a0b4989e1f04858952f941bc
: : Author: Michel Lespinasse <walken@google.com>
: : Date:   Thu Mar 10 18:50:58 2011 -0800
: :
: :     futex: Sanitize futex ops argument types
: :
: :     Change futex_atomic_op_inuser and futex_atomic_cmpxchg_inatomic
: :     prototypes to use u32 types for the futex as this is the data type the
: :     futex core code uses all over the place.
: :
: : Looking at the commit I see there is a change of the uaddr argument in
: : the Alpha architecture specific code for futexes from int to u32, but I
: : don't see why this should cause a problem.

Richard Henderson said:

: futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
:                               u32 oldval, u32 newval)
: ...
:         :       "r"(uaddr), "r"((long)oldval), "r"(newval)
:
:
: There is no 32-bit compare instruction.  These are implemented by
: consistently extending the values to a 64-bit type.  Since the
: load instruction sign-extends, we want to sign-extend the other
: quantity as well (despite the fact it's logically unsigned).
:
: So:
:
: -        :       "r"(uaddr), "r"((long)oldval), "r"(newval)
: +        :       "r"(uaddr), "r"((long)(int)oldval), "r"(newval)
:
: should do the trick.

Michael said:

: This fixes the glibc test suite failures and the pulseaudio related
: crashes, but it does not fix the java compiiler lockups that I was (and
: are still) observing.  That is some other problem.

Reported-by: Michael Cree <mcree@orcon.net.nz>
Tested-by: Michael Cree <mcree@orcon.net.nz>
Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/alpha/include/asm/futex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/alpha/include/asm/futex.h
+++ b/arch/alpha/include/asm/futex.h
@@ -108,7 +108,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 	"	lda	$31,3b-2b(%0)\n"
 	"	.previous\n"
 	:	"+r"(ret), "=&r"(prev), "=&r"(cmp)
-	:	"r"(uaddr), "r"((long)oldval), "r"(newval)
+	:	"r"(uaddr), "r"((long)(int)oldval), "r"(newval)
 	:	"memory");
 
 	*uval = prev;



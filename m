Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab2CBWgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:36:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab2CBWgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:36:17 -0500
Date: Fri, 2 Mar 2012 14:36:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>, Michel Lespinasse <walken@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: alpha: futex regression bisected
Message-Id: <20120302143615.2a272976.akpm@linux-foundation.org>
In-Reply-To: <4F4B273C.9080506@orcon.net.nz>
References: <4F420256.2090600@orcon.net.nz>
	<4F4282CA.5010502@twiddle.net>
	<4F4B273C.9080506@orcon.net.nz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012 19:48:28 +1300
Michael Cree <mcree@orcon.net.nz> wrote:

> > There is no 32-bit compare instruction.  These are implemented by
> > consistently extending the values to a 64-bit type.  Since the
> > load instruction sign-extends, we want to sign-extend the other
> > quantity as well (despite the fact it's logically unsigned).
> > 
> > So:
> > 
> > -        :       "r"(uaddr), "r"((long)oldval), "r"(newval)
> > +        :       "r"(uaddr), "r"((long)(int)oldval), "r"(newval)
> > 
> > should do the trick.
> 
> Thanks, that fixes it.  Will you formally submit a patch with commit
> message or should I?
> 
> You can have at least a Reviewed-by, or even an
> Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> who correctly analysed the problem in response to when I suggested the
> fix on the debian-alpha email list without explanation.

Seems that I am an alpha hacker!  This?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: alpha: fix 32/64-bit bug in futex support

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

Reported-by: Michael Cree <mcree@orcon.net.nz>
Tested-by: Michael Cree <mcree@orcon.net.nz>
Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/futex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/include/asm/futex.h~alpha-fix-32-64-bit-bug-in-futex-support arch/alpha/include/asm/futex.h
--- a/arch/alpha/include/asm/futex.h~alpha-fix-32-64-bit-bug-in-futex-support
+++ a/arch/alpha/include/asm/futex.h
@@ -108,7 +108,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 	"	lda	$31,3b-2b(%0)\n"
 	"	.previous\n"
 	:	"+r"(ret), "=&r"(prev), "=&r"(cmp)
-	:	"r"(uaddr), "r"((long)oldval), "r"(newval)
+	:	"r"(uaddr), "r"((long)(int)oldval), "r"(newval)
 	:	"memory");
 
 	*uval = prev;
_


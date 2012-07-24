Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2GXUKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:10:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab2GXUKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:10:52 -0400
Date: Tue, 24 Jul 2012 16:10:45 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Law <law@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc
 definition
Message-ID: <20120724201045.GH10534@zod.bos.redhat.com>
References: <20120724182409.GB10534@zod.bos.redhat.com>
 <20120724183230.GC10534@zod.bos.redhat.com>
 <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com>
 <20120724190302.GE10534@zod.bos.redhat.com>
 <CA+55aFyn-yMUMdcY8jp65eeoGm3RPzy9p+St35-HGE_xXiVJag@mail.gmail.com>
 <500EF43C.3060200@redhat.com>
 <CA+55aFwvidWyBK5+U_4r5uibSkk4A-1jbnY-i9BtRgbx=Odo7w@mail.gmail.com>
 <500EF6EF.4080708@redhat.com>
 <20120724194301.GG10534@zod.bos.redhat.com>
 <CA+55aFygfHj3-PLPj2RZ6pg==7sf3=zKDATW3rVaE9jSOxCd_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFygfHj3-PLPj2RZ6pg==7sf3=zKDATW3rVaE9jSOxCd_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:55:38PM -0700, Linus Torvalds wrote:
> On Tue, Jul 24, 2012 at 12:43 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> >+  ({ long int __d = (d);                                                   \
> >      (__builtin_constant_p (__d)                                           \
> >-      ? (__d >= __FD_SETSIZE                                               \
> >-        ? __fdelt_warn (__d) : (__d / __NFDBITS))                          \
> >+      ? (0 <= __d && __d < __FD_SETSIZE                                            \
> >+        ? (__d / __NFDBITS)                                                \
> >+        : __fdelt_warn (__d))                                              \
> >       : __fdelt_chk (__d)); })
> 
> Ugh. This depends intimately on gcc doing the whole value range
> propagation thing, and probably generates horrible code when not
> optimizing, but whatever. It's irrelevant.
> 
> I vote we get rid of the crap. We'll force-redefine __FD_SETSIZE,
> because that's the one we really care about. And then just use our
> internal names for anything else.

Your vote counts more than mine ;).  I just want the problem solved in a
reasonable fasion since it's causing build failures now and the bug was
stalled.
 
> IOW, just something like this (whitespace-damaged on purpose, because
> it won't even compile as-is: we'll also need to replace the few uses
> of __NFDBITS in the kernel with BITS_PER_LONG).
> 
>    diff --git a/include/linux/posix_types.h b/include/linux/posix_types.h
>   index f04c98cf44f3..8a79a5021dc1 100644
>   --- a/include/linux/posix_types.h
>   +++ b/include/linux/posix_types.h
>   @@ -15,26 +15,14 @@
>     */
> 
>    /*
>   - * Those macros may have been defined in <gnu/types.h>. But we always
>   - * use the ones here.
>   + * This macro may have been defined in <gnu/types.h>. But we always
>   + * use the one here.
>     */
>   -#undef __NFDBITS
>   -#define __NFDBITS	(8 * sizeof(unsigned long))
>   -
>    #undef __FD_SETSIZE
>    #define __FD_SETSIZE	1024
> 
>   -#undef __FDSET_LONGS
>   -#define __FDSET_LONGS	(__FD_SETSIZE/__NFDBITS)
>   -
>   -#undef __FDELT
>   -#define	__FDELT(d)	((d) / __NFDBITS)
>   -
>   -#undef __FDMASK
>   -#define	__FDMASK(d)	(1UL << ((d) % __NFDBITS))
>   -
>    typedef struct {
>   -	unsigned long fds_bits [__FDSET_LONGS];
>   +	unsigned long fds_bits [__FD_SETSIZE / (8*sizeof(long))];
>    } __kernel_fd_set;
> 
>    /* Type of a signal handler.  */
> 
> Hmm?

Seems fine to me.  In addition to the s/__NFDBITS/BITS_PER_LONG change,
I'm guessing you'll want the odd FD_ISSET/CLR/ZERO/etc macros in
linux/time.h killed as well?

If you don't get to it before me, I'll try whipping something up either
later this evening or first thing in the morning.

josh

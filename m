Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2KMLYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:24:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41489 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2KMLYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:24:50 -0500
Date: Tue, 13 Nov 2012 11:24:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Clark <rob.clark@linaro.org>, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Message-ID: <20121113112430.GF28341@n2100.arm.linux.org.uk>
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org> <20121112235348.GD28341@n2100.arm.linux.org.uk> <CAF6AEGvoXR3YJomjV1YOeNvjr46aYJ2mVxS+jZfH+41+v1nAvw@mail.gmail.com> <201211130911.09613.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211130911.09613.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 09:11:09AM +0000, Arnd Bergmann wrote:
> On Tuesday 13 November 2012, Rob Clark wrote:
> > right, that is what I was worried about..  but what about something
> > along the lines of:
> > 
> >                 case 8: {                                               \
> >                         if (sizeof(x) < 8)                              \
> >                                 __get_user_x(__r2, __p, __e, __l, 4);   \
> >                         else                                            \
> >                                 __get_user_x(__r2, __p, __e, __l, 8);   \
> >                         break;                                          \
> >                 }                                                       \
> 
> I guess that's still broken if x is 8 or 16 bits wide.

Actually, it isn't - because if x is 8 or 16 bits wide, and we load
a 32-bit quantity, all that follows is a narrowing cast which is exactly
what happens today.  We don't have a problem with register allocation
like we have in the 32-bit x vs 64-bit pointer target type, which is what
the above code works around.

> > maybe we need a special variant of __get_user_8() instead to get the
> > right 32bits on big vs little endian systems, but I think something
> > roughly along these lines could work.
> > 
> > Or maybe in sizeof(x)<8 case, we just __get_user_bad()..  I'm not 100%
> > sure on whether this is supposed to be treated as an error case at
> > compile time or not.
> 
> We know that nobody is using that at the moment, so we could define
> it to be a compile-time error.
> 
> But I still think this is a pointless exercise, a number of people have
> concluded independently that it's not worth trying to come up with a
> solution, whether one exists or not. Why can't you just use copy_from_user()
> anyway?

You're missing something; that is one of the greatest powers of open
source.  The many eyes (and minds) effect.  Someone out there probably
has a solution to whatever problem, the trick is to find that person. :)

I think we have a working solution for this for ARM.  It won't be suitable
for every arch, where they have 8-bit and 16-bit registers able to be
allocated by the compiler, but for architectures where the minimum register
size is 32-bit, what we have below should work.

In other words, I don't think this will work for x86-32 where ax, al, ah
as well as eax are still available.

What I have currently in my test file, which appears to work correctly,
is (bear in mind this is based upon an older version of get_user() which
pre-dates Will's cleanups):

#define __get_user_x(__r2,__p,__e,__s,__i...)                           \
           __asm__ __volatile__ (                                       \
                "bl     __get_user_" #__s                               \
                : "=&r" (__e), "=r" (__r2)                              \
                : "0" (__p)                                             \
                : __i, "cc")

#ifdef BIG_ENDIAN
#define __get_user_xb(__r2,__p,__e,__s,__i...)                          \
	__get_user_x(__r2,(uintptr_t)__p + 4,__s,__i)
#else
#define __get_user_xb __get_user_x
#endif

#define get_user(x,p)                                                   \
        ({                                                              \
                register const typeof(*(p)) __user *__p asm("r0") = (p);\
                register int __e asm("r0");                             \
                register typeof(x) __r2 asm("r2");                      \
                switch (sizeof(*(__p))) {                               \
                case 1:                                                 \
                        __get_user_x(__r2, __p, __e, 1, "lr");          \
                        break;                                          \
                case 2:                                                 \
                        __get_user_x(__r2, __p, __e, 2, "r3", "lr");    \
                        break;                                          \
                case 4:                                                 \
                        __get_user_x(__r2, __p, __e, 4, "lr");          \
                        break;                                          \
                case 8:                                                 \
                        if (sizeof((x)) < 8)                            \
                                __get_user_xb(__r2, __p, __e, 4, "lr"); \
                        else                                            \
                                __get_user_x(__r2, __p, __e, 8, "lr");  \
                        break;                                          \
                default: __e = __get_user_bad(); break;                 \
                }                                                       \
                x = (typeof(*(__p))) __r2;                              \
                __e;                                                    \
        })

Tested with 8, 16, 32, 64 ints, 32bit int with const p, pointers, const
pointers, pointer to 64bit with 32bit target, pointer-to-const-pointer
to non-const pointer (which should and does warn).

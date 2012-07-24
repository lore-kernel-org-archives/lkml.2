Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2GXTnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab2GXTnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:43:08 -0400
Date: Tue, 24 Jul 2012 15:43:01 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jeff Law <law@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc
 definition
Message-ID: <20120724194301.GG10534@zod.bos.redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com>
 <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com>
 <20120724183230.GC10534@zod.bos.redhat.com>
 <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com>
 <20120724190302.GE10534@zod.bos.redhat.com>
 <CA+55aFyn-yMUMdcY8jp65eeoGm3RPzy9p+St35-HGE_xXiVJag@mail.gmail.com>
 <500EF43C.3060200@redhat.com>
 <CA+55aFwvidWyBK5+U_4r5uibSkk4A-1jbnY-i9BtRgbx=Odo7w@mail.gmail.com>
 <500EF6EF.4080708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <500EF6EF.4080708@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 01:26:39PM -0600, Jeff Law wrote:
> On 07/24/12 13:24, Linus Torvalds wrote:
> >On Tue, Jul 24, 2012 at 12:15 PM, Jeff Law <law@redhat.com> wrote:
> >>
> >>Please refer to the original discussion where they did evaluate the cost of
> >>this change and tested that the final change made no difference to the
> >>generated code.
> >
> >Umm. That bugzilla entry seems to be talking about a *sane* change, namely
> >
> >-  ({ unsigned long int __d = (d);					    \
> >+  ({ unsigned long int __d = (unsigned long int) (d);			    \
> >
> >in __FD_ELT(), which is totally different from the one Josh talks about.

So glibc has multiple definitions of __FD_ELT.  I originally quoted the
one from misc/sys/select.h, but the one from the first patch in the
glibc bugzilla entry is patching misc/bits/select2.h.  I'm going to
guess that through some kind of implies or header chain, the second is used.

However, the actually commit for that glibc bug is ceb9e56b3d1f8 and
that actually doesn't keep (unsigned long) here.  It does this:

diff --git a/debug/fdelt_chk.c b/debug/fdelt_chk.c
index 5e06f8f..ded3f2f 100644
--- a/debug/fdelt_chk.c
+++ b/debug/fdelt_chk.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2011 Free Software Foundation, Inc.
+/* Copyright (C) 2011, 2012 Free Software Foundation, Inc.
    This file is part of the GNU C Library.
 
    The GNU C Library is free software; you can redistribute it and/or
@@ -18,10 +18,10 @@
 #include <sys/select.h>
 
 
-unsigned long int
-__fdelt_chk (unsigned long int d)
+long int
+__fdelt_chk (long int d)
 {
-  if (d >= FD_SETSIZE)
+  if (d < 0 || d >= FD_SETSIZE)
     __chk_fail ();
 
   return d / __NFDBITS;
diff --git a/misc/bits/select2.h b/misc/bits/select2.h
index 9679925..76ae368 100644
--- a/misc/bits/select2.h
+++ b/misc/bits/select2.h
@@ -1,5 +1,5 @@
 /* Checking macros for select functions.
-   Copyright (C) 2011 Free Software Foundation, Inc.
+   Copyright (C) 2011, 2012 Free Software Foundation, Inc.
    This file is part of the GNU C Library.
 
    The GNU C Library is free software; you can redistribute it and/or
@@ -21,14 +21,15 @@
 #endif
 
 /* Helper functions to issue warnings and errors when needed.  */
-extern unsigned long int __fdelt_chk (unsigned long int __d);
-extern unsigned long int __fdelt_warn (unsigned long int __d)
+extern long int __fdelt_chk (long int __d);
+extern long int __fdelt_warn (long int __d)
   __warnattr ("bit outside of fd_set selected");
 #undef __FD_ELT
 #define	__FD_ELT(d) \
   __extension__								    \
-  ({ unsigned long int __d = (d);					    \
+  ({ long int __d = (d);						    \
      (__builtin_constant_p (__d)					    \
-      ? (__d >= __FD_SETSIZE						    \
-	 ? __fdelt_warn (__d) : (__d / __NFDBITS))			    \
+      ? (0 <= __d && __d < __FD_SETSIZE					    \
+	 ? (__d / __NFDBITS)						    \
+	 : __fdelt_warn (__d))						    \
       : __fdelt_chk (__d)); })


> Right.  Josh's change is necessary to prevent warnings from folks
> (incorrectly) using posix_types.h instead of select.h after the
> change in that BZ was made.  That's why I originally stated that,
> arguably, posix_types.h really should go away or just use the
> definitions provided by glibc.

The warnings being specifically:

[root@localhost ~]# cat foo.c 
#include <sys/select.h>
#include <linux/types.h>

int foo(void)
{
  fd_set fds;
  FD_ZERO(&fds);
  FD_SET(0, &fds);
  return FD_ISSET(0, &fds);
}

[root@localhost ~]# gcc -Wextra -Werror -O2 -D_FORTIFY_SOURCE=2 -c foo.c -save-temps
foo.c: In function ‘foo’:
foo.c:8:162: error: signed and unsigned type in conditional expression [-Werror=sign-compare]
foo.c:8:184: error: signed and unsigned type in conditional expression [-Werror=sign-compare]
foo.c:9:162: error: signed and unsigned type in conditional expression [-Werror=sign-compare]
foo.c:9:184: error: signed and unsigned type in conditional expression [-Werror=sign-compare]
cc1: all warnings being treated as errors

As I said in the commit log, -Wsign-compare and -D_FORTIFY_SOURCE=2 are
required.  Now you have as much info as I do on this particular awesome
issue.

josh

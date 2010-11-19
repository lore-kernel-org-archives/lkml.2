Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab0KSWIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:08:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758408Ab0KSWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:08:35 -0500
Date: Fri, 19 Nov 2010 14:07:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: michalj@gmail.com, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        linux-kernel@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: Re: abs() vs. abs64() (was: Re: [PATCH] fbdev: fix nearest mode
 search)
Message-Id: <20101119140721.33576c61.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimYDAJr9x00sjGGnDF2vOVXU12qmbnmfuzA5_0h@mail.gmail.com>
References: <AANLkTimYDAJr9x00sjGGnDF2vOVXU12qmbnmfuzA5_0h@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 07:40:19 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> [Don't use the obsolete linux-fbdev-devel address]
> 
> On Thu, Nov 18, 2010 at 00:08, Michal Januszewski <michalj@gmail.com> wrote:
> > In the framebuffer subsystem the abs() macro is often used as a part of
> > the calculation of a Manhattan metric, which in turn is used as a measure
> > of similarity between video modes. __The arguments of abs() are sometimes
> > unsigned numbers. __This worked fine until commit a49c59c0, which changed
> > the definition of abs() to prevent truncation. __As a result of this
> > change, in the following piece of code:
> >
> > __u32 a = 0, b = 1;
> > __u32 c = abs(a - b);
> 
> Indeed, the difference of 2 numbers is unsigned, as per C.
> 
> > 'c' will end up with a value of 0xffffffff instead of the expected 0x1.
> 
> This happens on 64-bit only, right?
> 
> Anyway, I think commit a49c59c0 is wrong: abs() operates on signed
> (32-bit) numbers. For larger (64-bit signed) numbers, we have abs64().
> 
> > A problem caused by this change and visible by the end user is that
> > framebuffer drivers relying on functions from modedb.c will fail to
> > find high resolution video modes similar to that explicitly requested
> > by the user if an exact match cannot be found (see e.g.
> > https://bugs.gentoo.org/show_bug.cgi?id=296539).

How does this look?


From: Andrew Morton <akpm@linux-foundation.org>

Michal reports:

In the framebuffer subsystem the abs() macro is often used as a part of
the calculation of a Manhattan metric, which in turn is used as a measure
of similarity between video modes.  The arguments of abs() are sometimes
unsigned numbers.  This worked fine until commit a49c59c0 ("Make sure the
value in abs() does not get truncated if it is greater than 2^32:) , which
changed the definition of abs() to prevent truncation.  As a result of
this change, in the following piece of code:

u32 a = 0, b = 1;
u32 c = abs(a - b);

'c' will end up with a value of 0xffffffff instead of the expected 0x1.

A problem caused by this change and visible by the end user is that
framebuffer drivers relying on functions from modedb.c will fail to find
high resolution video modes similar to that explicitly requested by the
user if an exact match cannot be found (see e.g.

Fix this by special-casing `long' types within abs().  

This patch reduces x86_64 code size a bit - drivers/video/uvesafb.o shrunk
by 15 bytes, presumably because it is doing abs() on 4-byte quantities,
and expanding those to 8-byte longs adds code.

testcase:

#define oldabs(x) ({				\
		long __x = (x);			\
		(__x < 0) ? -__x : __x;		\
	})

#define newabs(x) ({						\
		long ret;					\
		if (sizeof(x) == sizeof(long)) {		\
			long __x = (x);				\
			ret = (__x < 0) ? -__x : __x;		\
		} else {					\
			int __x = (x);				\
			ret = (__x < 0) ? -__x : __x;		\
		}						\
		ret;						\
	})

typedef unsigned int u32;

main()
{
	u32 a = 0;
	u32 b = 1;
	u32 oldc = oldabs(a - b);
	u32 newc = newabs(a - b);

	printf("%u %u\n", oldc, newc);
}

akpm:/home/akpm> gcc t.c
akpm:/home/akpm> ./a.out
4294967295 1

Reported-by: Michal Januszewski <michalj@gmail.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit
+++ a/include/linux/kernel.h
@@ -143,9 +143,16 @@ extern int _cond_resched(void);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
-#define abs(x) ({				\
-		long __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
+#define abs(x) ({						\
+		long ret;					\
+		if (sizeof(x) == sizeof(long)) {		\
+			long __x = (x);				\
+			ret = (__x < 0) ? -__x : __x;		\
+		} else {					\
+			int __x = (x);				\
+			ret = (__x < 0) ? -__x : __x;		\
+		}						\
+		ret;						\
 	})
 
 #define abs64(x) ({				\
_


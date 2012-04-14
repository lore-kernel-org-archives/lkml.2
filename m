Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab2DNGnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 02:43:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab2DNGnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 02:43:14 -0400
From: Lubos Lunak <l.lunak@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
Date: Sat, 14 Apr 2012 08:43:08 +0200
User-Agent: KMail/1.9.10
Cc: Peter Seebach <peter.seebach@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <201204132124.21294.l.lunak@suse.cz> <201204140118.51534.l.lunak@suse.cz> <CA+55aFzWiaXYSwO7eGt_V6oUZGWkp_v1hv9xc6KAiFnrzumxXA@mail.gmail.com>
In-Reply-To: <CA+55aFzWiaXYSwO7eGt_V6oUZGWkp_v1hv9xc6KAiFnrzumxXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201204140843.08671.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 of April 2012, Linus Torvalds wrote:
> On Fri, Apr 13, 2012 at 4:18 PM, Lubos Lunak <l.lunak@suse.cz> wrote:
> >> imagine replacing the kernel ((void *)0) with __null.
> >
> >  __null apparently exists only with g++, C does not have the stronger
> > type safety that prevents ((void*)0) from being usable in C++
>
> Please don't continue to spread this total bogosity.
>
> The reason C++ cannot use "(void *)0" has nothing to do with "stronger
> type safety". That's a total idiotic lie by C++ apologists, and I hate
> hearing it repeated over and over again.
>
> And it really *is* a lie. The C++ type system isn't even "stronger",

$ cat b.c
void foo()
    {
    int* a;
    void* b;
    char c;
    a = b = &c;
    }
$ gcc -Wall b.c -c
$ g++ -Wall b.c -c
b.c: In function ‘void foo()’:
b.c:6:14: error: invalid conversion from ‘void*’ to ‘int*’

> it's just different, and it's actively *broken* wrt NULL. Always has
> been.
>
> The sane thing to do for C++ would always have been to recognize that
> "(void *)0" is not a "void pointer" - it's just NULL.

 As much as I agree that it was stupid to copy the special-casing of 0 from C 
and they should have instead special-cased (void*)0, the reality is that it 
took them until C++11 to add that to the standard, and even there they did it 
differently, so C++ now has to live with the legacy of NULL being possibly 
implemented in a stupid way.

 The reality is also that g++ people recognized this quite some time back, 
implemented NULL in a sane way, and kernel headers still replace that 
implementation with one that, as you yourself say, is technically wrong. So 
how about my patch that fixes that? The rest is a discussion about things 
that should have been but are not and is completely pointless by now.

8<-----
headers: do not redefine userspace's NULL #define when compiling C++ code

GCC's NULL is actually __null when compiling C++, which allows detecting some
questionable NULL usage and warn about it.

Signed-off-by: Luboš Luňák <l.lunak@suse.cz>
---
 include/linux/stddef.h |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 6a40c76..a75f4b9 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -3,12 +3,18 @@
 
 #include <linux/compiler.h>
 
-#undef NULL
 #if defined(__cplusplus)
-#define NULL 0
+#ifndef NULL
+#ifdef __GNUG__
+#define NULL __null
 #else
-#define NULL ((void *)0)
+#define NULL 0
 #endif
+#endif
+#else /* __cplusplus */
+#undef NULL
+#define NULL ((void *)0)
+#endif /* __cplusplus */
 
 #ifdef __KERNEL__
 
-- 
1.7.7


-- 
 Lubos Lunak
 l.lunak@suse.cz

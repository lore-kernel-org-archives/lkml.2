Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab2DMXSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 19:18:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131Ab2DMXSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 19:18:54 -0400
From: Lubos Lunak <l.lunak@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
Date: Sat, 14 Apr 2012 01:18:51 +0200
User-Agent: KMail/1.9.10
Cc: Peter Seebach <peter.seebach@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <201204132124.21294.l.lunak@suse.cz> <20120413170151.20c7230e@wrlaptop> <CA+55aFz0c43QARhefvhdiB=H6buO7VpEOnNbuJTYEcUn8M+mKw@mail.gmail.com>
In-Reply-To: <CA+55aFz0c43QARhefvhdiB=H6buO7VpEOnNbuJTYEcUn8M+mKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201204140118.51534.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 of April 2012, Linus Torvalds wrote:
> On Fri, Apr 13, 2012 at 3:01 PM, Peter Seebach
> > Maybe the thing to do would be to ensure that NULL goes to __null,
> > then define that to be ((void *) 0) if the compiler doesn't provide
> > it?  The magic behavior of __null seems like it'd be preferable
> > where it is available.
>
> So if gcc guarantees that __null has the correct semantics, I could
> imagine replacing the kernel ((void *)0) with __null.

 __null apparently exists only with g++, C does not have the stronger type 
safety that prevents ((void*)0) from being usable in C++, so __null is not 
needed there. So this is really only about userspace C++ code.

 So how about this one? It does not change anything in the C mode and keeps it 
the way you want, and it fixes the C++ mode.

8<-----
headers: do not redefine userspace's NULL #define when compiling C++ code

GCC's NULL is actually __null when compiling C++, which allows detecting some
questionable NULL usage and warn about it, so do not redefine NULL to 0.
Use the 0 definition only if NULL does not exists, to keep kernel headers
self-contained (and GCC's stddef.h will possibly redefine it later to __null).
In C mode ((void*)0) works fine.

Signed-off-by: Luboš Luňák <l.lunak@suse.cz>
---
 include/linux/stddef.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 6a40c76..13dfc92 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -3,10 +3,12 @@
 
 #include <linux/compiler.h>
 
-#undef NULL
 #if defined(__cplusplus)
+#ifndef NULL
 #define NULL 0
+#endif
 #else
+#undef NULL
 #define NULL ((void *)0)
 #endif
 
-- 
1.7.7


-- 
 Lubos Lunak
 l.lunak@suse.cz

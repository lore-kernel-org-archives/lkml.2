Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab2DMVrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 17:47:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab2DMVq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 17:46:59 -0400
From: Lubos Lunak <l.lunak@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
Date: Fri, 13 Apr 2012 23:46:56 +0200
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
References: <201204132124.21294.l.lunak@suse.cz> <CA+55aFxCrVtwCd9bjHLt82Uwisp8OtKP9c+raPYMqCTXqVfxGw@mail.gmail.com>
In-Reply-To: <CA+55aFxCrVtwCd9bjHLt82Uwisp8OtKP9c+raPYMqCTXqVfxGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201204132346.57019.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 of April 2012, Linus Torvalds wrote:
> On Fri, Apr 13, 2012 at 12:24 PM, Lubos Lunak <l.lunak@suse.cz> wrote:
> > GCC's NULL is actually __null, which allows detecting some questionable
> > NULL usage and warn about it. Moreover each platform/compiler should have
> > its own stddef.h anyway (which is different from linux/stddef.h).
> > So there's no good reason to override what the compiler provides.
> > Keep the #define conditionally, in order to keep the headers
> > self-contained.
>
> There's no way user should ever include the linux internal stddef.h.

 If that were the case, one of the earlier versions of the patch would have 
been correct then, but as Arnd has pointed out, user applications do include 
the header. It's even as simple as:

#include <signal.h>

( -> bits/sigcontext.h -> asm/sigcontext.h -> linux/types.h -> 
linux/posix_types.h -> linux/stddef.h ).

> And quite frankly, kernel-external definitions of NULL have
> traditionally been pure sh*t (ie plain "0" without the cast to a
> pointer), so I'm not entirely convinced about this patch.

 Quite frankly, I do not care what happens with it in kernel builds. I just 
don't want the suboptimal definition to leak to userspace. If you instead 
make sure linux/stddef.h is never used by userspace, that's fine with me.

> So what is the *actual* thing this helps with?

 Random example:

/home/tinderbox/clang-master-build/vcl/unx/gtk/fpicker/SalGtkFilePicker.cxx:216:66: 
warning: missing sentinel in function call [-Wsentinel]
            GTK_CELL_LAYOUT (m_pLists[i]), pCell, "text", 0, NULL);
                                                                 ^
                                                                 , NULL

 I used the Clang compiler for the more detailed error output (and the in this 
context somewhat amusing fix-it hint), but it's of course the same with GCC.

 And from 'man gcc' (4.6):

       -Wstrict-null-sentinel (C++ and Objective-C++ only)
           Warn also about the use of an uncasted "NULL" as sentinel.  When 
compiling only with GCC this is a valid sentinel, as "NULL" is defined 
to "__null".  Although it is a null pointer constant not a null pointer, it 
is guaranteed to be of the same size as a pointer.  But this use is not 
portable across different compilers.

-- 
 Lubos Lunak
 l.lunak@suse.cz

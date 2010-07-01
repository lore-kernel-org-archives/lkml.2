Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab0GAVvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:51:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:54256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758975Ab0GAVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:47 -0400
Date: Thu, 1 Jul 2010 18:13:31 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/21] perf: rewire generic library stuff, p1
Message-ID: <20100701211331.GA28165@ghostprotocols.net>
References: <1277992175-19821-1-git-send-email-bp@amd64.org>
 <1277992175-19821-6-git-send-email-bp@amd64.org>
 <20100701154737.GE8902@ghostprotocols.net>
 <20100701161054.GF8902@ghostprotocols.net>
 <20100701161738.GH17823@aftab>
 <20100701171449.GG8902@ghostprotocols.net>
 <20100701201418.GA21223@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701201418.GA21223@aftab>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 01, 2010 at 10:14:18PM +0200, Borislav Petkov escreveu:
> From: Arnaldo Carvalho de Melo <acme@infradead.org>
> Date: Thu, Jul 01, 2010 at 01:14:49PM -0400
> > But we have one other problem:

> > [acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -C tools/
> > make: Entering directory `/home/acme/git/linux-2.6-tip/tools'
> > make[1]: Entering directory `/home/acme/git/linux-2.6-tip/tools/lib'
> > make[1]: `lklib.a' is up to date.
> > make[1]: Leaving directory `/home/acme/git/linux-2.6-tip/tools/lib'
> > make[1]: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
> >     GEN perf-archive
> > make[1]: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
> > make: Leaving directory `/home/acme/git/linux-2.6-tip/tools'
> > [acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -C tools/perf/
> > make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
> >     * new build flags or prefix
> >     CC /home/acme/git/build/perf/perf.o
> >     CC /home/acme/git/build/perf/builtin-annotate.o
> > 
> > The logic that detects "new build flags or prefix" gets confused when we
> > alternate between tools/ and tools/perf/, checking that.
> 
> This might need an up-to-date check for the lklib.a archive first and
> not do "new build flags or prefix" if it is. Yeah, this is a different
> library and the logic doesn't know about it.

I got sidetracked, but this is what is in $(O)/PERF-CFLAGS for
make -C tools/

[acme@emilia linux-2.6-tip]$ cat ../build/perf/PERF-CFLAGS 
-ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement  -fstack-protector-all -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/home/acme/git/linux-2.6-tip/tools/lib -I/home/acme/git/linux-2.6-tip/tools/perf -I/home/acme/git/linux-2.6-tip/tools/perf/util/include -Iutil/include -Iarch/x86/include -I../lib/ -I/home/acme/git/build/perf/ -DLIBELF_NO_MMAP -I/usr/include/elfutils -DDWARF_SUPPORT -I/usr/include/slang -DSHA1_HEADER='<openssl/sha.h>' : /home/acme/bin:libexec/perf-core:share/perf-core/templates:/home/acme
[acme@emilia linux-2.6-tip]$

And this is its contents if we use "make -C tools/perf/"

-ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2   -fstack-protector-all -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Iutil/include -Iarch/x86/include -I../lib/ -I/home/acme/git/build/perf/ -DLIBELF_NO_MMAP -I/usr/include/elfutils -DDWARF_SUPPORT -I/usr/include/slang -DSHA1_HEADER='<openssl/sha.h>' : /home/acme/bin:libexec/perf-core:share/perf-core/templates:/home/acme

Its just a matter of making both match :-)

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2AHOuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 09:50:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60546 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab2AHOuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 09:50:18 -0500
Subject: Re: [ERROR] perf build failure on current tip:perf/core
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20120108140318.GA15654@elte.hu>
References: <1325950949.1486.20.camel@leonhard>
	 <20120108090018.GB7168@elte.hu> <1326015664.1486.10.camel@leonhard>
	 <20120108113426.GB26516@elte.hu> <87r4zaz88t.fsf@gmail.com>
	 <20120108140318.GA15654@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Jan 2012 23:50:08 +0900
Message-ID: <1326034208.1508.15.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-08 (Sun), 15:03 +0100, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@gmail.com> wrote:
> 
> > >>   $ map pwrite
> > >>   The program 'map' is currently not installed.  You can install it by
> > >> typing:
> > >>   sudo apt-get install sgt-puzzles
> > >> 
> > >> I don't think this is the package what you said. Anyway quick grep'ing
> > >> pwrite tells me it's in the unistd.h:
> > >> 
> > >>   $ grep pwrite /usr/include/unistd.h
> > >>   extern ssize_t pwrite (int __fd, __const void *__buf, size_t __n,
> > >>   extern ssize_t __REDIRECT (pwrite, (int __fd, __const void *__buf,
> > >> 			     pwrite64) __wur;
> > >>   #   define pwrite pwrite64
> > >
> > > There's multiple definitions there, and we get lost somehow - as 
> > > unistd.h is included:
> > >
> > >   ~/tip/tools/perf> grep -n unistd.h util/trace-event-info.c
> > >   34:#include <unistd.h>
> > >
> > > Thanks,
> > >
> > > 	Ingo
> > 
> > This is the content of my /usr/include/unistd.h:
> > 
> > #ifdef __USE_UNIX98
> > # ifndef __USE_FILE_OFFSET64
> > extern ssize_t pread (int __fd, void *__buf, size_t __nbytes,
> > 		      __off_t __offset) __wur;
> > extern ssize_t pwrite (int __fd, __const void *__buf, size_t __n,
> > 		       __off_t __offset) __wur;
> > # else
> > #  ifdef __REDIRECT
> > extern ssize_t __REDIRECT (pread, (int __fd, void *__buf, size_t __nbytes,
> > 				   __off64_t __offset),
> > 			   pread64) __wur;
> > extern ssize_t __REDIRECT (pwrite, (int __fd, __const void *__buf,
> > 				    size_t __nbytes, __off64_t __offset),
> > 			   pwrite64) __wur;
> > #  else
> > #   define pread pread64
> > #   define pwrite pwrite64
> > #  endif
> > # endif
> > 
> > # ifdef __USE_LARGEFILE64
> > extern ssize_t pread64 (int __fd, void *__buf, size_t __nbytes,
> > 			__off64_t __offset) __wur;
> > extern ssize_t pwrite64 (int __fd, __const void *__buf, size_t __n,
> > 			 __off64_t __offset) __wur;
> > # endif
> > #endif
> > 
> > I think all of pread/write functions are properly defined here:
> > 
> >   $ echo '#include <unistd.h>' | \
> >   > gcc -xc -E -dM -D_GNU_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 - | \
> >   > grep -e UNIX98 -e LARGEFILE64 -e FILE_OFFSET
> >   #define __ILP32_OFFBIG_CFLAGS "-m32 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
> >   #define _LARGEFILE64_SOURCE 1
> >   #define __USE_UNIX98 1
> >   #define __USE_LARGEFILE64 1
> >   #define _FILE_OFFSET_BITS 64
> >   #define __USE_FILE_OFFSET64 1
> 
> So which preprocessor branch within unistd.h does it get into on 
> your system and why isnt there a pwrite()/pwrite64() prototype 
> once it goes along that path?
> 
> You could try an ugly approach and edit your unistd.h and put in 
> debug lines like this:
> 
> #warn got here: __LINE__
> 
> and thus see which branch it really gets into.
> 
> (save a backup copy of unistd.h first ;-)
> 
> Thanks,
> 
> 	Ingo

Hi, Ingo

Putting the debug lines told me __USE_UNIX98 is not defined for the
file. It's because ctype.h gets included without _GNU_SOURCE and then it
includes feature.h AFAICS. Encompassing ctype.h with #define/#undef
_GNU_SOURCE or just adding __USE_UNIX98 before unistd.h makes the file
compiled, but it seems like an improper solution. What is the right way?

Thanks.

-- 
Regards,
Namhyung Kim



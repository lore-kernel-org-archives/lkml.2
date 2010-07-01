Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab0GARPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:15:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:39965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0GARPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:15:08 -0400
Date: Thu, 1 Jul 2010 14:14:49 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/21] perf: rewire generic library stuff, p1
Message-ID: <20100701171449.GG8902@ghostprotocols.net>
References: <1277992175-19821-1-git-send-email-bp@amd64.org>
 <1277992175-19821-6-git-send-email-bp@amd64.org>
 <20100701154737.GE8902@ghostprotocols.net>
 <20100701161054.GF8902@ghostprotocols.net>
 <20100701161738.GH17823@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701161738.GH17823@aftab>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 01, 2010 at 06:17:38PM +0200, Borislav Petkov escreveu:
> From: Arnaldo Carvalho de Melo <acme@infradead.org>
> Date: Thu, Jul 01, 2010 at 12:10:54PM -0400
> 
> Hi Arnaldo,
> 
> > Em Thu, Jul 01, 2010 at 12:47:37PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Thu, Jul 01, 2010 at 03:49:19PM +0200, Borislav Petkov escreveu:
> > > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > > 
> > > > Carve out generic library stuff into tools/lib/lk/ and rewire it with
> > > > perf. Add a top-level Makefile which selects between targets depending
> > > > on the tool we want to build. Also, add a Makefile.lib for common
> > > > facilities used by all the Makefiles.
> > > 
> > > Testing this now, thanks,
> > 
> > Needs the patch below for "make O=~/build/perf tools" to continue
> > working. Needs some more polishing so as not to break the non O= case.
> > 
> > After lunch will investigate why my usual way to build the tools isn't working
> > anymore, some missing -I probably:
> > 
> > [acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -C tools/perf install
> > make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
> >     CC /home/acme/git/build/perf/builtin-record.o
> > builtin-record.c:24:23: error: lk/cpumap.h: No such file or directory
> > cc1: warnings being treated as errors

The patch below fixes it.

But we have one other problem:

[acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -C tools/
make: Entering directory `/home/acme/git/linux-2.6-tip/tools'
make[1]: Entering directory `/home/acme/git/linux-2.6-tip/tools/lib'
make[1]: `lklib.a' is up to date.
make[1]: Leaving directory `/home/acme/git/linux-2.6-tip/tools/lib'
make[1]: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
    GEN perf-archive
make[1]: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
make: Leaving directory `/home/acme/git/linux-2.6-tip/tools'
[acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -C tools/perf/
make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
    * new build flags or prefix
    CC /home/acme/git/build/perf/perf.o
    CC /home/acme/git/build/perf/builtin-annotate.o
    CC /home/acme/git/build/perf/builtin-bench.o

The logic that detects "new build flags or prefix" gets confused when we
alternate between tools/ and tools/perf/, checking that.

- Arnaldo

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 200fc13..72ccd17 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -268,7 +268,7 @@ endif
 # Those must not be GNU-specific; they are shared with perl/ which may
 # be built by a different compiler. (Note that this is an artifact now
 # but it still might be nice to keep that distinction.)
-BASIC_CFLAGS += -Iutil/include -Iarch/$(ARCH)/include
+BASIC_CFLAGS += -Iutil/include -Iarch/$(ARCH)/include -I../lib/
 BASIC_LDFLAGS =
 
 # Guard against environment variables

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab0GAUMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:12:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55459 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0GAUMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:12:17 -0400
Date: Thu, 1 Jul 2010 22:14:18 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/21] perf: rewire generic library stuff, p1
Message-ID: <20100701201418.GA21223@aftab>
References: <1277992175-19821-1-git-send-email-bp@amd64.org>
 <1277992175-19821-6-git-send-email-bp@amd64.org>
 <20100701154737.GE8902@ghostprotocols.net>
 <20100701161054.GF8902@ghostprotocols.net>
 <20100701161738.GH17823@aftab>
 <20100701171449.GG8902@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701171449.GG8902@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, Jul 01, 2010 at 01:14:49PM -0400

> > > Needs the patch below for "make O=~/build/perf tools" to continue
> > > working. Needs some more polishing so as not to break the non O= case.
> > > 
> > > After lunch will investigate why my usual way to build the tools isn't working
> > > anymore, some missing -I probably:
> > > 
> > > [acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -C tools/perf install
> > > make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
> > >     CC /home/acme/git/build/perf/builtin-record.o
> > > builtin-record.c:24:23: error: lk/cpumap.h: No such file or directory
> > > cc1: warnings being treated as errors
> 
> The patch below fixes it.
> 
> But we have one other problem:
> 
> [acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -C tools/
> make: Entering directory `/home/acme/git/linux-2.6-tip/tools'
> make[1]: Entering directory `/home/acme/git/linux-2.6-tip/tools/lib'
> make[1]: `lklib.a' is up to date.
> make[1]: Leaving directory `/home/acme/git/linux-2.6-tip/tools/lib'
> make[1]: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
>     GEN perf-archive
> make[1]: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
> make: Leaving directory `/home/acme/git/linux-2.6-tip/tools'
> [acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -C tools/perf/
> make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
>     * new build flags or prefix
>     CC /home/acme/git/build/perf/perf.o
>     CC /home/acme/git/build/perf/builtin-annotate.o
>     CC /home/acme/git/build/perf/builtin-bench.o
> 
> The logic that detects "new build flags or prefix" gets confused when we
> alternate between tools/ and tools/perf/, checking that.

This might need an up-to-date check for the lklib.a archive first and
not do "new build flags or prefix" if it is. Yeah, this is a different
library and the logic doesn't know about it.

> - Arnaldo
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 200fc13..72ccd17 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -268,7 +268,7 @@ endif
>  # Those must not be GNU-specific; they are shared with perl/ which may
>  # be built by a different compiler. (Note that this is an artifact now
>  # but it still might be nice to keep that distinction.)
> -BASIC_CFLAGS += -Iutil/include -Iarch/$(ARCH)/include
> +BASIC_CFLAGS += -Iutil/include -Iarch/$(ARCH)/include -I../lib/
>  BASIC_LDFLAGS =

Right, the whole scheme with the include paths is kinda shaky. I have
the -I$(CURDIR)/lib BASIC_CFLAGS in the top Makefile for the case where
we're in tools/ but this doesn't help with the -C switch as you show
above.

Maybe we should add more logic later to make the include path guessing
more robust no matter from which directory you execute make instead of
polluting BASIC_CFLAGS with duplicated path entries ... Hmmm...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

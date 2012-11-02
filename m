Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177Ab2KBKbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:31:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933559Ab2KBKbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:31:20 -0400
Date: Fri, 2 Nov 2012 11:30:57 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 02/25] perf tests: Move test objects into 'tests'
 directory
Message-ID: <20121102103057.GB1157@krava.brq.redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
 <1351634526-1516-3-git-send-email-jolsa@redhat.com>
 <87k3u44vw6.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3u44vw6.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 10:48:57AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> Despite its way to acme's tree, I'd like to leave a few comments. :)
> 
> 
> On Tue, 30 Oct 2012 23:01:43 +0100, Jiri Olsa wrote:
> > Separating test objects into 'tests' directory.
> >
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  tools/perf/Makefile                 |    9 +-
> >  tools/perf/builtin-test.c           | 1559 -----------------------------------
> >  tools/perf/tests/builtin-test.c     | 1559 +++++++++++++++++++++++++++++++++++
> >  tools/perf/tests/dso-data.c         |  153 ++++
> >  tools/perf/tests/parse-events.c     | 1116 +++++++++++++++++++++++++
> >  tools/perf/util/dso-test-data.c     |  153 ----
> >  tools/perf/util/parse-events-test.c | 1116 -------------------------
> 
> Looks like it should be considered as renames.  Isn't 'git format-patch
> -M' working?

I can see it is.. nice ;) first time I hear about it..

> 
> 
> >  7 files changed, 2833 insertions(+), 2832 deletions(-)
> >  delete mode 100644 tools/perf/builtin-test.c
> >  create mode 100644 tools/perf/tests/builtin-test.c
> >  create mode 100644 tools/perf/tests/dso-data.c
> >  create mode 100644 tools/perf/tests/parse-events.c
> >  delete mode 100644 tools/perf/util/dso-test-data.c
> >  delete mode 100644 tools/perf/util/parse-events-test.c
> >
> > diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> > index 3e807d7..2d3427f 100644
> > --- a/tools/perf/Makefile
> > +++ b/tools/perf/Makefile
> > @@ -169,7 +169,7 @@ endif
> >  
> >  ### --- END CONFIGURATION SECTION ---
> >  
> > -BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
> > +BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -Iutil -I. -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
> 
> Hmm..  Do you really want this?  AFAIK there're lots of places that
> include header files under the util directory and they used relative
> path.  I don't know how it affects them but at least they can be changed
> to use simpler path with this change.

[jolsa@krava perf]$ make O=$PWD/../build/
...
    CC /home/jolsa/kernel.org/linux/tools/build/tests/parse-events.o
tests/parse-events.c:2:26: fatal error: parse-events.h: No such file or directory

yes, we could consolidate util includes globaly

> 
> 
> >  BASIC_LDFLAGS =
> >  
> >  ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
> > @@ -371,7 +371,6 @@ LIB_OBJS += $(OUTPUT)util/help.o
> >  LIB_OBJS += $(OUTPUT)util/levenshtein.o
> >  LIB_OBJS += $(OUTPUT)util/parse-options.o
> >  LIB_OBJS += $(OUTPUT)util/parse-events.o
> > -LIB_OBJS += $(OUTPUT)util/parse-events-test.o
> >  LIB_OBJS += $(OUTPUT)util/path.o
> >  LIB_OBJS += $(OUTPUT)util/rbtree.o
> >  LIB_OBJS += $(OUTPUT)util/bitmap.o
> > @@ -389,7 +388,6 @@ LIB_OBJS += $(OUTPUT)util/sigchain.o
> >  LIB_OBJS += $(OUTPUT)util/dso.o
> >  LIB_OBJS += $(OUTPUT)util/symbol.o
> >  LIB_OBJS += $(OUTPUT)util/symbol-elf.o
> > -LIB_OBJS += $(OUTPUT)util/dso-test-data.o
> >  LIB_OBJS += $(OUTPUT)util/color.o
> >  LIB_OBJS += $(OUTPUT)util/pager.o
> >  LIB_OBJS += $(OUTPUT)util/header.o
> > @@ -430,6 +428,9 @@ LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
> >  
> >  LIB_OBJS += $(OUTPUT)arch/common.o
> >  
> > +LIB_OBJS += $(OUTPUT)tests/parse-events.o
> > +LIB_OBJS += $(OUTPUT)tests/dso-data.o
> > +
> 
> Maybe TEST_OBJS?  I guess they don't need to be included in libperf?

I guess we could have NO_TESTS Makefile variable to disable tests

and '[x] Tests' directory under make menuconfig ;)

> 
> 
> >  BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
> >  BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
> >  # Benchmark modules
> > @@ -459,8 +460,8 @@ BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
> >  BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
> >  BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
> >  BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
> > -BUILTIN_OBJS += $(OUTPUT)builtin-test.o
> >  BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
> > +BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
> 
> Placing builtin command in a different directory looks little bit odd.

well, it's full of tests ;)

maybe we could have those tests placed in separate files and use
builtin-test as runner only

thanks,
jirka

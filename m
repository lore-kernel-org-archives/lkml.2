Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2C0Sdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:33:44 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35316 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2C0Sdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:33:42 -0400
Date: Tue, 27 Mar 2012 20:33:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] perf tools: Including pre-generated flex files
Message-ID: <20120327183335.GA27621@gmail.com>
References: <20120327181547.GA7374@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327181547.GA7374@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> [...]
>
> 	But Ingo argues that flex and bison are just a 
> yum/whatever install away, so we shouldn't clutter the kernel 
> git history with things we can generate at build time.
> 
> 	What is your take on this?

I.e. we could just autogenerate automatically via something like 
the patch below.

My main worry was that Linus would (somewhat rightfully) object 
to the large diffstats that these things introduce:

 tools/perf/util/parse-events-bison.c               | 1917 +++++++++++++++++
 tools/perf/util/parse-events-bison.h               |   81 +
 tools/perf/util/parse-events-flex.c                | 2272 ++++++++++++++++++++
 tools/perf/util/parse-events-flex.h                |  316 +++
 tools/perf/util/parse-events.c                     |  603 +++---
 tools/perf/util/parse-events.h                     |   49 +
 tools/perf/util/parse-events.l                     |  126 ++
 tools/perf/util/parse-events.y                     |  229 ++
 tools/perf/util/pmu-bison.c                        | 1663 ++++++++++++++
 tools/perf/util/pmu-bison.h                        |   73 +
 tools/perf/util/pmu-flex.c                         | 1821 ++++++++++++++++
 tools/perf/util/pmu-flex.h                         |  316 +++

I mean, since auto-generating them is in the Makefile *already*, 
the only argument in favor of it is that whether we want to make 
the perf build depend on bison and flex.

Anyway, it would be nice if we could hear an official opinion on 
this. I didn't want to send the latest perf/urgent with this 
diffstat until this is settled one way or another.

Thanks,

	Ingo

------------->
>From 3cfa99c3a09224cc270ed1e1260cc4fe1b79cebc Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Tue, 27 Mar 2012 14:07:50 +0200
Subject: [PATCH] perf tools: Remove auto-generated bison/flex files

These should not be in the Git history - they are auto-generated.

Extend the Makefile rules of the parser files to include the generation
run.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/n/tip-h6jnlwdy7by4v7yljrvzbii0@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile                  |   25 +-
 tools/perf/util/parse-events-bison.c | 1917 ----------------------------
 tools/perf/util/parse-events-bison.h |   81 --
 tools/perf/util/parse-events-flex.c  | 2272 ----------------------------------
 tools/perf/util/parse-events-flex.h  |  316 -----
 tools/perf/util/pmu-bison.c          | 1663 -------------------------
 tools/perf/util/pmu-bison.h          |   73 --
 tools/perf/util/pmu-flex.c           | 1821 ---------------------------
 tools/perf/util/pmu-flex.h           |  316 -----
 9 files changed, 15 insertions(+), 8469 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2f42886..a9dfd1f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -61,8 +61,6 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
-FLEX = $(CROSS_COMPILE)flex
-BISON= $(CROSS_COMPILE)bison
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
@@ -236,6 +234,21 @@ endif
 
 export PERL_PATH
 
+FLEX = $(CROSS_COMPILE)flex
+BISON= $(CROSS_COMPILE)bison
+
+event-parser:
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o util/parse-events-bison.c
+	$(QUIET_FLEX)$(FLEX) --header-file=util/parse-events-flex.h -t util/parse-events.l > util/parse-events-flex.c
+
+util/parse-events-flex.c: event-parser
+
+pmu-parser:
+	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o util/pmu-bison.c
+	$(QUIET_FLEX)$(FLEX) --header-file=util/pmu-flex.h -t util/pmu.l > util/pmu-flex.c
+
+util/pmu-flex.c: pmu-parser
+
 LIB_FILE=$(OUTPUT)libperf.a
 
 LIB_H += ../../include/linux/perf_event.h
@@ -883,14 +896,6 @@ cscope:
 	$(RM) cscope*
 	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
 
-event-parser:
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o util/parse-events-bison.c
-	$(QUIET_FLEX)$(FLEX) --header-file=util/parse-events-flex.h -t util/parse-events.l > util/parse-events-flex.c
-
-pmu-parser:
-	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o util/pmu-bison.c
-	$(QUIET_FLEX)$(FLEX) --header-file=util/pmu-flex.h -t util/pmu.l > util/pmu-flex.c
-
 ### Detect prefix changes
 TRACK_CFLAGS = $(subst ','\'',$(ALL_CFLAGS)):\
              $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
[...]

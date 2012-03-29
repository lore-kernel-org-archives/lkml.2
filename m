Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab2C2GoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:44:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab2C2GoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:44:00 -0400
Date: Thu, 29 Mar 2012 08:43:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] perf tools: Including pre-generated flex files
Message-ID: <20120329064347.GB1754@m.brq.redhat.com>
References: <20120327181547.GA7374@infradead.org>
 <20120327183335.GA27621@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327183335.GA27621@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 08:33:37PM +0200, Ingo Molnar wrote:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > [...]
> >
> > 	But Ingo argues that flex and bison are just a 
> > yum/whatever install away, so we shouldn't clutter the kernel 
> > git history with things we can generate at build time.
> > 
> > 	What is your take on this?
> 
> I.e. we could just autogenerate automatically via something like 

SNIP

> From 3cfa99c3a09224cc270ed1e1260cc4fe1b79cebc Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@kernel.org>
> Date: Tue, 27 Mar 2012 14:07:50 +0200
> Subject: [PATCH] perf tools: Remove auto-generated bison/flex files
> 
> These should not be in the Git history - they are auto-generated.
> 
> Extend the Makefile rules of the parser files to include the generation
> run.
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Link: http://lkml.kernel.org/n/tip-h6jnlwdy7by4v7yljrvzbii0@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---

Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

>  tools/perf/Makefile                  |   25 +-
>  tools/perf/util/parse-events-bison.c | 1917 ----------------------------
>  tools/perf/util/parse-events-bison.h |   81 --
>  tools/perf/util/parse-events-flex.c  | 2272 ----------------------------------
>  tools/perf/util/parse-events-flex.h  |  316 -----
>  tools/perf/util/pmu-bison.c          | 1663 -------------------------
>  tools/perf/util/pmu-bison.h          |   73 --
>  tools/perf/util/pmu-flex.c           | 1821 ---------------------------
>  tools/perf/util/pmu-flex.h           |  316 -----
>  9 files changed, 15 insertions(+), 8469 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 2f42886..a9dfd1f 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -61,8 +61,6 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>  
>  CC = $(CROSS_COMPILE)gcc
>  AR = $(CROSS_COMPILE)ar
> -FLEX = $(CROSS_COMPILE)flex
> -BISON= $(CROSS_COMPILE)bison
>  
>  # Additional ARCH settings for x86
>  ifeq ($(ARCH),i386)
> @@ -236,6 +234,21 @@ endif
>  
>  export PERL_PATH
>  
> +FLEX = $(CROSS_COMPILE)flex
> +BISON= $(CROSS_COMPILE)bison
> +
> +event-parser:
> +	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o util/parse-events-bison.c
> +	$(QUIET_FLEX)$(FLEX) --header-file=util/parse-events-flex.h -t util/parse-events.l > util/parse-events-flex.c
> +
> +util/parse-events-flex.c: event-parser
> +
> +pmu-parser:
> +	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o util/pmu-bison.c
> +	$(QUIET_FLEX)$(FLEX) --header-file=util/pmu-flex.h -t util/pmu.l > util/pmu-flex.c
> +
> +util/pmu-flex.c: pmu-parser
> +
>  LIB_FILE=$(OUTPUT)libperf.a
>  
>  LIB_H += ../../include/linux/perf_event.h
> @@ -883,14 +896,6 @@ cscope:
>  	$(RM) cscope*
>  	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
>  
> -event-parser:
> -	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o util/parse-events-bison.c
> -	$(QUIET_FLEX)$(FLEX) --header-file=util/parse-events-flex.h -t util/parse-events.l > util/parse-events-flex.c
> -
> -pmu-parser:
> -	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o util/pmu-bison.c
> -	$(QUIET_FLEX)$(FLEX) --header-file=util/pmu-flex.h -t util/pmu.l > util/pmu-flex.c
> -
>  ### Detect prefix changes
>  TRACK_CFLAGS = $(subst ','\'',$(ALL_CFLAGS)):\
>               $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
> [...]

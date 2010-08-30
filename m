Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0H3Iiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:38:46 -0400
Received: from shutemov.name ([188.40.19.243]:59233 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab0H3Iip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:38:45 -0400
Date: Mon, 30 Aug 2010 11:38:44 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tzanussi@gmail.com, ozan@pardus.org.tr,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Fix linking errors with --as-needed
 flag
Message-ID: <20100830083844.GA7010@shutemov.name>
References: <1282627430.28324.8.camel@tropicana>
 <tip-f2481f3df4521e731da36afe7f0fe19a5c93e46d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-f2481f3df4521e731da36afe7f0fe19a5c93e46d@git.kernel.org>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 08:35:40AM +0000, tip-bot for Tom Zanussi wrote:
> Commit-ID:  f2481f3df4521e731da36afe7f0fe19a5c93e46d
> Gitweb:     http://git.kernel.org/tip/f2481f3df4521e731da36afe7f0fe19a5c93e46d
> Author:     Tom Zanussi <tzanussi@gmail.com>
> AuthorDate: Tue, 24 Aug 2010 00:23:50 -0500
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Wed, 25 Aug 2010 17:35:21 -0300
> 
> perf tools: Fix linking errors with --as-needed flag
> 
> External shared libraries should never be appended to the LDFLAGS as this
> messes the linking order. As EXTLIBS collects those libraries, it seems that
> perl and python libraries  should also be appended to EXTLIBS.
> 
> Also fix the broken linking order.
> 
> This is a refresh of a patch by Ozan Çağlayan and improved by both Tom Zanussi
> and Kirill A. Shutemov.
> 
> Cc: Ozan Çağlayan <ozan@pardus.org.tr>
> Tested-by: Kirill A. Shutemov <kirill@shutemov.name>

I guess Signed-off-by is more appropriate here.

> Tested-by: Tom Zanussi <tzanussi@gmail.com>
> LKML-Reference: <1282627430.28324.8.camel@tropicana>
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/Makefile |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 26a3f2e..fe1e307 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -313,6 +313,9 @@ TEST_PROGRAMS =
>  
>  SCRIPT_SH += perf-archive.sh
>  
> +grep-libs = $(filter -l%,$(1))
> +strip-libs = $(filter-out -l%,$(1))
> +
>  #
>  # No Perl scripts right now:
>  #
> @@ -588,14 +591,17 @@ endif
>  ifdef NO_LIBPERL
>  	BASIC_CFLAGS += -DNO_LIBPERL
>  else
> -	PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
> +       PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
> +       PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
> +       PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
>  	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
>  	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
>  
>  	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
>  		BASIC_CFLAGS += -DNO_LIBPERL
>  	else
> -		ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
> +               ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
> +               EXTLIBS += $(PERL_EMBED_LIBADD)
>  		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
>  		LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
>  	endif
> @@ -604,13 +610,16 @@ endif
>  ifdef NO_LIBPYTHON
>  	BASIC_CFLAGS += -DNO_LIBPYTHON
>  else
> -	PYTHON_EMBED_LDOPTS = `python-config --ldflags 2>/dev/null`
> +       PYTHON_EMBED_LDOPTS = $(shell python-config --ldflags 2>/dev/null)
> +       PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
> +       PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
>  	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
>  	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
>  	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
>  		BASIC_CFLAGS += -DNO_LIBPYTHON
>  	else
> -		ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
> +               ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
> +               EXTLIBS += $(PYTHON_EMBED_LIBADD)
>  		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
>  		LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
>  	endif
> @@ -919,8 +928,8 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
>  		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
>  
>  $(OUTPUT)perf$X: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
> -	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(OUTPUT)perf.o \
> -		$(BUILTIN_OBJS) $(ALL_LDFLAGS) $(LIBS)
> +	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
> +               $(BUILTIN_OBJS) $(LIBS) -o $@
>  
>  $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \

-- 
 Kirill A. Shutemov

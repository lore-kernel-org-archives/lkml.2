Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0HRP0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:26:11 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5585 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753268Ab0HRP0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:26:09 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7IFPfmH004907
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
From: Bernd Petrovitsch <bernd@sysprog.at>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100818141412.GD9410@ghostprotocols.net>
References: <20100817181835.GA21083@ghostprotocols.net>
	 <20100818123713.1F02414C03B@msa103.auone-net.jp>
	 <20100818141412.GD9410@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 17:25:41 +0200
Message-ID: <1282145141.5822.125.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-debian-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2010-08-18 at 11:14 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 18, 2010 at 09:37:12PM +0900, Kusanagi Kouichi escreveu:
> > On 2010-08-17 15:18:35 -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Tue, Aug 17, 2010 at 11:17:54AM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > Em Tue, Aug 17, 2010 at 11:08:40PM +0900, Kusanagi Kouichi escreveu:
> > > > > +++ b/tools/perf/feature-tests.mak
> > > > > @@ -113,7 +113,7 @@ endef
> > > > >  try-cc = $(shell sh -c						  \
> > > > > -	'TMP="$(TMPOUT).$$$$";			 		  \
> > > > > +	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
> > > > >  	 echo "$(1)" |						  \
> 
> > > > Much better! Will test and merge, thanks!
> 
> > > Still has issues:
> > > [acme@emilia linux-2.6-tip]$ rm -rf ~/git/build/perf/
> > > [acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -s -j9 -C tools/perf install
> > > Makefile:503: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev
> > > Makefile:534: *** No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static.  Stop.
> > > [acme@emilia linux-2.6-tip]$
> 
> > > Can you please investigate?
> > 
> > With POSIX shell patch, $(OUTPUT) has not been created yet when it is
> > used by try-cc. This fixes the issue anyway.
> > 
> > diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> > index dcb9700..5b1c12b 100644
> > --- a/tools/perf/Makefile
> > +++ b/tools/perf/Makefile
> > @@ -281,6 +281,7 @@ endif
> > 
> >  -include feature-tests.mak
> > 
> > +$(shell mkdir -p $(OUTPUT) 2> /dev/null)
> 
> But with this we're back using $(shell mkdir), Bernd, ideas on how to
> properly fix this, probably the feature tests have to be triggered by
> the first rule and probably be something like:
> 
> $(phony feature-tests): 
First, this should probably have been:
.PHONY: feature-tests

> -include feature-tests.mak
> 
> DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
> $(DIRECTORY_DEPS): $(sort $(dir $(DIRECTORY_DEPS))) feature-tests
>
> completely untested! Unsure if this would trigger the mkdir first tho.
>
> Right?

This doesn't trigger it. I played around a little bit and didn't find
any way to trigger any rule.
The "problem" is IMHO that "try-cc" is used in "ifeq" clauses and these
are evaluated as `make` goes through the Makefile before the first
(real) rule (like "all") is triggered.

So ATM I see only 3 possibilities:
1) The old (aka ugly) "solution" from above.
2) Add to try-cc something like
	[ -d "$(OUTPUT)" ] || mkdir -p "$(OUTPUT)" 2>/dev/null;
before the line with the "echo".
The '[ -d "$(OUTPUT)" ]' is not really necessary as `mkdir -p` is a
no-op on existing directories.
3) Another possibility would be to move the temporary file into the /tmp
directory as into
----  snip  ----
try-cc = $(shell sh -c						  \
	'TMP="/tmp/$(TMPOUT).$$$$";		 		  \
	 echo "$(1)" |						  \
	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
	 rm -f "$$TMP"')
----  snip  ----
If yes, we could use (and thus depend on) `mktemp` - which is usual
shell script way to generate unique temporary filename - as in
----  snip  ----
try-cc = $(shell sh -c   \
	'TMP="$$(mktemp)";   \
	 echo "$(1)" |   \
	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
	 rm -f "$$TMP"')
----  snip  ----

	Bernd
-- 
mobile: +43 664 4416156              http://www.sysprog.at/
    Linux Software Development, Consulting and Services


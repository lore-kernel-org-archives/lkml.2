Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0HRRTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:19:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0HRRTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:19:30 -0400
Date: Wed, 18 Aug 2010 14:19:18 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Bernd Petrovitsch <bernd@sysprog.at>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
Message-ID: <20100818171917.GH9410@ghostprotocols.net>
References: <20100817181835.GA21083@ghostprotocols.net>
 <20100818123713.1F02414C03B@msa103.auone-net.jp>
 <20100818141412.GD9410@ghostprotocols.net>
 <1282145141.5822.125.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282145141.5822.125.camel@thorin>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 18, 2010 at 05:25:41PM +0200, Bernd Petrovitsch escreveu:
> On Mit, 2010-08-18 at 11:14 -0300, Arnaldo Carvalho de Melo wrote:
> > But with this we're back using $(shell mkdir), Bernd, ideas on how to
> > properly fix this, probably the feature tests have to be triggered by
> > the first rule and probably be something like:
> > 
> > $(phony feature-tests): 
> First, this should probably have been:
> .PHONY: feature-tests

Humm, isn't $(phony feature-tests): variation valid and shorter, humm,
yeah, seems to be for !GNU make :-\

(http://makepp.sourceforge.net/1.18/t_phony.html)

> > -include feature-tests.mak
> > 
> > DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
> > $(DIRECTORY_DEPS): $(sort $(dir $(DIRECTORY_DEPS))) feature-tests
> >
> > completely untested! Unsure if this would trigger the mkdir first tho.
> >
> > Right?
> 
> This doesn't trigger it. I played around a little bit and didn't find
> any way to trigger any rule.
> The "problem" is IMHO that "try-cc" is used in "ifeq" clauses and these
> are evaluated as `make` goes through the Makefile before the first
> (real) rule (like "all") is triggered.
> 
> So ATM I see only 3 possibilities:
> 1) The old (aka ugly) "solution" from above.
> 2) Add to try-cc something like
> 	[ -d "$(OUTPUT)" ] || mkdir -p "$(OUTPUT)" 2>/dev/null;
> before the line with the "echo".
> The '[ -d "$(OUTPUT)" ]' is not really necessary as `mkdir -p` is a
> no-op on existing directories.

Probably 2) is the best, since we'll end up creating that dir anyway.
But as PeterZ pointed out, this is all moot since the kernel behaviour
for O= is to expect the directory specified to already exist.

We're left with the task of checking that and providing a meaningful
answer if not, like this:

[acme@emilia linux-2.6-tip]$ ls -la ~/git/build/foo
ls: cannot access /home/acme/git/build/foo: No such file or directory
[acme@emilia linux-2.6-tip]$ make O=~/git/build/foo
/bin/sh: line 0: cd: /home/acme/git/build/foo: No such file or directory
Makefile:117: *** output directory "/home/acme/git/build/foo" does not exist.  Stop.
[acme@emilia linux-2.6-tip]$

> 3) Another possibility would be to move the temporary file into the /tmp
> directory as into
> ----  snip  ----
> try-cc = $(shell sh -c						  \
> 	'TMP="/tmp/$(TMPOUT).$$$$";		 		  \
> 	 echo "$(1)" |						  \
> 	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
> 	 rm -f "$$TMP"')
> ----  snip  ----
> If yes, we could use (and thus depend on) `mktemp` - which is usual
> shell script way to generate unique temporary filename - as in

There is no use of mktemp in Kbuild, that I try hard to use as reference
here.

- Arnaldo

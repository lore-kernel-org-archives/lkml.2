Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab0HRMhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 08:37:20 -0400
Received: from msa103.auone-net.jp ([61.117.18.163]:46198 "EHLO
	msa103.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0HRMhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 08:37:18 -0400
Date: Wed, 18 Aug 2010 21:37:12 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
References: <20100817181835.GA21083@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817181835.GA21083@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Message-Id: <20100818123713.1F02414C03B@msa103.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-17 15:18:35 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Aug 17, 2010 at 11:17:54AM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Tue, Aug 17, 2010 at 11:08:40PM +0900, Kusanagi Kouichi escreveu:
> > > --- a/tools/perf/feature-tests.mak
> > > +++ b/tools/perf/feature-tests.mak
> > > @@ -113,7 +113,7 @@ endef
> > >  # try-cc
> > >  # Usage: option = $(call try-cc, source-to-build, cc-options)
> > >  try-cc = $(shell sh -c						  \
> > > -	'TMP="$(TMPOUT).$$$$";			 		  \
> > > +	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
> > >  	 echo "$(1)" |						  \
> > >  	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
> > >  	 rm -f "$$TMP"')
> > 
> > Much better! Will test and merge, thanks!
> 
> Still has issues:
> 
> [acme@emilia linux-2.6-tip]$ rm -rf ~/git/build/perf/
> [acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -s -j9 -C tools/perf install
> PERF_VERSION = 2.6.36.rc1.2.g19bad
>     * new build flags or prefix
> [acme@emilia linux-2.6-tip]$ patch -p1 < Kouichi.patch 
> patching file tools/perf/Makefile
> patching file tools/perf/feature-tests.mak
> [acme@emilia linux-2.6-tip]$ rm -rf ~/git/build/perf/
> [acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -s -j9 -C tools/perf install
> Makefile:503: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev
> Makefile:534: *** No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static.  Stop.
> [acme@emilia linux-2.6-tip]$
> 
> Can you please investigate?
> 
> Thanks,
> 
> - Arnaldo

With POSIX shell patch, $(OUTPUT) has not been created yet when it is
used by try-cc. This fixes the issue anyway.

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index dcb9700..5b1c12b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -281,6 +281,7 @@ endif

 -include feature-tests.mak

+$(shell mkdir -p $(OUTPUT) 2> /dev/null)
 ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
 endif

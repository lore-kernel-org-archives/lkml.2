Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0FOBCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:02:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab0FOBCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:02:21 -0400
Date: Mon, 14 Jun 2010 22:02:01 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@amd64.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100615010201.GA27077@ghostprotocols.net>
References: <1274799588.5882.1572.camel@twins>
 <20100528143311.GB9710@elte.hu>
 <1275059860.27810.9635.camel@twins>
 <20100528155719.GA10141@kryptos.osrc.amd.com>
 <1275070030.1645.362.camel@laptop>
 <20100603134301.GA30880@kryptos.osrc.amd.com>
 <20100603173242.GD29202@ghostprotocols.net>
 <20100614192514.GA7803@kryptos.osrc.amd.com>
 <20100614210116.GA26716@ghostprotocols.net>
 <20100614212426.GA19915@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100614212426.GA19915@liondog.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 14, 2010 at 11:24:26PM +0200, Borislav Petkov escreveu:
> From: Arnaldo Carvalho de Melo <acme@infradead.org>
> > One thing I thought was that perhaps reusing Kbuild would be a good
> > idea, something like:
> > 
> > cd tools/
> > make menuconfig
> > 
> > And use all the Kbuild machinery to select needed features, etc.
> > 
> > What do you think?
> 
> Why not, however, do we need it at this point? I mean, you simply do
> 
> make -j; make install
> 
> in tools/perf/ and all is good. It even tells you if some libraries are
> missing. I simply don't see such a large amount of options to justify
> a configurator but maybe there are usecases where Kconfig would make
> sense, hmmm?

Yeah, I mean longer term, as we get libraries separated, more benchmarks,
tools, etc.
 
> > It can be a follow up to what you're doing, that is needed anyway, some
> > questions below:

> > >  tools/lib/util/util.h                              |  282 ++++++++++++++++++++
> > 
> > Will we continue using "util" here? What other name could we pick? Nah,
> > probably for the ones you moved we can continue using it, the symbols
> > part I plan to move to tools/lib/symbol/.
 
> Yeah, names are kinda arbitrary. Keeping "util" meant as little changes as
> possible but it would make more sense to simply have all different library
> modules under "tools/lib/<module>.(c|h)" Will do so in the next version.

Ok

> > >  tools/perf/builtin-bench.c                         |    2 +-
> > >  tools/perf/builtin.h                               |    4 +-
> > 
> > > -#include "types.h"
> > > +#include <util/types.h>
> > 
> > I thought about suggesting using -I to reduce patch size, but then it is
> > using "" :-\
> 
> Yeah, I have the -I$(CURDIR)/lib for this in the top level Makefile so all
> library includes would be like:
> 
> #include <util.h>
> 
> however, this does not differentiate perflib (let's call it that for how
> :) from libc headers. Do we want a "perf" or "kernel" or "perflib" or
> whatever prefix here - it might make sense later when this thing grows
> to differentiate between the namespaces...?

Agreed, but the last name this thing will have will be 'perf'something :-)

One of the goals at least I have with pursuing this path is to separate
out everything that is not strictly 'perf' into things that can be reused
by other tools, like yours.
 
> > So I'll do some testing here and merge this for .36 unless somebody has
> > other issues with this, Ingo? Frédéric?

> Can you please wait a bit with the merging, I'd like to write the
> whole rasd daemon stuff before we merge that and have the generic lib
> carve-out in one patchset?

Ok with me, I'll see if I manage to do the symbols part tho, as it is
kinda self contained and I already toyed with writing a test program
that uses the subset of tools/perf/util/ that deals with symbols.

Part of that experiment is in tools/perf/builtin-test.c, parts are
exemplified by this Makefile:

[acme@doppio linux-2.6-tip]$ cat tools/perf/util/examples/symbol/Makefile 
ppio linux-2.6-tip]$ l tools/perf/util/examples/symbol/Makefile 
-rw-rw-r-- 1 acme acme 693 2010-03-27 11:14 tools/perf/util/examples/symbol/Makefile
CFLAGS = -Wall -I../../include -I../.. -std=gnu99 -DNO_DEMANGLE -g
LDFLAGS = -lelf

ifeq ("$(origin O)", "command line")
	OUTPUT := $(O)/
endif

LIBSYM_OBJS = $(OUTPUT)map.o $(OUTPUT)rbtree.o $(OUTPUT)symbol.o $(OUTPUT)strlist.o $(OUTPUT)eprintf.o

all: $(OUTPUT)dsym $(OUTPUT)ksym

$(OUTPUT)dsym: $(OUTPUT)dsym.o $(LIBSYM_OBJS)
	gcc -o $@ $(LDFLAGS) $@.o $(LIBSYM_OBJS)

$(OUTPUT)ksym: $(OUTPUT)ksym.o $(LIBSYM_OBJS)
	gcc -o $@ $(LDFLAGS) $@.o $(LIBSYM_OBJS)

$(OUTPUT)rbtree.o: ../../../../../lib/rbtree.c
	gcc -o $@ -c $(CFLAGS) $<

$(OUTPUT)%.o: ../../%.c
	gcc -o $@ -c $(CFLAGS) $<

$(OUTPUT)%.o: %.c
	gcc -o $@ -c $(CFLAGS) $<

clean:
	rm -f $(LIBSYM_OBJS) $(OUTPUT)?sym.o $(OUTPUT)?sym
[acme@doppio linux-2.6-tip]$
[acme@doppio linux-2.6-tip]$ cd tools/perf/util/examples/symbol/
[acme@doppio symbol]$ l build/
total 104
drwxrwxr-x 2 acme acme  4096 2010-06-14 21:55 ./
drwxrwxr-x 3 acme acme  4096 2010-03-28 13:52 ../
-rwxrwxr-x 1 acme acme 47040 2010-06-14 21:55 dsym*
-rwxrwxr-x 1 acme acme 47200 2010-06-14 21:55 ksym*
[acme@doppio symbol]$ ldd build/dsym
	linux-vdso.so.1 =>  (0x00007fffe6cf2000)
	libelf.so.1 => /usr/lib64/libelf.so.1 (0x0000003404c00000)
	libc.so.6 => /lib64/libc.so.6 (0x0000003715a00000)
	/lib64/ld-linux-x86-64.so.2 (0x0000003715600000)
[acme@doppio symbol]$
[acme@doppio symbol]$ build/dsym 
usage: dso DSO_NAME SYMBOL_NAME|0xADDR
[acme@doppio symbol]$ build/dsym /lib/libc-2.10.2.so malloc
malloc: 0x749c0-0x74bee
[acme@doppio symbol]$ build/dsym /lib/libc-2.10.2.so 0x749ee
__GI___libc_malloc: 0x749c0-0x74bee
[acme@doppio symbol]$ build/dsym /lib/libc-2.10.2.so __GI___libc_malloc
__GI___libc_malloc: 0x749c0-0x74bee

:-)

- Arnaldo

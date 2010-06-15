Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab0FOKWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:22:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59656 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0FOKWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:22:09 -0400
Date: Tue, 15 Jun 2010 12:22:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Lin Ming <ming.m.lin@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100615102259.GB17953@aftab>
References: <20100528143311.GB9710@elte.hu>
 <1275059860.27810.9635.camel@twins>
 <20100528155719.GA10141@kryptos.osrc.amd.com>
 <1275070030.1645.362.camel@laptop>
 <20100603134301.GA30880@kryptos.osrc.amd.com>
 <20100603173242.GD29202@ghostprotocols.net>
 <20100614192514.GA7803@kryptos.osrc.amd.com>
 <20100614210116.GA26716@ghostprotocols.net>
 <20100614212426.GA19915@liondog.tnic>
 <20100615010201.GA27077@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100615010201.GA27077@ghostprotocols.net>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Alberto_Bozzo=2C_Andrew_Bowd=2C_Sitz=3A?=
	=?iso-8859-1?Q?_Dornach=2C_Gemeinde_Aschheim=2C_Landkreis_M=FCnchen=2C_Re?=
	=?iso-8859-1?Q?gistergericht_M=FCnchen=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Mon, Jun 14, 2010 at 09:02:01PM -0400

> Em Mon, Jun 14, 2010 at 11:24:26PM +0200, Borislav Petkov escreveu:
> > From: Arnaldo Carvalho de Melo <acme@infradead.org>
> > > One thing I thought was that perhaps reusing Kbuild would be a good
> > > idea, something like:
> > > 
> > > cd tools/
> > > make menuconfig
> > > 
> > > And use all the Kbuild machinery to select needed features, etc.
> > > 
> > > What do you think?
> > 
> > Why not, however, do we need it at this point? I mean, you simply do
> > 
> > make -j; make install
> > 
> > in tools/perf/ and all is good. It even tells you if some libraries are
> > missing. I simply don't see such a large amount of options to justify
> > a configurator but maybe there are usecases where Kconfig would make
> > sense, hmmm?
> 
> Yeah, I mean longer term, as we get libraries separated, more benchmarks,
> tools, etc.

Sure, this is generally a good idea.

>  
> > > It can be a follow up to what you're doing, that is needed anyway, some
> > > questions below:
> 
> > > >  tools/lib/util/util.h                              |  282 ++++++++++++++++++++
> > > 
> > > Will we continue using "util" here? What other name could we pick? Nah,
> > > probably for the ones you moved we can continue using it, the symbols
> > > part I plan to move to tools/lib/symbol/.
>  
> > Yeah, names are kinda arbitrary. Keeping "util" meant as little changes as
> > possible but it would make more sense to simply have all different library
> > modules under "tools/lib/<module>.(c|h)" Will do so in the next version.
> 
> Ok
> 
> > > >  tools/perf/builtin-bench.c                         |    2 +-
> > > >  tools/perf/builtin.h                               |    4 +-
> > > 
> > > > -#include "types.h"
> > > > +#include <util/types.h>
> > > 
> > > I thought about suggesting using -I to reduce patch size, but then it is
> > > using "" :-\
> > 
> > Yeah, I have the -I$(CURDIR)/lib for this in the top level Makefile so all
> > library includes would be like:
> > 
> > #include <util.h>
> > 
> > however, this does not differentiate perflib (let's call it that for how
> > :) from libc headers. Do we want a "perf" or "kernel" or "perflib" or
> > whatever prefix here - it might make sense later when this thing grows
> > to differentiate between the namespaces...?
> 
> Agreed, but the last name this thing will have will be 'perf'something :-)
> 
> One of the goals at least I have with pursuing this path is to separate
> out everything that is not strictly 'perf' into things that can be reused
> by other tools, like yours.

Ok, since I'm a big fan of unambiguous short names, let's call it "lk"
for "linux kernel" and have this namespace for all generic headers. So
when you include those, you have something like

#include <lk/util.h>

How does that sound?

> > > So I'll do some testing here and merge this for .36 unless somebody has
> > > other issues with this, Ingo? Frédéric?
> 
> > Can you please wait a bit with the merging, I'd like to write the
> > whole rasd daemon stuff before we merge that and have the generic lib
> > carve-out in one patchset?
> 
> Ok with me, I'll see if I manage to do the symbols part tho, as it is
> kinda self contained and I already toyed with writing a test program
> that uses the subset of tools/perf/util/ that deals with symbols.

Neat, let's sync when I got my stuff ready so that we merge it together
and fixup any paths fallout that might happen.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.

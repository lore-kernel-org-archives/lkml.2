Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252Ab0FQP11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:27:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51915 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab0FQP1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:27:25 -0400
Date: Thu, 17 Jun 2010 17:27:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100617152734.GB6115@kryptos.osrc.amd.com>
References: <20100528155719.GA10141@kryptos.osrc.amd.com>
 <1275070030.1645.362.camel@laptop>
 <20100603134301.GA30880@kryptos.osrc.amd.com>
 <20100603173242.GD29202@ghostprotocols.net>
 <20100614192514.GA7803@kryptos.osrc.amd.com>
 <20100614210116.GA26716@ghostprotocols.net>
 <20100614212426.GA19915@liondog.tnic>
 <20100615010201.GA27077@ghostprotocols.net>
 <20100617134357.GA6115@kryptos.osrc.amd.com>
 <20100617142546.GA563@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100617142546.GA563@ghostprotocols.net>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, Jun 17, 2010 at 11:25:46AM -0300

> Em Thu, Jun 17, 2010 at 03:43:57PM +0200, Borislav Petkov escreveu:
> > From: Arnaldo Carvalho de Melo <acme@infradead.org>
> > Date: Mon, Jun 14, 2010 at 10:02:01PM -0300
> > > > however, this does not differentiate perflib (let's call it that for how
> > > > :) from libc headers. Do we want a "perf" or "kernel" or "perflib" or
> > > > whatever prefix here - it might make sense later when this thing grows
> > > > to differentiate between the namespaces...?
> 
> > > Agreed, but the last name this thing will have will be 'perf'something :-)
> > > One of the goals at least I have with pursuing this path is to separate
> > > out everything that is not strictly 'perf' into things that can be reused
> > > by other tools, like yours.
> 
> > I'm still splitting perf/util into a more or less generic lib.  Now, I
> > want to reuse as much code as possible and am parsing the
> > "mce:mce_record" tracepoint using parse_events(). However, this means
> > that I have to push the not-so-generic perf bits like
> > util/parse-events.c into the lib. Which, in turn, pulls in
> > util/trace-event* etc.
> 
> I'm not that familiar with the trace bits in perf, but I'd say pick what
> is needed for your tool and stash it into files in a tools/lib/trace/
> directory, in a way that can be used by both perf and your tools.
> 
> I.e. no need to move files as-is, you can reorganize things to make it
> useful for both perf and your tool.

Right, this is the idea. However, all those header includes pull in
other stuff. For example, if I want to use parse_events(), it pulls in
parse-options.* which pulls in header.h, symbol.h etc.

What I ended up doing is have

tools/lib/perf/
	 /trace/
	 /include/
	 /lk/

for all the different types of facilities. So lk contains the generic
perf/util/ stuff, include contains all the linux and asm headers like
bitops.h, hash.h, kernel.h etc, perf contains parse-events.* because it
deals with perf stuff and so on.

How's that?

> > What is your preference, do we want to export all perf/util stuff for
> > other tools to use or rather link other tools together with
> > compilation modules from perf/util in case those other tools need
> > them?
> 
> If we do it on a as-needed basis, as I suggested, we go eroding the
> current perf hodgepodge of potentially generic stuff.

I think splitting it in kinda "subsystems" helps keep the modularity.

Opinions, comments?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis München
Registergericht Muenchen, HRB Nr. 43632

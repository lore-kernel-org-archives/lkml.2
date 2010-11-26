Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab0KZHOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 02:14:18 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41849 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0KZHOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:14:17 -0500
Date: Fri, 26 Nov 2010 16:13:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org,
        davem <davem@davemloft.net>, Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Don Zickus <dzickus@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC][PATCH 2/8] perf, arch: Use early_initcall() for all arch pmu implementations
Message-ID: <20101126071325.GD7893@linux-sh.org>
References: <20101117221730.002627458@chello.nl> <20101117222056.040309789@chello.nl> <1290680713.2145.18.camel@laptop> <1290707759.2145.119.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290707759.2145.119.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 06:55:59PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-25 at 11:25 +0100, Peter Zijlstra wrote:
> > 
> > Right, so hw perf init happens from (after this patch):
> > 
> >  arch_initcall: powerpc, arm, sh, mips
> >  early_initcall: x86, sparc, alpha
> > 
> > 
> > Now the problem is that the generic watchdog code (kernel/watchdog.c)
> > tries to create hw perf events, and that too runs from early_initcall.
> > 
> > So my question is, how do we go about curing this, because powerpc, arm,
> > sh and mips are too late and the rest depends on link order to work, not
> > really a nice situation.
> > 
> > There's two categories of solutions:
> >  - move the watchdog later, and
> >  - move the hw perf init earlier.
> > 
> > The former is undesired because we want the watchdog as early as
> > possible, the later needs new infrastructure (also, I don't know if the
> > arch implementations can actually run this early).
> > 
> > So do I create a perf_initcall() or is there another solution that
> > avoids things like calling the watchdog code from all arch init code? 
> 
> So the perf_event_init() site is _waaay_ to early to init stuff.. I
> guess I'll move it all to early_initcall() and I'll move the watchdog to
> an explicit call right after it.
> 
> Something like the below,.. now I guess the question to all of you is,
> can your arch pmu code cope with early_initcall() or does it need to be
> some other place?
> 
Any of the initcall levels are ok for SH at least. The only dependency we
have for the perf code is the clock framework, which comes up during
time_init().

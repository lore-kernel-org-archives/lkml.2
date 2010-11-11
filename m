Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab0KKXVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:21:30 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54665 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab0KKXV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:21:29 -0500
Subject: Re: [PATCH 04/10] tile: convert to use clocksource_register_hz
From: john stultz <johnstul@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1289514133.2084.207.camel@laptop>
References: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
	 <1288642350-1599-5-git-send-email-johnstul@us.ibm.com>
	 <4CDC5E70.90102@tilera.com>  <1289513176.2742.56.camel@work-vm>
	 <1289514133.2084.207.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 15:21:15 -0800
Message-ID: <1289517675.2742.125.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 23:22 +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-11 at 14:06 -0800, john stultz wrote:
> > 1) How often is sched_clock guaranteed to be called? Once each tick, (so
> > the maximum time in nohz mode would be reasonable?)
> 
> Never,.. sparc64 for example can stay in nohz mode for hours. We have a
> nohz_exit hook for the kernel/sched_clock.c code though which resyncs us
> against the GTOD.

Well, I suspect after hours in nohz, timekeeping might not be 100%
correct, unless a low enough shift value is used.

And that's part of the motivation for the clocksource_register_hz bits:
to consolidate assumptions about adjustment granularity and safe nohz
limits, so they can be tuned in a generic and clean fashion without
assumptions being made in the arch specific code.

> > 2) What considerations for sched_clock wrapping is there in generic
> > code? I see some considerations in kernel/sched_clock.c, but its not
> > obvious the limits. On x86, the 64-bit TSC won't wrap (but might jump on
> > non-synced systems, or halt in idle modes). Do architectures that have
> > faster-wrapping counters need to handle the cycle accumulation
> > internally? 
> 
> Basically all code assumes we wrap on the u64 boundary.
> 
> So the whole kernel/sched_clock.c machinery tries to make a crummy arch
> sched_clock() usable, it syncs against the GTOD code (on tick, idle_exit
> and nohz_exit) and only assumes the arch sched_clock() wraps at the u64
> boundary, jumps, inter-cpu drift etc are all taken care of.

So at some point it might be worth having a clocksource-like structure
to register for sched_clock and allowing generic code manage calculating
the cycles to ns conversion and accumulation method so we don't run into
arch specific issues.

That said, for now, I think it would be easiest to make sure the arch
specific sched_clock implementations don't mis-use the timekeeping logic
that is built for different assumptions.

It looks the tile folks have done the right thing, hopefully we can fix
the few other cases (like the lpj issue brought up earlier) fairly
easily in the arch code.

thanks
-john



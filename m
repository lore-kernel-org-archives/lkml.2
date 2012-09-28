Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab2I1Du2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:50:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53126 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754602Ab2I1Du0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:50:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ouZoVX7hopRuLwdRpC384+5fV8fBXHbWm/6kC5S
	KzTmHzxPM4uHSQ
Message-ID: <1348804220.7072.2.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Fri, 28 Sep 2012 05:50:20 +0200
In-Reply-To: <20120927192426.GF8527@x1.osrc.amd.com>
References: <1348722568.7059.115.camel@marge.simpson.net>
	 <20120927054742.GA4370@gmail.com>
	 <1348727665.7059.160.camel@marge.simpson.net>
	 <20120927064142.GB5996@gmail.com>
	 <1348728852.7059.171.camel@marge.simpson.net>
	 <20120927071011.GA8980@gmail.com>
	 <CA+55aFyxjdir-LZneBTk1JQV0cVSRFzEK9Jpxje2SJqA6aP3Yg@mail.gmail.com>
	 <20120927180507.GD8527@x1.osrc.amd.com>
	 <CA+55aFyTrcmx3Uf7UGU=-K=BwTym8aN15fTo==cV2bCK6so0Fg@mail.gmail.com>
	 <1348770584.3292.44.camel@twins> <20120927192426.GF8527@x1.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 21:24 +0200, Borislav Petkov wrote: 
> On Thu, Sep 27, 2012 at 08:29:44PM +0200, Peter Zijlstra wrote:
> > > >> Or could we just improve the heuristics. What happens if the
> > > >> scheduling granularity is increased, for example? It's set to 1ms
> > > >> right now, with a logarithmic scaling by number of cpus.
> > > >
> > > > /proc/sys/kernel/sched_wakeup_granularity_ns=10000000 (10ms)
> > > > ------------------------------------------------------
> > > > tps = 4994.730809 (including connections establishing)
> > > > tps = 5000.260764 (excluding connections establishing)
> > > >
> > > > A bit better over the default NO_WAKEUP_PREEMPTION setting.
> > > 
> > > Ok, so this gives us something possible to actually play with.
> > > 
> > > For example, maybe SCHED_TUNABLESCALING_LINEAR is more appropriate
> > > than SCHED_TUNABLESCALING_LOG. At least for WAKEUP_PREEMPTION. Hmm?
> > 
> > Don't forget to run the desktop interactivity benchmarks after you're
> > done wriggling with this knob... wakeup preemption is important for most
> > those.
> 
> Setting sched_tunable_scaling to SCHED_TUNABLESCALING_LINEAR made
> wakeup_granularity go to 4ms:
> 
> sched_autogroup_enabled:1
> sched_child_runs_first:0
> sched_latency_ns:24000000
> sched_migration_cost_ns:500000
> sched_min_granularity_ns:3000000
> sched_nr_migrate:32
> sched_rt_period_us:1000000
> sched_rt_runtime_us:950000
> sched_shares_window_ns:10000000
> sched_time_avg_ms:1000
> sched_tunable_scaling:2
> sched_wakeup_granularity_ns:4000000
> 
> pgbench results look good:
> 
> tps = 4997.675331 (including connections establishing)
> tps = 5003.256870 (excluding connections establishing)
> 
> This is still with Ingo's NO_WAKEUP_PREEMPTION patch.

And wakeup preemption is still disabled as well, correct?

-Mike


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0ENHFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:05:46 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34572 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0ENHFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:05:45 -0400
Date: Fri, 14 May 2010 16:04:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
Message-ID: <20100514070454.GE12002@linux-sh.org>
References: <1273560419.5605.3426.camel@twins> <20100511072127.GB10421@elte.hu> <1273566031.30322.31.camel@minggr.sh.intel.com> <1273567815.5605.3491.camel@twins> <1273568620.30322.42.camel@minggr.sh.intel.com> <1273569154.5605.3499.camel@twins> <1273570845.30322.59.camel@minggr.sh.intel.com> <1273571322.5605.3523.camel@twins> <20100512055112.GA4691@linux-sh.org> <1273653443.5605.3529.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273653443.5605.3529.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 10:37:23AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-12 at 14:51 +0900, Paul Mundt wrote:
> > On Tue, May 11, 2010 at 11:48:42AM +0200, Peter Zijlstra wrote:
> 
> > > No all the cpus would have the same event sources. I'm not sure if we
> > > can make sysfs understand that though (added GregKH and Kay to CC).
> > > 
> > This is something I've been thinking about, too. On SH we have a
> > large set of perf counter events that are entirely dependent on the
> > configuration of the CPU they're on, with no requirement that these
> > configurations are identical on all CPUs in an SMP configuration.
> > 
> > As an example, it's possible to halve the L1 dcache and use that part of
> > it as a small and fast memory which has completely different events
> > associated with it from the regular L1 dcache events. These events would
> > be invalid on a CPU that was running with all cache ways enabled but
> > might also be valid on other CPUs that bolt these events to an extra SRAM
> > outside of the cache topology completely.
> > 
> > In any event, the events are at least consistent across all CPUs, it's
> > only which ones are valid on a given CPU at a given time that can change.
> 
> So you're running with asymmetric SMP systems? I really hadn't
> considered that. Will this change at runtime or is it a system boot time
> thing?

At the moment it's a boot time thing, but we're moving towards runtime
switching via CPU hotplug (which at the moment we primarily use for
runtime power management). This has specifically been a recurring
requirement from some of our automotive customers, so it's gradually
becoming more prevalent.

We also have the multi-core case where multiple architectures are
combined but we still have memory-mapped access to the slave CPUs
performance counters (SH-Mobile G series has this behaviour where we have
both an ARM and an SH core and it doesn't really matter which one is
running the primary linux kernel, the slave on the other hand might be
running linux or it may be running a fixed application that depends on
control and input from the primary linux-running MPU). Presently we just
tie in through the hardware debug interfaces for monitoring and
controlling the secondary counters, but being able to make this sort of
thing workload granular via perf would obviously be a huge benefit.
Supporting these sorts of configurations is going to take a bit of doing
though, especially on the topology side.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab0ETTwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:52:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab0ETTwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:52:51 -0400
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100520184213.GB21030@kroah.com>
References: <1274233602.3036.84.camel@localhost>
	 <20100518200524.GA20223@kroah.com>
	 <1274236496.3603.22.camel@minggr.sh.intel.com>
	 <20100519024823.GA25229@kroah.com> <1274253276.5605.10124.camel@twins>
	 <20100520184213.GB21030@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 21:52:32 +0200
Message-ID: <1274385152.1674.1636.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 11:42 -0700, Greg KH wrote:
> On Wed, May 19, 2010 at 09:14:36AM +0200, Peter Zijlstra wrote:

> > Since the CPU and memory controllers are (assumed) symmetric on the
> > system, we get to add things like:
> > 
> > 
> >   /sys/devices/system/cpu/cpu_event_source/
> 
> Wouldn't that really be:
> 	/sys/devices/system/cpu/cpu0/cpu_event_source/
> ?
> 
> /sys/devices/system/cpu is a "type" of devices in the system here, and
> isn't an event source specific to the device itself?
> 
> Or is it for all cpus together?

All CPUs are assumed identical, and the perf syscall has task/cpu
monitor targets. If the CPUs would not be identical (like Paul Mundt
said SH might do) then it would make sense to have different
event_sources for each cpu.

> > I'm not sure where we'd want them to live, we could add them to:
> > 
> >   /sys/kernel/tracepoint_event_source/
> > 
> > and have them live there, but I'm open to alternatives :-)
> 
> Once you go outside of /sys/devices/ you aren't playing with devices
> properly, so you might just want to stick to a "class" and have
> /sys/class/tracepoint_event_source/ where all of the devices would end
> up symlinking to.

Sure, that would work.

> > [ With event_source's being a sysfs-class, we also get a nice flat
> >   collection in /sys/class/event_source/ helping those who get lost
> >   in the device topology, me :-) ]
> 
> Yes, but isn't the fact that you can have different types of
> event sources lend itself to different classes of event sources?

I'm not quite sure adding another abstraction level buys us much.

> >  fd = open("/sys/devices/system/cpu/cpu_event_source/instructions/config");
> >  attr->type = fd | PERF_TYPE_FD;
> >  event_fd = perf_event_open(attr, ... );
> >  close(fd);
> > 
> > From that one fd we can find to which 'event_source' it belongs and what
> > particular config we need to use.
> 
> Ah, pass the fd of a sysfs file to sysfs to get the kobject.  Ick,
> that's just, well, something that I never even considered someone would
> need/want to do...

No, we don't pass the fd to sysfs, we pass the fd into a syscall.

> sysfs exports single values just fine.  If you are starting to do more
> complex things, like you currently are, maybe you shouldn't be in
> sysfs...

Well, like said, I'm fine with it actually being single values, its just
that Ingo suggested skipping a few syscalls.

Robert just suggested we could use the sysfs files as device nodes and
have then open() return a perf_event fd. Its just that that would
require we add a ioctl to change the perf_event_attr structure and
attach it to a context.

> I can always knock up a eventfs for you do mount at /sys/kernel/events/
> or something if you want :)

But that won't get us the nice device linkage, right?


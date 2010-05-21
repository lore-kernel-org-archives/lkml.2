Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab0EUJlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:41:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50788 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab0EUJlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:41:35 -0400
Date: Fri, 21 May 2010 11:40:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>
Cc: Lin Ming <ming.m.lin@intel.com>,
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
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [rfc] Describe events in a structured way via sysfs
Message-ID: <20100521094053.GA4658@elte.hu>
References: <1274233602.3036.84.camel@localhost>
 <20100518200524.GA20223@kroah.com>
 <1274236496.3603.22.camel@minggr.sh.intel.com>
 <20100519024823.GA25229@kroah.com>
 <1274253276.5605.10124.camel@twins>
 <20100520184213.GB21030@kroah.com>
 <20100520201418.GB11470@elte.hu>
 <20100520231229.GB8335@kroah.com>
 <1274429038.1674.1684.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274429038.1674.1684.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-05-20 at 16:12 -0700, Greg KH wrote:

> > How deep in the device tree are you really going to be 
> > caring about?  It sounds like the large majority of 
> > events are only going to be coming from the "system" 
> > type objects (cpu, nodes, memory, etc.) and very few 
> > would be from things that we consider a 'struct 
> > device' today (like a pci, usb, scsi, or input, etc.)
> 
> The general noise I hear from the hardware people is 
> that we'll see more and more device-level stuff - bus 
> bridges/controller and actual devices (GPUs, NICs etc.) 
> will be wanting to export performance metrics.

There's (much) more:

 - laptops want to provide power level/usage metrics,

 - we could express a lot of special, lower level 
   (transport specific) disk IO stats via events as well - 
   without having to push those stats to a higher level 
   (where it might not make sense). Currently such kinds
   of stats/metrics are very device/subsystem specific 
   way, if they are provided at all.

Also, we already have quite a few per device tracepoints 
upstream. Here are a few examples:

 - GPU tracepoints (trace_i915_gem_request_submit(), etc.)
 - WIFI tracepoints (trace_iwlwifi_dev_ioread32(), etc.)
 - block tracepoints (trace_block_bio_complete())

So these would be attached to:

  # GEM events of drm/card0:
  /sys/devices/pci0000:00/0000:00:02.0/drm/card0/events/i915_gem_request_submit/

  # Wifi-ioread events of wlan0:
  /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/events/iwlwifi_dev_ioread32/

  # whole sdb disk events:
  /sys/block/sdb/events/block_bio_complete/

  # sdb1 partition events:
  /sys/block/sdb/sdb1/events/block_bio_complete/

And we also have 'software nodes' in /sys that have events 
upstream here and today. For example for SLAB we already 
have kmalloc/kfree tracepoints (trace_kmalloc() and 
trace_kfree()):

  # all kmalloc events:
  /sys/kernel/slab/events/

  # kmalloc events for sighand_cache:
  /sys/kernel/slab/sighand_cache/events/kmalloc/

  # kfree events for sighand_cache:
  /sys/kernel/slab/sighand_cache/events/kfree/

In general the set of events we have upstream is growing 
along an exponential curve (there's over a hundred now, 
via tracepoints).

They are either logically attached to the hardware 
topology of the system (as in the first set of examples 
above), or ae attached to the software/subsystem object 
topology of the kernel (some examples of which are 
described in the second set of examples above).

Sometimes there are aliasing/filtering relationship 
between events, which is expressed very well via the 
hierarchy and granularity of /sysfs.

New events would go into that topology there in a natural 
way.

For example general hugepage tracepoints (should we 
introduce any) would go into the existing hugepage node:

  /sys/kernel/mm/hugepages/events/...

All in one, all these existing and future events, both of 
hardware and software type, are literally begging to be 
attached to nodes in /sys :-)

If we created a separate eventfs for it we'd have to start 
with duplicating all the topology/hiearchy/structure that 
is present in sysfs already. (and dilluting /sys's 
utility)

That would be a bad thing, so it would be nice if we found 
a workable solution here. We could split up the record 
format some more:

 /sys/kernel/sched/events/sched_wakeup/format/
 /sys/kernel/sched/events/sched_wakeup/format/common_type/
 /sys/kernel/sched/events/sched_wakeup/format/common_flags/
 /sys/kernel/sched/events/sched_wakeup/format/common_preempt_count/
 /sys/kernel/sched/events/sched_wakeup/format/common_pid/
 /sys/kernel/sched/events/sched_wakeup/format/common_lock_depth/
 /sys/kernel/sched/events/sched_wakeup/format/comm/
 /sys/kernel/sched/events/sched_wakeup/format/pid/
 /sys/kernel/sched/events/sched_wakeup/format/prio/
 /sys/kernel/sched/events/sched_wakeup/format/success/
 /sys/kernel/sched/events/sched_wakeup/format/target_cpu/

Into single-value files. But this would add significant 
parsing overhead (plus significant allocation overhead), 
for no tangible benefit.

The problem with /proc was always the lack of standard 
structure and the lack of performance - while the format 
file is about _more_ structure.

Increasing structure parsing overhead does not look like 
the right answer to that problem.

Hm?

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1GEJNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:13:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38646 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab1GEJNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:13:06 -0400
Date: Tue, 5 Jul 2011 11:12:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
Message-ID: <20110705091252.GA5725@elte.hu>
References: <20110703150430.GV4590@erda.amd.com>
 <1309716271.3282.6.camel@twins>
 <20110704175927.GZ4590@erda.amd.com>
 <1309855905.3282.42.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309855905.3282.42.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > Overall, my approach improves the perf design. It adds a better 
> > and more intuitve access to perf from user space with clear and 
> > common methods and interfaces. Please let me know the concerns 
> > you have.
> 
> Its redundant, this interface ship has sailed, its not going to 
> happen.

Even if we had the choice, i don't see how a /dev based enumeration 
of PMUs is in any way better than a topologically attached set of 
PMUs in /sys.

This kind of structure is nice in principle:

 # ls -l /dev/pmu/
 total 0
 crw-rw---- 1 root root 254, 5 Jul  8  2011 breakpoint
 crw-rw---- 1 root root 254, 4 Jul  8  2011 cpu
 crw-rw---- 1 root root 254, 6 Jul  8  2011 proto
 crw-rw---- 1 root root 254, 1 Jul  8  2011 software
 crw-rw---- 1 root root 254, 2 Jul  8  2011 tracepoint

But it should be done in /sys/. That way for example the graphics 
card:

  00:02.0 VGA compatible controller

should have its events under:

  /sys/devices/pci0000\:00/0000\:00\:02.0/events/

breakpoints could be listed in:

  /sys/devices/system/cpu/cpu0/events/

core kernel software events could be listed in:

  /sys/devices/system/core/events/

tracepoints could be listed in their respective subsystem directories:

  /sys/devices/system/timekeeping/events/    # timer tracepoints
  /sys/devices/system/machinecheck/events/   # the MCE tracepoint

  /sys/kernel/slab/events/                   # SLAB tracepoints

  /sys/kernel/debug/tracing/events/          # the old, legacy location of
                                             # tracepoint events

there should also be a /sys/class/events/ populated with symlinks to 
all their locations.

Then we could transition all events to their respective sysfs 
locations, where they would be easily discoverable and enumerable.

The events would also automatically move (and with time, be 
automatically added) when a new device is added to sysfs.

Peter, there was a patch (from you?) that started doing this kind of 
sysfs enumeration with a class added as well - do you still have it 
or do you have a link to it?

Thanks,

	Ingo

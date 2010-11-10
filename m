Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0KJOxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:53:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:54945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0KJOxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:53:17 -0500
Subject: Re: [RFC PATCH 2/2] perf stat: Use event group to simulate PMI on
 PMI-less hardware counter
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1289400319.2479.39.camel@localhost>
References: <1289369725.2430.39.camel@minggr.sh.intel.com>
	 <1289391709.2191.102.camel@laptop>  <1289400319.2479.39.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 15:53:04 +0100
Message-ID: <1289400784.2191.134.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 22:45 +0800, Lin Ming wrote:
> On Wed, 2010-11-10 at 20:21 +0800, Peter Zijlstra wrote:
> > On Wed, 2010-11-10 at 14:15 +0800, Lin Ming wrote:
> > > Some hardware counters(for example, Intel RAPL) can't generate interrupt
> > > when overflow. So we need to simulate the interrupt to periodically
> > > record the counter values. Otherwise, the counter may overflow and the
> > > wrong value is read.
> > > 
> > > This patch uses event group to simulate PMI as suggested by Peter
> > > Zijlstra, http://marc.info/?l=linux-kernel&m=128220854801819&w=2
> > > 
> > > create_group_counters() will create a group with 2 events, one hrtimer
> > > based event as the group leader, and the other event to count. The
> > > hrtimer is fired periodically, so the sibling event can record its
> > > counter value periodically as well.
> > 
> > I'm terribly confused here....
> > 
> >  - you introduce perf_event_attr:pmi_simulate, but then you never
> > implement it -- nor do we need it afaict.
> 
> Someone need to simluate pmi will use it in future.

Maybe, but simply adding an ABI just in case doesn't seem like a good
idea. The proposed idea was to group with a software hrtimer-based event
and use the hrtimer's sample to read the hardware group sibling using
PERF_SAMPLE_READ.

That should be possible using today's interface.

> > 
> > 
> >  - you use grouped counters for perf-stat, perf-stat doesn't use
> > sampling so I don't see a need to group events to simulate the PMI.
> > 
> 
> Aha, sorry, actually, I mean to periodically read the PMI-less counter
> and reset it to zero each time to avoid overflow.
> 
> Well, seems I have done this in the wrong way.
> Let me re-think about it.

Right, so you're wanting to avoid overflowing the hardware counter? This
is only a problem for short hardware counters without a pmi, SH and the
like currently cascade 2 32bit counters to create 64bit hardware
counters and avoid the overflow case that way.

Another thing they can do is simply use the system tick to fold the
32bit counters into a the 64bit counter.

Again, this doesn't need any changes to the ABI and generic code.




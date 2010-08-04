Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab0HDK4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:56:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46621 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab0HDK4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:56:20 -0400
Subject: Re: [PATCH 2/3] perf: Remove dead code in buildin-record.c
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <87hbjwzhak.fsf@linux-g6p1.site>
References: <4C241140.9090008@cn.fujitsu.com>
	 <4C24119B.60200@cn.fujitsu.com>  <20100625131356.GB4078@ghostprotocols.net>
	 <1277477285.32034.666.camel@twins> <87pqzd3jx5.fsf@linux-g6p1.site>
	 <87hbjwzhak.fsf@linux-g6p1.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 12:56:06 +0200
Message-ID: <1280919366.1923.985.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-18 at 21:06 +0100, Matt Fleming wrote:
> On Sat, 26 Jun 2010 16:14:46 +0100, Matt Fleming <matt@console-pimps.org> wrote:
> > On Fri, 25 Jun 2010 16:48:05 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > Ah, yes, it would be nice for SH (which doesn't have a PMI) to couple a
> > > software timer with their hardware counter to get samples.
> > > 
> > > Never got around to actually implementing that though, maybe Paul has a
> > > minion interested in making that work?
> > 
> > I'll take a look at it.
> 
> How does the 'group_fd' parameter relate to the lack of PMI? Is the idea
> to have one hrtimer that, when it fires, we sample all the counters? So
> the first counter to be created is the group leader, which starts the
> hrtimer, and all other counters are linked to this one? I had a go at
> using a hrtimer per counter (minus any weighting of samples) and it
> worked OK and seemed sensible given that we may want to sample counters
> at different frequencies.
> 
> Is this what you had in mind with the 'group_fd' paramter, Peter? That
> there'd be only one hrtimer?

Right. So sys_perf_event_open() creates a stand alone event, but if you
supply the group_fd param it will attach the newly created one to the
leader indicated by group_fd.

Groups have the properly that they will always be scheduled together,
and read/sample can access/provide data of all of them.

So you can have a sampling leader report the counts of its siblings.

You can make multiple groups, like {hrtimer, cycles} and {hrtimer,
instructions} and {hrtimer, dcache-miss} and perf will schedule the
stuff. If you'd try to do {hrtimer, cycles, insns, dcache-miss} but only
have 2 hardware counters the group creation should fail because the
implementation should dis-allow creating groups that cannot be
scheduled 



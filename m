Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab0HDLZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:25:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48957 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932618Ab0HDLZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:25:18 -0400
Date: Wed, 4 Aug 2010 12:25:17 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/3] perf: Remove dead code in buildin-record.c
Message-ID: <20100804112517.GB25587@console-pimps.org>
References: <4C241140.9090008@cn.fujitsu.com> <4C24119B.60200@cn.fujitsu.com> <20100625131356.GB4078@ghostprotocols.net> <1277477285.32034.666.camel@twins> <87pqzd3jx5.fsf@linux-g6p1.site> <87hbjwzhak.fsf@linux-g6p1.site> <1280919366.1923.985.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280919366.1923.985.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 12:56:06PM +0200, Peter Zijlstra wrote:
> On Sun, 2010-07-18 at 21:06 +0100, Matt Fleming wrote:
> > 
> > How does the 'group_fd' parameter relate to the lack of PMI? Is the idea
> > to have one hrtimer that, when it fires, we sample all the counters? So
> > the first counter to be created is the group leader, which starts the
> > hrtimer, and all other counters are linked to this one? I had a go at
> > using a hrtimer per counter (minus any weighting of samples) and it
> > worked OK and seemed sensible given that we may want to sample counters
> > at different frequencies.
> > 
> > Is this what you had in mind with the 'group_fd' paramter, Peter? That
> > there'd be only one hrtimer?
> 
> Right. So sys_perf_event_open() creates a stand alone event, but if you
> supply the group_fd param it will attach the newly created one to the
> leader indicated by group_fd.
> 
> Groups have the properly that they will always be scheduled together,
> and read/sample can access/provide data of all of them.

Ah, I think I see. The benefit of scheduling these events together is
that we can then sample the counters at roughly the same time? As
opposed to the case where we have multiple hrtimers firing and the
counter values will be from vastly different times? Yeah, that makes
sense now.

> So you can have a sampling leader report the counts of its siblings.
> 
> You can make multiple groups, like {hrtimer, cycles} and {hrtimer,
> instructions} and {hrtimer, dcache-miss} and perf will schedule the
> stuff. If you'd try to do {hrtimer, cycles, insns, dcache-miss} but only
> have 2 hardware counters the group creation should fail because the
> implementation should dis-allow creating groups that cannot be
> scheduled 

Right, so the hrtimer is an event all by itself: the parent event?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab1GRQMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:12:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56700 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1GRQL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:11:59 -0400
Subject: Re: [PATCH v2 2/6] perf, x86: Add Intel Nehalem/Westmere uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1311000892.2970.23.camel@localhost>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-3-git-send-email-ming.m.lin@intel.com>
	 <1310998851.13765.106.camel@twins>  <1311000892.2970.23.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Jul 2011 18:11:30 +0200
Message-ID: <1311005490.13765.151.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 22:54 +0800, Lin Ming wrote:
> > I guess we can start with this, there is still the issue of mapping the
> > events to a single active cpu in the node, but I guess we can do that a
> > little later.
> 
> Do we really need this mapping with uncore pmu interrupt disabled? 

Yes, because event scheduling is per-cpu. Suppose you've got 8 events, 7
on one cpu, 1 on another, all fits, everything is fine.

Now add an event to the cpu that has 1, at that point the new event
fails to fit on the cpu and that context ends up with nr_events !=
nr_active, and rotation starts.

Now instead of rotating between all 9 events, each getting 8/9 of the
time. It will only rotate the two events, resulting in 7 events that are
always on, and 2 that are on 50-50.

Also, consider cpu-hotplug, for as long as there is at least one core of
the node active, we can count all these events. But now, suppose we
unplug the core with the 7 counters on, they all die.

Anyway, we can fix that later once we get something working.

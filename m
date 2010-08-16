Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0HPRq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:46:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:57172 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0HPRqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:46:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,377,1278313200"; 
   d="scan'208";a="597058268"
Subject: Re: [patch 3/3] sched: move sched_avg_update() to update_cpu_load()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@frostnet.net" <chris@frostnet.net>,
        "debian00@aliceadsl.fr" <debian00@aliceadsl.fr>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jonathan.protzenko@gmail.com" <jonathan.protzenko@gmail.com>,
        "mans@mansr.com" <mans@mansr.com>,
        "psastudio@mail.ru" <psastudio@mail.ru>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stephan.eicher@web.de" <stephan.eicher@web.de>,
        "sxxe@gmx.de" <sxxe@gmx.de>,
        "thomas@archlinux.org" <thomas@archlinux.org>,
        "venki@google.com" <venki@google.com>,
        "wonghow@gmail.com" <wonghow@gmail.com>
In-Reply-To: <1281945634.1926.968.camel@laptop>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.999833492@sbsiddha-MOBL3.sc.intel.com>
	 <1281945634.1926.968.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 16 Aug 2010 10:46:09 -0700
Message-Id: <1281980769.2676.33.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 01:00 -0700, Peter Zijlstra wrote:
> On Fri, 2010-08-13 at 12:45 -0700, Suresh Siddha wrote:
> > plain text document attachment (move_sched_avg_update.patch)
> > Currently sched_avg_update() (which updates rt_avg stats in the rq) is getting
> > called from scale_rt_power() (in the load balance context) which doesn't take
> > rq->lock.
> 
> Right, but I think it doesn't need to, as its never accessed cross CPU
> (except maybe for /proc/sched_debug, and who cares about that).
> 
> The (other) odd case is NO_HZ idle balancing, but there the actual CPU
> won't be updating the fields, so the remote CPU doing NO_HZ idle
> balancing should be good to touch it.

There is no guarantee that the original cpu won't be doing this in
parallel with nohz idle load balancing cpu.

> 
> > Fix it by moving the sched_avg_update() to more appropriate update_cpu_load()
> > where the CFS load gets updated aswell.
> 
> Right, except it breaks things a bit, at the very least you really need
> that update right before reading it, otherwise you can end up with >100%
> fractions, which are odd indeed ;-)

with the patch, the update always happens before reading it. isn't it?

update now happens during the scheduler tick (or during nohz load
balancing tick). And the load balancer gets triggered with the tick.
So the update (at the tick) should happen before reading it (used by
load balancing triggered by the tick). Am I missing something?

thanks,
suresh



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0HPRgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:36:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:5649 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab0HPRgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:36:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,377,1278313200"; 
   d="scan'208";a="597055463"
Subject: Re: [patch 1/3] sched: init rt_avg stat whenever rq comes online
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
        "wonghow@gmail.com" <wonghow@gmail.com>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <1281944854.1926.948.camel@laptop>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.827207098@sbsiddha-MOBL3.sc.intel.com>
	 <1281944854.1926.948.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 16 Aug 2010 10:36:19 -0700
Message-Id: <1281980179.2676.22.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 00:47 -0700, Peter Zijlstra wrote:
> On Fri, 2010-08-13 at 12:45 -0700, Suresh Siddha wrote:
> > plain text document attachment (sched_reset_rt_avg_stat_online.patch)
> > TSC's get reset after suspend/resume and this leads to a scenario of
> > rq->clock (sched_clock_cpu()) less than rq->age_stamp. This leads
> > to a big value returned by scale_rt_power() and the resulting big group
> > power set by the update_group_power() is causing improper load balancing
> > between busy and idle cpu's after suspend/resume.
> 
> ARGH, so i[357] westmere mobile stops TSC on some power state?

WSM has working TSC with constant rate across P/C/T-states. This issue
is about suspend/resume (S-states).

> Why don't we sync it back to the other CPUs instead?

All the cpu's entered suspend state and during resume it gets reset for
all the CPU's.

> 
> Or does it simply mark TSCs unstable and leaves it at that?

TSCs are stable and in sync after resume aswell. If we want to do SW
sync, we need to keep track of the time we spent in the suspend state
and do a SW sync (during resume) that can potentially disturb the HW
sync.

> 
> In any case, this needs to be fixed at the clock level, not like this.

If we have more such dependencies on TSC then we may need to address the
issue at clock level aswell. Nevertheless, across cpu online/offline,
current scheduler code is expecting TSC (sched_clock) to be going
forward and not sure why we need to carry the rt_avg history across
online/offline.

thanks,
suresh


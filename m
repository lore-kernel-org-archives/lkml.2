Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0INLT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 07:19:59 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:44395 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0INLT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 07:19:57 -0400
Date: Tue, 14 Sep 2010 13:19:54 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
Message-ID: <20100914111954.GB2201@osiris.boeblingen.de.ibm.com>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
 <1284116817.402.33.camel@laptop>
 <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
 <1284196838.2251.12.camel@laptop>
 <AANLkTi=Vrd0g-64oRYLo6fTj1SYYa++VG57vGn608tkA@mail.gmail.com>
 <1284400941.2684.19.camel@sbsiddha-MOBL3.sc.intel.com>
 <1284451427.2275.462.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284451427.2275.462.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 10:03:47AM +0200, Peter Zijlstra wrote:
> On Mon, 2010-09-13 at 11:02 -0700, Suresh Siddha wrote:
> > On Sat, 2010-09-11 at 09:42 -0700, Venkatesh Pallipadi wrote:
> > > Also, as we don't have rq lock around this point, it seems possible
> > > that the CPU that was busy and wants to kick idle load balance on
> > > remote CPU, could have become idle and nominated itself as idle load
> > > balancer.
> > 
> > A busy cpu (currently running something -- one task on the rq atleast)
> > can't become idle in the middle of trigger_load_balance().
> > 
> > What might be happening is similar what you said but the opposite of it.
> > 
> > cpu-x is idle which is also ilb_cpu
> > got a scheduler tick during idle
> > and the nohz_kick_needed() in trigger_load_balance() checks for
> > rq_x->nr_running which might not be zero (because of someone waking a
> > task on this rq etc) and this leads to the situation of the cpu-x
> > sending a kick to itself.
> 
> So what patches are we going to merge?
> 
> I share Heiko's opinion on that its somewhat surprising to have
> __smp_call_function_single() differ in this detail from
> smp_call_function_single() and think that merging his patch would be
> good in that respect. But Andrew seemed to have reservations.
> 
> We can also merge either my or Suresh's patch (which I think makes
> sense, but is kinda subtle) to avoid the needless self kick.

I would prefer to see your's or Suresh's scheduler patch to be merged to
fix the bug.
My patch could be merged for 2.6.37 or be dropped in favour of a WARN_ON
in __smp_call_function_single() if remote cpu == current cpu.
However I think it would be better if smp_call_function_single() and
__smp_call_function_single() wouldn't differ here.

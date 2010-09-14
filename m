Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0INIEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:04:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0INIEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 04:04:00 -0400
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1284400941.2684.19.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
	 <1284116817.402.33.camel@laptop>
	 <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
	 <1284196838.2251.12.camel@laptop>
	 <AANLkTi=Vrd0g-64oRYLo6fTj1SYYa++VG57vGn608tkA@mail.gmail.com>
	 <1284400941.2684.19.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Sep 2010 10:03:47 +0200
Message-ID: <1284451427.2275.462.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 11:02 -0700, Suresh Siddha wrote:
> On Sat, 2010-09-11 at 09:42 -0700, Venkatesh Pallipadi wrote:
> > Also, as we don't have rq lock around this point, it seems possible
> > that the CPU that was busy and wants to kick idle load balance on
> > remote CPU, could have become idle and nominated itself as idle load
> > balancer.
> 
> A busy cpu (currently running something -- one task on the rq atleast)
> can't become idle in the middle of trigger_load_balance().
> 
> What might be happening is similar what you said but the opposite of it.
> 
> cpu-x is idle which is also ilb_cpu
> got a scheduler tick during idle
> and the nohz_kick_needed() in trigger_load_balance() checks for
> rq_x->nr_running which might not be zero (because of someone waking a
> task on this rq etc) and this leads to the situation of the cpu-x
> sending a kick to itself.

So what patches are we going to merge?

I share Heiko's opinion on that its somewhat surprising to have
__smp_call_function_single() differ in this detail from
smp_call_function_single() and think that merging his patch would be
good in that respect. But Andrew seemed to have reservations.

We can also merge either my or Suresh's patch (which I think makes
sense, but is kinda subtle) to avoid the needless self kick.

Hmm?

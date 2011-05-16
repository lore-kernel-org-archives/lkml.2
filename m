Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1EPIeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:34:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:27884 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab1EPIeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:34:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,373,1301900400"; 
   d="scan'208";a="436703613"
Subject: Re: [patch V3] percpu_counter: scalability works
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305531877.3120.230.camel@edumazet-laptop>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
	 <1305190520.2373.18.camel@sli10-conroe>
	 <20110512085922.GD1030@htj.dyndns.org>
	 <1305190936.3795.1.camel@edumazet-laptop>
	 <20110512090534.GE1030@htj.dyndns.org>
	 <1305261477.2373.45.camel@sli10-conroe>
	 <1305264007.2831.14.camel@edumazet-laptop>
	 <20110513052859.GA11088@sli10-conroe.sh.intel.com>
	 <1305268456.2831.38.camel@edumazet-laptop>
	 <1305298300.3866.22.camel@edumazet-laptop>
	 <1305301151.3866.39.camel@edumazet-laptop>
	 <1305304532.3866.54.camel@edumazet-laptop>
	 <1305305190.3866.57.camel@edumazet-laptop>
	 <1305324187.3120.30.camel@edumazet-laptop>
	 <1305507517.2375.10.camel@sli10-conroe>
	 <1305526296.3120.204.camel@edumazet-laptop>
	 <1305527828.2375.28.camel@sli10-conroe>
	 <1305528912.3120.213.camel@edumazet-laptop>
	 <1305530143.2375.42.camel@sli10-conroe>
	 <1305531877.3120.230.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 16:34:17 +0800
Message-ID: <1305534857.2375.55.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 15:44 +0800, Eric Dumazet wrote:
> Le lundi 16 mai 2011 à 15:15 +0800, Shaohua Li a écrit :
> 
> > I can, but you can't prevent me to optimize percpu_counter.
> > 
> 
> Well, I have the right to say you're wrong.
sure, but please give a reason.

> Your last patch is not good, sorry. 
> Please take the time to read it
> again and fix obvious problems.
what kind of obvious problems?

> And also give us numbers if one process
> does the mmap()/munmap() loop, before and after your patch.
I did a stress test with one thread

while {
__percpu_counter_add(+count)
__percpu_counter_add(-count)
}
the loop do 10000000 times.
in _add fast path (no locking hold):
before my patch:
real    0m0.133s
user    0m0.000s
sys     0m0.124s
after:
real    0m0.129s
user    0m0.000s
sys     0m0.120s
the difference is variation.

in _add slow path (locking hold):
before my patch:
real    0m0.374s
user    0m0.000s
sys     0m0.372s
after:
real    0m0.245s
user    0m0.000s
sys     0m0.020s

My patch actually makes _add faster, because we removed spin_lock.

> A percpu_counter is already a beast as is, you're suggesting to double
> its size, for a pathological case.
> 
> Its absolutely not clear to me why vm_committed_as is using the default
> percpu_counter_batch. 
> 
> By the way could you make sure percpu_counter_batch has the right value
> on your 24 cpus machine ?
> 
> Your 128Mbyte mmap threshold sounds like percpu_counter_batch=32 instead
> of 48
let's not argue the batch size anymore. If we can make percpu_counter
faster, why we don't (even your patch mentioned this).

Thanks,
Shaohua


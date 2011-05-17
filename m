Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab1EQFWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 01:22:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:22565 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab1EQFWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 01:22:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,223,1304319600"; 
   d="scan'208";a="2604105"
Subject: Re: [patch V3] percpu_counter: scalability works
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305608212.9466.45.camel@edumazet-laptop>
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
	 <1305534857.2375.55.camel@sli10-conroe>
	 <1305538504.2898.33.camel@edumazet-laptop>
	 <1305555736.2898.46.camel@edumazet-laptop>
	 <1305593751.2375.69.camel@sli10-conroe>
	 <1305608212.9466.45.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 13:22:48 +0800
Message-ID: <1305609768.2375.84.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 12:56 +0800, Eric Dumazet wrote:
> Le mardi 17 mai 2011 à 08:55 +0800, Shaohua Li a écrit :
> 
> > I'm still interesting in improving percpu_counter itself. If we can
> > improve it, why we don't? My patch doesn't slow down anything for all
> > tests. Why didn't you ever look at it?
> > 
> 
> I did and said there were obvious problems in it.
> 
> 1) 4096 cpus : size of one percpu_counter is 16Kbytes.
> 
> After your last patch -> 20 kbytes for no good reason.
I don't know why you said there is no good reason. I posted a lot of
data which shows improvement, while you just ignore.

The size issue is completely pointless. If you have 4096 CPUs, how could
you worry about 16k bytes memory. Especially the extra memory makes the
API much faster.

> 2) Two separate alloc_percpu() -> two separate cache lines instead of
> one.
Might be in one cache line actually, but can be easily fixed if not
anyway. On the other hand, even touch two cache lines, it's still faster
than the original spinlock implementation, which I already posted data.

> But then, if one alloc_percpu() -> 32 kbytes per object.
the size issue is completely pointless

> 3) Focus on percpu_counter() implementation instead of making an
> analysis of callers.
> 
> I did a lot of rwlocks removal in network stack because they are not the
> right synchronization primitive in many cases. I did not optimize
> rwlocks. If rwlocks were even slower, I suspect other people would have
> help me to convert things faster.
My original issue is mmap, but I already declaimed several times we can
make percpu_counter better, why won't we?

> 4) There is a possible way to solve your deviation case : add at _add()
> beginning a short cut for crazy 'amount' values. Its a bit expensive on
> 32bit arches, so might be added in a new helper to let _add() be fast
> for normal and gentle users.

+		if (unlikely(cmpxchg(ptr, old, 0) != old))
> +			goto retry;
this doesn't change anything, you still have the deviation issue here

> +		atomic64_add(count, &fbc->count);

> if (unlikely(amount >= batch || amount <= -batch)) {
> 	atomic64(amount, &fbc->count);
> 	return;
> }
why we just handle this special case, my patch can make the whole part
faster without deviation

so you didn't point out any obvious problem with my patch actually. This
is good.

Thanks,
Shaohua


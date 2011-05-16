Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab1EPHPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:15:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:48091 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab1EPHPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:15:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,373,1301900400"; 
   d="scan'208";a="747730087"
Subject: Re: [patch V3] percpu_counter: scalability works
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305528912.3120.213.camel@edumazet-laptop>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 15:15:43 +0800
Message-ID: <1305530143.2375.42.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 14:55 +0800, Eric Dumazet wrote:
> Le lundi 16 mai 2011 à 14:37 +0800, Shaohua Li a écrit :
> > On Mon, 2011-05-16 at 14:11 +0800, Eric Dumazet wrote:
> > > Le lundi 16 mai 2011 à 08:58 +0800, Shaohua Li a écrit :
> > > 
> > > > so if _sum starts and ends here, _sum can still get deviation.
> > > 
> > > This makes no sense at all. If you have so many cpus 'here' right before
> > > you increment fbc->sum_cnt, then no matter how precise and super
> > > cautious you are in your _sum() implementation, as soon as you exit from
> > > sum(), other cpus already changed the percpu counter global value.
> > I don't agree here. The original implementation also just has quite
> > small window we have deviation, the window only exists between the two
> > lines:
> > 		atomic64_add(count, &fbc->count);
> > 	        __this_cpu_write(*fbc->counters, 0);
> > if you think we should ignore it, we'd better not use any protection
> > here.
> > 
> 
> Not at all. Your version didnt forbid new cpu to come in _add() and
> hitting the deviation problem.
if everybody agrees the deviation isn't a problem, I will not bother to
argue here.
but your patch does have the deviation issue which Tejun dislike.


> There is a small difference, or else I wouldnt had bother.
in _sum, set a bit. in _add, we wait till the bit is unset. This can
easily solve the issue too, and much easier.

> > as I wrote in the email, the atomic and cacheline issue can be resolved
> > with a per_cpu data, I just didn't post the patch. I post it this time,
> > please see below. There is no cache line bounce anymore.
> > 
> 
> I am afraid we make no progress at all here, if you just try to push
> your patch and ignore my comments.
I did try to push my patch, but I didn't ignore your comments. I pointed
out your patch still has the deviation issue and you didn't think it's
an issue, so you are ignoring my comments actually. On the other hand, I
push my patch because I thought mine hasn't the deviation.

> percpu_counter is a compromise, dont make it too slow for normal
> operations. It works well if most _add() operations only go through
> percpu data.
> 
> Please just move vm_committed_as to a plain atomic_t, this will solve
> your problem.
I can, but you can't prevent me to optimize percpu_counter.

Thanks,
Shaohua


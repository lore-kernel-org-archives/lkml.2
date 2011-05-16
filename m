Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab1EPGzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 02:55:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33114 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1EPGzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 02:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YKI1KXdGXArA52LT8dX3YEvsp7CkLa82h5I+Mi78GoVaJ7tQNA5sc/gVAwfBH+zbHQ
         Vf35uac7KjHj7+ZLzHG1lL3UO0JKEm/LjiaDNVIIR8vor5cdpiJKB6Q+lK8D8tsM3nkL
         lnvc7HAo+MSsXQJr3kGgs4dHzMfPFLNYmxI0s=
Subject: Re: [patch V3] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305527828.2375.28.camel@sli10-conroe>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 08:55:12 +0200
Message-ID: <1305528912.3120.213.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 mai 2011 à 14:37 +0800, Shaohua Li a écrit :
> On Mon, 2011-05-16 at 14:11 +0800, Eric Dumazet wrote:
> > Le lundi 16 mai 2011 à 08:58 +0800, Shaohua Li a écrit :
> > 
> > > so if _sum starts and ends here, _sum can still get deviation.
> > 
> > This makes no sense at all. If you have so many cpus 'here' right before
> > you increment fbc->sum_cnt, then no matter how precise and super
> > cautious you are in your _sum() implementation, as soon as you exit from
> > sum(), other cpus already changed the percpu counter global value.
> I don't agree here. The original implementation also just has quite
> small window we have deviation, the window only exists between the two
> lines:
> 		atomic64_add(count, &fbc->count);
> 	        __this_cpu_write(*fbc->counters, 0);
> if you think we should ignore it, we'd better not use any protection
> here.
> 

Not at all. Your version didnt forbid new cpu to come in _add() and
hitting the deviation problem.

There is a small difference, or else I wouldnt had bother.


> as I wrote in the email, the atomic and cacheline issue can be resolved
> with a per_cpu data, I just didn't post the patch. I post it this time,
> please see below. There is no cache line bounce anymore.
> 

I am afraid we make no progress at all here, if you just try to push
your patch and ignore my comments.

percpu_counter is a compromise, dont make it too slow for normal
operations. It works well if most _add() operations only go through
percpu data.

Please just move vm_committed_as to a plain atomic_t, this will solve
your problem.

Thanks



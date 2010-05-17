Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0EQRf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:35:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:44481 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab0EQRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:35:25 -0400
Subject: Re: [PATCH] sched: Avoid side-effect of tickless idle on 
 update_cpu_load (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>,
       Nikhil Rao <ncrao@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <AANLkTikWWEYpwmqhQ0oYz30SUFY-y2erqStw2T6h0WXg@mail.gmail.com>
References: <1273886490-15627-1-git-send-email-venki@google.com>
	 <1274084399.5605.3655.camel@twins>
	 <AANLkTikWWEYpwmqhQ0oYz30SUFY-y2erqStw2T6h0WXg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 19:35:17 +0200
Message-ID: <1274117717.1674.1539.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 09:52 -0700, Venkatesh Pallipadi wrote:

> >  load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * load_(i-1)

> > So because we're in no_hz, current load == 0 and we could approximate
> > the thing by:
> >
> >  load_i = ((2^i)-1)/(2^i) * load_i
> >
> > Because for i ~ 1, there is no new input, and for i >> 1 the fraction is
> > small.
> 
> Something like that. But, with total_updates = n and missed_updates = n - 1
> We do this for (n - 1)
> load_i = ((2^i)-1)/(2^i) * load_i
> And do this once.
> load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * cur_load

> That way we do not differentiate between whether we are in tickless or
> not and we use the same code path.

But by the above, that's not the same as without, because that does

load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * load_(i-1)

not

load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * cur_load

> > But why then do we precalculate these factors? It seems to me
> > ((2^i)-1)/(2^i) is something that is trivial to compute and doesn't
> > warrant a lookup table?
> >
> 
> Yes. Initially I had a for loop running for missed_updates to calculate
>  ((2^i)-1)/(2^i) * load_i
> in a loop.

Ah, right! So you want to calculate:

 (((2^i)-1)/(2^i))^n

Which ends up being a nasty binomial sum: 1/(2^ni) * \Sum_k^n (n choose
k) * 2^k, so yeah, I don't see a fancy way to quickly compute that.


OK, could you summarize our discussion into that comment?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1ERU1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:27:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49035 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab1ERU05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:26:57 -0400
Date: Wed, 18 May 2011 22:26:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Subject: Re: [PATCH v2 3/3] sched: increase SCHED_LOAD_SCALE resolution
Message-ID: <20110518202646.GA14141@elte.hu>
References: <BANLkTinHZpgqe0DjBrya--J+xFE=ksv9CQ@mail.gmail.com>
 <1305747683-16742-1-git-send-email-ncrao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305747683-16742-1-git-send-email-ncrao@google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikhil Rao <ncrao@google.com> wrote:

> +#if BITS_PER_LONG > 32
> +# define SCHED_LOAD_RESOLUTION	10
> +# define scale_load(w)		(w << SCHED_LOAD_RESOLUTION)
> +# define scale_load_down(w)	(w >> SCHED_LOAD_RESOLUTION)
> +#else
> +# define SCHED_LOAD_RESOLUTION	0
> +# define scale_load(w)		(w)
> +# define scale_load_down(w)	(w)
> +#endif

We want (w) in the other definitions as well, to protect potential operators 
with lower precedence than <<. (Roughly half of the C operators are such so 
it's a real issue, should anyone use these macros with operators.)

> +#define SCHED_LOAD_SHIFT	(10 + (SCHED_LOAD_RESOLUTION))

that () is not needed actually, if you look at the definition of 
SCHED_LOAD_RESOLUTION.

So you could move the superfluous () from here up to the two definitions above 
and thus no parentheses would be hurt during the making of this patch.

> +		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
>  			lw->inv_weight = 1;
> +		else if (unlikely(!w))
> +			lw->inv_weight = WMULT_CONST;
>  		else
> +			lw->inv_weight = WMULT_CONST / w;

Ok, i just noticed that you made use of BITS_PER_LONG here too.

It's better to put that into a helper define, something like 
SCHED_LOAD_HIGHRES, which could thus be used like this:

		if (SCHED_LOAD_HIGHRES && unlikely(w >= WMULT_CONST))

then, should anyone want to tweak the condition for SCHED_LOAD_HIGHRES, it 
could be done in a single place. It would also self-document.

Thanks,

	Ingo

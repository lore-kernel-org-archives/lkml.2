Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445Ab1ERSZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:25:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58517 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393Ab1ERSZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:25:35 -0400
Date: Wed, 18 May 2011 20:25:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Subject: Re: [PATCH v2 3/3] sched: increase SCHED_LOAD_SCALE resolution
Message-ID: <20110518182519.GB25881@elte.hu>
References: <1305738580-9924-1-git-send-email-ncrao@google.com>
 <1305738580-9924-4-git-send-email-ncrao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305738580-9924-4-git-send-email-ncrao@google.com>
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

> -#define SCHED_LOAD_SHIFT	10
> +#if BITS_PER_LONG > 32
> +#define SCHED_LOAD_RESOLUTION	10
> +#define scale_load(w)		(w << SCHED_LOAD_RESOLUTION)
> +#define scale_load_down(w)	(w >> SCHED_LOAD_RESOLUTION)
> +#else
> +#define SCHED_LOAD_RESOLUTION	0
> +#define scale_load(w)		w
> +#define scale_load_down(w)	w
> +#endif

Please use the:

#if X
# define Y A
#else
# define Y B
#endif

type of nested CPP branching style.

Also, the 'w' probably wants to be '(w)', just in case.

>  	if (!lw->inv_weight) {
> -		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
> +		unsigned long w = scale_load_down(lw->weight);
> +		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
>  			lw->inv_weight = 1;

Please separate local variable declarations and the first statement following 
it by an extra empty line.

Could you also put all the performance measurement description into the 
changelog of this third commit - so that people can see (and enjoy) the 
extensive testing you have done on this topic?

Thanks,

	Ingo

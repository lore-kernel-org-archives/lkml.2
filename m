Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1DGWiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:38:11 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:36501 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756174Ab1DGWiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:38:09 -0400
From: Kevin Hilman <khilman@ti.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <lenb@kernel.org>, Nicole Chalhoub <n-chalhoub@ti.com>,
        Vincent Bour <v-bour@ti.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] nohz: delay going tickless under CPU load to favor deeper C states
Organization: Texas Instruments, Inc.
References: <1302200311-24263-1-git-send-email-khilman@ti.com>
	<4D9E1712.5090600@linux.intel.com>
Date: Thu, 07 Apr 2011 15:38:04 -0700
In-Reply-To: <4D9E1712.5090600@linux.intel.com> (Arjan van de Ven's message of
	"Thu, 07 Apr 2011 12:57:06 -0700")
Message-ID: <87k4f5662b.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

Arjan van de Ven <arjan@linux.intel.com> writes:

> On 4/7/2011 11:18 AM, Kevin Hilman wrote:
>> From: Nicole Chalhoub<n-chalhoub@ti.com>
>>
>> While there is CPU load, continue the periodic tick in order to give
>> CPUidle another opportunity to pick a deeper C-state instead of
>> spending potentially long i
>
>
> so I don't really like this patch. It's actually a pretty bad hack
> (I'm sure it'll work somewhat)
> [and I mean that in the most positive sense of the word ;-) ]

I'll take it as a complement then. :)

I agree though, it did feel somewhat like we were attempting to fix the
problem in the wrong place.

> what we really need instead, and this is inside cpuidle, is the option
> to set a timer when we enter the non-deepest C state,
> so that if that timer fires we then reevaluate.
> The duration of that timer will be dependent on the C state (so should
> come from the C state structure of the state we pick).

OK, this sounds like a good idea.  Will experiment.

Of course, setting new timers can affect the governors decision.  To
avoid that, I guess this timer will need to be one-shot, and only set
after the CPUidle governor has made a decision, otherwise that timer
itself will affect tick_nohz_get_sleep_length() which the governor uses
to pick a C-state.

> For the most shallow one this will be a relatively short time, but for
> the deepest-but-one this might be a lot longer time.
>
> your patch abuses a completely different, unrelated timer for this,
> with a pretty much unspecified frequency, that also has other side
> effects that we probably don't want.

What side effects come to mind?  The only side effects that I could
think of were (potentially) unwanted wakeups from C1.  However, since C1
is presumably cheap to enter (and exit), it seemed like a worthwhile
cost since you're almost certain to pick a deeper C state after wakeup.

That being said, your idea of per C-state timer is much better than
relying on the scheduler tick.  On most ARM systems, HZ is still pretty
low (around 100), the time between ticks is relatively long, but on a
HZ=1000 setup, I could see the extra wakeups having a penalty of their
own.

> it shouldn't be hard to do the right thing instead and make it a
> separate timer with a per C state timeout.

Agreed.  Will give it a try.

> (and I would say a default timeout of 10x the break even time that we
> already have in the structure)

OK.

Thanks for the review and suggestions,

Kevin

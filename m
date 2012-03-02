Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab2CBHiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:38:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37438 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab2CBHiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:38:52 -0500
Date: Fri, 2 Mar 2012 08:38:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 4/9] time: Update timekeeper structure using a local
 shadow
Message-ID: <20120302073848.GB32401@elte.hu>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
 <1330672368-32290-5-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330672368-32290-5-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* John Stultz <john.stultz@linaro.org> wrote:

> Uses a local shadow structure to update the timekeeper. This
> will allow for reduced timekeeper.rlock hold time.
> 
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/time/timekeeping.c |   43 +++++++++++++++++++++++--------------------
>  1 files changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index f9ee96c..09460c1 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -74,6 +74,7 @@ struct timekeeper {
>  };
>  
>  static struct timekeeper timekeeper;
> +static struct timekeeper shadow_tk;

Sigh.

As I said it in the first round of review, it's fundamentally 
wrong to copy live fields like locks or the clocksource pointer 
around.

It's doubly wrong to do it in a global variable that no-one else 
but the copying function (update_wall_time()) is supposed to 
access.

There are over a dozen fields in 'struct timekeeper' - exactly 
which ones of them are used on this private copy, as 
update_wall_time() does the cycle accumulation and calls down 
into timkeeping_adjust()?

The right solution would be to separate timekeeping time state 
from global state:

struct timekeeper {
	spinlock_t		lock;

	struct time_state	time_state;
};

And then standardize the time calculation code on passing around 
not 'struct timekeeper *' but 'struct time_state *' ! Then you 
can have a local shadow copy of the global state:

	struct time_state time_state_copy;

and copy it from the global one and then pass it down to 
calculation functions.

This also gives the freedom to add other global state fields 
beyond the lock. (Right now the lock appears to be the only 
global state field - there might be more.)

Thanks,

	Ingo

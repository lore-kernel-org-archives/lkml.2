Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0LGN35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 08:29:57 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:42652 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0LGN34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 08:29:56 -0500
Date: Tue, 7 Dec 2010 14:29:51 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] "perf top" results in "NOHZ: local_softirq_pending 100"
Message-ID: <20101207132951.GB10927@osiris.boeblingen.de.ibm.com>
References: <20101207124448.GA10927@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207124448.GA10927@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 01:44:48PM +0100, Heiko Carstens wrote:
> While playing around with perf I realized that "perf top" immediatly results
> in a "NOHZ: local_softirq_pending 100" message to the console.
> 
> 0x100 means that a HRTIMER_SOFTIRQ is pending when the cpu tries to disable
> the tick.
> In perf_event.c we have a call to __hrtimer_start_range_ns() in
> perf_swevent_start_hrtimer() where its wakeup parameter is zero.
> __hrtimer_start_range_ns() in turn will call hrtimer_enqueue_reprogram()
> which will call __raise_softirq_irqoff(HRTIMER_SOFTIRQ) (since wakeup is
> zero).
> That means that just the HRTIMER_SOFTIRQ bit gets set in the softirq
> pending field, but wakeup_softirqd() doesn't get called.
> 
> As far as I could see this function gets called from process context with
> a spinlock held and hence we don't have any guarantee that this pending
> softirq get executed before the idle task gets scheduled and tries to
> disable the tick.
> 
> The easiest fix would be to set wakeup to one (see patch below), but I guess
> there is a reason why its zero. Anybody?
> 
> ---
>  kernel/perf_event.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index eac7e33..958b3e0 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4942,7 +4942,7 @@ static void perf_swevent_start_hrtimer(struct perf_event *event)
>  		}
>  		__hrtimer_start_range_ns(&hwc->hrtimer,
>  				ns_to_ktime(period), 0,
> -				HRTIMER_MODE_REL_PINNED, 0);
> +				HRTIMER_MODE_REL_PINNED, 1);

Ah. With this patch "perf record" might deadlock.
That's the reason why wakeup is zero. Tough luck.

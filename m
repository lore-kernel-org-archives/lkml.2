Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2AIKGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:06:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:39045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2AIKGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:06:34 -0500
Message-ID: <1326103578.2442.50.camel@twins>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, akpm@linux-foundation.org, stable@vger.kernel.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com, len.brown@intel.com,
        anhua.xu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Date: Mon, 09 Jan 2012 11:06:18 +0100
In-Reply-To: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 16:56 +0800, Youquan Song wrote:
> sched_smt_power_savings is totally broken at lastest linux and -tip tree.

Yes it is.. also that knob should die! Like i've been saying for way too
long. I'm >< close to committing a patch removing all the power_saving
magic from the scheduler.

> sched_smt_power_savings is set to 1, the scheduler tries to schedule processes
>  on the least number of hyper-threads on a core as possible. In other words, 
> the process load is distributed such that all the hyper-threads in a core and 
> all the cores within the same processor are busy before the load is distributed
>  to other hyper-threads and cores in another processor. 

That's the most convoluted way I've seen that stated in a while. What
you're saying is that all threads (of a socket) should be used before
spilling over to another socket.

> This patch will set SMT sibling power capability to SCHED_POWER_SCALE
> (1024) when sched_smt_power_savings set. So when there is possible do power
> saving during scheduling, scheduler will truly schedule processes as
> sched_smt_power_savings should do.
>  
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> Tested-by: Anhua Xu <anhua.xu@intel.com>
> ---
>  kernel/sched/fair.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index a4d2b7a..5be1d43 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3715,6 +3715,9 @@ unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
>  	unsigned long weight = sd->span_weight;
>  	unsigned long smt_gain = sd->smt_gain;
>  
> +	if (sched_smt_power_savings)
> +		return SCHED_POWER_SCALE;
> +
>  	smt_gain /= weight;
>  
>  	return smt_gain;

Hell no, that's completely the wrong thing to do. I think you want to
frob at the group_capacity computation in update_sg_lb_stats.


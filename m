Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0I1XFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 19:05:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:29776 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab0I1XFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 19:05:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,249,1283756400"; 
   d="scan'208";a="611365027"
Subject: Re: [PATCH 2/3] sched: drop group_capacity to 1 only if remote
 group has no running tasks
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Venkatesh Pallipadi <venki@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1285633798-26886-3-git-send-email-ncrao@google.com>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
	 <1285633798-26886-3-git-send-email-ncrao@google.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 28 Sep 2010 16:04:56 -0700
Message-Id: <1285715096.2623.37.camel@sbsiddha-MOBL3>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 17:29 -0700, Nikhil Rao wrote:
> When SD_PREFER_SIBLING is set on a sched domain, drop group_capacity to 1
> only if the remote sched group has no running tasks. This addresses the case
> where you have two tasks on one socket and the other socket is idle, in which
> case you drop the capacity to 1. If the remote group has >=1 running task, then
> there is no difference from a cache-sharing perspective.
> 
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> ---
>  kernel/sched_fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index de8a6a0..33a7985 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -2548,7 +2548,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>  		 * first, lower the sg capacity to one so that we'll try
>  		 * and move all the excess tasks away.
>  		 */
> -		if (prefer_sibling)
> +		if (prefer_sibling && !sgs.sum_nr_running)
>  			sgs.group_capacity = min(sgs.group_capacity, 1UL);
>  
>  		if (local_group) {

Nikhil, Doesn't this break the case of:

two sockets with dual-core and HT. Four tasks currently scheduled as:
three on socket-0 (two threads on core-0 running two tasks and 1 thread
on core-1 running one task). One on socket-1 (one thread on core-0
running a task, with other core-1 idle)

We would like to move the task from core-0 socket-0 to core-1 socket-1,
while we are load balancing at the socket level (it might be smp or numa
level depending on system).

thanks,
suresh


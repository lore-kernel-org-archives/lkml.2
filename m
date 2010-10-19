Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab0JSEiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:38:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41797 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0JSEiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 00:38:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v2.6.36-rc7] memory_hotplug: drop spurious calls to flush_scheduled_work()
Cc: kosaki.motohiro@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>
In-Reply-To: <20101018094403.GW30667@csn.ul.ie>
References: <4CB8725B.9010200@kernel.org> <20101018094403.GW30667@csn.ul.ie>
Message-Id: <20101019133750.A1E6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Oct 2010 13:38:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Oct 15, 2010 at 05:25:15PM +0200, Tejun Heo wrote:
> > lru_add_drain_all() uses schedule_on_each_cpu() which is synchronous.
> > There is no reason to call flush_scheduled_work() after
> > lru_add_drain_all().  Drop the spurious calls.
> > 
> 
> This looks correct.
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> 
> I suspect this call to flush_scheduled_work() existed because it is easy
> to interpret the documentation of schedule_on_each_cpu to mean it is an
> asynchronous call.  Maybe something like the following?
> 
> ==== CUT HERE ====
> workqueue: Clarify that schedule_on_each_cpu is synchronous
> 
> The documentation for schedule_on_each_cpu() states that it calls a function
> on each online CPU from keventd. This can easily be interpreted as an
> asyncronous call because the description does not mention that flush_work
> is called. Clarify that it is synchronous.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  kernel/workqueue.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index f77afd9..07cba1e 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2592,13 +2592,15 @@ int schedule_delayed_work_on(int cpu,
>  EXPORT_SYMBOL(schedule_delayed_work_on);
>  
>  /**
> - * schedule_on_each_cpu - call a function on each online CPU from keventd
> + * schedule_on_each_cpu - Call a function on each online CPU via keventd and wait for completion
>   * @func: the function to call
>   *
> + * schedule_on_each_cpu executes a given callback function on each CPU via keventd
> + * and blocks until each callback has completed. schedule_on_each_cpu() is very
> + * slow.
> + *
>   * Returns zero on success.
>   * Returns -ve errno on failure.
> - *
> - * schedule_on_each_cpu() is very slow.

Nice!
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




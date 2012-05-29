Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2E2QM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:12:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:58158 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab2E2QM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:12:56 -0400
Message-ID: <1338307942.26856.111.camel@twins>
Subject: Re: [PATCH 22/35] autonuma: sched_set_autonuma_need_balance
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Date: Tue, 29 May 2012 18:12:22 +0200
In-Reply-To: <1337965359-29725-23-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-23-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
> Invoke autonuma_balance only on the busy CPUs at the same frequency of
> the CFS load balance.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  kernel/sched/fair.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 99d1d33..1357938 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4893,6 +4893,9 @@ static void run_rebalance_domains(struct softirq_action *h)
>  
>  	rebalance_domains(this_cpu, idle);
>  
> +	if (!this_rq->idle_balance)
> +		sched_set_autonuma_need_balance();
> +

This just isn't enough.. the whole thing needs to move out of
schedule(). The only time schedule() should ever look at another cpu is
if its idle.

As it stands load-balance actually takes too much time as it is to live
in a softirq, -rt gets around that by pushing all softirqs into a thread
and I was thinking of doing some of that for mainline too.



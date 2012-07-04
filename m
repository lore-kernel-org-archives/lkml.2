Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2GDPdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:33:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:43409 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2GDPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:33:05 -0400
Subject: Re: [PATCH 01/16] sched: track the runnable average on a per-task
 entitiy basis
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <20120628022414.30496.98256.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	 <20120628022414.30496.98256.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 17:32:54 +0200
Message-ID: <1341415974.19870.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 19:24 -0700, Paul Turner wrote:
> Instead of tracking averaging the load parented by a cfs_rq, we can track
> entity load directly.  With the load for a given cfs_Rq then being the sum of
> its children.
> 
> To do this we represent the historical contribution to runnable average within each
> trailing 1024us of execution as the coefficients of a geometric series.
> 
> We can express this for a given task t as:
>   runnable_sum(t) = \Sum u_i * y^i ,
>   load(t) = weight_t * runnable_sum(t) / (\Sum 1024 * y^i)
> 
> Where: u_i is the usage in the last i`th 1024us period (approximately 1ms) ~ms
> and y is chosen such that y^k = 1/2.  We currently choose k to be 32 which
> roughly translates to about a sched period.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> ---
>  include/linux/sched.h |    8 +++
>  kernel/sched/debug.c  |    4 ++
>  kernel/sched/fair.c   |  128 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 140 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 9dced2e..5bf5c79 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1136,6 +1136,11 @@ struct load_weight {
>         unsigned long weight, inv_weight;
>  };
>  
> +struct sched_avg {
> +       u32 runnable_avg_sum, runnable_avg_period;
> +       u64 last_runnable_update;
> +}; 


So we can use u32 because:

             n         1 
lim n->inf \Sum y^i = --- = ~ 46.66804636511427012122 ; y^32 = 0.5
             i=0      1-y

So the values should never be larger than ~47k, right?

/me goes add something like that in a comment.


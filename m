Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab1FGK05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:26:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:42677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1FGK04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:26:56 -0400
Subject: Re: [PATCH] sched: remove rcu_read_lock from wake_affine
From: Peter Zijlstra <peterz@infradead.org>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20110607101251.777.34547.stgit@IBM-009124035060.in.ibm.com>
References: <20110607101251.777.34547.stgit@IBM-009124035060.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 12:26:51 +0200
Message-ID: <1307442411.2322.246.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 15:43 +0530, Nikunj A. Dadhania wrote:
> wake_affine is called from one path: select_task_rq_fair, which already has
> rcu read lock held.
> 
> Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> ---
>  kernel/sched_fair.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 354e26b..0bfec93 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1461,6 +1461,7 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
>  
>  #endif
>  
> +/* Assumes rcu_read_lock is held */

Not a big fan of such comments, esp with CONFIG_PROVE_RCU its better to
use those facilities, which is to say: if we're missing a
rcu_read_lock() the thing will yell bloody murder.

>  static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  {
>  	s64 this_load, load;
> @@ -1481,7 +1482,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	 * effect of the currently running task from the load
>  	 * of the current CPU:
>  	 */
> -	rcu_read_lock();
>  	if (sync) {
>  		tg = task_group(current);
>  		weight = current->se.load.weight;
> @@ -1517,7 +1517,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  		balanced = this_eff_load <= prev_eff_load;
>  	} else
>  		balanced = true;
> -	rcu_read_unlock();
>  
>  	/*
>  	 * If the currently running task will sleep within
> 

OK, took the patch and removed the comment, thanks!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2JRMo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 08:44:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42038 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab2JRMoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 08:44:55 -0400
Subject: Re: [PATCH] rcu: restore correct batch limiting
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20121018115859.GH2518@linux.vnet.ibm.com>
References: <1350458052.26103.31.camel@edumazet-glaptop>
	 <20121018115859.GH2518@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Oct 2012 14:44:50 +0200
Message-ID: <1350564290.26103.1496.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 04:58 -0700, Paul E. McKenney wrote:
> On Wed, Oct 17, 2012 at 09:14:12AM +0200, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > Commit 29c00b4a1d9e27 (rcu: Add event-tracing for RCU callback
> > invocation) added a regression in rcu_do_batch()
> > 
> > Under stress, RCU is supposed to allow to process all items in queue,
> > instead of a batch of 10 items (blimit), but an integer overflow makes
> > the effective limit being 1.
> > 
> > So RCU cannot recover and machine eventually crash because of OOM.
> > 
> > Using long instead of int is not really needed, convert everything
> > to integers.
> 
> <facepalm>
> 
> Good catch!!!
> 
> The reason for favoring long over int is that there are a few systems out
> there with terabytes of main memory.  In addition, there have been a few
> bugs over the past few years that could result in RCU CPU stalls of more
> than a minute.  This makes it impossible to rule out the possibility of
> a billion callbacks appearing on one CPU.
> 
> So, does the following patch fix things, or a I still confused?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Fix batch-limit size problem
> 
> Commit 29c00b4a1d9e27 (rcu: Add event-tracing for RCU callback
> invocation) added a regression in rcu_do_batch()
> 
> Under stress, RCU is supposed to allow to process all items in queue,
> instead of a batch of 10 items (blimit), but an integer overflow makes
> the effective limit being 1.  So, unless there is frequent idle periods
> (during which RCU ignores batch limits), RCU can be forced into a
> state where it cannot keep up with the callback-generation rate,
> eventually resulting in OOM.
> 
> This commit therefore converts a few variables in rcu_do_batch() from
> int to long to fix this problem.
> 
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e36d085..e056e1e 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1823,7 +1823,8 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
>  {
>  	unsigned long flags;
>  	struct rcu_head *next, *list, **tail;
> -	int bl, count, count_lazy, i;
> +	long bl, count, count_lazy;
> +	int i;
>  
>  	/* If no callbacks are ready, just return.*/
>  	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
> 

Yes, why not, but global "int blimit" being an int, I really dont see
the point having a long in struct rcu_data.

Having 2 billions callbacks on one cpu would be problematic, I really
hope nobody relies on this ;)

I guess the 10/infinity switch should be smarter.

something like the following maybe :

rdp->blimit = max(blimit, rdp->qlen >> 6);

(if queue is big, dont wait to hit 10000 before allowing more items to
be handled per round)


Signed-off-by: Eric Dumazet <edumazet@google.com>

Please dont forget stable teams.  (3.2 + )






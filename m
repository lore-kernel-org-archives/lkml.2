Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab0I1X2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 19:28:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39013 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0I1X2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 19:28:34 -0400
Date: Tue, 28 Sep 2010 16:28:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dongdong Deng <dongdong.deng@windriver.com>
Cc: dipankar@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] rcu: using ACCESS_ONCE() to observe the
 jiffies_stall/rnp->qsmask value
Message-ID: <20100928232831.GC2419@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1285662763-16748-1-git-send-email-dongdong.deng@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285662763-16748-1-git-send-email-dongdong.deng@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 04:32:43PM +0800, Dongdong Deng wrote:
> Using ACCESS_ONCE() to observe the jiffies_stall/rnp->qsmask value
> due to the caller didn't hold the root_rcu/rnp node's lock.

Given that the quantities are only used once, ACCESS_ONCE() is strictly
speaking not necessary.  I am tempted to queue your patch regardless
for the documentation benefits.

Or is this patch necessary to fix a failure that you have been seeing?

In any case, thank you for taking a look at RCU!

							Thanx, Paul

> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
> CC: Dipankar Sarma <dipankar@in.ibm.com>
> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index d5bc439..07a7063 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -532,9 +532,9 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
> 
>  	if (rcu_cpu_stall_panicking)
>  		return;
> -	delta = jiffies - rsp->jiffies_stall;
> +	delta = jiffies - ACCESS_ONCE(rsp->jiffies_stall);
>  	rnp = rdp->mynode;
> -	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
> +	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && delta >= 0) {
> 
>  		/* We haven't checked in, so go dump stack. */
>  		print_cpu_stall(rsp);
> -- 
> 1.6.0.4
> 

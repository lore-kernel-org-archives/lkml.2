Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834Ab1EAPtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:49:25 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47597 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1EAPtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:49:23 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Sun, 1 May 2011 08:48:58 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 09/86] rcu: avoid hammering sched with yet
 another bound RT kthread
Message-ID: <20110501154858.GE14829@feather>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-9-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304256126-26015-9-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 06:20:49AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> The scheduler does not appear to take kindly to having multiple
> real-time threads bound to a CPU that is going offline.  So this
> commit is a temporary hack-around to avoid that happening.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutorture.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index c224da4..4d256db 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -163,11 +163,11 @@ static int stutter_pause_test;
>  #endif
>  int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
>  
> -#ifdef CONFIG_RCU_BOOST
> +#if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU)
>  #define rcu_can_boost() 1
> -#else /* #ifdef CONFIG_RCU_BOOST */
> +#else /* #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
>  #define rcu_can_boost() 0
> -#endif /* #else #ifdef CONFIG_RCU_BOOST */
> +#endif /* #else #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */

So, this disables boosting entirely when CONFIG_HOTPLUG_CPU=y?  Other
patches in this series take various steps to un-bound or un-realtime the
RCU threads on a CPU when it goes offline; do those fix this problem?
Which patch disables this hack-around?

Also, it seems like your patch series introduces boosting, and then
disables it for CONFIG_HOTPLUG_CPU=y, which suggests that in the middle
of this patch series you can have a broken kernel if you build with
CONFIG_HOTPLUG_CPU=y and CONFIG_RCU_BOOST=y.  Please consider reordering
the patches (and possibly merging this patch into the original
introduction of RCU boosting) to make sure that kernels in the middle of
the patch series don't have this potential brokenness.

- Josh Triplett

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946299Ab2JDVk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:40:26 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49241 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946149Ab2JDVkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:40:13 -0400
Date: Thu, 4 Oct 2012 14:39:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: ananaza@iki.fi
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: Add "expedite always" switch
Message-ID: <20121004213933.GI2464@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121005.000053.1467384272006747942.apm@brigitte.kvy.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005.000053.1467384272006747942.apm@brigitte.kvy.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100421-7408-0000-0000-0000090A170D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 12:00:53AM +0300, Antti P Miettinen wrote:
> Add a module parameter for always using expedited RCU primitives.

Cool, looks quite close!!!  Please see below for a couple of questions and
comments.

> Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
> ---
>  include/linux/rcupdate.h |    2 ++
>  kernel/rcupdate.c        |    4 ++++
>  kernel/rcutiny_plugin.h  |    5 ++++-
>  kernel/rcutree.c         |   10 ++++++++--
>  kernel/rcutree_plugin.h  |    5 ++++-
>  kernel/srcu.c            |    4 +++-
>  6 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 7c968e4..b37efae 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -45,6 +45,8 @@
>  #include <linux/bug.h>
>  #include <linux/compiler.h>
> 
> +extern int rcu_expedited;
> +

This needs to move to kernel/rcu.h, otherwise it is being exported to
the entire kernel.  Don't get me wrong, if someone in the kernel needs
to be able switch to and from expedited mode, I am OK with their doing
that -- but via a proper API rather than a bare store to a variable.  ;-)

(That said, the networking guys are doing just fine by having
synchronize_net() call either synchronize_rcu_expedited() or
synchronize_rcu(), depending on internal networking locking state.
So I do not believe that we need an API, not yet, anyway.)

>  #ifdef CONFIG_RCU_TORTURE_TEST
>  extern int rcutorture_runnable; /* for sysctl */
>  #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index 29ca1c6..6057e58 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -46,12 +46,16 @@
>  #include <linux/export.h>
>  #include <linux/hardirq.h>
>  #include <linux/delay.h>
> +#include <linux/module.h>
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/rcu.h>
> 
>  #include "rcu.h"
> 
> +int rcu_expedited;
> +module_param(rcu_expedited, int, 0644);

Ah, the joys of exported-to-userspace API design...  ;-)

Summary: Please s/0644/0/ and add a KERNEL_ATTR_RW()-style sysfs interface.

If you want the details, please read on!

This exports the ability to switch expedited mode on and off at boot
time and also via sysfs.  However, this approach to the sysfs interface
does not gracefully handle multiple things enabling and disabling
expedited mode concurrently.  There are a couple of possible approaches:

1.	Look at current use cases.  These seem to be networking
	applications such as wireshark that reportedly cause the kernel
	to do a large number of RCU grace periods when starting up.
	These would be best served by an enter/exit style that
	increments and decrements a counter.

2.	Of course, applications can abort without properly cleaning
	up, which would argue for some sort of open/close protocol
	relying on the fact that all the application's fds are
	closed on any sort of exit.  But that leaves scripts out.

3.	One way to handle the scripts is to use redirection tricks,
	opening (say) FD 9 to the device.

4.	Do the bare minimum initially, so that when/if other use
	cases appear, they can be accommodated -- but using real
	information about what they really need.

>From what I can see, #4 is the only approach with a decent chance.
So, what is the bare minimum?

a.	Boot-time setting, allowing small embedded systems to
	unconditionally speed up grace periods.  You have this with the
	module_param() above.  Setting the permissions to zero would
	disable the userspace direct-set ability that is likely to get
	us into backwards-compatibility hot water in the future.

b.	Maybe sysfs setting.  Initially, this can be simple "on" and "off",
	exported with root-only access (like you have above).  If more
	elaborate use cases appear, this might become the adminstrative
	override.  The key point is that this needs to go through some
	sort of separate function (for example, via the KERNEL_ATTR_RW()
	macro) so that if it needs to change in the future, we can do
	the change easily.

Or am I missing something?

The rest looks good!

							Thanx, Paul

> +
>  #ifdef CONFIG_PREEMPT_RCU
> 
>  /*
> diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> index 3d01902..f85016a 100644
> --- a/kernel/rcutiny_plugin.h
> +++ b/kernel/rcutiny_plugin.h
> @@ -706,7 +706,10 @@ void synchronize_rcu(void)
>  		return;
> 
>  	/* Once we get past the fastpath checks, same code as rcu_barrier(). */
> -	rcu_barrier();
> +	if (rcu_expedited)
> +		synchronize_rcu_expedited();
> +	else
> +		rcu_barrier();
>  }
>  EXPORT_SYMBOL_GPL(synchronize_rcu);
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 4fb2376..744c117 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -2221,7 +2221,10 @@ void synchronize_sched(void)
>  			   "Illegal synchronize_sched() in RCU-sched read-side critical section");
>  	if (rcu_blocking_is_gp())
>  		return;
> -	wait_rcu_gp(call_rcu_sched);
> +	if (rcu_expedited)
> +		synchronize_sched_expedited();
> +	else
> +		wait_rcu_gp(call_rcu_sched);
>  }
>  EXPORT_SYMBOL_GPL(synchronize_sched);
> 
> @@ -2242,7 +2245,10 @@ void synchronize_rcu_bh(void)
>  			   "Illegal synchronize_rcu_bh() in RCU-bh read-side critical section");
>  	if (rcu_blocking_is_gp())
>  		return;
> -	wait_rcu_gp(call_rcu_bh);
> +	if (rcu_expedited)
> +		synchronize_rcu_bh_expedited();
> +	else
> +		wait_rcu_gp(call_rcu_bh);
>  }
>  EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index f921154..0e9ca8b 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -679,7 +679,10 @@ void synchronize_rcu(void)
>  			   "Illegal synchronize_rcu() in RCU read-side critical section");
>  	if (!rcu_scheduler_active)
>  		return;
> -	wait_rcu_gp(call_rcu);
> +	if (rcu_expedited)
> +		synchronize_rcu_expedited();
> +	else
> +		wait_rcu_gp(call_rcu);
>  }
>  EXPORT_SYMBOL_GPL(synchronize_rcu);
> 
> diff --git a/kernel/srcu.c b/kernel/srcu.c
> index 97c465e..00c4169 100644
> --- a/kernel/srcu.c
> +++ b/kernel/srcu.c
> @@ -464,7 +464,9 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
>   */
>  void synchronize_srcu(struct srcu_struct *sp)
>  {
> -	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_TRYCOUNT);
> +	__synchronize_srcu(sp, rcu_expedited
> +			   ? SYNCHRONIZE_SRCU_EXP_TRYCOUNT
> +			   : SYNCHRONIZE_SRCU_TRYCOUNT);
>  }
>  EXPORT_SYMBOL_GPL(synchronize_srcu);
> 
> -- 
> 1.7.4.1
> 


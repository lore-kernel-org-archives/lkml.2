Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1FJQit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:38:49 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60149 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab1FJQip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:38:45 -0400
Date: Fri, 10 Jun 2011 09:38:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH]rcu: avoid unnecessary thread wakeup
Message-ID: <20110610163842.GB2230@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307692251.15392.91.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307692251.15392.91.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 03:50:51PM +0800, Shaohua Li wrote:
> invoke_rcu_cpu_kthread could be called in the thread itself. In this case,
> we don't need call wakeup, which is just wasting CPU.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 89419ff..f9bd051 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1475,7 +1475,8 @@ static void invoke_rcu_cpu_kthread(void)
>  		local_irq_restore(flags);
>  		return;
>  	}
> -	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
> +	if (current != __this_cpu_read(rcu_cpu_kthread_task))
> +		wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
>  	local_irq_restore(flags);
>  }

Excellent point, thank you!

But how about combining the tests, perhaps something like the
following?

Unless you have objections or spot problems with it (or it breaks during
testing), I will queue the patch below with your SOB, since I derived
it from your patch.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b4b254d..eda3986 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1523,11 +1523,9 @@ static void invoke_rcu_cpu_kthread(void)
 
 	local_irq_save(flags);
 	__this_cpu_write(rcu_cpu_has_work, 1);
-	if (__this_cpu_read(rcu_cpu_kthread_task) == NULL) {
-		local_irq_restore(flags);
-		return;
-	}
-	wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
+	if (__this_cpu_read(rcu_cpu_kthread_task) != NULL &&
+	    current != __this_cpu_read(rcu_cpu_kthread_task))
+		wake_up_process(__this_cpu_read(rcu_cpu_kthread_task));
 	local_irq_restore(flags);
 }
 

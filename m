Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab2DXPf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:35:57 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33143 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2DXPf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:35:56 -0400
Message-ID: <4F96C838.3090309@linux.vnet.ibm.com>
Date: Tue, 24 Apr 2012 21:05:20 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>, venki@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC tip/core/rcu 1/6] rcu: Stabilize use of num_online_cpus()
 for GP short circuit
References: <20120423164159.GA13819@linux.vnet.ibm.com> <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12042415-5564-0000-0000-00000256B82B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 10:12 PM, Paul E. McKenney wrote:

> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The rcu_blocking_is_gp() function tests to see if there is only one
> online CPU, and if so, synchronize_sched() and friends become no-ops.
> However, for larger systems, num_online_cpus() scans a large vector,


Venki had posted a patch to optimize that by using a variable, so that we
don't calculate the value each and every time.
http://thread.gmane.org/gmane.linux.kernel/1240569/focus=1246659

However, unfortunately there was some confusion around that patch and
even though it made it to akpm's tree and stayed there briefly, it didn't
go upstream. Venki had attempted to resolve the confusion here:
http://thread.gmane.org/gmane.linux.kernel/1240569/focus=1260702

> and might be preempted while doing so.  While preempted, any number
> of CPUs might come online and go offline, potentially resulting in
> num_online_cpus() returning 1 when there never had only been one
> CPU online.  This would result in a too-short RCU grace period, which
> could in turn result in total failure.
> 


So, if I understand correctly, the "too-short RCU grace period being
troublesome" case occurs when we move from UP to SMP (ie., RCU thought
that the system is in UP judging by the value returned by num_online_cpus(),
but underneath, some CPUs got onlined in the meantime and hence the system
now became SMP).

> This commit therefore protects the num_online_cpus() with preempt_disable().
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  include/linux/rcutree.h |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index e8ee5dd..997179f 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -101,8 +101,13 @@ extern void rcu_sched_force_quiescent_state(void);
>  /* A context switch is a grace period for RCU-sched and RCU-bh. */
>  static inline int rcu_blocking_is_gp(void)
>  {
> +	int ret;
> +


Wouldn't it be more appropriate to return a bool? (and of course change the
function prototype as well..)

>  	might_sleep();  /* Check for RCU read-side critical section. */
> -	return num_online_cpus() == 1;
> +	preempt_disable();  /* Prevent CPU hotplug from confusing us. */


Preempt disable only prevents CPU offline from occurring concurrently.  So
even if we use preempt_disable/enable(), new CPUs can always come online!
And going by the above concern about RCU grace periods being too-short, I
guess we should also protect against CPUs from coming online concurrently
right?

[By the way, we don't really need to protect against CPU offlining, because
an SMP -> UP switch is harmless; we'll just miss a fast-path in the worst
case, but the code correctness is still guaranteed.]

> +	ret = num_online_cpus() == 1;
> +	preempt_enable();
> +	return ret;
>  }
>


Maybe I am missing something, but how is this code safe? Isn't it still racy?
Even if we use:

{
	might_sleep();
	get_online_cpus(); /* Prevent both CPU offline and CPU online */
	ret = num_online_cpus() == 1;
	put_online_cpus();
			<===============
	return ret;
}

What prevents a CPU Hotplug from happening right before we return from this
function, thereby rendering our num_online_cpus() calculation out-dated and
hence useless?

Regards,
Srivatsa S. Bhat


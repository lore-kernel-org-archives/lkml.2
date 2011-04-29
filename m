Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab1D2Lgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 07:36:37 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50155 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452Ab1D2Lge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 07:36:34 -0400
Date: Fri, 29 Apr 2011 01:36:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: export rcu_note_context_switch() function
Message-ID: <20110429083618.GL2191@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1303984323-3203-1-git-send-email-gleb@redhat.com>
 <1303984323-3203-2-git-send-email-gleb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303984323-3203-2-git-send-email-gleb@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:52:02PM +0300, Gleb Natapov wrote:

Hmmm....  This is interesting.  KVM being a module, we either expand
TINY_RCU's size a bit by making rcu_note_context_switch() be a real
function in rcutiny.c and adding an export, or we expand it by adding
two exports.

I would like to solve this without making TINY_RCU larger, and preferably
by making it smaller.  Any ideas come to mind?  (Other than making
KVM depend on CONFIG_SMP, which sounds too much like throwing out the
baby with the bathwater.)

							Thanx, Paul

> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> ---
>  include/linux/rcutiny.h |    6 +-----
>  kernel/rcutiny.c        |    7 +++++++
>  kernel/rcutree.c        |    1 +
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index 30ebd7c..8e5f7cf 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -93,11 +93,7 @@ static inline int rcu_needs_cpu(int cpu)
> 
>  #endif /* #else #ifdef CONFIG_TINY_RCU */
> 
> -static inline void rcu_note_context_switch(int cpu)
> -{
> -	rcu_sched_qs(cpu);
> -	rcu_preempt_note_context_switch();
> -}
> +extern void rcu_note_context_switch(int cpu);
> 
>  /*
>   * Return the number of grace periods.
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 0c343b9..3d715a4 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -78,6 +78,13 @@ void rcu_exit_nohz(void)
> 
>  #endif /* #ifdef CONFIG_NO_HZ */
> 
> +void rcu_note_context_switch(int cpu)
> +{
> +	rcu_sched_qs(cpu);
> +	rcu_preempt_note_context_switch();
> +}
> +EXPORT_SYMBOL_GPL(rcu_note_context_switch);
> +
>  /*
>   * Helper function for rcu_qsctr_inc() and rcu_bh_qsctr_inc().
>   * Also disable irqs to avoid confusion due to interrupt handlers
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index dd4aea8..0837d63 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -124,6 +124,7 @@ void rcu_note_context_switch(int cpu)
>  	rcu_sched_qs(cpu);
>  	rcu_preempt_note_context_switch(cpu);
>  }
> +EXPORT_SYMBOL_GPL(rcu_note_context_switch);
> 
>  #ifdef CONFIG_NO_HZ
>  DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

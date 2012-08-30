Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab2H3TB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:01:56 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53423 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2H3TBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:01:55 -0400
X-Originating-IP: 217.70.178.151
X-Originating-IP: 173.246.103.110
Date: Thu, 30 Aug 2012 12:01:46 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 3/5] rcu: Document SRCU dead-CPU
 capabilities, emphasize read-side limits
Message-ID: <20120830190146.GD6749@jtriplet-mobl1>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352312-31987-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352312-31987-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:45:10AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The current documentation did not help someone grepping for SRCU to
> learn that disabling preemption is not a replacement for srcu_read_lock(),
> so upgrade the documentation to bring this out, not just for SRCU,
> but also for RCU-bh.  Also document the fact that SRCU readers are
> respected on CPUs executing in user mode, idle CPUs, and even on
> offline CPUs.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  Documentation/RCU/checklist.txt |    6 ++++++
>  Documentation/RCU/whatisRCU.txt |    9 +++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
> index fc103d7..cdb20d4 100644
> --- a/Documentation/RCU/checklist.txt
> +++ b/Documentation/RCU/checklist.txt
> @@ -310,6 +310,12 @@ over a rather long period of time, but improvements are always welcome!
>  	code under the influence of preempt_disable(), you instead
>  	need to use synchronize_irq() or synchronize_sched().
>  
> +	This same limitation also applies to synchronize_rcu_bh()
> +	and synchronize_srcu(), as well as to the asynchronous and
> +	expedited forms of the three primitives, namely call_rcu(),
> +	call_rcu_bh(), call_srcu(), synchronize_rcu_expedited(),
> +	synchronize_rcu_bh_expedited(), and synchronize_srcu_expedited().
> +
>  12.	Any lock acquired by an RCU callback must be acquired elsewhere
>  	with softirq disabled, e.g., via spin_lock_irqsave(),
>  	spin_lock_bh(), etc.  Failing to disable irq on a given
> diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
> index 69ee188..bf0f6de 100644
> --- a/Documentation/RCU/whatisRCU.txt
> +++ b/Documentation/RCU/whatisRCU.txt
> @@ -873,7 +873,7 @@ d.	Do you need to treat NMI handlers, hardirq handlers,
>  	and code segments with preemption disabled (whether
>  	via preempt_disable(), local_irq_save(), local_bh_disable(),
>  	or some other mechanism) as if they were explicit RCU readers?
> -	If so, you need RCU-sched.
> +	If so, RCU-sched is the only choice that will work for you.
>  
>  e.	Do you need RCU grace periods to complete even in the face
>  	of softirq monopolization of one or more of the CPUs?  For
> @@ -884,7 +884,12 @@ f.	Is your workload too update-intensive for normal use of
>  	RCU, but inappropriate for other synchronization mechanisms?
>  	If so, consider SLAB_DESTROY_BY_RCU.  But please be careful!
>  
> -g.	Otherwise, use RCU.
> +g.	Do you need read-side critical sections that are respected
> +	even though they are in the middle of the idle loop, during
> +	user-mode execution, or on an offlined CPU?  If so, SRCU is the
> +	only choice that will work for you.
> +
> +h.	Otherwise, use RCU.
>  
>  Of course, this all assumes that you have determined that RCU is in fact
>  the right tool for your job.
> -- 
> 1.7.8
> 

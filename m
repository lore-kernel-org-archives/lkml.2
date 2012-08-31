Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2HaXy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:54:57 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37265 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab2HaXy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:54:56 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 16:54:46 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: Re: [PATCH tip/core/rcu 14/26] rcu: Userspace RCU extended QS
 selftest
Message-ID: <20120831235446.GK11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-14-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-14-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:31PM -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Provide a config option that enables the userspace
> RCU extended quiescent state on every CPUs by default.
> 
> This is for testing purpose.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  init/Kconfig     |    8 ++++++++
>  kernel/rcutree.c |    2 +-
>  2 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index f6a1830..c26b8a1 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -451,6 +451,14 @@ config RCU_USER_QS
>  	  excluded from the global RCU state machine and thus doesn't
>  	  to keep the timer tick on for RCU.
>  
> +config RCU_USER_QS_FORCE
> +	bool "Force userspace extended QS by default"
> +	depends on RCU_USER_QS
> +	help
> +	  Set the hooks in user/kernel boundaries by default in order to
> +	  test this feature that treats userspace as an extended quiescent
> +	  state until we have a real user like a full adaptive nohz option.
> +
>  config RCU_FANOUT
>  	int "Tree-based hierarchical RCU fanout value"
>  	range 2 64 if 64BIT
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index af92681..ccf3cbf 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -210,7 +210,7 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
>  DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
>  	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
>  	.dynticks = ATOMIC_INIT(1),
> -#ifdef CONFIG_RCU_USER_QS
> +#if defined(CONFIG_RCU_USER_QS) && !defined(CONFIG_RCU_USER_QS_FORCE)
>  	.ignore_user_qs = true,
>  #endif
>  };
> -- 
> 1.7.8
> 

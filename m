Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1CJAfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:35:41 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48786 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1CJAfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:35:40 -0500
Date: Wed, 9 Mar 2011 16:34:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "houston.jim@comcast.net" <houston.jim@comcast.net>
Subject: Re: [PATCH 2/4] jrcu: tap rcu_read_unlock
Message-ID: <20110310003419.GE2196@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101110155419.GC5750@nowhere>
 <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110309221517.GB24670@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309221517.GB24670@tsunami.ccur.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 05:15:17PM -0500, Joe Korty wrote:
> jrcu: tap into rcu_read_unlock().
> 
> All places where rcu_read_unlock() is the final lock in
> a set of nested rcu locks are known rcu quiescent points.
> This patch recognizes that subset of those which also make
> the task preemptable.  The others are left unrecognized.
> 
> Not fundamentally needed, accelerates rcu batching.

Wouldn't you need to hook rcu_read_lock() as well, at least in
the CONFIG_PREEMPT_RCU case?  Otherwise, the RCU read-side critical
section's accesses could leak out, possibly causing an RCU read-side
critical section that looked like it started after a given grace period
(thus not blocking that grace period) actually have accesses that precede
the grace period?  If this situation could arise, the grace period could
end too soon, resulting in memory corruption.

Or am I missing something here?

							Thanx, Paul

> Signed-off-by: Joe Korty <joe.korty@ccur.com>
> 
> Index: b/include/linux/jrcu.h
> ===================================================================
> --- a/include/linux/jrcu.h
> +++ b/include/linux/jrcu.h
> @@ -21,8 +21,10 @@
>  #ifndef __LINUX_JRCU_H
>  #define __LINUX_JRCU_H
> 
> +extern void rcu_read_unlock_jrcu(void);
> +
>  #define __rcu_read_lock()			preempt_disable()
> -#define __rcu_read_unlock()			preempt_enable()
> +#define __rcu_read_unlock()			rcu_read_unlock_jrcu()
> 
>  #define __rcu_read_lock_bh()			__rcu_read_lock()
>  #define __rcu_read_unlock_bh()			__rcu_read_unlock()
> Index: b/kernel/jrcu.c
> ===================================================================
> --- a/kernel/jrcu.c
> +++ b/kernel/jrcu.c
> @@ -153,6 +153,14 @@ static inline void rcu_eob(int cpu)
>  	}
>  }
> 
> +void rcu_read_unlock_jrcu(void)
> +{
> +	if (preempt_count() == 1)
> +		rcu_eob(rcu_cpu());
> +	preempt_enable();
> +}
> +EXPORT_SYMBOL_GPL(rcu_read_unlock_jrcu);
> +
>  void rcu_note_context_switch(int cpu)
>  {
>  	rcu_eob(cpu);

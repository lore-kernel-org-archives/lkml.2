Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0KFUDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 16:03:08 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48534 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752666Ab0KFUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 16:03:06 -0400
Date: Sat, 6 Nov 2010 16:03:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, fweisbec@gmail.com,
        dhowells@redhat.com, loic.minier@linaro.org, dhaval.giani@gmail.com,
        tglx@linutronix.de, peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101106200304.GA23702@Krystal>
References: <20101104232148.GA28037@linux.vnet.ibm.com> <20101105210059.GA27317@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105210059.GA27317@tsunami.ccur.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:59:40 up 45 days, 1 min,  4 users,  load average: 0.06, 0.11,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thanks for sending these patches. Here are some comments below,

* Joe Korty (joe.korty@ccur.com) wrote:
[...]
> 
> Jim Houston's timer-less version of RCU.
> 	
> This rather ancient version of RCU handles RCU garbage
> collection in the absence of a per-cpu local timer
> interrupt.
> 
> This is a minimal forward port to 2.6.36.  It works,
> but it is not yet a complete implementation of RCU.
> 
> Developed-by: Jim Houston <jim.houston@ccur.com>
> Signed-off-by: Joe Korty <joe.korty@ccur.com>
> 
[...]
> +/*
> + * rcu_quiescent() is called from rcu_read_unlock() when a
> + * RCU batch was started while the rcu_read_lock/rcu_read_unlock
> + * critical section was executing.
> + */
> +
> +void rcu_quiescent(int cpu)
> +{
> +	cpu_clear(cpu, rcu_state.rcu_cpu_mask);
> +	if (cpus_empty(rcu_state.rcu_cpu_mask))
> +		rcu_grace_period_complete();
> +}

These seems to be a race here when the number of CPUs is large enough to occupy
a bitmap larger than one word. Two unlock racing could each clear their own bit
on different words, and each thinking that the cpu mask is not empty, which
would hold the grace period forever.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

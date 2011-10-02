Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1JBWuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 18:50:35 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:32948 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1JBWu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 18:50:28 -0400
Date: Mon, 3 Oct 2011 00:50:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20111002225019.GA1835@somewhere>
References: <20110927180142.GD2335@linux.vnet.ibm.com>
 <20110928123116.GP18553@somewhere>
 <20110928184025.GF2383@linux.vnet.ibm.com>
 <20110928234633.GA3537@somewhere>
 <20110929005545.GT2383@linux.vnet.ibm.com>
 <20110929123040.GB3537@somewhere>
 <20110929171205.GA2362@linux.vnet.ibm.com>
 <20110930131105.GC19053@somewhere>
 <20110930152946.GA2397@linux.vnet.ibm.com>
 <20110930192438.GA7505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930192438.GA7505@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 12:24:38PM -0700, Paul E. McKenney wrote:
> @@ -328,11 +326,11 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
>  		return 1;
>  	}
>  
> -	/* If preemptible RCU, no point in sending reschedule IPI. */
> -	if (rdp->preemptible)
> -		return 0;
> -
> -	/* The CPU is online, so send it a reschedule IPI. */
> +	/*
> +	 * The CPU is online, so send it a reschedule IPI.  This forces
> +	 * it through the scheduler, and (inefficiently) also handles cases
> +	 * where idle loops fail to inform RCU about the CPU being idle.
> +	 */

If the idle loop forgets to call rcu_idle_enter() before going to
sleep, I don't know if it's a good idea to try to cure that situation
by forcing a quiescent state remotely. It may make the thing worse
because we actually won't notice the lack of call to rcu_idle_enter()
that the rcu stall detector would otherwise report to us.

Also I don't think that works. If the task doesn't have
TIF_RESCHED, it won't go through the scheduler on irq exit.
smp_send_reschedule() doesn't set the flag. And also scheduler_ipi()
returns right away if no wake up is pending.

So, other than resuming the idle loop to sleep again, nothing may happen.

Or am I missing something?



>  	if (rdp->cpu != smp_processor_id())
>  		smp_send_reschedule(rdp->cpu);
>  	else

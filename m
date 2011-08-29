Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1H2QAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:00:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:52749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1H2QAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:00:14 -0400
Subject: Re: [PATCH 18/32] nohz/cpuset: Don't stop the tick if posix cpu
 timers are running
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 17:59:37 +0200
In-Reply-To: <1313423549-27093-19-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-19-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314633577.2816.107.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> If either a per thread or a per process posix cpu timer is running,
> don't stop the tick.
> 
> TODO: restart the tick if it is stopped and a posix cpu timer is
> enqueued. Check we probably need a memory barrier for the per
> process posix timer that can be enqueued from another task
> of the group.


it would

> +++ b/kernel/sched.c
> @@ -71,6 +71,7 @@
>  #include <linux/ctype.h>
>  #include <linux/ftrace.h>
>  #include <linux/slab.h>
> +#include <linux/posix-timers.h>
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -2491,6 +2492,9 @@ bool cpuset_nohz_can_stop_tick(void)
>  	if (rcu_pending(cpu))
>  		return false;
>  
> +	if (posix_cpu_timers_running(current))
> +		return false;
> +
>  	return true;
>  }

Doesn't belong here, go poke at tick_nohz_can_stop_tick().

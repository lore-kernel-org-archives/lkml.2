Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1H2Pgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:36:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58008 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1H2Pgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:36:53 -0400
Subject: Re: [PATCH 14/32] nohz/cpuset: Don't turn off the tick if rcu needs
 it
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
Date: Mon, 29 Aug 2011 17:36:31 +0200
In-Reply-To: <1313423549-27093-15-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-15-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314632191.2816.95.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> @@ -2446,6 +2447,19 @@ bool cpuset_nohz_can_stop_tick(void)
>         if (rq->nr_running > 1)
>                 return false;
>  
> +       cpu = smp_processor_id();
> +
> +       /*
> +        * FIXME: will probably be removed soon as it's
> +        * already checked from tick_nohz_stop_sched_tick()
> +        */
> +       if (rcu_needs_cpu(cpu))
> +               return false;
> +
> +       /* Is there a grace period to complete ? */
> +       if (rcu_pending(cpu))
> +               return false;
> +
>         return true;
>  } 

This really shouldn't live in sched.c, also I would have expected
tick_nohz_can_stop_tick() to do this, its named like it does this.

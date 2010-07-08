Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab0GHMXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:23:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47827 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0GHMXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:23:11 -0400
Subject: Re: high power consumption in recent kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Norbert Preining <preining@logic.at>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100708120421.GF20841@gamma.logic.tuwien.ac.at>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
	 <1278579992.1900.17.camel@laptop> <20100708045711.398d4e26@infradead.org>
	 <1278590303.1900.91.camel@laptop>
	 <20100708120421.GF20841@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 14:22:59 +0200
Message-ID: <1278591779.1900.97.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 21:04 +0900, Norbert Preining wrote:

> Just one more point, searching a bit more in the net I found the following
> patch (forgot who wrote it) which I merged into my current git:

> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index a878b53..f26efba 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3248,6 +3248,9 @@ int select_nohz_load_balancer(int stop_tick)
>         if (stop_tick) {
>                 cpu_rq(cpu)->in_nohz_recently = 1;
>  
> +               if (!mc_capable())
> +                       return 0;
> +
>                 if (!cpu_active(cpu)) {
>                         if (atomic_read(&nohz.load_balancer) != cpu)
>                                 return 0;
> @@ -3297,6 +3300,9 @@ int select_nohz_load_balancer(int stop_tick)
>                 if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
>                         return 0;
>  
> +               if (!mc_capable())
> +                       return 0;
> +
>                 cpumask_clear_cpu(cpu, nohz.cpu_mask);
>  
>                 if (atomic_read(&nohz.load_balancer) == cpu)

Right, so that is a buggy patch, see the original discussion:
  http://lkml.org/lkml/2010/4/26/249

> which looks better

The thing is, we didn't change that code recently, the patches that are
supposed to cure the nohz balancer are still pending (in -tip and
-next).

That said, we did frob something with the whole nohz thing, does the
below cure anything:

---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 813993b..9bc8029 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -325,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu) || nohz_ratelimit(cpu)) {
+	    arch_needs_cpu(cpu) /* || nohz_ratelimit(cpu) */) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {


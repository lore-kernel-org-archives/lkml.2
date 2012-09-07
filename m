Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2IGHXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:23:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:58477 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab2IGHXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:23:23 -0400
Message-ID: <1347002596.18408.84.camel@twins>
Subject: Re: WARNING: cpu_is_offline() at native_smp_send_reschedule()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Date: Fri, 07 Sep 2012 09:23:16 +0200
In-Reply-To: <20120907012058.GA9000@localhost>
References: <20120905011152.GA19853@localhost>
	 <5046D69F.9000705@linux.vnet.ibm.com> <1346842480.2461.11.camel@laptop>
	 <20120905125700.GA5833@localhost> <20120907012058.GA9000@localhost>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 09:20 +0800, Fengguang Wu wrote:

> FYI, the bisect result is
> 
> commit 554cecaf733623b327eef9652b65965eb1081b81
> Author: Diwakar Tundlam <dtundlam@nvidia.com>
> Date:   Wed Mar 7 14:44:26 2012 -0800
> 
>     sched/nohz: Correctly initialize 'next_balance' in 'nohz' idle balancer
> 
>     The 'next_balance' field of 'nohz' idle balancer must be initialized
>     to jiffies. Since jiffies is initialized to negative 300 seconds the
>     'nohz' idle balancer does not run for the first 300s (5mins) after
>     bootup. If no new processes are spawed or no idle cycles happen, the
>     load on the cpus will remain unbalanced for that duration.
> 
>     Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Link: http://lkml.kernel.org/r/1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Oh fun.. does the below 'fix' it?

The thing I'm thinking of a tick happening right after we set jiffies
but before the zalloc (specifically the memset(0)) is complete. Since
we've already registered the softirq we can end up in the load-balancer
and see a completely weird idle mask.

Hmm?

---
 kernel/sched/fair.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1ca4fe4..ac57bb6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5346,13 +5346,12 @@ void print_cfs_stats(struct seq_file *m, int
cpu)
 __init void init_sched_fair_class(void)
 {
 #ifdef CONFIG_SMP
-	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
-
 #ifdef CONFIG_NO_HZ
 	nohz.next_balance = jiffies;
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	cpu_notifier(sched_ilb_notifier, 0);
 #endif
-#endif /* SMP */
 
+	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
+#endif /* SMP */
 }



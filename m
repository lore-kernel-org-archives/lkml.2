Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab1KRPOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:14:35 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35055 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752181Ab1KRPOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:14:34 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4AJ4NYre4YPFIU2WmfVZUdiPcjcPey8C1INeeeH
	l4tmEFYut+/ros
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 16:14:27 +0100
Message-ID: <1321629267.7080.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 09:36 -0800, Suresh Siddha wrote:
> On Thu, 2011-11-17 at 08:38 -0800, Mike Galbraith wrote:
> > On Thu, 2011-11-17 at 16:56 +0100, Peter Zijlstra wrote:
> > > Something like the below maybe, although I'm certain it all can be
> > > written much nicer indeed.
> > 
> > I'll give it a go.
> > 
> > Squabbling with bouncing buddies in an isolated and otherwise idle
> > cpuset ate my day.
> >  
> 
> Well looks like I managed to have the similar issue in my patch too.
> Anyways here is the updated cleaned up version of the patch ;)

Works fine.  However, unpinned buddies bounce more than with virgin
mainline.  I tried doing it differently (mikie in numbers below), and it
worked for a single unbound pair, but raped multiple unbound pairs.

---
 kernel/sched_fair.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: linux-3.0-tip/kernel/sched_fair.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched_fair.c
+++ linux-3.0-tip/kernel/sched_fair.c
@@ -2276,17 +2276,11 @@ static int select_idle_sibling(struct ta
 		for_each_cpu_and(i, sched_domain_span(sd), tsk_cpus_allowed(p)) {
 			if (idle_cpu(i)) {
 				target = i;
+				if (sd->flags & SD_SHARE_CPUPOWER)
+					continue;
 				break;
 			}
 		}
-
-		/*
-		 * Lets stop looking for an idle sibling when we reached
-		 * the domain that spans the current cpu and prev_cpu.
-		 */
-		if (cpumask_test_cpu(cpu, sched_domain_span(sd)) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
-			break;
 	}
 	rcu_read_unlock();
 
 

mikie2 is your patch + twiddles I'll post as a reply to this post.
  
kernel v3.2-rc1-306-g7f80850

TTWU_QUEUE off (skews results), test in cpuset 1-3,5-7

Test1: one unbound TCP_RR pair, three runs

virgin      66611.73      71376.00      61297.09                       avg 66428.27   1.000
suresh      68488.88      68412.48      68149.73 (bounce)                  68350.36   1.028
mikie       75925.91      75851.63      74617.29 (bounce--)                75464.94   1.136
mikie2      71403.39      71396.73      72258.91 NO_SIBLING_LIMIT_SYNC     71686.34   1.079
mikie2     139210.06     140485.95     140189.95 SIBLING_LIMIT_SYNC       139961.98   2.106


Test2: one unbound TCP_RR pair plus 2 unbound hogs, three runs

virgin      87108.59      88737.30      87383.98                       avg 87743.29  1.000
suresh      84281.24      84725.07      84823.57                           84931.93   .967
mikie       87850.37      86081.73      85789.49                           86573.86   .986
mikie2      92613.79      92022.95      92014.26 NO_SIBLING_LIMIT_SYNC     92217.00  1.050
mikie2     134682.16     133497.30     133584.48 SIBLING_LIMIT_SYNC


Test3: three unbound TCP_RR pairs, single run

virgin      55246.99      55138.67      55248.95                       avg 55211.53  1.000
suresh      53141.24      53165.45      53224.71                           53177.13   .963
mikie       47627.14      47361.68      47389.41                           47459.41   .859
mikie2      57969.49      57704.79      58218.14 NO_SIBLING_LIMIT_SYNC     57964.14  1.049
mikie2     132205.11     133726.94     133706.09 SIBLING_LIMIT_SYNC       133212.71  2.412


Test4: three bound TCP_RR pairs, single run

virgin     130073.67     130202.02     131666.48                      avg 130647.39  1.000
suresh     129805.98     128058.25     128709.77                          128858.00   .986
mikie      125597.11     127260.39     127208.73                          126688.74   .969
mikie2     135441.58     134961.89     137162.00                          135855.15  1.039


Test5: drop shield, tbench 8

virgin     2118.26 MB/sec  1.000
suresh     2036.32 MB/sec   .961
mikie      2051.18 MB/sec   .968
mikie2     2125.21 MB/sec  1.003  (hohum, all within tbench jitter)

Problem reference: select_idle_sibling() = painful L2 misses with westmere.

Identical configs, nohz=off NO_TTWU_QUEUE,
processor.max_cstate=0 intel_idle.max_cstate=0
turbo-boost off (so both are now plain 2.4GHz boxen)

single bound TCP_RR pair
              E5620      Q6600  bound
           90196.84   42517.96  3->0
           92654.92   43946.50  3->1
           91735.26   95274.10  3->2
          129394.55   95266.83  3->3
           89127.98             3->4
           91303.15             3->5
           91345.85             3->6
           74141.88             3->7  huh?.. load is synchronous!



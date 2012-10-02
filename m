Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2JBGvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:51:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab2JBGvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:51:47 -0400
Date: Tue, 2 Oct 2012 07:51:43 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Netperf UDP_STREAM regression due to not sending IPIs in ttwu_queue()
Message-ID: <20121002065143.GK29125@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm going through old test results to see could I find any leftover
performance regressions that have not yet been fixed (most have at this point
or at least changed in such a way to make a plain revert impossible). One
major regression still left is with netperf UDP_STREAM regression. Bisection
points the finger straight at 518cd623 (sched: Only queue remote wakeups
when crossing cache boundaries).  Problem was introduced between 3.2 and
3.3, current kernel still sucks as the following results show.

NETPERF UDP
                           3.3.0                 3.3.0                 3.6.0
                         vanilla       revert-518cd623               vanilla
Tput 64         328.38 (  0.00%)      436.58 ( 32.95%)      312.51 ( -4.83%)
Tput 128        661.43 (  0.00%)      869.88 ( 31.52%)      625.70 ( -5.40%)
Tput 256       1310.27 (  0.00%)     1724.45 ( 31.61%)     1243.65 ( -5.08%)
Tput 1024      5466.85 (  0.00%)     6601.43 ( 20.75%)     4838.86 (-11.49%)
Tput 2048     10885.95 (  0.00%)    12694.06 ( 16.61%)     9161.75 (-15.84%)
Tput 3312     15930.33 (  0.00%)    19327.67 ( 21.33%)    14106.26 (-11.45%)
Tput 4096     18025.47 (  0.00%)    22183.12 ( 23.07%)    16636.01 ( -7.71%)
Tput 8192     30076.42 (  0.00%)    37280.86 ( 23.95%)    28575.84 ( -4.99%)
Tput 16384    47742.12 (  0.00%)    56123.21 ( 17.55%)    46060.57 ( -3.52%)

Machine is a single-socket I7-2600.

Netperf was running in loopback testing UDP_STREAM instead of TCP_STREAM
which the commit was intended to fix. The netperf server and client were
bound to CPUs 0 and 1 respectively. Scheduling domains for those two
CPUs look like

[    0.788535] CPU0 attaching sched-domain:
[    0.788537]  domain 0: span 0,4 level SIBLING
[    0.788538]   groups: 0 (cpu_power = 589) 4 (cpu_power = 589)
[    0.788541]   domain 1: span 0-7 level MC
[    0.788543]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
[    0.788548] CPU1 attaching sched-domain:
[    0.788549]  domain 0: span 1,5 level SIBLING
[    0.788550]   groups: 1 (cpu_power = 589) 5 (cpu_power = 589)
[    0.788552]   domain 1: span 0-7 level MC
[    0.788553]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)

CPUs 0,1 are not SMT siblings but are in the same MC domain so would share a
common higher scheduling domain when searching for SD_SHARE_PKG_RESOURCES. I
get the logic of the patch that only sends an IPI if waking up cross-domain
but it's not a universal win either apparently. Unfortunately as I'm a
bit weak on the scheduler, it's not obvious to me what the correct path
forward is.

FWIW, the following shows the results of allowing IPIs to be sent.

NETPERF UDP
                           3.3.0                 3.3.0                 3.6.0                 3.6.0
                         vanilla          sendipi-v1r1               vanilla          sendipi-v1r1
Tput 64         328.38 (  0.00%)      423.46 ( 28.95%)      312.51 ( -4.83%)      391.83 ( 19.32%)
Tput 128        661.43 (  0.00%)      845.78 ( 27.87%)      625.70 ( -5.40%)      783.14 ( 18.40%)
Tput 256       1310.27 (  0.00%)     1681.17 ( 28.31%)     1243.65 ( -5.08%)     1548.88 ( 18.21%)
Tput 1024      5466.85 (  0.00%)     6553.80 ( 19.88%)     4838.86 (-11.49%)     5902.06 (  7.96%)
Tput 2048     10885.95 (  0.00%)    12760.77 ( 17.22%)     9161.75 (-15.84%)    11245.34 (  3.30%)
Tput 3312     15930.33 (  0.00%)    19480.40 ( 22.28%)    14106.26 (-11.45%)    17186.32 (  7.88%)
Tput 4096     18025.47 (  0.00%)    22659.79 ( 25.71%)    16636.01 ( -7.71%)    20111.05 ( 11.57%)
Tput 8192     30076.42 (  0.00%)    36865.53 ( 22.57%)    28575.84 ( -4.99%)    33801.49 ( 12.39%)
Tput 16384    47742.12 (  0.00%)    55127.99 ( 15.47%)    46060.57 ( -3.52%)    52262.36 (  9.47%)

MMTests Statistics: duration
               3.3.0       3.3.0       3.6.0       3.6.0
             vanillasendipi-v1r1     vanillasendipi-v1r1
User           54.60       33.87       41.32       39.81
System       2441.70     1245.99     1419.30     1380.85
Elapsed      3010.63     1546.65     1764.70     1716.92

A plain revert on 3.3 was a massive win but sending the IPI at least
gets most of the performance back. It's not so great on 3.6 but too much
has changed to make a plain revert feasible.

It's also worth noting that in 3.3 at least, sending the IPI made netperf
performance less variable. I am inferring this from the fact that it
completed in about half the time and required fewer iterations to be
confident of the result.

This is obviously a stupid hack but illustrates the point.

Not-signed-off-as-this-obviously-breaking-intent-of-original-patch
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 649c9f8..79d483c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1548,7 +1548,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 
 #if defined(CONFIG_SMP)
-	if (sched_feat(TTWU_QUEUE) && !cpus_share_cache(smp_processor_id(), cpu)) {
+	if (sched_feat(TTWU_QUEUE) && cpus_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;

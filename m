Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121Ab0KPJd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:33:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:13005 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934110Ab0KPJd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:33:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,205,1288594800"; 
   d="scan'208";a="858053760"
Subject: [performance bug] volanomark regression on 37-rc1
From: "Alex,Shi" <alex.shi@intel.com>
To: ncrao@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, "Chen, Tim C" <tim.c.chen@intel.com>,
        zheng.z.yan@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 17:34:02 +0800
Message-ID: <1289900042.27424.253.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do performance testing on 37-rc1 kernel on Core2 machines, we find
the volanomark loopback performance drop about 30%, that due to
commit:fab476228ba37907ad7 

Volanomark link: http://www.volano.com/benchmarks.html 
Our volanomark testing parameters as following:
"-count 25000 -rooms 10 "
JVM is jrockit-R27.3.1-jre1.5.0_11
java_options is "-Xmx1500m -Xms1500m -Xns750m -XXaggressive -Xlargepages
-XXlazyUnlocking -Xgc:genpar -XXtlasize:min=16k,preferred=64k"
and we set /proc/sys/kernel/sched_compat_yield as "1". 

We find if with the following patch, the regression can be recovered. 

Signed-off-by:Alex Shi <alex.shi@intel.com>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f4f6a83..5dca678 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1766,7 +1766,6 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	check_preempt_curr(this_rq, p, 0);
 
 	/* re-arm NEWIDLE balancing when moving tasks */
-	src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
 	this_rq->idle_stamp = 0;
 }
 

It seems some of load_balance() is not necessary that caused by avg_idle
setting. But do not know more details of the volano running. Anyone like
to give a comments for this issue? 

Ncrao, I have no idea of your benchmarks, but just guess removing the
avg_idle setting won't bring much wakeup delay for tasks. Could you like
to show some data of this?

The vmstat output for .36 and .37-rc1 kernel as below: 
2.6.36 
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
394  0      0 4680728   3168 118972    0    0     0     3 5314 1348711 38 62  0  0  0
396  0      0 4680500   3184 118976    0    0     0     8 5345 1303237 38 62  0  0  0
413  0      0 4680252   3200 118976    0    0     0     3 5082 1326851 38 61  0  0  0

2.6.37-rc1
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
329  0      0 4653748   4600 134032    0    0     0     7 11649 918370 35 64  0  0  0
210  0      0 4653492   4608 134032    0    0     0     6 11957 898011 36 64  0  0  0
373  0      0 4653496   4624 134032    0    0     0     4 11736 912468 36 64  0  0  0

Regards
Alex 


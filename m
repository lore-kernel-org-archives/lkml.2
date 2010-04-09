Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab0DICdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 22:33:24 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52760 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0DICdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 22:33:21 -0400
Date: Fri, 09 Apr 2010 11:20:13 +0900 (JST)
Message-Id: <20100409.112013.200619992.igawa@mxs.nes.nec.co.jp>
To: peterz@infradead.org
Cc: sjayaraman@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: High priority threads causing severe CPU load imbalances
From: Masayuki Igawa <igawa@mxs.nes.nec.co.jp>
In-Reply-To: <1270743344.20295.2554.camel@laptop>
References: <1270562890.1595.438.camel@laptop>
	<4BBB62E1.2080308@suse.de>
	<1270743344.20295.2554.camel@laptop>
X-Face: #`8<;#^GT6I29B~d}[W1|;e^NwB_F&@OwnDz+/F)N"lG{]tYc'vaA\]b;xHb9-C@4|G<.<7
 >/wNWw\=q82cH.g)}hCEuY9FY}*Y7ip\-?]:z"n0}J3Y{g2}wNTu66I8wY#&UYUB]S0p_)&_W~eP'z
  C.3zWia]pH3)m`\V/]/V"w]{mv~a{Q)bvm,[866h%-xE@_4Clm,<q)/oS\-9+ueGL{*N
Organization: NEC Soft, Ltd.
X-Mailer: Mew version 6.3 on Emacs 23.0.60 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: High priority threads causing severe CPU load imbalances
Date: Thu, 08 Apr 2010 18:15:44 +0200

> On Tue, 2010-04-06 at 22:05 +0530, Suresh Jayaraman wrote:
>> Perhaps there is a chance that with more CPUs, different number of high
>> priority threads the problem could get worser as I mentioned above..?
> 
> One thing that could be happening (triggered by what Igawa-san said,
> although his case is more complicated by involving the cgroup stuff) is
> that f_b_g() ends up selecting a group that contains these niced tasks
> and then f_b_q() will not find a suitable source queue because all of
> them will have but a single runnable task on it and hence we simply
> bail.
> 
> We'd somehow have to teach update_*_lb_stats() not to consider groups
> where nr_running <= nr_cpus. I don't currently have a patch for that,
> but I think that is the direction you might need to look in.

I made a patch for my understanding the load_balance()'s behavior.
This patch reduced CPU load imbalances but not perfect.
---
Cpu0  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  : 90.1%us,  0.0%sy,  0.0%ni,  9.9%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu2  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  : 98.7%us,  0.3%sy,  0.0%ni,  1.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu5  : 96.1%us,  1.0%sy,  0.0%ni,  3.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu6  : 99.0%us,  0.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.3%si,  0.0%st
Cpu7  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   8032460k total,   807628k used,  7224832k free,    30692k buffers
Swap:        0k total,        0k used,        0k free,   347308k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND         
 9872 root      20   0 66128  632  268 R   99  0.0   0:13.69 4 bash            
 9876 root      20   0 66128  632  268 R   99  0.0   0:10.31 2 bash            
 9877 root      20   0 66128  632  268 R   99  0.0   0:10.79 3 bash            
 9871 root      20   0 66128  632  268 R   99  0.0   0:13.70 0 bash            
 9873 root      20   0 66128  632  268 R   99  0.0   0:13.68 1 bash            
 9874 root      20   0 66128  632  268 R   98  0.0   0:10.00 6 bash            
 9875 root      20   0 66128  632  268 R   92  0.0   0:11.22 4 bash            
 9878 root      20   0 66128  632  268 R   91  0.0   0:10.03 7 bash            
---
Also, this patch caused ping-pong load balances..

This patch is regards the sched_group as a idle sched_group
if local sched_group's cpu is CPU_IDLE.

But the state is not stable because active_load_balance() runs at this situation IIUC.


I'll investigate more.

===
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5a5ea2c..806be90 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2418,6 +2418,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	int i;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
 	unsigned long avg_load_per_task = 0;
+	int idle_group = 0;
 
 	if (local_group)
 		balance_cpu = group_first_cpu(group);
@@ -2440,6 +2441,12 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 			}
 
 			load = target_load(i, load_idx);
+			/* This group is idle if it has a idle cpu. */
+			if (idle == CPU_IDLE) {
+				idle_group = 1;
+				sgs->group_load = 0;
+				sgs->sum_weighted_load = 0;
+			}
 		} else {
 			load = source_load(i, load_idx);
 			if (load > max_cpu_load)
@@ -2451,6 +2458,10 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
+		if (!idle_group) {
+			sgs->group_load += load;
+			sgs->sum_weighted_load += weighted_cpuload(i);
+		}
 
 	}
 
===


Thanks.
-- 
Masayuki Igawa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1BHSOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:14:30 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56289 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab1BHSO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vklOelCs1rz9wLOJzeXfn/msnPjRg8WeEgkAcyNfqwdX8Cp1zTHVGeIXtFW3iDMlrQ
         RhxI3phDwRVc6455GjCA==
From: Venkatesh Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 2/3] sched: fix_up broken SMT load balance dilation
Date: Tue,  8 Feb 2011 10:13:38 -0800
Message-Id: <1297188819-19999-3-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTikmWfLv3iMNUky7TRvQtUknLckftiQ4-Br614Rm@mail.gmail.com>
References: <AANLkTikmWfLv3iMNUky7TRvQtUknLckftiQ4-Br614Rm@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is logic in rebalance_domains that intends to change CPU_IDLE
load balancing from an SMT CPU to CPU_NOT_IDLE, in presence of
a busy SMT sibling.

load_balance() at SIBLING domain returns -1, when there is a busy
sibling in that domain and the check in rebalance domain for non-zero
return values following which idle is changed to CPU_NOT_IDLE.

But this does not work as intended. This does reduce the number of
higher domain load balancing on such SMT CPUs. But, they end up
doing CPU_IDLE balance most of the times.

Here is a "10s diff" of CPU_IDLE and CPU_NOT_IDLE lb_count from
sched_stat (fields 2, 3, 11 from domain lines) on the particular
CPU of interest.

sd_cpus lb_count[CPU_IDLE] lb_count[CPU_NOT_IDLE]

00001001 4579 0
0003f03f 1200 0
00ffffff 310 0

00001001 4485 0
0003f03f 999 0
00ffffff 341 0

00001001 4593 0
0003f03f 1031 0
00ffffff 293 0

The reason for this is, we do successfully avoid load balancing of higher
domain when SIBLING domain says one of the siblings is busy. But, next
CORE or NODE load balancing can trigger (and is triggering) at a jiffy
when there is no SIBLING load balance pending and thus those
load balances will not know about SMT sibling being busy and go ahead
with CPU_IDLE.

One way to solve this is to remember the idle state from last sibling
load balance and bubble it up the domain levels. With that, under
same conditions as above, schedstat shows

sd_cpus lb_count[CPU_IDLE] lb_count[CPU_NOT_IDLE]

00001001 4677 0
0003f03f 2 39
00ffffff 2 9

00001001 4684 0
0003f03f 3 37
00ffffff 3 12

00001001 4781 0
0003f03f 1 39
00ffffff 1 21

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 include/linux/sched.h |    1 +
 kernel/sched_fair.c   |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..56194b3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -937,6 +937,7 @@ struct sched_domain {
 	unsigned int nr_balance_failed; /* initialise to 0 */
 
 	u64 last_update;
+	enum cpu_idle_type bubble_up_idle;
 
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d7e6da3..91227d9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3871,6 +3871,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 				idle = CPU_NOT_IDLE;
 			}
 			sd->last_balance = jiffies;
+			sd->bubble_up_idle = idle;
 		}
 		if (need_serialize)
 			spin_unlock(&balancing);
@@ -3887,6 +3888,9 @@ out:
 		 */
 		if (!balance)
 			break;
+
+		if (idle == CPU_IDLE)
+			idle = sd->bubble_up_idle;
 	}
 
 	/*
-- 
1.7.3.1


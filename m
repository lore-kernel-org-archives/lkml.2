Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab1DNSIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:08:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:42168 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964973Ab1DNR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 160/209] nohz: Fix printk_needs_cpu() return value on offline cpus
Date: Thu, 14 Apr 2011 13:55:18 -0400
Message-Id: <1302803767-9715-47-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 61ab25447ad6334a74e32f60efb135a3467223f8 upstream.

This patch fixes a hang observed with 2.6.32 kernels where timers got enqueued
on offline cpus.

printk_needs_cpu() may return 1 if called on offline cpus. When a cpu gets
offlined it schedules the idle process which, before killing its own cpu, will
call tick_nohz_stop_sched_tick(). That function in turn will call
printk_needs_cpu() in order to check if the local tick can be disabled. On
offline cpus this function should naturally return 0 since regardless if the
tick gets disabled or not the cpu will be dead short after. That is besides the
fact that __cpu_disable() should already have made sure that no interrupts on
the offlined cpu will be delivered anyway.

In this case it prevents tick_nohz_stop_sched_tick() to call
select_nohz_load_balancer(). No idea if that really is a problem. However what
made me debug this is that on 2.6.32 the function get_nohz_load_balancer() is
used within __mod_timer() to select a cpu on which a timer gets enqueued. If
printk_needs_cpu() returns 1 then the nohz_load_balancer cpu doesn't get
updated when a cpu gets offlined. It may contain the cpu number of an offline
cpu. In turn timers get enqueued on an offline cpu and not very surprisingly
they never expire and cause system hangs.

This has been observed 2.6.32 kernels. On current kernels __mod_timer() uses
get_nohz_timer_target() which doesn't have that problem. However there might be
other problems because of the too early exit tick_nohz_stop_sched_tick() in
case a cpu goes offline.

Easiest way to fix this is just to test if the current cpu is offline and call
printk_tick() directly which clears the condition.

Alternatively I tried a cpu hotplug notifier which would clear the condition,
however between calling the notifier function and printk_needs_cpu() something
could have called printk() again and the problem is back again. This seems to
be the safest fix.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101126120235.406766476@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/printk.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 75077ad..8ace9f8 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1009,6 +1009,8 @@ void printk_tick(void)
 
 int printk_needs_cpu(int cpu)
 {
+	if (unlikely(cpu_is_offline(cpu)))
+		printk_tick();
 	return per_cpu(printk_pending, cpu);
 }
 
-- 
1.7.4.4


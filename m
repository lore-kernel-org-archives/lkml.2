Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab0C3Kke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:40:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63519 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755551Ab0C3Kkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:40:33 -0400
Message-ID: <4BB1D524.9050508@cn.fujitsu.com>
Date: Tue, 30 Mar 2010 18:40:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: more careful check for the last non-dyntick-idle CPU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warning: I just did build test.

Subject: [PATCH] rcu: more careful check for the last non-dyntick-idle CPU

If a CPU is not in nohz_cpu_mask, it does not means this
CPU is a non-dyntick-idle CPU, because this CPU may be offline or not exist.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 4befb64..6086a7d 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1026,7 +1026,7 @@ int rcu_needs_cpu(int cpu)
 
 	/* Don't bother unless we are the last non-dyntick-idle CPU. */
 	for_each_cpu_not(thatcpu, nohz_cpu_mask)
-		if (thatcpu != cpu) {
+		if (cpu_online(thatcpu) && thatcpu != cpu) {
 			per_cpu(rcu_dyntick_drain, cpu) = 0;
 			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 			return rcu_needs_cpu_quick_check(cpu);

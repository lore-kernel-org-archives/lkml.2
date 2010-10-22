Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0JVIS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:18:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58884 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab0JVIS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:18:56 -0400
Message-ID: <4CC149E5.60901@cn.fujitsu.com>
Date: Fri, 22 Oct 2010 16:23:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: force all adopted callbacks are invoked before next
 cpu-offline
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When cpu-offline/online happen continuously, a CPU may
adopts too much callbacks or some callbacks are just
moved back and forth without invoked.

It will cause a CPU has a lot of burden or some callbacks
are invoked very late or starvation.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 669d7fe..8af45d6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1811,6 +1811,23 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_UP_CANCELED_FROZEN:
 		rcu_offline_cpu(cpu);
 		break;
+	case CPU_POST_DEAD:
+	case CPU_POST_DEAD | CPU_TASKS_FROZEN:
+		/*
+		 * When a cpu is offline, the callbacks in the offline CPU
+		 * are orphaned and adopted by a online CPU. These callbacks
+		 * are processed as new inserted one. So in the worst case,
+		 * if the offline/online happen continuously, a CPU may
+		 * adopts too much callbacks or some callbacks are just
+		 * moved back and forth without invoked.
+		 *
+		 * To fix it, we must force all adopted callbacks are invoked
+		 * before next cpu-offline.
+		 */
+		rcu_barrier_bh();
+		rcu_barrier_sched();
+		rcu_barrier();
+		break;
 	default:
 		break;
 	}

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935229Ab2DMKy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:54:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64125 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2DMKy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:54:26 -0400
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT] rcu: Fix build break
Date: Fri, 13 Apr 2012 12:54:21 +0200
Message-Id: <1334314461-8937-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A build break can occur with the following config options enabled

CONFIG_PREEMPT_RT_FULL
CONFIG_RCU_FAST_NO_HZ
CONFIG_RCU_CPU_STALL_INFO

This occurs because symbols in print_cpu_stall_fast_no_hz() such as
rcu_idle_gp_timer are not accessible with CONFIG_PREEMPT_RT_FULL
and results in the following type of build errors:

kernel/rcutree_plugin.h: In function ‘print_cpu_stall_fast_no_hz’:
kernel/rcutree_plugin.h:2195: error: ‘rcu_idle_gp_timer’ undeclared (first use in this function)

This patch fixes the build break by limiting the
to the function rcu_needs_cpu() instead of to the entire
!defined(CONFIG_RCU_FAST_NO_NZ) section

as was intended in the original rcu: Make ksoftirqd do RCU quiescent states
patch.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/rcutree_plugin.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 14acafc..2844d7d 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1914,6 +1914,9 @@ int rcu_needs_cpu(int cpu)
 {
 	return rcu_cpu_has_callbacks(cpu);
 }
+#endif	/* !defined(CONFIG_RCU_FAST_NO_HZ) || defined(CONFIG_PREEMPT_RT_FULL) */
+
+#if !defined(CONFIG_RCU_FAST_NO_HZ)
 
 /*
  * Because we do not have RCU_FAST_NO_HZ, don't bother initializing for it.
@@ -1984,6 +1987,7 @@ static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
 static ktime_t rcu_idle_gp_wait;	/* If some non-lazy callbacks. */
 static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
  * callbacks on this CPU, (2) this CPU has not yet attempted to enter
@@ -2001,6 +2005,7 @@ int rcu_needs_cpu(int cpu)
 	/* Otherwise, RCU needs the CPU only if it recently tried and failed. */
 	return per_cpu(rcu_dyntick_holdoff, cpu) == jiffies;
 }
+#endif	/* #ifndef CONFIG_PREEMPT_RT_FULL */
 
 /*
  * Does the specified flavor of RCU have non-lazy callbacks pending on
-- 
1.7.2.3


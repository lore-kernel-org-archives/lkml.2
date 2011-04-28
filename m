Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470Ab1D1OUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:20:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52688 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760010Ab1D1OUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:20:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH] cpuset: fix cpuset_cpus_allowed_fallback() don't update tsk->rt.nr_cpus_allowed
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110428232228.3D57.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 28 Apr 2011 23:20:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg, Peter,

I apologize if I misunderstand a code. I'm afraid we need following
patch. Is there any gurantte that cpusets user task is not RT task?



>From 400e24f7b6e15d1397dc82d74fdd1e0a631493ef Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 28 Apr 2011 16:14:16 +0900
Subject: [PATCH] cpuset: fix cpuset_cpus_allowed_fallback() don't update tsk->rt.nr_cpus_allowed

The rule is, we have to update tsk->rt.nr_cpus_allowed too if we change
tsk->cpus_allowed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cpuset.h |    1 +
 kernel/cpuset.c        |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index f20eb8f..42dcbdc 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -147,6 +147,7 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
 {
 	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+	p->rt.nr_cpus_allowed = cpumask_weight(&p->cpus_allowed);
 	return cpumask_any(cpu_active_mask);
 }
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1ceeb04..6e5bbe8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2220,6 +2220,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
 		cpu = cpumask_any(cpu_active_mask);
 	}
+	tsk->rt.nr_cpus_allowed = cpumask_weight(&tsk->cpus_allowed);
 
 	return cpu;
 }
-- 
1.7.3.1




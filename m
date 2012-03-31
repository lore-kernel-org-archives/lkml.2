Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab2CaJr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 05:47:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2CaJrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 05:47:23 -0400
Date: Sat, 31 Mar 2012 02:46:54 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-e3831edd59edf57ca11fc289f08961b20baf5146@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, davej@redhat.com,
        srivatsa.bhat@linux.vnet.ibm.com, levinsasha928@gmail.com,
        tglx@linutronix.de, chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, srivatsa.bhat@linux.vnet.ibm.com,
        davej@redhat.com, levinsasha928@gmail.com, tglx@linutronix.de,
        chuansheng.liu@intel.com
In-Reply-To: <4F75BED4.9050005@linux.vnet.ibm.com>
References: <4F75BED4.9050005@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix incorrect usage of for_each_cpu_mask
 () in select_fallback_rq()
Git-Commit-ID: e3831edd59edf57ca11fc289f08961b20baf5146
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 31 Mar 2012 02:47:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3831edd59edf57ca11fc289f08961b20baf5146
Gitweb:     http://git.kernel.org/tip/e3831edd59edf57ca11fc289f08961b20baf5146
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Fri, 30 Mar 2012 19:40:28 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 31 Mar 2012 10:43:36 +0200

sched: Fix incorrect usage of for_each_cpu_mask() in select_fallback_rq()

The function for_each_cpu_mask() expects a *pointer* to struct
cpumask as its second argument, whereas select_fallback_rq()
passes the value itself.

And moreover, for_each_cpu_mask() has been marked as obselete
in include/linux/cpumask.h. So move to the more appropriate
for_each_cpu() variant.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Jones <davej@redhat.com>
Cc: Liu Chuansheng <chuansheng.liu@intel.com>
Cc: vapier@gentoo.org
Cc: rusty@rustcorp.com.au
Link: http://lkml.kernel.org/r/4F75BED4.9050005@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 985f6e5..8773176 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1268,7 +1268,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	int dest_cpu;
 
 	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_mask(dest_cpu, *nodemask) {
+	for_each_cpu(dest_cpu, nodemask) {
 		if (!cpu_online(dest_cpu))
 			continue;
 		if (!cpu_active(dest_cpu))
@@ -1279,7 +1279,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 
 	for (;;) {
 		/* Any allowed, online CPU? */
-		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
+		for_each_cpu(dest_cpu, tsk_cpus_allowed(p)) {
 			if (!cpu_online(dest_cpu))
 				continue;
 			if (!cpu_active(dest_cpu))

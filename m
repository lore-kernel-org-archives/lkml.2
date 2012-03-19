Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab2CSMpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:45:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54044 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2CSMpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:45:04 -0400
MIME-Version: 1.0
Date: Mon, 19 Mar 2012 20:45:03 +0800
Message-ID: <CAJd=RBAhi6vmihBT4iZ2ELtix8vEtx-VM8gujb-q-cOjqqdcnQ@mail.gmail.com>
Subject: [PATCH 1/2] autonuma: fix typo in sched balance
From: Hillf Danton <dhillf@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea

It is redefined to be safely used by set/test_bit(cpu, mm_mask).

Q-0: another case of mm_mask in struct rq?
Q-1: make sense to move NR_CPUS variable out of stack?
Q-2: for online mem node, cpumask_of_node(nid) implies cpu also online?

	for_each_online_node(nid) {
		for_each_cpu_and(cpu, cpumask_of_node(nid), allowed) {
			struct rq *rq;
		+	if (!cpu_online(cpu))
		+		continue;
			rq = cpu_rq(cpu);
			if (rq->curr->mm == mm)
				nr_mm++;
		}
	}

where check needed for accessing rq->curr?


Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/numa.c	Sat Mar 17 11:01:40 2012
+++ b/kernel/sched/numa.c	Mon Mar 19 20:01:34 2012
@@ -95,7 +95,7 @@ void sched_autonuma_balance(void)
 	struct migration_arg arg;
 	struct task_struct *p = current;
 	struct sched_autonuma *sched_autonuma = p->sched_autonuma;
-	DECLARE_BITMAP(mm_mask, MAX_NUMNODES);
+	DECLARE_BITMAP(mm_mask, NR_CPUS);

 	if (!sched_autonuma || sched_autonuma->autonuma_stop_one_cpu || !p->mm)
 		return;
@@ -136,7 +136,7 @@ void sched_autonuma_balance(void)
 		weight_current[nid] = p_w*AUTONUMA_BALANCE_SCALE/p_t;
 	}

-	bitmap_zero(mm_mask, MAX_NUMNODES);
+	bitmap_zero(mm_mask, NR_CPUS);
 	for_each_online_node(nid) {
 		if (nid == cpu_nid)
 			continue;
--

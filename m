Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1DKKqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:46:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:48192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab1DKKqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:46:37 -0400
Date: Mon, 11 Apr 2011 10:46:23 GMT
From: tip-bot for Ken Chen <kenchen@google.com>
Message-ID: <tip-b0432d8f162c7d5d9537b4cb749d44076b76a783@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, kenchen@google.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, kenchen@google.com, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110408002322.3A0D812217F@elm.corp.google.com>
References: <20110408002322.3A0D812217F@elm.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix sched-domain avg_load calculation
Git-Commit-ID: b0432d8f162c7d5d9537b4cb749d44076b76a783
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 10:46:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0432d8f162c7d5d9537b4cb749d44076b76a783
Gitweb:     http://git.kernel.org/tip/b0432d8f162c7d5d9537b4cb749d44076b76a783
Author:     Ken Chen <kenchen@google.com>
AuthorDate: Thu, 7 Apr 2011 17:23:22 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 11:08:54 +0200

sched: Fix sched-domain avg_load calculation

In function find_busiest_group(), the sched-domain avg_load isn't
calculated at all if there is a group imbalance within the domain. This
will cause erroneous imbalance calculation.

The reason is that calculate_imbalance() sees sds->avg_load = 0 and it
will dump entire sds->max_load into imbalance variable, which is used
later on to migrate entire load from busiest CPU to the puller CPU.

This has two really bad effect:

1. stampede of task migration, and they won't be able to break out
   of the bad state because of positive feedback loop: large load
   delta -> heavier load migration -> larger imbalance and the cycle
   goes on.

2. severe imbalance in CPU queue depth.  This causes really long
   scheduling latency blip which affects badly on application that
   has tight latency requirement.

The fix is to have kernel calculate domain avg_load in both cases. This
will ensure that imbalance calculation is always sensible and the target
is usually half way between busiest and puller CPU.

Signed-off-by: Ken Chen <kenchen@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/20110408002322.3A0D812217F@elm.corp.google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7f00772..60f9d40 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3127,6 +3127,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
+	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
+
 	/*
 	 * If the busiest group is imbalanced the below checks don't
 	 * work because they assumes all things are equal, which typically
@@ -3151,7 +3153,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * Don't pull any tasks if this group is already above the domain
 	 * average load.
 	 */
-	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2KSQjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:39:21 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61389 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2KSQit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:38:49 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@redhat.com
Cc: ccross@android.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 2/3] sched: fix init NOHZ_IDLE flag
Date: Mon, 19 Nov 2012 17:38:06 +0100
Message-Id: <1353343087-18015-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1353343087-18015-1-git-send-email-vincent.guittot@linaro.org>
References: <1353343087-18015-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my smp platform which is made of 5 cores in 2 clusters,I have the
nr_busy_cpu field of sched_group_power struct that is not null when the
platform is fully idle. The root cause seems to be:
During the boot sequence, some CPUs reach the idle loop and set their
NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
field is initialized later with the assumption that all CPUs are in the busy
state whereas some CPUs have already set their NOHZ_IDLE flag.
We clear the NOHZ_IDLE flag when nr_busy_cpus is initialized in order to 
have a coherent configuration.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5dae0d2..05058e8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5817,6 +5817,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	update_group_power(sd, cpu);
 	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
+	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
 }
 
 int __weak arch_sd_sibling_asym_packing(void)
-- 
1.7.10


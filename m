Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab1DTUv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:51:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47347 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1DTUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:51:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=iw2QAMqrj0bNqPKwMry1lfq/JoGX0csU57baJyFR0t80F0dk75oBqkU+hz/RypIau
	V4HhTkcJ9QwgQaM11x+gA==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 03/18] sched: use u64 for load_weight fields
Date: Wed, 20 Apr 2011 13:51:22 -0700
Message-Id: <1303332697-16426-4-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts load_weight fields to use u64 instead of unsigned long.
This is effectively a no-op for 64-bit where unsigned long is 64-bit wide
anyway. On 32-bit architectures, it is required to ensure the rq load weight
does not overflow in the presence of multiple large weight entities. Also
increase MAX_SHARES to 2^28 (from 2^18).

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 include/linux/sched.h |    2 +-
 kernel/sched_debug.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d2c3bab..6d88be1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1104,7 +1104,7 @@ struct sched_class {
 };
 
 struct load_weight {
-	unsigned long weight, inv_weight;
+	u64 weight, inv_weight;
 };
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 7bacd83..d22b666 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -201,7 +201,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
-	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
+	SEQ_printf(m, "  .%-30s: %lld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "load_avg",
@@ -264,7 +264,7 @@ static void print_cpu(struct seq_file *m, int cpu)
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(rq->x))
 
 	P(nr_running);
-	SEQ_printf(m, "  .%-30s: %lu\n", "load",
+	SEQ_printf(m, "  .%-30s: %llu\n", "load",
 		   rq->load.weight);
 	P(nr_switches);
 	P(nr_load_updates);
-- 
1.7.3.1


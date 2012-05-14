Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab2ENNtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:49:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56659 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2ENNtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:49:04 -0400
Date: Mon, 14 May 2012 06:48:51 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-gk5tm8t2n4ix2vkpns42uqqp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dtundlam@nvidia.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, dtundlam@nvidia.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/debug:
  Fix printing large integers on 32-bit platforms
Git-Commit-ID: 13e099d2f77e1da3e4046860c48d956588633613
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:48:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13e099d2f77e1da3e4046860c48d956588633613
Gitweb:     http://git.kernel.org/tip/13e099d2f77e1da3e4046860c48d956588633613
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 14 May 2012 14:34:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 May 2012 15:05:28 +0200

sched/debug: Fix printing large integers on 32-bit platforms

Some numbers like nr_running and nr_uninterruptible are fundamentally
unsigned since its impossible to have a negative amount of tasks, yet
we still print them as signed to easily recognise the underflow
condition.

rq->nr_uninterruptible has 'special' accounting and can in fact very
easily become negative on a per-cpu basis.

It was noted that since the P() macro assumes things are long long and
the promotion of unsigned 'int/long' to long long on 32bit doesn't
sign extend we print silly large numbers instead of the easier to read
signed numbers.

Therefore extend the P() macro to not require the sign extention.

Reported-by: Diwakar Tundlam <dtundlam@nvidia.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-gk5tm8t2n4ix2vkpns42uqqp@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 31e4f61..6f79596 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -260,8 +260,14 @@ static void print_cpu(struct seq_file *m, int cpu)
 	SEQ_printf(m, "\ncpu#%d\n", cpu);
 #endif
 
-#define P(x) \
-	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x))
+#define P(x)								\
+do {									\
+	if (sizeof(rq->x) == 4)						\
+		SEQ_printf(m, "  .%-30s: %ld\n", #x, (long)(rq->x));	\
+	else								\
+		SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x));\
+} while (0)
+
 #define PN(x) \
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(rq->x))
 

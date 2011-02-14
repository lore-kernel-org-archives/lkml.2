Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1BNPTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:19:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47432 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1BNPTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:19:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=kyRXImnua/N0HAAZgYvEiBf+w4ME3sSkLmzY4n8FBeQe6wXgkvJzNtgeyHWFzNR6SV
         YTe72TNH80oZZGjf6/No3L7n+R+nNVFGEu6k9tsC+tjXQ3JKuP6OW995virmFqGuY8tS
         6CNCrF4v4UueSctztiyjxuZJ+kL1YrywMvopU=
Date: Mon, 14 Feb 2011 23:19:05 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH] lockdep: fix lockdep_stats_show() by using
 lockdep_state magic
Message-ID: <20110214151905.GA3193@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter/Ingo,

Now lockdep_stats_show() doesn't show every thing we need, like RECLAIM_FS
status is missed. So I come up with a patch for it(but not for included).

1) In this patch, RECLAIM_FS-* locks is added:
    RECLAIM_FS-safe locks:                   4
    RECLAIM_FS-unsafe locks:               134
    RECLAIM_FS-read-safe locks:              0
    RECLAIM_FS-read-unsafe locks:           74

2) But the difference is HARDIRQ, SOFRIRQ, RECLAIM_FS becomes to
   upcase. Like:
    HARDIRQ-safe locks:                     63
    HARDIRQ-unsafe locks:                  590
    SOFTIRQ-safe locks:                    115
    SOFTIRQ-unsafe locks:                  506
    RECLAIM_FS-safe locks:                   4
    RECLAIM_FS-unsafe locks:               134

  Is this kind of change acceptable?

3) When looking through lockdep_stats_show(), I think there is more
   thing to rewrite, like:
   a) "all direct dependencies" calculation, actually I'm not very sure how
      it is worked out(teach please).
   b) factor is not used.
   c) Is there any other message should be showed?

So could we make a decision on what lockdep_stats should be, then
I can make a patchset to reach the requirement?

BTW, the below is just to show some point, not for included.


Thanks,
Yong

---
Subject: [PATCH] lockdep: fix lockdep_stats_show() by using lockdep_state magic

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/lockdep_proc.c |   79 ++++++++++++++++++++++++++-----------------------
 1 files changed, 42 insertions(+), 37 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 1969d2f..c979679 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -220,12 +220,16 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 	struct lock_class *class;
 	unsigned long nr_unused = 0, nr_uncategorized = 0,
 		      nr_irq_safe = 0, nr_irq_unsafe = 0,
-		      nr_softirq_safe = 0, nr_softirq_unsafe = 0,
-		      nr_hardirq_safe = 0, nr_hardirq_unsafe = 0,
 		      nr_irq_read_safe = 0, nr_irq_read_unsafe = 0,
-		      nr_softirq_read_safe = 0, nr_softirq_read_unsafe = 0,
-		      nr_hardirq_read_safe = 0, nr_hardirq_read_unsafe = 0,
 		      sum_forward_deps = 0, factor = 0;
+#define LOCKDEP_STATE(__STATE)					\
+	unsigned long nr_##__STATE##_safe = 0;			\
+	unsigned long nr_##__STATE##_unsafe = 0;		\
+	unsigned long nr_##__STATE##_read_safe = 0;		\
+	unsigned long nr_##__STATE##_read_unsafe = 0;
+
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
 
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
 
@@ -233,35 +237,33 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			nr_unused++;
 		if (class->usage_mask == LOCKF_USED)
 			nr_uncategorized++;
+#define LOCKDEP_STATE(__STATE)						\
+		if (class->usage_mask & LOCKF_USED_IN_##__STATE)	\
+			nr_##__STATE##_safe++;				\
+		if (class->usage_mask & LOCKF_ENABLED_##__STATE)	\
+			nr_##__STATE##_unsafe++;			\
+		if (class->usage_mask & LOCKF_USED_IN_##__STATE##_READ)	\
+			nr_##__STATE##_read_safe++;			\
+		if (class->usage_mask & LOCKF_ENABLED_##__STATE##_READ)	\
+			nr_##__STATE##_read_unsafe++;
+
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+
 		if (class->usage_mask & LOCKF_USED_IN_IRQ)
 			nr_irq_safe++;
 		if (class->usage_mask & LOCKF_ENABLED_IRQ)
 			nr_irq_unsafe++;
-		if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ)
-			nr_softirq_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ)
-			nr_softirq_unsafe++;
-		if (class->usage_mask & LOCKF_USED_IN_HARDIRQ)
-			nr_hardirq_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ)
-			nr_hardirq_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_IRQ_READ)
 			nr_irq_read_safe++;
 		if (class->usage_mask & LOCKF_ENABLED_IRQ_READ)
 			nr_irq_read_unsafe++;
-		if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ_READ)
-			nr_softirq_read_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ_READ)
-			nr_softirq_read_unsafe++;
-		if (class->usage_mask & LOCKF_USED_IN_HARDIRQ_READ)
-			nr_hardirq_read_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ_READ)
-			nr_hardirq_read_unsafe++;
 
 #ifdef CONFIG_PROVE_LOCKING
 		sum_forward_deps += lockdep_count_forward_deps(class);
 #endif
 	}
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 	DEBUG_LOCKS_WARN_ON(debug_atomic_read(nr_unused_locks) != nr_unused);
 #endif
@@ -280,7 +282,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 	 */
 	seq_printf(m, " all direct dependencies:       %11lu\n",
 			nr_irq_unsafe * nr_irq_safe +
-			nr_hardirq_unsafe * nr_hardirq_safe +
+			nr_HARDIRQ_unsafe * nr_HARDIRQ_safe +
 			nr_list_entries);
 
 	/*
@@ -312,27 +314,30 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			(nr_softirq_chains + 1) *
 			(nr_process_chains + 1)
 	);
-	seq_printf(m, " hardirq-safe locks:            %11lu\n",
-			nr_hardirq_safe);
-	seq_printf(m, " hardirq-unsafe locks:          %11lu\n",
-			nr_hardirq_unsafe);
-	seq_printf(m, " softirq-safe locks:            %11lu\n",
-			nr_softirq_safe);
-	seq_printf(m, " softirq-unsafe locks:          %11lu\n",
-			nr_softirq_unsafe);
+
+#define LOCKDEP_STATE(__STATE)						\
+	seq_printf(m, " %-31s%11lu\n",					\
+			__stringify(__STATE)"-safe locks:",		\
+			nr_##__STATE##_safe);				\
+	seq_printf(m, " %-31s%11lu\n",					\
+			__stringify(__STATE)"-unsafe locks:",		\
+			nr_##__STATE##_unsafe);
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
 	seq_printf(m, " irq-safe locks:                %11lu\n",
 			nr_irq_safe);
 	seq_printf(m, " irq-unsafe locks:              %11lu\n",
 			nr_irq_unsafe);
 
-	seq_printf(m, " hardirq-read-safe locks:       %11lu\n",
-			nr_hardirq_read_safe);
-	seq_printf(m, " hardirq-read-unsafe locks:     %11lu\n",
-			nr_hardirq_read_unsafe);
-	seq_printf(m, " softirq-read-safe locks:       %11lu\n",
-			nr_softirq_read_safe);
-	seq_printf(m, " softirq-read-unsafe locks:     %11lu\n",
-			nr_softirq_read_unsafe);
+#define LOCKDEP_STATE(__STATE)						\
+	seq_printf(m, " %-31s%11lu\n",					\
+			__stringify(__STATE)"-read-safe locks:",	\
+			nr_##__STATE##_read_safe);			\
+	seq_printf(m, " %-31s%11lu\n",					\
+			__stringify(__STATE)"-read-unsafe locks:",	\
+			nr_##__STATE##_read_unsafe);
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
 	seq_printf(m, " irq-read-safe locks:           %11lu\n",
 			nr_irq_read_safe);
 	seq_printf(m, " irq-read-unsafe locks:         %11lu\n",
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab2JVF5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:57:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:39696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab2JVF5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,628,1344236400"; 
   d="scan'208";a="230478529"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.n
Cc: eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 4/6] perf, core: Pass perf_sample_data to perf_callchain()
Date: Mon, 22 Oct 2012 13:57:14 +0800
Message-Id: <1350885436-5540-5-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350885436-5540-1-git-send-email-zheng.z.yan@intel.com>
References: <1350885436-5540-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

New Intel CPU can record call chains by using existing last branch
record facility. perf_callchain_user() can make use of the call
chains recorded by hardware in case of there is no frame pointer.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/arm/kernel/perf_event.c     | 4 ++--
 arch/powerpc/perf/callchain.c    | 4 ++--
 arch/sparc/kernel/perf_event.c   | 4 ++--
 arch/x86/kernel/cpu/perf_event.c | 4 ++--
 include/linux/perf_event.h       | 3 ++-
 kernel/events/callchain.c        | 8 +++++---
 kernel/events/core.c             | 2 +-
 kernel/events/internal.h         | 3 ++-
 8 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 93971b1..7cd3eba 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -567,8 +567,8 @@ user_backtrace(struct frame_tail __user *tail,
 	return buftail.fp - 1;
 }
 
-void
-perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
+void perf_callchain_user(struct perf_callchain_entry *entry,
+			 struct pt_regs *regs, struct perf_sample_data *data)
 {
 	struct frame_tail __user *tail;
 
diff --git a/arch/powerpc/perf/callchain.c b/arch/powerpc/perf/callchain.c
index 74d1e78..b379ebc 100644
--- a/arch/powerpc/perf/callchain.c
+++ b/arch/powerpc/perf/callchain.c
@@ -482,8 +482,8 @@ static void perf_callchain_user_32(struct perf_callchain_entry *entry,
 	}
 }
 
-void
-perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
+void perf_callchain_user(struct perf_callchain_entry *entry,
+			 struct pt_regs *regs, struct perf_sample_data *data)
 {
 	if (current_is_64bit())
 		perf_callchain_user_64(entry, regs);
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 885a8af..6e9c62c 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1775,8 +1775,8 @@ static void perf_callchain_user_32(struct perf_callchain_entry *entry,
 	} while (entry->nr < PERF_MAX_STACK_DEPTH);
 }
 
-void
-perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
+void perf_callchain_user(struct perf_callchain_entry *entry,
+			 struct pt_regs *regs, struct perf_sample_data *data)
 {
 	perf_callchain_store(entry, regs->tpc);
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 119687d..8ae8044 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1839,8 +1839,8 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 }
 #endif
 
-void
-perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
+void perf_callchain_user(struct perf_callchain_entry *entry,
+			 struct pt_regs *regs, struct perf_sample_data *data)
 {
 	struct stack_frame frame;
 	const void __user *fp;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9151bdd..803b511 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -706,7 +706,8 @@ extern void perf_event_fork(struct task_struct *tsk);
 /* Callchains */
 DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
 
-extern void perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs);
+extern void perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs,
+				struct perf_sample_data *data);
 extern void perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs);
 
 static inline void perf_callchain_store(struct perf_callchain_entry *entry, u64 ip)
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index c772061..bd7138a 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -30,7 +30,8 @@ __weak void perf_callchain_kernel(struct perf_callchain_entry *entry,
 }
 
 __weak void perf_callchain_user(struct perf_callchain_entry *entry,
-				struct pt_regs *regs)
+				struct pt_regs *regs,
+				struct perf_sample_data *data)
 {
 }
 
@@ -154,7 +155,8 @@ put_callchain_entry(int rctx)
 }
 
 struct perf_callchain_entry *
-perf_callchain(struct perf_event *event, struct pt_regs *regs)
+perf_callchain(struct perf_event *event, struct pt_regs *regs,
+	       struct perf_sample_data *data)
 {
 	int rctx;
 	struct perf_callchain_entry *entry;
@@ -195,7 +197,7 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 				goto exit_put;
 
 			perf_callchain_store(entry, PERF_CONTEXT_USER);
-			perf_callchain_user(entry, regs);
+			perf_callchain_user(entry, regs, data);
 		}
 	}
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b15c8a2..b914039 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4228,7 +4228,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
 
-		data->callchain = perf_callchain(event, regs);
+		data->callchain = perf_callchain(event, regs, data);
 
 		if (data->callchain)
 			size += data->callchain->nr;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index d56a64c..4ce75bf 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -126,7 +126,8 @@ DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
 
 /* Callchain handling */
 extern struct perf_callchain_entry *
-perf_callchain(struct perf_event *event, struct pt_regs *regs);
+perf_callchain(struct perf_event *event, struct pt_regs *regs,
+	       struct perf_sample_data *data);
 extern int get_callchain_buffers(void);
 extern void put_callchain_buffers(void);
 
-- 
1.7.11.7


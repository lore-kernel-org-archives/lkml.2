Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2JDKj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:39:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2JDKjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:39:21 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] perf: Simplify the sample's user regs/stack retrieval
Date: Thu,  4 Oct 2012 12:38:45 +0200
Message-Id: <1349347125-5770-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349347125-5770-1-git-send-email-jolsa@redhat.com>
References: <20121003133007.GD945@krava.brq.redhat.com>
 <1349347125-5770-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_sample_regs_user function now returns result of the user
register retrieval, which simplifies surrounding code a bit.

The perf_output_sample_ustack now combines initial dump size
output for both (stack dump un/available) cases.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/events/core.c |   64 ++++++++++++++++++++++++-------------------------
 1 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 71329d6..e392dcb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3783,11 +3783,15 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 __weak void
 arch_sample_regs_user_fixup(struct perf_regs_user *regs_user, int kernel) { }
 
-static void perf_sample_regs_user(struct perf_regs_user *regs_user,
+static int perf_sample_regs_user(struct perf_regs_user *regs_user,
 				 struct pt_regs *regs)
 {
 	int kernel = !user_mode(regs);
 
+	/* Already defined. */
+	if (regs_user->abi)
+		return 1;
+
 	if (kernel) {
 		if (current->mm)
 			regs = task_pt_regs(current);
@@ -3800,6 +3804,8 @@ static void perf_sample_regs_user(struct perf_regs_user *regs_user,
 		regs_user->abi  = perf_reg_abi(current);
 		arch_sample_regs_user_fixup(regs_user, kernel);
 	}
+
+	return regs ? 1 : 0;
 }
 
 /*
@@ -3825,10 +3831,6 @@ perf_sample_ustack_size(u16 stack_size, u16 header_size,
 {
 	u64 task_size;
 
-	/* No regs, no stack pointer, no dump. */
-	if (!regs)
-		return 0;
-
 	/*
 	 * Check if we fit in with the requested stack size into the:
 	 * - TASK_SIZE
@@ -3862,29 +3864,26 @@ static void
 perf_output_sample_ustack(struct perf_output_handle *handle, u64 dump_size,
 			  struct pt_regs *regs)
 {
-	/* Case of a kernel thread, nothing to dump */
-	if (!regs) {
-		u64 size = 0;
-		perf_output_put(handle, size);
-	} else {
+	/*
+	 * We dump:
+	 * static size
+	 *   - the size requested by user or the best one we can fit
+	 *     in to the sample max size
+	 *   - zero (and final data) if there's nothing to dump
+	 * data
+	 *   - user stack dump data
+	 * dynamic size
+	 *   - the actual dumped size
+	 */
+
+	/* Static size. */
+	perf_output_put(handle, dump_size);
+
+	if (dump_size) {
 		unsigned long sp;
 		unsigned int rem;
 		u64 dyn_size;
 
-		/*
-		 * We dump:
-		 * static size
-		 *   - the size requested by user or the best one we can fit
-		 *     in to the sample max size
-		 * data
-		 *   - user stack dump data
-		 * dynamic size
-		 *   - the actual dumped size
-		 */
-
-		/* Static size. */
-		perf_output_put(handle, dump_size);
-
 		/* Data. */
 		sp = perf_user_stack_pointer(regs);
 		rem = __output_copy_user(handle, (void *) sp, dump_size);
@@ -4235,9 +4234,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 		/* regs dump ABI info */
 		int size = sizeof(u64);
 
-		perf_sample_regs_user(&data->regs_user, regs);
-
-		if (data->regs_user.regs) {
+		if (perf_sample_regs_user(&data->regs_user, regs)) {
 			u64 mask = event->attr.sample_regs_user;
 			size += hweight64(mask) * sizeof(u64);
 		}
@@ -4253,14 +4250,15 @@ void perf_prepare_sample(struct perf_event_header *header,
 		 * up the rest of the sample size.
 		 */
 		struct perf_regs_user *uregs = &data->regs_user;
-		u16 stack_size = event->attr.sample_stack_user;
+		u64 sample_stack_user = event->attr.sample_stack_user;
+		u16 stack_size = 0;
 		u16 size = sizeof(u64);
 
-		if (!uregs->abi)
-			perf_sample_regs_user(uregs, regs);
-
-		stack_size = perf_sample_ustack_size(stack_size, header->size,
-						     uregs->regs);
+		if (perf_sample_regs_user(uregs, regs)) {
+			stack_size = perf_sample_ustack_size(sample_stack_user,
+							     header->size,
+							     uregs->regs);
+		}
 
 		/*
 		 * If there is something to dump, add space for the dump
-- 
1.7.7.6


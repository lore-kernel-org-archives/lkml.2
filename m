Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0C1FLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 01:11:37 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55123 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0C1FLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 01:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LwCKeeohKRFrLeJaTQTTU4l+fGSLmdsWiLlDaHWBs8FT+PHsKeym97HS5gyCXdEN2F
         +BBHy5H/hPAwG7BVpfkAYMrb/Q+A+xfuUYwGnTQvbTWPI0QXxt5EIOsIQKFmE4XMpyBe
         dH7/PUgmRkgfmP0VZYCcDR+FCNFocQDSNVyW0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 2/2] perf: Use hot regs with software sched switch/migrate events
Date: Sun, 28 Mar 2010 07:11:06 +0200
Message-Id: <1269753066-17246-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scheduler's task migration events don't work because they always
pass NULL regs perf_sw_event(). The event hence gets filtered
in perf_swevent_add().

Scheduler's context switches events use task_pt_regs() to get
the context when the event occured which is a wrong thing to
do as this won't give us the place in the kernel where we went
to sleep but the place where we left userspace. The result is
even more wrong if we switch from a kernel thread.

Use the hot regs snapshot for both events as they belong to the
non-interrupt/exception based events family. Unlike page faults
or so that provide the regs matching the exact origin of the event,
we need to save the current context.

This makes the task migration event working and fix the context
switch callchains and origin ip.

Example: perf record -a -e cs

Before:

    10.91%      ksoftirqd/0                  0  [k] 0000000000000000
                |
                --- (nil)
                    perf_callchain
                    perf_prepare_sample
                    __perf_event_overflow
                    perf_swevent_overflow
                    perf_swevent_add
                    perf_swevent_ctx_event
                    do_perf_sw_event
                    __perf_sw_event
                    perf_event_task_sched_out
                    schedule
                    run_ksoftirqd
                    kthread
                    kernel_thread_helper

After:

    23.77%  hald-addon-stor  [kernel.kallsyms]  [k] schedule
            |
            --- schedule
               |
               |--60.00%-- schedule_timeout
               |          wait_for_common
               |          wait_for_completion
               |          blk_execute_rq
               |          scsi_execute
               |          scsi_execute_req
               |          sr_test_unit_ready
               |          |
               |          |--66.67%-- sr_media_change
               |          |          media_changed
               |          |          cdrom_media_changed
               |          |          sr_block_media_changed
               |          |          check_disk_change
               |          |          cdrom_open

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
---
 include/linux/perf_event.h |   21 ++++++++++++++-------
 kernel/perf_event.c        |    4 +---
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9547703..c8e3754 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -842,13 +842,6 @@ extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
 
-static inline void
-perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
-{
-	if (atomic_read(&perf_swevent_enabled[event_id]))
-		__perf_sw_event(event_id, nr, nmi, regs, addr);
-}
-
 extern void
 perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip);
 
@@ -887,6 +880,20 @@ static inline void perf_fetch_caller_regs(struct pt_regs *regs, int skip)
 	return perf_arch_fetch_caller_regs(regs, ip, skip);
 }
 
+static inline void
+perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
+{
+	if (atomic_read(&perf_swevent_enabled[event_id])) {
+		struct pt_regs hot_regs;
+
+		if (!regs) {
+			perf_fetch_caller_regs(&hot_regs, 1);
+			regs = &hot_regs;
+		}
+		__perf_sw_event(event_id, nr, nmi, regs, addr);
+	}
+}
+
 extern void __perf_event_mmap(struct vm_area_struct *vma);
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index fb3031c..bc7943c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1164,11 +1164,9 @@ void perf_event_task_sched_out(struct task_struct *task,
 	struct perf_event_context *ctx = task->perf_event_ctxp;
 	struct perf_event_context *next_ctx;
 	struct perf_event_context *parent;
-	struct pt_regs *regs;
 	int do_switch = 1;
 
-	regs = task_pt_regs(task);
-	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, regs, 0);
+	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
 	if (likely(!ctx || !cpuctx->task_ctx))
 		return;
-- 
1.6.2.3


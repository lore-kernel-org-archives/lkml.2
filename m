Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab0JRTWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:22:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:35139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933101Ab0JRTWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:22:34 -0400
Date: Mon, 18 Oct 2010 19:22:11 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize sw events
Message-ID: <tip-7e54a5a0b655734326dc78c2b5efc1eb35497bb6@git.kernel.org>
Git-Commit-ID: 7e54a5a0b655734326dc78c2b5efc1eb35497bb6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:22:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e54a5a0b655734326dc78c2b5efc1eb35497bb6
Gitweb:     http://git.kernel.org/tip/7e54a5a0b655734326dc78c2b5efc1eb35497bb6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 14 Oct 2010 22:32:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:59 +0200

perf: Optimize sw events

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   20 +++++++++++---------
 kernel/perf_event.c        |    4 ++--
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7f0e7f5..3b80cbf 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1012,18 +1012,20 @@ static inline void perf_fetch_caller_regs(struct pt_regs *regs)
 	perf_arch_fetch_caller_regs(regs, CALLER_ADDR0);
 }
 
-static inline void
+static __always_inline void
 perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 {
-	if (atomic_read(&perf_swevent_enabled[event_id])) {
-		struct pt_regs hot_regs;
-
-		if (!regs) {
-			perf_fetch_caller_regs(&hot_regs);
-			regs = &hot_regs;
-		}
-		__perf_sw_event(event_id, nr, nmi, regs, addr);
+	struct pt_regs hot_regs;
+
+	JUMP_LABEL(&perf_swevent_enabled[event_id], have_event);
+	return;
+
+have_event:
+	if (!regs) {
+		perf_fetch_caller_regs(&hot_regs);
+		regs = &hot_regs;
 	}
+	__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f7febb0..05ecf6f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4669,7 +4669,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 	WARN_ON(event->parent);
 
-	atomic_dec(&perf_swevent_enabled[event_id]);
+	jump_label_dec(&perf_swevent_enabled[event_id]);
 	swevent_hlist_put(event);
 }
 
@@ -4699,7 +4699,7 @@ static int perf_swevent_init(struct perf_event *event)
 		if (err)
 			return err;
 
-		atomic_inc(&perf_swevent_enabled[event_id]);
+		jump_label_inc(&perf_swevent_enabled[event_id]);
 		event->destroy = sw_perf_event_destroy;
 	}
 

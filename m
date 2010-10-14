Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0JNVK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:10:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:44600 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab0JNVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:10:26 -0400
Message-Id: <20101014203625.609332490@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 14 Oct 2010 22:34:11 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 7/7] perf: Optimize sw events
References: <20101014203404.222133139@chello.nl>
Content-Disposition: inline; filename=perf-jump-label-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |   16 +++++++++-------
 kernel/perf_event.c        |    4 ++--
 2 files changed, 11 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -1013,15 +1013,17 @@ static inline void perf_fetch_caller_reg
 static inline void
 perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 {
-	if (atomic_read(&perf_swevent_enabled[event_id])) {
-		struct pt_regs hot_regs;
+	struct pt_regs hot_regs;
 
-		if (!regs) {
-			perf_fetch_caller_regs(&hot_regs);
-			regs = &hot_regs;
-		}
-		__perf_sw_event(event_id, nr, nmi, regs, addr);
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
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4603,7 +4603,7 @@ static void sw_perf_event_destroy(struct
 
 	WARN_ON(event->parent);
 
-	atomic_dec(&perf_swevent_enabled[event_id]);
+	jump_label_dec(&perf_swevent_enabled[event_id]);
 	swevent_hlist_put(event);
 }
 
@@ -4633,7 +4633,7 @@ static int perf_swevent_init(struct perf
 		if (err)
 			return err;
 
-		atomic_inc(&perf_swevent_enabled[event_id]);
+		jump_label_inc(&perf_swevent_enabled[event_id]);
 		event->destroy = sw_perf_event_destroy;
 	}
 



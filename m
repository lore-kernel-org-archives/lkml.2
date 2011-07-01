Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1GAPZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:25:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:42630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534Ab1GAPZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:25:28 -0400
Date: Fri, 1 Jul 2011 15:25:12 GMT
From: tip-bot for Avi Kivity <avi@redhat.com>
Message-ID: <tip-26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, avi@redhat.com,
        mingo@elte.hu
In-Reply-To: <1309362157-6596-4-git-send-email-avi@redhat.com>
References: <1309362157-6596-4-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: export perf_event_refresh() to modules
Git-Commit-ID: 26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:25:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350
Gitweb:     http://git.kernel.org/tip/26ca5c11fb45ae2b2ac7e3574b8db6b3a3c7d350
Author:     Avi Kivity <avi@redhat.com>
AuthorDate: Wed, 29 Jun 2011 18:42:37 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:40 +0200

perf: export perf_event_refresh() to modules

KVM needs one-shot samples, since a PMC programmed to -X will fire after X
events and then again after 2^40 events (i.e. variable period).

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1309362157-6596-4-git-send-email-avi@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    5 +++++
 kernel/events/core.c       |    3 ++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2a08cac..3f2711c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -955,6 +955,7 @@ extern void perf_pmu_disable(struct pmu *pmu);
 extern void perf_pmu_enable(struct pmu *pmu);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
+extern int perf_event_refresh(struct perf_event *event, int refresh);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
@@ -1149,6 +1150,10 @@ static inline void perf_event_delayed_put(struct task_struct *task)	{ }
 static inline void perf_event_print_debug(void)				{ }
 static inline int perf_event_task_disable(void)				{ return -EINVAL; }
 static inline int perf_event_task_enable(void)				{ return -EINVAL; }
+static inline int perf_event_refresh(struct perf_event *event, int refresh)
+{
+	return -EINVAL;
+}
 
 static inline void
 perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)	{ }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ba8e0f4..0567e32 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1764,7 +1764,7 @@ out:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
-static int perf_event_refresh(struct perf_event *event, int refresh)
+int perf_event_refresh(struct perf_event *event, int refresh)
 {
 	/*
 	 * not supported on inherited events
@@ -1777,6 +1777,7 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(perf_event_refresh);
 
 static void ctx_sched_out(struct perf_event_context *ctx,
 			  struct perf_cpu_context *cpuctx,

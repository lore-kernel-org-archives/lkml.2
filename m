Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab1CWVTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:19:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:35790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190Ab1CWVTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:19:07 -0400
Date: Wed, 23 Mar 2011 21:18:45 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110323150306.GA1580@quad>
References: <20110323150306.GA1580@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix stale ->cgrp pointer in update_cgrp_time_from_cpuctx()
Message-ID: <tip-68cacd29167b1926d237bd1b153aa2a990201729@git.kernel.org>
Git-Commit-ID: 68cacd29167b1926d237bd1b153aa2a990201729
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Mar 2011 21:18:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68cacd29167b1926d237bd1b153aa2a990201729
Gitweb:     http://git.kernel.org/tip/68cacd29167b1926d237bd1b153aa2a990201729
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 23 Mar 2011 16:03:06 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Mar 2011 16:07:22 +0100

perf_events: Fix stale ->cgrp pointer in update_cgrp_time_from_cpuctx()

This patch solves a stale pointer problem in
update_cgrp_time_from_cpuctx(). The cpuctx->cgrp
was not cleared on all possible event exit paths,
including:

   close()
     perf_release()
       perf_release_kernel()
         list_del_event()

This patch fixes list_del_event() to clear cpuctx->cgrp
when there are no cgroup events left in the context.

[ This second version makes the code compile when
  CONFIG_CGROUP_PERF is not enabled. We unconditionally define
  perf_cpu_context->cgrp. ]

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: perfmon2-devel@lists.sf.net
Cc: paulus@samba.org
Cc: davem@davemloft.net
LKML-Reference: <20110323150306.GA1580@quad>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    2 --
 kernel/perf_event.c        |   12 +++++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f495c01..311b4dc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -938,9 +938,7 @@ struct perf_cpu_context {
 	struct list_head		rotation_list;
 	int				jiffies_interval;
 	struct pmu			*active_pmu;
-#ifdef CONFIG_CGROUP_PERF
 	struct perf_cgroup		*cgrp;
-#endif
 };
 
 struct perf_output_handle {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3472bb1..0c71422 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -941,6 +941,7 @@ static void perf_group_attach(struct perf_event *event)
 static void
 list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 {
+	struct perf_cpu_context *cpuctx;
 	/*
 	 * We can have double detach due to exit/hot-unplug + close.
 	 */
@@ -949,8 +950,17 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
-	if (is_cgroup_event(event))
+	if (is_cgroup_event(event)) {
 		ctx->nr_cgroups--;
+		cpuctx = __get_cpu_context(ctx);
+		/*
+		 * if there are no more cgroup events
+		 * then cler cgrp to avoid stale pointer
+		 * in update_cgrp_time_from_cpuctx()
+		 */
+		if (!ctx->nr_cgroups)
+			cpuctx->cgrp = NULL;
+	}
 
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)

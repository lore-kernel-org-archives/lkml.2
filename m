Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab1CWPDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:03:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51618 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab1CWPDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=biqNkhztUSgdl7hvzBhCPz4L0R9Hnr/dX3oqGaxvmpXw51DzYwXuHOfMOlKxW34RpC
         KfjFIj5bAABbccqLMA8g==
Date: Wed, 23 Mar 2011 16:03:06 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, perfmon2-devel@lists.sf.net,
        paulus@samba.org, davem@davemloft.net
Subject: [PATCH] perf_events: fix cgrp stale pointer in
 update_cgrp_time_from_cpuctx() v2
Message-ID: <20110323150306.GA1580@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

This second version makes the code compile when CONFIG_CGROUP_PERF
is not enabled. We unconditionally define perf_cpu_context->cgrp.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

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

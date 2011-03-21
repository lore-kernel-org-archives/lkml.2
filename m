Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab1CUPMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:12:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1CUPMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:12:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=F1mOPmcgO1pKnIWh+OBmgkj181W6PPew3A1JD6eNDsA5J/3eani/LF1W+iLvqiFb5z
         HnHXuxrLK+WJnWmfd5pQ==
Date: Mon, 21 Mar 2011 16:11:26 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, perfmon2-devel@lists.sf.net,
        paulus@samba.org, davem@davemloft.net
Subject: [PATCH] perf_events: fix cgrp stale pointer in
 update_cgrp_time_from_cpuctx()
Message-ID: <20110321151126.GA5084@quad>
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

Signed-off-by: Stephane Eranian <eranian@google.com>
---

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
+		 * then clear cgrp to avoid stale pointer
+		 * in update_cgrp_time_from_cpuctx()
+		 */
+		if (!ctx->nr_cgroups)
+			cpuctx->cgrp = NULL;
+	}
 
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)

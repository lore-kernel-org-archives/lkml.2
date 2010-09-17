Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0IQJeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:34:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0IQJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:34:07 -0400
Message-Id: <20100917093009.360420946@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 17 Sep 2010 11:28:47 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/6] perf_events: Fix broken event grouping
References: <20100917092844.651383640@chello.nl>
Content-Disposition: inline; filename=stephane-perf_events-fix_broken_event_grouping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Stephane Eranian <eranian@google.com>

Events were not grouped anymore. The reason was that in
perf_event_open(), the field event->group_leader was
initialized before the function looked up the group_fd
to find the event leader. This patch fixes this by
reordering the code correctly.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4c90ea16.21edd80a.4b94.2495@mx.google.com>
---
 kernel/perf_event.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -5543,17 +5543,11 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (event_fd < 0)
 		return event_fd;
 
-	event = perf_event_alloc(&attr, cpu, group_leader, NULL, NULL);
-	if (IS_ERR(event)) {
-		err = PTR_ERR(event);
-		goto err_fd;
-	}
-
 	if (group_fd != -1) {
 		group_leader = perf_fget_light(group_fd, &fput_needed);
 		if (IS_ERR(group_leader)) {
 			err = PTR_ERR(group_leader);
-			goto err_alloc;
+			goto err_fd;
 		}
 		group_file = group_leader->filp;
 		if (flags & PERF_FLAG_FD_OUTPUT)
@@ -5562,6 +5556,12 @@ SYSCALL_DEFINE5(perf_event_open,
 			group_leader = NULL;
 	}
 
+	event = perf_event_alloc(&attr, cpu, group_leader, NULL, NULL);
+	if (IS_ERR(event)) {
+		err = PTR_ERR(event);
+		goto err_fd;
+	}
+
 	/*
 	 * Special case software events and allow them to be part of
 	 * any hardware group.
@@ -5643,7 +5643,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	put_ctx(ctx);
 err_group_fd:
 	fput_light(group_file, fput_needed);
-err_alloc:
 	free_event(event);
 err_fd:
 	put_unused_fd(event_fd);



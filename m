Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0IOPpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:45:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45652 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0IOPpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:45:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=IpE2bm8z2/G8FzID5utzmxqOQytjeFdJ+8Y3PWDpFfNDbtB9b+E1DToSq5uUPo/uD
	mkdAPEUzJ0VTdk9x1eEeA==
Message-ID: <4c90ea16.21edd80a.4b94.2495@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 15 Sep 2010 17:44:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf_events: fix broken event grouping
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events were not grouped anymore. The reason was that in
perf_event_open(), the field event->group_leader was
initialized before the function looked up the group_fd
to find the event leader. This patch fixes this by
reordering the code correctly.

Signed-off-by: Stephane Eranian <eranian@google.com>
--
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 86f394e..ce95617 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5550,17 +5550,11 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -5569,6 +5563,12 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -5653,7 +5653,6 @@ err_context:
 	put_ctx(ctx);
 err_group_fd:
 	fput_light(group_file, fput_needed);
-err_alloc:
 	free_event(event);
 err_fd:
 	put_unused_fd(event_fd);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0EUJLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:11:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46008 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0EUJLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:11:30 -0400
Message-Id: <20100521090710.528215873@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 11:02:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/10] perf: Ensure IOC_OUTPUT isnt used to create multi-writer buffers
References: <20100521090201.326791353@chello.nl>
Content-Disposition: inline; filename=perf-fix-output-ioctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we want to ensure buffers only have a single writer, we must
avoid creating one with multiple.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4885,6 +4885,13 @@ static int perf_event_set_output(struct 
 	int fput_needed = 0;
 	int ret = -EINVAL;
 
+	/*
+	 * Don't allow output of inherited per-task events. This would
+	 * create performance issues due to cross cpu access.
+	 */
+	if (event->cpu == -1 && event->attr.inherit)
+		return -EINVAL;
+
 	if (!output_fd)
 		goto set;
 
@@ -4905,6 +4912,18 @@ static int perf_event_set_output(struct 
 	if (event->data)
 		goto out;
 
+	/*
+	 * Don't allow cross-cpu buffers
+	 */
+	if (output_event->cpu != event->cpu)
+		goto out;
+
+	/*
+	 * If its not a per-cpu buffer, it must be the same task.
+	 */
+	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
+		goto out;
+
 	atomic_long_inc(&output_file->f_count);
 
 set:



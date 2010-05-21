Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0EUL3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:29:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:58537 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab0EUL3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:29:05 -0400
Date: Fri, 21 May 2010 11:28:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100521090710.528215873@chello.nl>
References: <20100521090710.528215873@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Ensure that IOC_OUTPUT isn't used to create multi-writer buffers
Message-ID: <tip-0f139300c9057c16b5833a4636b715b104fe0baa@git.kernel.org>
Git-Commit-ID: 0f139300c9057c16b5833a4636b715b104fe0baa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 11:28:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f139300c9057c16b5833a4636b715b104fe0baa
Gitweb:     http://git.kernel.org/tip/0f139300c9057c16b5833a4636b715b104fe0baa
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 20 May 2010 14:35:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 May 2010 11:37:57 +0200

perf: Ensure that IOC_OUTPUT isn't used to create multi-writer buffers

Since we want to ensure buffers only have a single
writer, we must avoid creating one with multiple.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100521090710.528215873@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3f2cc31..7a93252 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4920,6 +4920,13 @@ static int perf_event_set_output(struct perf_event *event, int output_fd)
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
 
@@ -4940,6 +4947,18 @@ static int perf_event_set_output(struct perf_event *event, int output_fd)
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

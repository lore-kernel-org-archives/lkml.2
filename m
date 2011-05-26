Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab1EZTzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:55:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35331 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1EZTzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:55:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Ce41RDl2QvEGSWr+HF0Xhs5Gpvt0+pLN09+IVlCGEO5HoFiBjud/1ZPklBGBkZNae
	pVbCyzVsd9Gr6VqDez5sw==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] trace: Set oom_score_adj to maximum for ring buffer allocating process
Date: Thu, 26 May 2011 12:52:17 -0700
Message-Id: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracing ring buffer is allocated from kernel memory. While
allocating the memory, if OOM happens, the allocating process might not
be the one that gets killed, since the ring-buffer memory is not
allocated as process memory. Thus random processes might get killed
during the allocation.

This patch makes sure that the allocating process is considered the most
likely oom-kill-able process while the allocating is going on. Thus if
oom-killer is invoked because of ring-buffer allocation, it is easier
for the ring buffer memory to be freed and save important system
processes from being killed.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/trace.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b926578..15a667a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -37,6 +37,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/fs.h>
+#include <linux/oom.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -3498,6 +3499,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	unsigned long val;
 	char buf[64];
 	int ret;
+	int oom_score_adj;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -3518,7 +3520,14 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	/* value is in KB */
 	val <<= 10;
 
+	/*
+	 * make sure this process is picked over others to be killed in OOM
+	 * condition
+	 */
+	oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
 	ret = tracing_resize_ring_buffer(val);
+	/* restore the original oom_score_adj value */
+	test_set_oom_score_adj(oom_score_adj);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.3.1


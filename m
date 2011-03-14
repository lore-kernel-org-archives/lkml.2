Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab1CNWmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:42:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39599 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1CNWmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:42:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Uh4TdTr/y4gnouqcuJ+++tXoJb0+FJ60fDpWpGiE/Wq4Q/YOJzGwzhFkDW8VNNAyq
	gmScuBWYlpbseGRoRDfYw==
From: Slava Pestov <slavapestov@google.com>
To: linux-kernel@vger.kernel.org
Cc: mrubin@google.com, dhsharp@google.com, rostedt@goodmis.org,
        Slava Pestov <slavapestov@google.com>
Subject: [PATCH] ftrace: add 'version' special file for ring buffer format
Date: Mon, 14 Mar 2011 15:42:08 -0700
Message-Id: <1300142528-4918-1-git-send-email-slavapestov@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intention here is that if the ftrace ring buffer format changes
in the future like it did in the past with ktrace, we can increment
the version number and update clients appropriately.

Tested: Verified that special file contains correct content

This patch is against 2.6.38-rc8 but should apply to any version
from at least 2.6.34 onwards.

Signed-Off-By: Slava Pestov <slavapestov@google.com>
---
 kernel/trace/trace.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dc53ecb..e56868a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -44,6 +44,12 @@
 #define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
 
 /*
+ * The version number should be incremented if the ring buffer
+ * format changes in an incompatible way.
+ */
+static const char ftrace_version[] = "1.0.0\n";
+
+/*
  * On boot up, the ring buffer is set to the minimum size, so that
  * we do not waste memory on systems that are not using tracing.
  */
@@ -2624,6 +2630,20 @@ static const struct file_operations tracing_readme_fops = {
 };
 
 static ssize_t
+tracing_version_read(struct file *filp, char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	return simple_read_from_buffer(ubuf, cnt, ppos,
+				       ftrace_version, strlen(ftrace_version));
+}
+
+static const struct file_operations tracing_version_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_version_read,
+	.llseek		= generic_file_llseek,
+};
+
+static ssize_t
 tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
 				size_t cnt, loff_t *ppos)
 {
@@ -4336,6 +4356,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
 
+	trace_create_file("version", 0444, d_tracer,
+			NULL, &tracing_version_fops);
+
 	trace_create_file("trace_pipe", 0444, d_tracer,
 			(void *) TRACE_PIPE_ALL_CPU, &tracing_pipe_fops);
 
-- 
1.7.3.1


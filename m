Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab2ABJEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 04:04:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab2ABJEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 04:04:42 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/7] ftrace: Change filter/notrace set functions to return exit code
Date: Mon,  2 Jan 2012 10:04:14 +0100
Message-Id: <1325495060-6402-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1325495060-6402-1-git-send-email-jolsa@redhat.com>
References: <1324493791-5688-1-git-send-email-jolsa@redhat.com>
 <1325495060-6402-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the ftrace_set_filter and ftrace_set_notrace functions
do not return any return code. So there's no way for ftrace_ops
user to tell wether the filter was correctly applied.

The set_ftrace_filter interface returns error in case the filter
did not match:

  # echo krava > set_ftrace_filter
  bash: echo: write error: Invalid argument

Changing both ftrace_set_filter and ftrace_set_notrace functions
to return zero if the filter was applied correctly or -E* values
in case of error.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/ftrace.h |    4 ++--
 kernel/trace/ftrace.c  |   15 +++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 26eafce..523640f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -180,9 +180,9 @@ struct dyn_ftrace {
 };
 
 int ftrace_force_update(void);
-void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset);
-void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset);
 void ftrace_set_global_filter(unsigned char *buf, int len, int reset);
 void ftrace_set_global_notrace(unsigned char *buf, int len, int reset);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b79ab33..46e1031 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2912,8 +2912,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 	mutex_lock(&ftrace_regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
-	if (buf)
-		ftrace_match_records(hash, buf, len);
+	if (buf && !ftrace_match_records(hash, buf, len)) {
+		ret = -EINVAL;
+		goto out_regex_unlock;
+	}
 
 	mutex_lock(&ftrace_lock);
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
@@ -2923,6 +2925,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 
 	mutex_unlock(&ftrace_lock);
 
+ out_regex_unlock:
 	mutex_unlock(&ftrace_regex_lock);
 
 	free_ftrace_hash(hash);
@@ -2939,10 +2942,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
  * Filters denote which functions should be enabled when tracing is enabled.
  * If @buf is NULL and reset is set, all functions will be enabled for tracing.
  */
-void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset)
 {
-	ftrace_set_regex(ops, buf, len, reset, 1);
+	return ftrace_set_regex(ops, buf, len, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter);
 
@@ -2957,10 +2960,10 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter);
  * is enabled. If @buf is NULL and reset is set, all functions will be enabled
  * for tracing.
  */
-void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset)
 {
-	ftrace_set_regex(ops, buf, len, reset, 0);
+	return ftrace_set_regex(ops, buf, len, reset, 0);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_notrace);
 /**
-- 
1.7.1


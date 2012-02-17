Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2BQNqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:46:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2BQNqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:46:49 -0500
Date: Fri, 17 Feb 2012 05:46:05 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-ac483c446b67870444c9eeaf8325d3d2af9b91bc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1325495060-6402-2-git-send-email-jolsa@redhat.com>
References: <1325495060-6402-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Change filter/
 notrace set functions to return exit code
Git-Commit-ID: ac483c446b67870444c9eeaf8325d3d2af9b91bc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 05:46:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac483c446b67870444c9eeaf8325d3d2af9b91bc
Gitweb:     http://git.kernel.org/tip/ac483c446b67870444c9eeaf8325d3d2af9b91bc
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 2 Jan 2012 10:04:14 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 3 Feb 2012 09:48:18 -0500

ftrace: Change filter/notrace set functions to return exit code

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

Link: http://lkml.kernel.org/r/1325495060-6402-2-git-send-email-jolsa@redhat.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    4 ++--
 kernel/trace/ftrace.c  |   15 +++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 028e26f..f33fb3b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -178,9 +178,9 @@ struct dyn_ftrace {
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
index 683d559..e2e0597 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3146,8 +3146,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
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
@@ -3157,6 +3159,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 
 	mutex_unlock(&ftrace_lock);
 
+ out_regex_unlock:
 	mutex_unlock(&ftrace_regex_lock);
 
 	free_ftrace_hash(hash);
@@ -3173,10 +3176,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
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
 
@@ -3191,10 +3194,10 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter);
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

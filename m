Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab1GEMwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:52:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:58394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab1GEMwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:52:36 -0400
Date: Tue, 5 Jul 2011 12:52:31 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-f56e7f8efb4ec200364f690a9902713410e24d47@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1307113131-10045-4-git-send-email-jolsa@redhat.com>
References: <1307113131-10045-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing, function: Fix trace header to follow context-info option
Git-Commit-ID: f56e7f8efb4ec200364f690a9902713410e24d47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:52:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f56e7f8efb4ec200364f690a9902713410e24d47
Gitweb:     http://git.kernel.org/tip/f56e7f8efb4ec200364f690a9902713410e24d47
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 3 Jun 2011 16:58:49 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:48 -0400

tracing, function: Fix trace header to follow context-info option

The header display of function tracer does not follow
the context-info option, so field names are displayed even
if this option is off.

Added check for TRACE_ITER_CONTEXT_INFO trace_flags.

With following commands:
	# echo function > ./current_tracer
	# echo 0 > options/context-info
	# cat trace

This is what it looked like before:
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
add_preempt_count <-schedule
rcu_note_context_switch <-schedule
...

This is what it looks like now:
# tracer: function
#
_raw_spin_unlock_irqrestore <-hrtimer_try_to_cancel
...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1307113131-10045-4-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 42fdf3a..cf22b4b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2053,6 +2053,9 @@ void trace_default_header(struct seq_file *m)
 {
 	struct trace_iterator *iter = m->private;
 
+	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
+		return;
+
 	if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
 		/* print nothing if the buffers are empty */
 		if (trace_empty(iter))

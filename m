Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2DETT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 15:19:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50903 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab2DETTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 15:19:35 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <mark.asselstine@windriver.com>
Subject: [PATCH 3/3] trace-cmd: setting plugin to 'nop' clears data before its recorded
Date: Thu, 5 Apr 2012 15:19:46 -0400
Message-ID: <1333653586-3379-4-git-send-email-mark.asselstine@windriver.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333653586-3379-1-git-send-email-mark.asselstine@windriver.com>
References: <1333653586-3379-1-git-send-email-mark.asselstine@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [128.224.146.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e09a5db1a929ab668c273b87c4f0a32b81e1c21a
[trace-cmd: Add trace-cmd record --date option]

moved the call to disable_all() in trace_record() from after record_data()
to before it. disable_all() sets 'nop' in 'current_tracer' which has the
side affect of clearing 'trace', thus all the latency tracer reports are
empty/useless. By moving set_plugin() out of disable_all() and rather
calling it after record_data() we still achieve the desired goals of
commit e09a5db1a9 while fixing latency tracing reports.

Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
---
 trace-record.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/trace-record.c b/trace-record.c
index 1c56fa9..6887874 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -897,11 +897,10 @@ static void disable_tracing(void)
 	write_tracing_on(0);
 }
 
-static void disable_all(void)
+static void disable_all_but_plugin(void)
 {
 	disable_tracing();
 
-	set_plugin("nop");
 	reset_events();
 
 	/* Force close and reset of ftrace pid file */
@@ -911,6 +910,12 @@ static void disable_all(void)
 	clear_trace();
 }
 
+static void disable_all(void)
+{
+	disable_all_but_plugin();
+	set_plugin("nop");
+}
+
 static void
 update_sched_event(struct event_list **event, const char *file,
 		   const char *pid_filter, const char *field_filter)
@@ -2227,7 +2232,7 @@ void trace_record (int argc, char **argv)
 	}
 
 	if (!keep)
-		disable_all();
+		disable_all_but_plugin();
 
 	printf("Kernel buffer statistics:\n"
 	       "  Note: \"entries\" are the entries left in the kernel ring buffer and are not\n"
@@ -2245,6 +2250,8 @@ void trace_record (int argc, char **argv)
 
 	record_data(date2ts);
 	delete_thread_data();
+	if (!keep)
+		set_plugin("nop");
 
 	if (keep)
 		exit(0);
-- 
1.7.5.4


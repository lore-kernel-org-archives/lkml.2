Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2B0JcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:32:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44760 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2B0JcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:32:23 -0500
Date: Mon, 27 Feb 2012 01:31:46 -0800
From: tip-bot for Andrey Vagin <avagin@openvz.org>
Message-ID: <tip-e404b321dbb2d6e438522b7dce9c1d0c6a8c5275@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        avagin@openvz.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        avagin@openvz.org
In-Reply-To: <1329650167-480655-1-git-send-email-avagin@openvz.org>
References: <1329650167-480655-1-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Don't print an extra separator of flags
Git-Commit-ID: e404b321dbb2d6e438522b7dce9c1d0c6a8c5275
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 01:32:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e404b321dbb2d6e438522b7dce9c1d0c6a8c5275
Gitweb:     http://git.kernel.org/tip/e404b321dbb2d6e438522b7dce9c1d0c6a8c5275
Author:     Andrey Vagin <avagin@openvz.org>
AuthorDate: Sun, 19 Feb 2012 14:16:07 +0300
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 20 Feb 2012 20:33:31 -0500

tracing: Don't print an extra separator of flags

If __print_flags() is used after another __print_*() function, the
temp seq_file buffer will not be empty on entry, and the delimiter will
be printed even though there's just one field. We get something like:

	|S

instead of just:

	S

This is because the length of the temp seq buffer is used to determine
if the delimiter is printed or not. But this algorithm fails when
the seq buffer is not empty on entry, and the delimiter will be printed
because it thinks that a previous field was already printed.

Link: http://lkml.kernel.org/r/1329650167-480655-1-git-send-email-avagin@openvz.org

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 0d6ff355..3efd718 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -300,7 +300,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 	unsigned long mask;
 	const char *str;
 	const char *ret = p->buffer + p->len;
-	int i;
+	int i, first = 1;
 
 	for (i = 0;  flag_array[i].name && flags; i++) {
 
@@ -310,8 +310,10 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 
 		str = flag_array[i].name;
 		flags &= ~mask;
-		if (p->len && delim)
+		if (!first && delim)
 			trace_seq_puts(p, delim);
+		else
+			first = 0;
 		trace_seq_puts(p, str);
 	}
 
